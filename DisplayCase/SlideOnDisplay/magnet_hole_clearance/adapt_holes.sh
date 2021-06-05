#!/bin/bash

## normal mode (inverted=false)
for d in 0.1 0.2 0.3
do
for f in "OBS-Display-B-002_Sechskantmutter_Display_Bottom_v0.1.0" "OBS-Display-B-001_Sechskantmutter_Display_Top_v0.1.0" "OBS-Display-A-001_HeatSetInsert_Display_Top_v0.1.0" "OBS-Display-A-002_HeatSetInsert_Display_Bottom_v0.1.0"
do
openscad -D "l=${d}" -D "filename=\"../${f}.stl\"" SlideOnDisplay.scad -o adapted_models/${d}mm-$f.stl
echo $f
done
done

for f in OBS-Display-A-005_Kabelbinder_Schiene_v0.1.0 OBS-Display-B-005_Schiene_v0.1.0 OBS-Display-A-005_Kabelbinder_Schiene_v0.1.0
do
for d in 0.1 0.2 0.3
do
openscad -D "l=${d}" $f.scad -o adapted_models/${d}mm-$f.stl
echo $f
done
done

mkdir -p test-adapted_models/

for f in adapted_models/*001* adapted_models/*002*
do 
   echo $f
   openscad -D "filename=\"${f}\"" cut_examples.scad -o test-$f
done

