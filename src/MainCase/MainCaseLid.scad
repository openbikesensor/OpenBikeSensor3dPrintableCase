include <../../lib/BOSL2/std.scad>
include <../../lib/BOSL2/rounding.scad>
include <../../variables.scad>
include <../../lib/utils.scad>

use <../../lib/Round-Anything/polyround.scad>
use <MainCase.scad>

module MainCaseLid() {
  module BatteryHolderChannel() {
    translate([0, MainCaseLid_battery_holder_channel_width/2, 0])
    rotate([90, 0, 0])
    linear_extrude(MainCaseLid_battery_holder_channel_width)
    polygon(polyRound(mirrorPoints([
      [0, MainCaseLid_battery_holder_channel_depth/2, 0],
      [MainCaseLid_battery_holder_inner_width/2+3, MainCaseLid_battery_holder_channel_depth/2, MainCaseLid_battery_holder_channel_radius],
      [MainCaseLid_battery_holder_inner_width/2+3, MainCaseLid_battery_holder_channel_depth/2+MainCaseLid_battery_holder_channel_radius, 0],
      [MainCaseLid_battery_holder_inner_width/2+3+MainCaseLid_battery_holder_channel_extra_length, MainCaseLid_battery_holder_channel_depth/2+MainCaseLid_battery_holder_channel_radius, 0],
      [MainCaseLid_battery_holder_inner_width/2+3+MainCaseLid_battery_holder_channel_extra_length, -MainCaseLid_battery_holder_channel_depth/2, 0],
      [0, -MainCaseLid_battery_holder_channel_depth/2, 0],
    ], 180), fn=$pfn));
  }

  module BatteryHolder() {
    translate([0, MainCaseLid_battery_holder_length/2, MainCaseLid_battery_holder_lift])
    rotate([90, 0, 0])
    linear_extrude(MainCaseLid_battery_holder_length)
    polygon(polyRound(mirrorPoints([
      [0, 0, 0],
      [MainCaseLid_battery_holder_inner_width / 2, 0, MainCaseLid_battery_holder_inner_radius],
      [MainCaseLid_battery_holder_inner_width / 2, MainCaseLid_battery_holder_height, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 1, MainCaseLid_battery_holder_height, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 2.55, MainCaseLid_battery_holder_height - 1.8, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 2, MainCaseLid_battery_holder_height - 2.35, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 2, MainCaseLid_battery_holder_height - 5.85, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 3, MainCaseLid_battery_holder_height - 6.85, 0],
      [MainCaseLid_battery_holder_inner_width / 2 + 3, -MainCaseLid_battery_holder_lift, 0],
      // [0, -MainCaseLid_battery_holder_lift, 0],
    ], 180), fn=$pfn));
  }

  module Rim(chamfer_size) {
    rim_offset = wall_thickness + MainCaseLid_rim_clearance;
    hole_x = 75;
    rs = MainCase_sensor_hole_diameter / 2 + 2.4; //shorthand for readabilty: radius around the sensor hole.

    dx = function (x) x * tan(frontside_angle);
    rimPolyPoints = remove_conseq_dupes(polyRound([
        [rim_offset + MainCaseLid_rim_radius, rim_offset, 0],
        [rim_offset + MainCaseLid_rim_radius, rim_offset + MainCaseLid_rim_radius, MainCaseLid_rim_radius],
        [rim_offset, rim_offset + MainCaseLid_rim_radius, 0],

        [rim_offset, hole_x - MainCaseLid_rim_radius, 0],
        [rim_offset + 0.7 * MainCaseLid_rim_radius, hole_x - 0.5 * MainCaseLid_rim_radius, 0.7 * MainCaseLid_rim_radius],
        [rim_offset + 0.7 * MainCaseLid_rim_radius, hole_x, 0],
        [rim_offset + 0.7 * MainCaseLid_rim_radius, OBS_width_small - rim_offset*1 / tan((90 - frontside_angle) / 2) + dx(rim_offset + 0.7 * MainCaseLid_rim_radius), 0],
        [OBS_height / 2, OBS_width_small + dx(OBS_height / 2) - rim_offset / tan((90 - frontside_angle) / 2), 0],
        [OBS_height / 2, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16, 0],
      // sensor hole circle starts here
        [OBS_height - 16 - rs, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16, 0],
        [OBS_height - 16 - rs, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16 + rs, rs],
        [OBS_height - 16, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16 + rs, 0],
        [OBS_height - 16 + rs, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16 + rs, rs],
        [OBS_height - 16 + rs, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16, 0],
        [OBS_height - 16 + rs, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16 - rs, rs],
        [OBS_height - 16, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16 - rs, 0],
      // sensor hole circle ends here.
        [OBS_height  - 10, hole_x - rim_offset * 2, 0],
        [OBS_height - rim_offset, hole_x - rim_offset * 2, 0],
        [OBS_height - rim_offset, rim_offset + MainCaseLid_rim_radius, 0],
        [OBS_height - rim_offset - MainCaseLid_rim_radius, rim_offset + MainCaseLid_rim_radius, MainCaseLid_rim_radius],
        [OBS_height - rim_offset - MainCaseLid_rim_radius, rim_offset, 0],
      ], fn = $pfn));

    translate([0, 0, - MainCaseLid_rim_thickness])difference() {
      offset_sweep(rimPolyPoints, height = MainCaseLid_rim_thickness, bottom = os_chamfer(chamfer_size),  steps = 2, check_valid = true,$fn = 16);
      offset_sweep(offset(rimPolyPoints, r = - MainCaseLid_rim_width, closed = true), height = MainCaseLid_rim_thickness, bottom = os_chamfer(-chamfer_size), steps = 2, check_valid = true, $fn = 16);
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
      translate([36+i*MainCaseLid_battery_holder_channel_spacing/2, 39, 0])
      rotate([0, 0, 90])
      BatteryHolderChannel();
    }

    // Hole for the sensor
    translate([OBS_height-16, OBS_width-1/tan((90-frontside_angle)/2)*16, 0]) {
      translate([0, 0, -15])
      cylinder(r=MainCase_sensor_hole_diameter/2, h=20);
      // the sensor has about 1.5 mm space for the silicone edge.
      translate([0, 0, 0])
        cylinder(r = MainCase_sensor_hole_diameter / 2+1.2, h = wall_thickness-1.5 );
    }
    translate([OBS_height-16, OBS_width-1/tan((90-frontside_angle)/2)*16, -20]) {
      cylinder(r=MainCase_sensor_hole_diameter/2 + MainCase_sensor_hole_ledge, h=20);
    }

    // Holes for M3 screws
    for (hole = MainCaseLid_hole_positions) {
      translate([hole.x, hole.y, -1])
      cylinder(d=m3_screw_diameter_loose, h=10, $fn=32);
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
    if (logo_use_prebuild) {
      import("../../export/MainCase/MainCaseLid.stl");
    } else {
      MainCaseLid();
    }
    mirror([1, 0, 0])
    translate([-104, -72-72, 0])
    load_svg(str("../../logo/", logo_name, "/MainCaseLid.svg"));
  }
}
// When changing MainCase outer dimensions, check that the rim does still fit by removing the asterisk:
*#translate([0,0,-40])rotate([0,0,-90])mirror([1,0,0])MainCase();

