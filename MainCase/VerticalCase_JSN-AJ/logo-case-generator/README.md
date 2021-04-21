# Logo Case Generator

This is a tool made with OpenSCAD, to take the main case or lid file and add a logo to
it. The script generates a "main" part and a "inner" part, where the main part
is the normal case file with the logo cut out, and the "inner" part is the
logo. This can be used in multi-part printing, e.g. in Prusa Slicer. In general
you will need to follow these steps:

* Find a logo as a vector graphics file (e.g. SVG)
* Scale the logo to the right dimensions, using the frame template
* Choose inverted or normal mode, and a logo thickness
* Generate the two STL files
* Import the two STL files into your slicer as a multipart print, or print just
  the main part with a color change at an early layer

## Features

* Use any vector graphics, simple placement in template
* Inverted or normal style logo
* Customize logo depth (number of layers)
* Only generates a lid for now, will be extended for the main case as well

## Guide

### Preparing the logo

* Open the logo you would like to use in [Inkscape](https://inkscape.org/)
* Make sure the logo is only a shape path. Colors, gradients and even the
  thickness of lines are ignored. Use the options in the "Path" menu of
  Inkscape, e.g. "Object to Path" and "Union", to generate a single path
  object. Remove its border, fill it black.
* Open `frame-lid.svg` or `frame-maincase.svg` in Inkscape and copy-paste your logo into it. Transform the
  logo to place it where you would like to print it.
* Delete the gray frame shape, leaving only a correctly sized document with the
  logo placed where you want it.
* Save the file as a different file, in this example we'll use `my-logo-framed.svg`.

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

You will also need to choose a thickness, or `logo_depth`. This should be a
multiple of your layer height. Some opaque filaments could work if just one
layer is applied, but for best results, at least two layers should be chosen.
Each layer will need a filament change though, so try to keep the number of
layers low. The default example is a 0.2mm layer height, and two layers of logo
printing, which results in a logo depth of 0.4mm.

### Generate the STL files

First, you need to have [OpenSCAD](https://openscad.org/) installed.

Run the following commands:

```bash
openscad -D 'mode="main"' -D 'logo_file="my-logo-framed.svg"' -D 'logo_depth=0.4' logo-lid.scad -o lid-my-logo-main.stl
openscad -D 'mode="inner"' -D 'logo_file="my-logo-framed.svg"' -D 'logo_depth=0.4' logo-lid.scad -o lid-my-logo-inner.stl
```

If you chose an inverted logo, also add `-D 'inverted=true'` to both
commands. If your logo is a very complex shape, and the result looks wrong, try
setting and increasing the `logo_convexity` parameter as well, from its default
10 upwards, e.g. to 20 or 30.

You can also combine the inverted `inner` with a with an inverted `main` with 
`-D 'logo_file="empty_logo.svg"'` to achieve a bridged logo with multiple files.

### Importing into Prusa Slicer

If you're not using Prusa Slicer or a derivative thereof, you will need to find
your own solution.

For Prusa Slicer, multipart printing is very simple to set up, if your printer
supports any type of command to switch filaments.  Marlin firmware can be
compiled for most printers with support for the M600 command. Printers with
physical support for multi-material printing of course should be supported out
of the box.

* Import the `lid-my-logo-main.stl` file into Prusa Slicer as usual. It should
  be placed in the center of your build plate automatically.
* In the right sidebar, locate your part. Under "Editing", click the icon, then
  choose "Add Part" > "Load...", and select the `lid-my-logo-inner.stl` file.
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
