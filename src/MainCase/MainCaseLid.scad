include <../../variables.scad>

use <Round-Anything/polyround.scad>
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
    difference() {
      projection(cut=true)
      MainCaseBody(1);

      union() {
        offset(r=Lid_clearance)
        projection(cut=true)
        translate([0, 0, -OBS_depth])
        MainCase(without_inserts=true);
      }
    }
  }

  difference() {
    union() {
      MainCaseBody(reduce=0, depth=Lid_thickness);

      mirror([0, 0, 1])
      translate([36, 39, 0])
      rotate([0, 0, 90])
      BatteryHolder();

      intersection() {
        translate([0, 0, -Lid_rim_thickness])
        difference() {
          linear_extrude(Lid_rim_thickness)
          RimPolygon();

          translate([0, 0, -1])
          linear_extrude(Lid_rim_thickness + 2)
          offset(r=-Lid_rim_width)
          RimPolygon();
        }

        // TODO: chamfer
      }
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
    for (hole = Lid_hole_positions) {
      translate([hole.x, hole.y, -1])
      cylinder(d=ScrewHole_diameter_M3, h=10, $fn=32);
    }
  }
}

translate([0, 0, Lid_thickness])
rotate([180, 0, 0])
MainCaseLid();
