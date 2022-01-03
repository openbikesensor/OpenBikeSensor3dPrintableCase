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
  ], fn=polyRoundFn));
}

module PCB() {
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
    ], 180)));
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
      difference() {
        MainCaseBody();

        translate([0, 0, wall_thickness])
        MainCaseBody(reduce=wall_thickness);
      }

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
            ], fn=polyRoundFn));

            // Hole 2
            translate([OBS_height-wall_thickness, wall_thickness, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, 0, 0],
              [0, 7, 0],
              [-8, 7, 3],
              [-8, 0, 5],
              [-12, 0, 0],
            ], fn=polyRoundFn));

            // Hole 3
            translate([OBS_height-wall_thickness, 75, 0])
            linear_extrude(OBS_depth)
            polygon(polyRound([
              [0, -4, 0],
              [-8, -4, 1],
              [-8, 2, 1],
              [-2, 8, 1],
              [0, 8, 0],
            ], fn=polyRoundFn));

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
              ], fn=polyRoundFn));
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
            ], fn=polyRoundFn));
          }

          // polygon(polyRound([
          //   [0, 0, 0],
          //   [-40, -sin(frontside_angle)*40, 0],
          //   [-35, -sin(frontside_angle)*35, 2],
          //   [-35, -35, 5],
          //   [0, -35, 0],
          // ]));
        }

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
          ]));

          translate([0, 78, 0])
          cube([OBS_height-16,30,100]);
        }
      }

      // Antenna housing
      translate([OBS_height, GPS_antenna_offset, OBS_depth/2])
      rotate([0, 90, 0])
      GpsAntennaHousing();
    }

    // Hole for the sensor
    translate([OBS_height-16, OBS_width-16-sin(frontside_angle)*16, 0]) {
      translate([0, 0, -2])
      cylinder(r=SensorHole_diameter/2, h=70+4);

      // In the main case, we have to cut the clearance hole larger than
      // requeste, to account for the width and twice the clearance of the rim
      // in the lid
      translate([0, 0, wall_thickness])
      cylinder(r=SensorHole_diameter/2+SensorHole_ledge+Lid_rim_width+Lid_clearance*2, h=70);
    }

    // USB hole underneath the GPS antenna
    translate([OBS_height, USB_offset, OBS_depth/2])
    rotate([0, 90, 0]) {
      cube([16, 19, 8], center=true);
    }

    // Hole for antenna cable
    translate([OBS_height, GPS_antenna_offset, OBS_depth/2])
    rotate([0, 90, 0]) {
      translate([0, -13.5, 0])
      cylinder(d=4, h=4, center=true);

      *translate([0, -13.5+4, 0])
      cube([4, 8, 4], center=true);
    }

    // Cutout and hole for switch
    translate([Switch_offset_bottom, OBS_width_small+sin(frontside_angle)*Switch_offset_bottom, wall_thickness+4])
    rotate([0, 0, frontside_angle]) {
      translate([0, 0, 11])
      cube([22, 24, 22], center=true);

      translate([0, -4-wall_thickness, 8])
      cylinder(d=6, h=20);

      translate([0, -wall_thickness, 24])
      linear_extrude(200)
      polygon(polyRound([
        [-16, -20, 0],
        [-16, 0, 4],
        [16, 0, 4],
        [16, -20, 0],
      ]));
    }

    if (!without_inserts) {
      // Holes for M3 screws
      for (hole = Lid_hole_positions) {
        translate([hole.x, hole.y, OBS_depth])
        HeatsetInsertHole();
      }
    }
  }
}

MainCase();

// Draw the PCB for debugging (disable with *, highlight with #)
*PCB();
