#!/bin/bash

## normal mode (inverted=false)

### the case 
openscad -D 'mode="main"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' logo-maincase.scad -o maincase-obs-main.stl

### the logo
openscad -D 'mode="inner"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' logo-maincase.scad -o maincase-obs-inner.stl



## alternative mode (inverted=true)

openscad -D 'mode="main"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o maincase-obs-main-inverted.stl

openscad -D 'mode="inner"' -D 'logo_file="obs-framed-maincase.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o maincase-obs-inner-inverted.stl


## empty logo (can be combined with inner-inverted to have the result of maincase-obs-main.stl in two files for manual color change)

openscad -D 'mode="main"' -D 'logo_file="empty_logo.svg"' -D 'logo_depth=0.4' -D 'inverted=true' logo-maincase.scad -o maincase-empty_logo-main.stl
