include <../../lib/BOSL2/std.scad>
include <../../lib/BOSL2/rounding.scad>
include <../../variables.scad>
include <../../lib/utils.scad>

use <../../lib/Round-Anything/polyround.scad>

use <../MainCase/MainCase.scad>
use <../MainCase/MainCaseLid.scad>
include <../../lib/PiZero.scad>
use <../../lib/RPiCam-v2.scad>
use <../DisplayCase/DisplayCaseTop.scad>
use <../Mounting/StandardMountAdapter.scad>

CamLid_height = StandardMountAdapter_width - 2 * wall_thickness;

CamLid_pi_rotation = [0, 180, 270];


battery_screw_positions = [[20, 10, 0], [48, 74, 0]];
CamBox_width = 85;
CamBox_height = 63;
CamBox_depth = 24;
CamBox_radius = 8;

CamLid_pi_position = [38, CamBox_height - 18, 3];

CamLid_converter_position = [15, 80, 0];
CamLid_converter_dimensions = [22.3, 4.3, 11.5];


switch_case_size = [13, 7, 15];
switch_stem_diameter = 6.2;
switch_stem_length = 8.5;
switch_handle_length = 10;

switch_position = [OBS_height - 1.6, 25, 0.5];

CamLid_battery_dimensions = [50, 34, 10.2];
CamLid_battery_position = [CamLid_battery_dimensions[0] / 2 + 2 * wall_thickness, CamBox_height - CamLid_battery_dimensions[1] / 2 - 2 * wall_thickness - 10, CamBox_depth -
  CamLid_battery_dimensions[2] - wall_thickness];
CamLid_battery_rotation = [0, 0, 0];

m3_insert_hole_depth = 7;
flex_cable_width = 16.05;

cam_hole_position = [CamBox_width / 2, 2 * wall_thickness, CamBox_depth / 2 - wall_thickness / 2];

module switch(clearance = true) {
  translate([- 11.5 / 2, 0, - 0.5])cube([11.5, 5, 6]);
  translate([- 7 / 2, 1, 1])cube([7, 7.8, 3]);
  difference() {
    union() {
      if (clearance)translate([- 20 / 2, 0.45, - 0.5])cube([20, 10, 6]);
      translate([- 20 / 2, 0, 0])cube([20, 0.45, 5]);}
    for (i = [- 1, 1]) {
      translate([i * 15 / 2, 1, 5 / 2])rotate([90, 0, 0])cylinder(d = 1.8, h = 2);
    }
  }
  translate([- 6.2 / 2, - 6, (5 - 3.2) / 2])cube([6.2, 6, 3.2]);
}

module battery() {
  translate(CamLid_battery_position + [0, 0, CamLid_battery_dimensions[2] / 2])rotate(CamLid_battery_rotation)cube(CamLid_battery_dimensions, center = true);
}

module charger() {
  translate([0, 0, - 0.25])cube([12.4, 26.2, 4.25], center = false);
  translate([(12.4 - 8.5) / 2, 25, - 0.25])cube([8.5, 3, 3.5], center = false);
  corners = [[0, 0, 1], [0, 8, 1], [11, 8, 1], [11, 0, 1]];
  translate([(12.4 - 11) / 2, 28.251, - (8 - 3) / 2])rotate([90, 0, 0])polyRoundExtrude(corners, 1, 0.5, - 0.5);
}

module charger_bay() {
  corners = [[0, 1, 0], [8, 1, 0], [8, 20, 1], [0, 20, 1]];
  polyRoundExtrude(corners, 10.5, 0, 0);
  corners_low = [[0, 1, 0], [8, 1, 0], [8, 30, 1], [0, 30, 1]];
  polyRoundExtrude(corners_low, 2, 0, 0);
  corners_low_2 = [[0, 28, 0], [4, 28, 0], [4, 30, 1], [0, 30, 1]];
  polyRoundExtrude(corners_low_2, 10.5, 0, 0);
}

module battery_bay() {
  cld = CamLid_battery_dimensions / 2 + [2, 2, CamLid_battery_dimensions[2] / 2];
  battery_silhouette = [
      [- cld[0], - cld[1], 2],
      [cld[0], - cld[1], 2],
      [cld[0], cld[1], 2],
      [- cld[0], cld[1], 2]
    ];
  translate(CamLid_battery_position + [0, 0, 0])rotate(CamLid_battery_rotation)polyRoundExtrude(battery_silhouette, cld[2], 0, 0);
}

module converter_bay(outset = 2) {
  cd = CamLid_converter_dimensions + [outset, outset, 0];
  corners = [[- outset, - outset, 1], [cd[0], - outset, 1], [cd[0], cd[1], 1], [- outset, cd[1], 1]];
  polyRoundExtrude(corners, cd[2] - epsilon, 0, 0);

}

module pi_mount_stem_locations() {
  translate(CamLid_pi_position)translate([0, 0, - PiSizeZ])for (x = [- PiHoleX, PiHoleX], y = [
    - PiHoleY, PiHoleY])
  {
    translate([x, y]) children();
  }
}

module battery_brace_screw_locations() {
  for (position = battery_screw_positions)
  {
    translate(position) children();
  }
}


module pi() {
  if ($preview) {
    PiZeroBody();
    PiGPIO(1);
  }
}

module MountAdapter() {
  difference() {
    translate([3, 36, StandardMountAdapter_width / 2])
      rotate([0, - 90, 0])
        difference()
          {
            StandardMountAdapter(channels = false, screwholes = false);translate([0, 0, - 47])
            cube(100, center = true);
          }

  }
}

module button_hole() {
  // Hole for the sensor
  translate([OBS_height - 16, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16, 0]) {
    translate([0, 0, - 15])
      cylinder(r = DisplayCaseTop_button_diameter / 2, h = 20);
    //the sensor has about 1.5 mm space for the silicone edge.
    translate([0, 0, 0])        cylinder(r = MainCase_sensor_hole_diameter / 2 + 1.2, h = wall_thickness - 1.5);
  }
  translate([OBS_height - 16, OBS_width - 1 / tan((90 - frontside_angle) / 2) * 16, - 20]) {
    cylinder(r = MainCase_sensor_hole_diameter / 2 + MainCase_sensor_hole_ledge, h = 20);
  }
}

box_corners = function(inset)  [
    [inset, inset, CamBox_radius - inset],
    [CamBox_width - inset, inset, CamBox_radius - inset],
    [CamBox_width - inset, CamBox_height - inset, CamBox_radius - inset],
    [inset, CamBox_height - inset, CamBox_radius - inset]
  ];

cam_box_lid_screw_positions_array = [for (i = [CamBox_radius, CamBox_width - CamBox_radius], j = [CamBox_radius, CamBox_height - CamBox_radius])
    [i, j]];

function cam_box_lid_screw_mount_polygon(shift) = [
    [- CamBox_radius+shift, - CamBox_radius+shift, CamBox_radius-shift],
    [4, - CamBox_radius+shift, 0],
    [4, 4, 4],
    [- CamBox_radius+shift, 4, 0]
  ];


module CamBoxBody() {
  difference()
    {
      translate([0, 0, - wall_thickness])difference() {
        polyRoundExtrude(box_corners(0), CamBox_depth, 0, 0);
        translate([0, 0, wall_thickness])polyRoundExtrude(box_corners(wall_thickness), CamBox_depth, 0, 0);
      }
      #translate(cam_hole_position)rotate([90, 0, 0])cylinder(d = flex_cable_width + 2, h = 10);

    }
}

module CamScrewMounts() {
  angles = [0, 270, 90, 180];
  for (i = [0:1:3]) {
    intersection() {
      hull() {
        translate([0, 0, CamBox_depth - 9])translate(cam_box_lid_screw_positions_array[i]) rotate([0, 0, angles[i]]) polyRoundExtrude(cam_box_lid_screw_mount_polygon(0), 6, 0);
        translate([0, 0, CamBox_depth - 9])translate(cam_box_lid_screw_positions_array[i]) rotate([0, 0, angles[i]]) translate([- CamBox_radius, - CamBox_radius, - 7])
          polyRoundExtrude(cam_box_lid_screw_mount_polygon(0), 6, 0);
      }
      translate([0, 0, CamBox_depth - 20])translate(cam_box_lid_screw_positions_array[i]) rotate([0, 0, angles[i]]) polyRoundExtrude(cam_box_lid_screw_mount_polygon(0), 30, 0);

    }
  }
}

module Corners(){
  translate([0,0,CamBox_depth-wall_thickness-0.9])polyRoundExtrude(box_corners(wall_thickness+0.2),0.8,0,0);

}

module CamLid() {
  CamBoxBody();
  translate(cam_hole_position)rotate([90, 0, 0])cam_sviwel();
  #battery();
  #translate([28.2, CamLid_pi_position[1] - 15, 5])rotate([0, 180, 90])charger();
  if ($preview)translate(CamLid_pi_position)pi();
  pi_mount_stem_locations() translate([0, 0, - CamLid_pi_position[2] + PiSizeZ])cylinder(r2 = PiHoleClearRad, r1 = PiHoleClearRad, h = CamLid_pi_position[2]);
  translate([5, 14, 0])#rotate([90, 0, 0])converter();
  CamScrewMounts();
  Corners();
}

module battery_brace() {
  difference() {
    hull()battery_brace_screw_locations()    translate([0, 0, CamLid_battery_dimensions[2] + 0.2])cylinder(h = 1.5, d = 8);
    battery_brace_screw_locations()    {
      translate([0, 0, CamLid_battery_dimensions[2] + 0.2 - epsilon])cylinder(h = 10, d = m3_screw_diameter_loose);
      translate([0, 0, CamLid_battery_dimensions[2] + 0.2 + 0.6 - epsilon])cylinder(d = m3_screw_head_diameter, h = 8);
    }
  }

}

module cam_sviwel_bottom(ds = 0.5, dc = 0, hmult = 2.1) {
  difference() {
    union() {
      cylinder(d = flex_cable_width + 2 - 0.4, h = hmult * wall_thickness);
      cylinder(d = flex_cable_width + 2 - 0.4 + dc, h = 2);
      polyRoundExtrude([[- CamLid_height, - CamLid_height, 4] / 2,
          [flex_cable_width / 3, - flex_cable_width / 3, 0.5 * flex_cable_width + 1],
          [CamLid_height / 2, CamLid_height / 2, 2],
          [- flex_cable_width / 3, + flex_cable_width / 3, 0.5 * flex_cable_width + 1],], 2, 0, 0);
    }
    cube([flex_cable_width + 0.5, 1, 18], center = true);
    for (i = [1, - 1]) {
      translate([0, i * flex_cable_width / 3, - 0.1])cylinder(d = 2.8 + ds, h = 10);
    }
  }
}

module cam_sviwel_top()
{
  clamp_screw_position = [0, 0, 37];
  difference() {
    translate([0, 0, + wall_thickness * 2 + 0.3])union() {
      cam_sviwel_bottom(ds = 0, dc = 4, hmult = 1);
      for (i = [0, 1])mirror([i, 0, 0])polyRoundExtrude([[- 7, 8, 3], [- 7, 5, 3], [- 15, 5
        , 3], , [- 15, - 4, 3], [0, - 4, 0], [0, 8, 0]], 30.5, 1.5, 0);
      polyRoundExtrude([[- 7, 8, 1.5], [- 7, - 4, 1.5], [7, - 4, 1.5], [7, 8, 1.5]], 36.5, 1.5, 0);

    }
    for (i = [0, 1]) mirror([i, 0, 0])
      for (i = [1, - 1])
      translate([0, i * flex_cable_width / 3, - 0.1])cylinder(d = 2.8, h = 10);
    // the hollow for the cam
    translate([- 13, - .5, 7.5])cube([26, 4, 25.5], center = false);
    translate([- 4.8, 3, 13])cube([9.5, 3.5, 9.5], center = false);
    translate([- 4.8 + 4.75, 3 + 4, 13.2 + 4.5])rotate([90, 0, 0])cylinder(d = 8.8, h = 8, center = true);
    translate([- 12.5, - 2, 7.5])cube([25, 3, 8], center = false);
    // cut it in its two halves
    cube([80, 0.2, 90], center = true);
    //* the screw for closing the cam at the top
    translate(clamp_screw_position)rotate([90, 0, 0])cylinder(d = m3_screw_diameter_loose, h = 10);
    translate(clamp_screw_position - [0, 2, 0])rotate([90, 0, 0])cylinder(d = m3_screw_head_diameter, h = 10);
    translate(clamp_screw_position + [0, 10, 0])rotate([90, 0, 0])cylinder(d = m3_screw_diameter_tight, h = 10);
    // the flex cable slit
    translate([0, 0, 4])cube([flex_cable_width + 0.5, 1, 18], center = true);
  }
}

module cam_sviwel() {
  cam_sviwel_bottom(dc = 1);
  cam_sviwel_top();
}

module converter() {
  cube(CamLid_converter_dimensions);
  for (i = [0, 1])translate([i * CamLid_converter_dimensions[0], - 0.5 - epsilon, 0] - [i * 4, 0, 0])cube([4, 8, CamLid_converter_dimensions[2]]);
}


if (logo_generate_templates) {
  projection(cut = true)
    translate([0, 0, - 0.001])
      CamLid();
} else {
  GenerateWithLogo() {
    {if (logo_use_prebuild) {
      import("../../export/Attachments/CamLid.stl");
    } else {
      CamLid();
    }};
    translate([- 108, - 72 - 72, 0])
      load_svg(str("../../logo/", logo_name, "/MainCaseLid.svg"));
  }
};
echo(box_corners(3));