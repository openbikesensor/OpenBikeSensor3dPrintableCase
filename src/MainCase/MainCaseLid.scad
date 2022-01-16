include <../../variables.scad>
include <../../lib/utils.scad>

use <../../lib/Round-Anything/polyround.scad>
use <MainCase.scad>

module MainCaseLid() {
  module BatteryHolderChannel() {
    translate([0, BatteryHolderChannel_width/2, 0])
    rotate([90, 0, 0])
    linear_extrude(BatteryHolderChannel_width)
    polygon(polyRound(mirrorPoints([
      [0, BatteryHolderChannel_depth/2, 0],
      [BatteryHolder_inner_width/2+3, BatteryHolderChannel_depth/2, BatteryHolderChannel_radius],
      [BatteryHolder_inner_width/2+3, BatteryHolderChannel_depth/2+BatteryHolderChannel_radius, 0],
      [BatteryHolder_inner_width/2+3+BatteryHolderChannel_extra_length, BatteryHolderChannel_depth/2+BatteryHolderChannel_radius, 0],
      [BatteryHolder_inner_width/2+3+BatteryHolderChannel_extra_length, -BatteryHolderChannel_depth/2, 0],
      [0, -BatteryHolderChannel_depth/2, 0],
    ], 180), fn=$pfn));
  }

  module BatteryHolder() {
    translate([0, BatteryHolder_length/2, BatteryHolder_lift])
    rotate([90, 0, 0])
    linear_extrude(BatteryHolder_length)
    polygon(polyRound(mirrorPoints([
      [0, 0, 0],
      [BatteryHolder_inner_width / 2, 0, BatteryHolder_inner_radius],
      [BatteryHolder_inner_width / 2, BatteryHolder_height, 0],
      [BatteryHolder_inner_width / 2 + 1, BatteryHolder_height, 0],
      [BatteryHolder_inner_width / 2 + 2.55, BatteryHolder_height - 1.8, 0],
      [BatteryHolder_inner_width / 2 + 2, BatteryHolder_height - 2.35, 0],
      [BatteryHolder_inner_width / 2 + 2, BatteryHolder_height - 5.85, 0],
      [BatteryHolder_inner_width / 2 + 3, BatteryHolder_height - 6.85, 0],
      [BatteryHolder_inner_width / 2 + 3, -BatteryHolder_lift, 0],
      // [0, -BatteryHolder_lift, 0],
    ], 180), fn=$pfn));
  }

  module RimPolygon() {
    rim_offset = wall_thickness + MainCaseLid_rim_clearance;
    hole_x = 75;

    dx = function (x) x * sin(frontside_angle);
    polygon(polyRound([
      [rim_offset+MainCaseLid_rim_radius, rim_offset, 0],
      [rim_offset+MainCaseLid_rim_radius, rim_offset+MainCaseLid_rim_radius, MainCaseLid_rim_radius],
      [rim_offset, rim_offset+MainCaseLid_rim_radius, 0],

      [rim_offset, hole_x-MainCaseLid_rim_radius, 0],
      [rim_offset+MainCaseLid_rim_radius, hole_x-MainCaseLid_rim_radius, MainCaseLid_rim_radius],
      [rim_offset+MainCaseLid_rim_radius, hole_x, 0],
      [rim_offset+MainCaseLid_rim_radius, OBS_width_small-rim_offset+dx(rim_offset+MainCaseLid_rim_radius), 0],

      [OBS_height/2, OBS_width_small+dx(OBS_height/2)-rim_offset, 0],
      [OBS_height/2, hole_x - rim_offset * 2, MainCaseLid_rim_radius *2],
      [OBS_height-rim_offset, hole_x - rim_offset * 2, 0],

      [OBS_height-rim_offset, rim_offset+MainCaseLid_rim_radius, 0],
      [OBS_height-rim_offset-MainCaseLid_rim_radius, rim_offset+MainCaseLid_rim_radius, MainCaseLid_rim_radius],
      [OBS_height-rim_offset-MainCaseLid_rim_radius, rim_offset, 0],
    ], fn=$pfn));
  }

  module Rim(chamfer_size) {
    translate([0, 0, -MainCaseLid_rim_thickness+chamfer_size])
    minkowski(){
      // If the chamfer is not rendered, the minkowski() has only one child
      // (the base shape), therefore it will only render the child and not
      // operate on it.
      if (chamfer_size) {
        rotate([180,0,0])ChamferPyramid(chamfer_size);
      }

      intersection() {
        difference() {
          linear_extrude(MainCaseLid_rim_thickness-chamfer_size)
            offset(r=-chamfer_size)
            RimPolygon();

          translate([0, 0, -1])
            linear_extrude(MainCaseLid_rim_thickness + 2)
            offset(r=-(MainCaseLid_rim_width-chamfer_size))
            RimPolygon();
        }
      }
    }
  }

  translate([0, 0, MainCaseLid_thickness])
  rotate([180, 0, 90])
  difference() {
    union() {
      MainCaseBody(reduce=0, depth=MainCaseLid_thickness);

      mirror([0, 0, 1])
      translate([36, 39, 0])
      rotate([0, 0, 90])
      BatteryHolder();

      Rim(fast ? 0 : 0.25);
    }

    // Channels underneath battery holder, for zip-ties
    for (i = [-1, 1]) {
      mirror([0, 0, 1])
      translate([36+i*BatteryHolderChannel_spacing/2, 39, 0])
      rotate([0, 0, 90])
      BatteryHolderChannel();
    }

    // Hole for the sensor
    translate([OBS_height-16, OBS_width-16-sin(frontside_angle)*16, 0]) {
      translate([0, 0, -15])
      cylinder(r=SensorHole_diameter/2, h=20);
    }
    translate([OBS_height-16, OBS_width-16-sin(frontside_angle)*16, -20]) {
      cylinder(r=SensorHole_diameter/2 + SensorHole_ledge, h=20);
    }

    // Holes for M3 screws
    for (hole = MainCaseLid_hole_positions) {
      translate([hole.x, hole.y, -1])
      cylinder(d=ScrewHole_diameter_M3, h=10, $fn=32);
    }
  }
}

if (logo_generate_templates) {
  mirror([1, 0, 0])
  projection(cut=true)
  translate([0, 0, -0.001])
  MainCaseLid();
} else {
  GenerateWithLogo() {
    MainCaseLid();

    mirror([1, 0, 0])
    translate([-104, -72-72, 0])
    import(str("../../logo/", logo_name, "/MainCaseLid.svg"));
  }
}

