# Magnet hole clearance

This folder contains scripts to adapt the magnet hole clerance for
the the ``SlideOnDisplay`` display case.

The plain models are designed to dimension, so in the stl the
magnet holes have exactly the dimensios of the magnets. To insert
the magnets a bit of clearance is required. It has been suggested
to heat up the magnets to melt them into place, but especially
for high-aspect ratio magnets such as the ones used in the display
case this is detrimental to their quality - they already start
losing magnetization at the temperatures required to soften
PETG.

How much clearance is required on the 3d printer used. 
To make things easy follow this workflow:

- Print two matching models from test-adapted_models, one with
  0.1, 0.2 and 0.3 mm clearance each. They only contain the section
  surrounding the magnet and require little filament and print time
- Test your models with your magnets. Start with the model with
  0.3 mm clearance and insert your magnets. if they are too loose,
  continue to the next smalller clearance value. Keep in mind that
  going too low will make it hard to remove the magnets later on.
- The magnets should slide in relatively easily. Also check that
  the two halves fit together without leaving a gap.

If required, local adjustments to ``adapt_holes.sh`` will allow to
generate additional clearance values. Modifications to the ``.scad``
files will allow adjusting other dimensions of the clearance cuts.
