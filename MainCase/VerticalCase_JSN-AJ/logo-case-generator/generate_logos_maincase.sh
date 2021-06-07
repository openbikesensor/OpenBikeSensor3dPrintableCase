#!/bin/bash

## normal mode (inverted=false)

### the case 
openscad -D 'mode="main"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' logo-maincase.scad -o ../OBS-MainCase-B-001a_MainCase_with_0.4mm_OBS-logo.stl

### the logo
openscad -D 'mode="inner"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' logo-maincase.scad -o ../OBS-MainCase-B-001b_inner_logo_part.stl



## alternative mode (inverted=true)

openscad -D 'mode="main"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o ../OBS-MainCase-C-001a_MainCase_with_0.4mm_OBS-logo-inverted.stl

openscad -D 'mode="inner"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o ../OBS-MainCase-C-001b_inner_logo_part-inverted.stl


## empty logo (can be combined with inner-inverted to have the result of maincase-obs-main.stl in two files for manual color change)

openscad -D 'mode="main"' -D 'logo_file="empty_logo.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o ../OBS-MainCase-D-001a_empty_logo_top.stl