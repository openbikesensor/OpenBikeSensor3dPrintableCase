OPENSCAD=/usr/bin/openscad
OPENSCAD_OPTIONS=-DVERBOSE=false -q
IMAGE_OPTIONS=--imgsize=1024,768 --colorscheme "Tomorrow Night" --render true

SRCS=$(wildcard src/*/*.scad)
STLS=$(patsubst src/%.scad,build/%.stl,$(SRCS))
PNGS=$(patsubst src/%.scad,render/%.png,$(SRCS))

all: build-all

clean:
	@rm -r build/ || true
	@rm -r render/ || true

build/%.stl: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -o $@ $<

build-all : $(STLS)

render/%.png: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) --viewall $(OPENSCAD_OPTIONS) $(IMAGE_OPTIONS) -o $@ $<

render-all : $(PNGS)

render/assembly.gif: assembly.scad $(SRCS)
	$(OPENSCAD) --animate 60 $(OPENSCAD_OPTIONS) $(IMAGE_OPTIONS) --camera 0,0,0,45,0,60,600 assembly.scad -o render/assembly.png
	convert render/assembly*.png -set delay 4 -reverse y*.png -set delay 4 -loop 0 render/assembly.gif

