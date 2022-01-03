include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/MountRails.scad>
use <../../lib/utils.scad>

module MainCaseBody(reduce=0, depth=OBS_depth) {
  linear_extrude(depth)
  polygon(polyRound([
    [reduce, reduce, 5-reduce],
    [OBS_height-reduce, reduce, 5-reduce],
    [OBS_height-reduce, OBS_width-reduce, 16-reduce],
    [reduce, OBS_width_small-reduce, 16-reduce],
  ], fn=$pfn));
}

module DebugPCB() {
  // move to the inside of the box
  translate([wall_thickness, wall_thickness, wall_thickness])

  // move up by the height of the screw inserts
  translate([0, 0, HeatsetInsert_height])

  // move by the offset
  translate([PCB_offset[0], PCB_offset[1], 0])

  // import the file
  rotate([0, 0, 90])
	import("../../lib/PCB_00.03.12.stl");
}

module HeatsetInsertStandoff(extend=0) {
  HeatsetInsertStandoff_profile_points = [
    [0, HeatsetInsert_height*0/3],
    [0, HeatsetInsert_height*3/3],
    [HeatsetInsert_diameter, HeatsetInsert_height*3/3],
    [HeatsetInsert_diameter, HeatsetInsert_height*2/3],
    [HeatsetInsert_diameter + HeatsetInsert_height/3, HeatsetInsert_height*1/3],
    [HeatsetInsert_diameter + HeatsetInsert_height/3, HeatsetInsert_height*0/3],
  ];

  render()
  difference() {
    union() {
      if (extend  > 0) {
        translate([-extend, 0, 0])
        mirrorCopy([0, 1, 0])
        rotate([90, 0, 90])
        linear_extrude(extend)
        polygon(HeatsetInsertStandoff_profile_points);
      }

      rotate_extrude()
      polygon(HeatsetInsertStandoff_profile_points);
    }

    HeatsetInsertHole(bottom=true);
  }
}

module GpsAntennaHousingPyramid() {
  intersection() {
    translate([-50, -50, 0])
    cube([100, 100, 100]);

    hull() {
      translate([0, 0, GpsAntennaHousing_depth-1])
      linear_extrude(1)
      polygon(roundedRectangle(GpsAntennaHousing_top_width, GpsAntennaHousing_top_height, GpsAntennaHousing_top_radius));

      translate([0, GpsAntennaHousing_bottom_offset, -1])
      linear_extrude(1)
      polygon(roundedRectangle(GpsAntennaHousing_bottom_width, GpsAntennaHousing_bottom_height, GpsAntennaHousing_bottom_radius));
    }
  }
}

module GpsAntennaLidCutBody(tab_clearance=0) {
  union() {
    translate([-50, -GpsAntennaHousing_top_height/2+GpsAntennaLid_offset, GpsAntennaHousing_depth - GpsAntennaLid_thickness])
    cube([100, 100, 10]);

    translate([0, -GpsAntennaHousing_top_height/2+GpsAntennaLid_offset, GpsAntennaHousing_depth - GpsAntennaLid_thickness])
    linear_extrude(GpsAntennaLid_tab_height - tab_clearance)
    polygon(polyRound(mirrorPoints([
      [0, 0, 0],
      [GpsAntennaLid_tab_width / 2 - tab_clearance, 0, 0],
      [GpsAntennaLid_tab_width / 2-GpsAntennaLid_tab_depth - tab_clearance, -GpsAntennaLid_tab_depth+tab_clearance, 0],
    ], 180), fn=$pfn));
  }
}

module GpsAntennaHousing() {
  difference() {
    GpsAntennaHousingPyramid();

    // Hole for ceramic antenna
    cube([GpsAntennaHousing_hole_width, GpsAntennaHousing_hole_height, 100], center=true);

    // remove the lid
    GpsAntennaLidCutBody();

    translate([0, GpsAntennaHousing_top_height / 2 - GpsAntennaHousing_screw_offset,  GpsAntennaHousing_depth - GpsAntennaLid_thickness])
    HeatsetInsertHole();
  }
}

module GpsAntennaLid() {
  translate([0, 0, -GpsAntennaHousing_depth + GpsAntennaLid_thickness])
  difference() {
    intersection() {
      GpsAntennaHousingPyramid();
      GpsAntennaLidCutBody(0.15);
    }

    translate([0, GpsAntennaHousing_top_height / 2 - GpsAntennaHousing_screw_offset,  GpsAntennaHousing_depth - GpsAntennaLid_thickness])
    cylinder(d=ScrewHole_diameter_M3, h=10, $fn=32);
  }
}

module MainCase(without_inserts=false) {
  difference() {
    union() {
      // Main outer wall and bottom
      difference() {
        MainCaseBody();

        translate([0, 0, wall_thickness])
        MainCaseBody(reduce=wall_thickness);
      }

      // PCB standoffs on the bottom of the case, with holes for heatset
      // inserts
      render()
      intersection() {
        MainCaseBody();

        union() {
          translate([wall_thickness, wall_thickness, wall_thickness]) {
            translate([PCB_offset[0], PCB_offset[1], 0]) {
              translate([PCB_holes[0][0], PCB_holes[0][1], 0])
              HeatsetInsertStandoff(PCB_holes[0][0] + PCB_offset[0]);

              translate([PCB_holes[1][0], PCB_holes[1][1], 0])
              HeatsetInsertStandoff();

              translate([PCB_holes[2][0], PCB_holes[2][1], 0])
              rotate([0, 0, 180])
              HeatsetInsertStandoff(OBS_height - PCB_holes[2][0] - 2 * wall_thickness - PCB_offset[0]);
            }
          }
        }
      }

      // High columns with holes for heatset inserts on the top, for attaching
      // the lid. Those are cut away in the middle to make room for the PCB,
      // the PCB rests on the bottom part and the top part contains the heatset
      // insert.
      difference() {
        intersection() {
          MainCaseBody();

          union() {
            // Hole 1
            translate([wall_thickness, wall_thickness, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, 0, 0],
              [0, 7, 0],
              [8, 7, 3],
              [8, 0, 5],
              [12, 0, 0],
            ], fn=$pfn));

            // Hole 2
            translate([OBS_height-wall_thickness, wall_thickness, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, 0, 0],
              [0, 7, 0],
              [-8, 7, 3],
              [-8, 0, 5],
              [-12, 0, 0],
            ], fn=$pfn));

            // Hole 3
            translate([OBS_height-wall_thickness, 75, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, -4, 0],
              [-8, -4, 1],
              [-8, 2, 1],
              [-2, 8, 1],
              [0, 8, 0],
            ], fn=$pfn));

            // Hole 4
            *translate([OBS_height-TopHole4_offset_top, OBS_width-sin(frontside_angle)*TopHole4_offset_top, 0])
            rotate([0, 0, frontside_angle]) {
              translate([0, -wall_thickness, 0])
              linear_extrude(OBS_depth)
              polygon(polyRound([
                [10, 0, 0],
                [4.5, 0, 3],
                [4.5, -9-sin(frontside_angle)*9, 3],
                [-4.5, -9, 3],
                [-4.5, 0, 3],
                [-10, 0, 0],
              ], fn=$pfn));
            }

            // Hole 5
            translate([wall_thickness, 75, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, -4, 0],
              [8, -4, 3],
              [8, sin(frontside_angle)*8, 1],
              [36, sin(frontside_angle)*36, 3],
              [36, sin(frontside_angle)*36+5, 3],
              [43, sin(frontside_angle)*43+5, 3],
              [43, 100, 0],
              [0, 100, 0],
            ], fn=$pfn));
          }
        }

        // A "house" shape that cuts away the middle of the columns, leaving
        // behind a top piece with a slanted underside (for 3D printing) and a
        // flat bottom piece, on which the PCB rests.
        difference() {
          translate([0, 88, 0])
          rotate([90,0,0])
          linear_extrude(1000)
          polygon(polyRound([
            [wall_thickness, wall_thickness+HeatsetInsert_height, 0],
            [OBS_height-wall_thickness, wall_thickness+HeatsetInsert_height, 0],
            [OBS_height-wall_thickness, OBS_depth-20, 0],
            [OBS_height/2, OBS_depth-20+OBS_height/2, 0],
            [wall_thickness, OBS_depth-20, 0],
          ], fn=$pfn));

          translate([0, 78, 0])
          cube([OBS_height-16,30,100]);
        }
      }

      // Housing for the GPS antenna
      translate([OBS_height, GPS_antenna_offset, OBS_depth/2])
      rotate([0, 90, 0])
      GpsAntennaHousing();
    }

    // The hole for the sensor
    translate([OBS_height-16, OBS_width-16-sin(frontside_angle)*16, 0]) {
      translate([0, 0, -2])
      cylinder(r=SensorHole_diameter/2, h=70+4);

      // In the main case, we have to cut the clearance hole larger than
      // requeste, to account for the width and twice the clearance of the rim
      // in the lid
      translate([0, 0, wall_thickness])
      cylinder(r=SensorHole_diameter/2+SensorHole_ledge+Lid_rim_width+Lid_clearance*2, h=70);
    }

    // Hole for accessing Micro-USB of the ESP32 from underneath the GPS
    // antenna
    translate([OBS_height, USB_offset, OBS_depth/2])
    rotate([0, 90, 0]) {
      cube([16, 19, 8], center=true);
    }

    // Hole for GPS antenna cable from the inside of the antenna housing to the
    // inside of the main case
    translate([OBS_height, GPS_antenna_offset, OBS_depth/2])
    rotate([0, 90, 0]) {
      translate([0, -13.5, 0])
      cylinder(d=4, h=4, center=true);

      *translate([0, -13.5+4, 0])
      cube([4, 8, 4], center=true);
    }

    // Cutouts and hole for switch
    translate([Switch_offset_bottom, OBS_width_small+sin(frontside_angle)*Switch_offset_bottom, wall_thickness+4])
    rotate([0, 0, frontside_angle]) {
      // Square cutout on outside
      translate([0, 0, 11])
      cube([22, 24, 22], center=true);

      // Hole for the switches' lever
      translate([0, -4-wall_thickness, 8])
      cylinder(d=6, h=20);

      // Rounded cutout on the inside, the main switch body sits in this place.
      translate([0, -wall_thickness, 24])
      linear_extrude(200)
      polygon(polyRound([
        [-16, -20, 0],
        [-16, 0, 4],
        [16, 0, 4],
        [16, -20, 0],
      ], fn=$pfn));
    }

    // Holes for inserts on top of the columns created earlier. Can be disabled
    // to generate the outline for the lid without the holes (the lid generates
    // those holes differently, as they contain M3 screws, not inserts).
    if (!without_inserts) {
      for (hole = Lid_hole_positions) {
        translate([hole.x, hole.y, OBS_depth])
        HeatsetInsertHole();
      }
    }
  }
}

MainCase();

// Draw the PCB for debugging (disable with *, highlight with #)
*DebugPCB();
