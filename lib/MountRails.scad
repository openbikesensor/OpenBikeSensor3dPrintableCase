include <../variables.scad>

use <Round-Anything/polyround.scad>
use <./utils.scad>

/**
 * Produces a rail with a smaller plate to attach to, and a bigger base that
 * holds it in the opposite rail. The rail is centered on one of the long edges
 * of the plate that can be built upon, ranging wide in both x directions and
 * short into the positive y direction.
 */
module MountRail() {
  translate([0, 0, -MountRail_total_height ])
  rotate([90, 0, 180])
  mirrorCopy([1, 0, 0])
  difference() {
    linear_extrude(MountRail_width)polygon([
      [0, 0],
      [MountRail_base_width/2, 0],
      [MountRail_base_width/2, MountRail_base_height],
      [MountRail_plate_width/2, MountRail_base_height+MountRail_chamfer_height],
      [MountRail_plate_width/2, MountRail_total_height],
      [0, MountRail_base_height+MountRail_chamfer_height+MountRail_plate_height]
    ]);

    translate([MountRail_base_width/2, 0, MountRail_width/2])
    rotate([0, -90, 0])
      cylinder(r=MountRail_pin_radius, h=MountRail_pin_length, $fn=32);
  }
}
