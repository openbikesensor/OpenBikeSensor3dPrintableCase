include <../../variables.scad>
use <./BikeRackMountCenter.scad>

translate([0, 0, BikeRackMountSide_length/2])
rotate([0, 90, 0])
BikeRackMountSide();

