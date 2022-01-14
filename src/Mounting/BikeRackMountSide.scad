include <../../variables.scad>
use <./BikeRackMountCenter.scad>

if (orient_for_printing) {
  translate([0, 0, BikeRackMountSide_length/2])
  rotate([0, 90, 0])
  BikeRackMountSide();
} else {
  BikeRackMountSide();
}

