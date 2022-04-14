# Logo generator

This folder contains logo files to be generated into the STL files, adding a
customizable logo to your cases. The script generates a "main" part and a
"highlight" part, where the main part is the normal case file with the logo cut
out, and the "inner" part is the logo. This can be used in multi-part printing,
e.g. in Prusa Slicer or Ultimaker Cura. In general you will need to follow these steps:

* Find your logo as a vector graphics file (e.g. SVG)
* Scale the logo to the right dimensions, using the frame templates
* Choose inverted or normal mode, and a logo thickness
* Generate the STL files with GNU make
* Import the two STL files into your slicer as a multipart print, or print just
  the main part with a color change at an early layer
  
The script will only work on linux.

## Features

* Use any vector graphics, simple placement in template
* Inverted or normal style logo
* Customize logo depth (number of layers)
* Auto generate in Makefile

## Guide

### Preparing the logo

* Open the logo you would like to use in [Inkscape](https://inkscape.org/)
* Make sure the logo is only a shape path. Colors, gradients and even the
  thickness of lines are ignored. Use the options in the "Path" menu of
  Inkscape, e.g. "Object to Path" and "Union", to generate a single path
  object. Remove its border, fill it black.
* Duplicate `logo/template` to `logo/MyLogoName` (choose a name) and edit the
  files in this folder in Inkscape, copy-paste your logo into it. Transform the
  logo to place it where you would like to print it.
* Delete the gray frame shape, leaving only a correctly sized document with the
  logo placed where you want it.

### Choosing options

Depending on your logo shape and the colors you are going to use it to print,
you might want to **invert the logo**. For an inverted logo, the space
surrounding the logo is separated for printing, the logo becomes part of the
main body instead. Use this

* when you want to print the logo and body in the same color, or
* when your logo should be printed in an translucent filament and the space
  around it should be covering in an opaque filament (the combination of two
  translucent filaments is discouraged as the colors mix and look ugly), or
* depending on the shape of your logo, e.g. when very thin features or acute
  angles are present and you want to influence the printing order.

If you use a custom layer height other than 0.2mm, or you need more layers of
logo, change the corresponding variables in `variables.scad`. Some opaque
filaments could work if just one layer is applied, but for best results, at
least two layers should be chosen. Each layer will need a filament change
though, so try to keep the number of layers low. The default example is a 0.2mm
layer height, and two layers of logo printing, which results in a logo depth of
0.4mm.

### Generate the STL files

The following make targets are available:

```bash
make logos # generate all logo files
make logo-MyLogoName # generate all files for the logo in logo/MyLogoName
make logo-MyLogoName-normal # only normal mode
make logo-MyLogoName-inverted # only inverted mode
```

The files generated are placed here:

```
export/logo/$logo_name/MainCase-$mode-main.stl
export/logo/$logo_name/MainCase-$mode-highlight.stl
```

A pair of two such files forms the whole case, where the `main` file is the
normal body of the object (case or lid), and the `highlight` file is the
cut-away part. Import both simultaenously into your slicer to form a multi-part
object for multi-color printing.

The `$mode` can be "normal" or "inverted". An inverted logo is used if the
color of the logo should match the color of the walls and remainder of the
object, effectively printing the bottom side (while printing) in a different
color, *except* for the logo. This may be easier to print or desired for
aesthetical reasons, depending on the logo and filaments you use.

### Importing into Prusa Slicer

If you're not using Prusa Slicer or a derivative thereof, you will need to find
your own solution. If you are using Ultimaker Cura, see below.

For Prusa Slicer, multipart printing is very simple to set up, if your printer
supports any type of command to switch filaments.  Marlin firmware can be
compiled for most printers with support for the M600 command. Printers with
physical support for multi-material printing of course should be supported out
of the box.

* Import the `export/logo/MyLogoName/MainCase-normal-main.stl` (or *inverted*
  instead of *normal*) file into Prusa Slicer as usual. It should be placed in
  the center of your build plate automatically.
* In the right sidebar, locate your part. Under "Editing", click the icon, then
  choose "Add Part" > "Load...", and select the corresponding
  `...-highlight.stl` file.
* You now have a multipart print. Configure everything as normal.
* If your printer only has one extruder, but supports the M600 command, you can
  still choose 2 extruders under "Printer Settings" > "General" >
  "Capabilities" > "Extruders". In the "Custom G-Code" section, under "Tool
  change G-code", you might have to enter `M600`.
* You should then be able to choose the two extruders for the different parts
  in the parts list in the right sidebar. This way the slicer generates
  separate toolpaths for both parts in each layer, and places the M600 command
  in between those paths. The printer will then pause and wait for the user to
  change the filament and confirm to resume.

If you don't mind multiple gcode-Files, your printer does not support `M600` and
your nozzle shape allows you to print around multiple layers, you can export the
gcode for each color by turning the other part into a support blocker. If the bed
keeps being heated after the print (eg. no `M140 S0` command at the end of the print),
you can change filament and start with the next file. Printing brims can be problematic
if the printed part only touches the build plate on smaller areas than the rest of the
body does.

### Importing into Ultimaker Cura

To print in Ultimkaer Cura with two colors, follw these steps:
* Click on the folder in the upper left corner and choose the first file. Make sure that on the left side extruder 1 is selected.
* Click again on the folder and choose the second file. Now select extruder 2 on the left side. Both files should now be visible next to each other.
* Select both parts (click, hold shift and click on the other part). Rightclick to bring up the context menu, select `Merge Models`.
* Normally, they should align now. If not, align them manually.
* Press `slice` and continue as normal.
