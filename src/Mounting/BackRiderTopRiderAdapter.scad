include <../../variables.scad>
include <../../lib/utils.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../MainCase/MainCase.scad>
use <../Mounting/StandardMountAdapter.scad>

main_case_alignment = [0, 0, -(OBS_depth-4)+MountAttachment_width / 2 + MountAttachment_holes_x_offset];

module BackRiderTopRiderAdapter(thickness=4, width=32, length=OBS_height, flange=8) {
  difference() {
    union () {
      translate([-thickness, -thickness, -width/2])
      cube([length, length, width]);

      translate([OBS_height/2, 0, 0])
      rotate([0, 90, 90])
      StandardMountAdapterScrewHoles()
      rotate([180, 0, 0])
      cylinder(h=thickness+flange, d=6);

      for(i=[0,1])
      mirror([0, 0, i])
      hull() {
        translate([-thickness-flange, -thickness-flange, width/2-3])
        roundedCube([length+flange, length+flange, 3], flange);

        translate([-thickness, -thickness, width/2-2-flange])
        roundedCube([length-flange, length-flange, 3], 0);
      }
    }

    translate(main_case_alignment)
    MainCaseBody(reduce=-default_clearance);

    translate([-thickness-flange, OBS_height/2, 0])
    rotate([0, 90, 180])
    StandardMountAdapterScrewHoles()
    ScrewHoleM3(head_depth=thickness/2+flange, depth=100);

    translate([OBS_height/2, 0, MountAttachment_width/2+MountAttachment_holes_x_offset])
    rotate([90, 90, 0])
    MountAttachmentHolePattern(with_cable_hole=false);
  }
}

BackRiderTopRiderAdapter();

if($preview)
translate(main_case_alignment)
translate([0, MountAttachment_depth, 0])
%MainCase(top_rider=true, back_rider=true);
