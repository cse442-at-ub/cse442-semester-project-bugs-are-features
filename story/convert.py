#!/usr/bin/env python3
import json
import os
import sys

gid = 0
level = 0
data = None

# Sets of SQL statements we're generating
ghost_resps = set()
user_resps = set()

def ghost_node(pid):
    # The current ghost node we're working on
    node = data[pid - 1]

    # pids start from 1, not 0
    text = node["text"].split('\n')[0]

    # Get list of user responses this ghost resp links to
    pids = ""
    # The response id's we'll use later
    rids = []

    if 'links' in node:
        for resp in node["links"]:
            pids = pids + resp["pid"] + ","
            rids.append(int(resp["pid"]))
    # Cut trailing ','
    pids = pids[:-1]

    statement = ('batch.execute(\"INSERT INTO ghost_responses '
        '(gid, level, rid, response_ids, text) '
        'VALUES ({}, {}, {}, \\"{}\\", \\"{}\\")\");'
        .format(gid, level, pid, pids, text))

    ghost_resps.add(statement)

    # Now add the user responses
    for rid in rids:
        user_node(rid)

def user_node(pid):
    # The current user node we're working on
    node = data[pid - 1]

    text = node["text"].split('\n')[0]
    points = 0
    effect = 0
    resp_t = 0
    rid = -1

    if 'links' in node:
        # User responses should only link to one ghost response
        rid = int(node["links"][0]["pid"])

    for tag in node["tags"]:
        pair = tag.split('=')
        if pair[0] == "points":
            points = pair[1]
        elif pair[0] == "effect":
            effect = pair[1]
        elif pair[0] == "type":
            resp_t = pair[1]

    statement = ('batch.execute(\"INSERT INTO user_responses '
        '(gid, level, rid, grid, type, effect, points, text) '
        'VALUES ({}, {}, {}, {}, {}, {}, {}, \\"{}\\")\");'
        .format(gid, level, rid, pid, resp_t, effect, points, text))

    user_resps.add(statement)

    if rid != -1:
        ghost_node(rid)

def main(argv):
    if len(argv) != 3:
        print("Usage: {} <ghost id> <level>".format(argv[0]))
        sys.exit(1)

    global gid
    global level
    global data

    gid = argv[1]
    level = argv[2]
    filename = os.path.abspath("{}/{}.json".format(gid, level))

    print("Opening {}".format(filename))
    # Parse .json
    with open(filename, 'r') as js:
        tmp = json.load(js)
        data = tmp["passages"]

    print("Walking through the tree")
    # Start at the root node, which is unfortunately not 0
    ghost_node(1)

    outfile = "{}/{}.txt".format(gid, level)
    print("Writing to {}".format(outfile))

    out = open(outfile, "w")

    # Write everything to the out file
    for stmt in ghost_resps:
        out.write(stmt + '\n')

    for stmt in user_resps:
        out.write(stmt + '\n')

if __name__ == "__main__":
    main(sys.argv)
