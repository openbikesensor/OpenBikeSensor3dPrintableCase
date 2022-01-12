include <../../variables.scad>

use <../../lib/utils.scad>
use <./BikeRackMountCenter.scad>

// Vhis variation includes holes for rods that run longitudinally, i.e. from
// front to back, in the center piece of the mount. This also changes the base
// shape and print orientation.

translate([0, 0, -10])
rotate([180, 0, 0])
BikeRackMountCenter(longitudinal=true);
