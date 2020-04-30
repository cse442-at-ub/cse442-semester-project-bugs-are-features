#!/usr/bin/env python3
import csv
import os
import sys

# Sets of SQL statements we're generating
interactions = set()

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


    if statement in ghost_resps:
        return
    else:
        ghost_resps.add(statement)

    # Now add the user responses
    for rid in rids:
        user_node(rid)

def main(argv):
    if len(argv) != 2:
        print("Usage: {} <ghost id>".format(argv[0]))
        sys.exit(1)

    gid = argv[1]
    filename = os.path.abspath("{}/interactions.csv".format(gid))

    print("Opening {}".format(filename))

    outfile = "{}/interactions.txt".format(gid)
    out = open(outfile, "w")

    print("Parsing & Writing all interactions to {}".format(outfile))
    # Parse csv
    with open(filename, 'r') as f:
        interactions = csv.reader(f, delimiter=',', quotechar='|')
        for row in interactions:
            statement = ('batch.execute(\"INSERT INTO interactions '
                '(gid, level, user_resp, ghost_resp, points) '
                'VALUES ({}, {}, \\"{}\\", \\"{}\\", {})\");'
                .format(row[0], row[1], row[2], row[3], row[4]))
            out.write(statement + '\n')


if __name__ == "__main__":
    main(sys.argv)
