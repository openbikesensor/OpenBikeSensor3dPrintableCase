#!/bin/bash

## normal mode (inverted=false)
LOGO_DEPTH=0.4
FOLDER=obs-logo

${FOLDER}: ${FOLDER}/lid_inverted_main.stl ${FOLDER}/lid_inverted_inner.stl ${FOLDER}/maincase_inverted_main.stl ${FOLDER}/maincase_inverted_inner.stl ${FOLDER}/lid_normal_main.stl ${FOLDER}/lid_normal_inner.stl ${FOLDER}/maincase_normal_main.stl ${FOLDER}/maincase_normal_inner.stl

${FOLDER}/lid_inverted_main.stl:
	openscad -D 'mode="main"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="lid"' -D "inverted=true" combine.scad -o $@

${FOLDER}/lid_inverted_inner.stl:
	openscad -D 'mode="inner"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="lid"' -D "inverted=true" combine.scad -o $@

${FOLDER}/maincase_inverted_main.stl:
	openscad -D 'mode="main"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="maincase"' -D "inverted=true" combine.scad -o $@

${FOLDER}/maincase_inverted_inner.stl:
	openscad -D 'mode="inner"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="maincase"' -D "inverted=true" combine.scad -o $@

${FOLDER}/lid_normal_main.stl:
	openscad -D 'mode="main"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="lid"' -D "inverted=false" combine.scad -o $@

${FOLDER}/lid_normal_inner.stl:
	openscad -D 'mode="inner"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="lid"' -D "inverted=false" combine.scad -o $@

${FOLDER}/maincase_normal_main.stl:
	openscad -D 'mode="main"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="maincase"' -D "inverted=false" combine.scad -o $@

${FOLDER}/maincase_normal_inner.stl:
	openscad -D 'mode="inner"' -D 'folder="${FOLDER}"' -D "logo_depth=${LOGO_DEPTH}" -D 'part="maincase"' -D "inverted=false" combine.scad -o $@
