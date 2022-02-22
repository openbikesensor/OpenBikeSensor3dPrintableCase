OPENSCAD=/usr/bin/openscad
OPENSCAD_OPTIONS=-q
STL_SORTER=lib/sort_stl.py
IMAGE_OPTIONS=--imgsize=1024,768 --colorscheme "Tomorrow Night" --render true -D orient_for_printing=false
THUMBNAIL_OPTIONS=--imgsize=400,300 --colorscheme "Tomorrow Night" --render true -D fast=true -D orient_for_printing=false

SHELL=bash

SRCS=$(wildcard src/*/*.scad)
STLS=$(patsubst src/%.scad,export/%.stl,$(SRCS))
PNGS=$(patsubst src/%.scad,render/%.png,$(SRCS))
THUMBNAILS=$(patsubst src/%.scad,render/thumbnails/%.png,$(SRCS))

LOGOS=$(shell find logo/ -mindepth 1 -maxdepth 1 -type d -not -name template | xargs -L1 basename)
FILES_WITH_LOGO := MainCase/MainCase MainCase/MainCaseLid
LOGO_PARTS := main highlight
LOGO_MODES := normal inverted

ifdef DEBUG
OPENSCAD_OPTIONS += -D fast=true
endif

all: export-all thumbnails logo-OpenBikeSensor

clean:
	@rm -r export/ || true
	@rm -r render/ || true

export/%.stl: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -D orient_for_printing=true -o $@ $<
	$(STL_SORTER) $@

export-all : $(STLS)

render/%.png: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) --viewall $(OPENSCAD_OPTIONS) $(IMAGE_OPTIONS) -o $@ $<

render-all : $(PNGS)

thumbnails: $(THUMBNAILS)

render/thumbnails/%.png: src/%.scad
	@mkdir -p $(shell dirname $@)
	$(OPENSCAD) --viewall $(OPENSCAD_OPTIONS) $(THUMBNAIL_OPTIONS) -o $@ $<

render/assembly.gif: assembly.scad $(SRCS)
	$(OPENSCAD) --animate 60 $(OPENSCAD_OPTIONS) $(IMAGE_OPTIONS) --camera 0,0,0,45,0,60,600 assembly.scad -o render/assembly.png
	convert render/assembly*.png -set delay 4 -reverse y*.png -set delay 4 -loop 0 render/assembly.gif

# $1: logo name
# $2: part path (e. g. MainCase/MainCaseLid)
# $3: logo part (main|highlight)
# $4: logo mode (normal|inverted)
define logo-part-rule
export/logo/$(1)/$(shell basename $(2))-$(4)-$(3).stl: src/$(2).scad logo/$(1)/$(shell basename $(2)).svg export/$(2).stl
	@mkdir -p $$(shell dirname $$@)
	$$(OPENSCAD) $$(OPENSCAD_OPTIONS) -D orient_for_printing=true -D logo_enabled=true -D logo_use_prebuild=true -D 'logo_mode="$(4)"' -D 'logo_part="$(3)"' -D 'logo_name="$(1)"' -o $$@ $$<
  $$(STL_SORTER) $$@
logo-$1-$4: export/logo/$(1)/$(shell basename $(2))-$(4)-$(3).stl
logo-$1: export/logo/$(1)/$(shell basename $(2))-$(4)-$(3).stl
logos: logo-$1
endef

$(foreach logo,$(LOGOS), \
	$(foreach file,$(FILES_WITH_LOGO), \
		$(foreach logo_part,$(LOGO_PARTS), \
			$(foreach logo_mode,$(LOGO_MODES), \
				$(eval $(call logo-part-rule,$(logo),$(file),$(logo_part),$(logo_mode)))))))


# $1: part path (e. g. MainCase/MainCaseLid)
define logo-template-rule
logo/template/$(shell basename $(1)).svg: src/$(1).scad
	@mkdir -p $$(shell dirname $$@)
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -D orient_for_printing=true -D logo_generate_templates=true -D fast=true -o $$@ $$<
	sed -i 's/stroke-width="[0-9\.]*"/stroke-width="0"/' $$@

logo-templates: logo/template/$(shell basename $(1)).svg
endef

$(foreach file,$(FILES_WITH_LOGO), \
	$(eval $(call logo-template-rule,$(file))))


define numbered-cover-rule
export/Mounting/AttachmentCover_$(1).stl: src/Mounting/AttachmentCover.scad
	@mkdir -p $$(shell dirname $$@)
	$(OPENSCAD) $(OPENSCAD_OPTIONS) -D orient_for_printing=true -D attachment_cover_number_text=$(1) -o $$@ $$<
	$(STL_SORTER) $@
endef

$(foreach number,$(shell seq 0 1 100), \
	$(eval $(call numbered-cover-rule,$(number))))
