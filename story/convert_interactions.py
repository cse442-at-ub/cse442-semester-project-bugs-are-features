#!/usr/bin/env python3
import csv
import os
import sys

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
