#!/usr/bin/env python3
import argparse
import re
from pathlib import Path


def permutations(c):
    # only permutations that preserve cycle direction
    for i in range(len(c)):
        yield [c[(i + n) % len(c)] for n in range(len(c))]


class Element():
    def __init__(self, line):
        self.startline = line
        self.children = []
        self.current_child = None
        self.endline = None

    def parse(self, line):

        if self.current_child is None:
            for Childtype in self._contains:
                if Childtype._startswith.match(line):
                    self.current_child = Childtype(line)
                else:
                    print(f"{Childtype} did not match {line} for {self.__class__}")
            assert self.current_child is not None, f"should have found type for line {line}"
        elif self.current_child._endswith.match(line):
            self.current_child.endline = line
            self.children.append(self.current_child)
            self.current_child = None
        else:
            self.current_child.parse(line)

    def __str__(self):
        return self.startline + "".join(sorted([str(c) for c in self.children])) + self.endline


class Loop(Element):
    _startswith = re.compile("^\s+(?:outer|inner) loop$")
    _endswith = re.compile("^\s+endloop$")
    _footer = "endloop"

    def parse(self, line):
        self.children.append(line)

    def __str__(self):
        return self.startline + "".join(min(list(permutations(self.children)))) + self.endline


class Facet(Element):
    _startswith = re.compile("^\s+facet\s+(.*)$")
    _endswith = re.compile("^\s+endfacet$")
    _contains = (Loop,)


class Model(Element):
    _startswith = re.compile("^\s*solid\s+(.*)$")
    _endswith = re.compile("^\s*endsolid\s+(.*)$")
    _contains = (Facet,)


class STL(Element):
    _contains = (Model,)
    endline = ""

    def __init__(self, filename):
        self.startline = ""
        data = open(filename, "r").readlines()
        self.children = []
        self.current_child = None
        self.read(data)

    def read(self, data):
        for line in data:
            self.parse(line)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="stl sorter for deterministic diffing")
    parser.add_argument('stlfile', metavar="STLFILE", type=Path, help="path of the STL to sort (in place)")
    args = parser.parse_args()

    s = STL(args.stlfile)
    s_as_str = str(s)
    open(args.stlfile, "w").write(s_as_str)
