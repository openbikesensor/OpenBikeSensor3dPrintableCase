include <../../variables.scad>
include <../../lib/utils.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../MainCase/MainCase.scad>
use <../Mounting/StandardMountAdapter.scad>

module BackRiderTopRiderAdapter() {
  post_width = 10;
  center_height = OBS_height/2+default_clearance;

  union() {
    rotate([180, 0, 0])
    StandardMountAdapterBody();

    translate([MountRail_width/2, StandardMountAdapter_length/2, 0])
    rotate([90, 0, -90])
    roundedCube([post_width, center_height + MountRail_plate_width/2-MountRail_clearance, MountRail_width], [0, 0, 0, post_width]);

    translate([0, StandardMountAdapter_length/2-post_width, center_height])
    rotate([90, 0, 0])
    rotate([0, 0, 90])
    mirror([0, 0, 1])
    translate([0, -MountRail_width/2, 0])
    MountRail(MountRail_clearance);
  }
}


if (orient_for_printing) {
  translate([0, 0, MountRail_width/2])
  rotate([0, 90, 0])
  BackRiderTopRiderAdapter();
} else {
  rotate([0, 0, -90])
  BackRiderTopRiderAdapter();
}

// if ($preview)
// translate([-30, 10, 0])
// rotate([0, -90, 180])
// %MainCase(top_rider=true, back_rider=true);
