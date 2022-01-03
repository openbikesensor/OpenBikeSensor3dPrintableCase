OPENSCAD=/usr/bin/openscad
OPENSCAD_OPTIONS=-DVERBOSE=false -q
IMAGE_OPTIONS=--imgsize=1024,768 --colorscheme=DeepOcean

SRCS=$(wildcard src/*/*.scad)
STLS=$(patsubst src/%.scad,build/%.stl,$(SRCS))

all: build-all

clean:
	@rm -r build/ || true

build-all : $(STLS)

build/%.stl: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -o $@ $<

