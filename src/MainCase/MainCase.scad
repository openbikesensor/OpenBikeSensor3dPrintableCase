include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>
use <./UsbCover.scad>
use <../Mounting/StandardMountAdapter.scad>

module MainCaseBody(reduce=0, depth=OBS_depth) {
  linear_extrude(depth)
  polygon(polyRound([
    [reduce, reduce, MainCase_small_corner_radius-reduce],
    [OBS_height-reduce, reduce, MainCase_small_corner_radius-reduce],
    [OBS_height-reduce, OBS_width-reduce/tan((90-frontside_angle)/2), 16-reduce],
    [reduce, OBS_width_small-reduce, 16-reduce],
  ], fn=$pfn));
}

module DebugPCB() {
  // move to the inside of the box
  translate([wall_thickness, wall_thickness, wall_thickness])

  // move up by the height of the screw inserts
  translate([0, 0, m3_insert_hole_depth])

  // move by the offset
  translate([MainCase_pcb_offset.x, MainCase_pcb_offset.y, 0])

  // import the file
  rotate([0, 0, 90])
	import("../../lib/PCB_00.03.12.stl");
}

module HeatsetInsertStandoff(extend=0) {
  HeatsetInsertStandoff_profile_points = [
    [0, m3_insert_hole_depth*0/3],
    [0, m3_insert_hole_depth*3/3],
    [m3_insert_hole_diameter, m3_insert_hole_depth*3/3],
    [m3_insert_hole_diameter, m3_insert_hole_depth*2/3],
    [m3_insert_hole_diameter  + m3_insert_hole_depth/3, m3_insert_hole_depth*1/3],
    [m3_insert_hole_diameter  + m3_insert_hole_depth/3, m3_insert_hole_depth*0/3],
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
      translate([0, 0, MainCase_gps_antenna_housing_depth-1])
      linear_extrude(1)
      polygon(roundedRectangle(MainCase_gps_antenna_housing_top_width, MainCase_gps_antenna_housing_top_height, MainCase_gps_antenna_housing_top_radius));

      translate([0, MainCase_gps_antenna_housing_bottom_offset, -1])
      linear_extrude(1)
      polygon(roundedRectangle(MainCase_gps_antenna_housing_bottom_width, MainCase_gps_antenna_housing_bottom_height, MainCase_gps_antenna_housing_bottom_radius));
    }
  }
}

module GpsAntennaLidCutBody(tab_clearance=0) {
  union() {
    translate([-50, -MainCase_gps_antenna_housing_top_height/2+MainCase_gps_antenna_lid_offset, MainCase_gps_antenna_housing_depth - MainCase_gps_antenna_lid_thickness])
    cube([100, 100, 10]);

    translate([0, -MainCase_gps_antenna_housing_top_height/2+MainCase_gps_antenna_lid_offset, MainCase_gps_antenna_housing_depth - MainCase_gps_antenna_lid_thickness])
    linear_extrude(MainCase_gps_antenna_lid_tab_height - tab_clearance)
    polygon(polyRound(mirrorPoints([
      [0, 0, 0],
      [MainCase_gps_antenna_lid_tab_width / 2 - tab_clearance, 0, 0],
      [MainCase_gps_antenna_lid_tab_width / 2-MainCase_gps_antenna_lid_tab_depth - tab_clearance, -MainCase_gps_antenna_lid_tab_depth+tab_clearance, 0],
    ], 180), fn=$pfn));
  }
}

module GpsAntennaHousing() {
  difference() {
    GpsAntennaHousingPyramid();

    // Hole for ceramic antenna
    cube([MainCase_gps_antenna_housing_hole_width, MainCase_gps_antenna_housing_hole_height, 100], center=true);

    // remove the lid
    GpsAntennaLidCutBody();

    // heatset insert hole
    translate([0, MainCase_gps_antenna_housing_top_height / 2 - MainCase_gps_antenna_housing_screw_offset,  MainCase_gps_antenna_housing_depth - MainCase_gps_antenna_lid_thickness])
    HeatsetInsertHole();
  }
}

module GpsAntennaLid() {
  translate([0, 0, -MainCase_gps_antenna_housing_depth + MainCase_gps_antenna_lid_thickness])
  difference() {
    intersection() {
      GpsAntennaHousingPyramid();
      GpsAntennaLidCutBody(0.15);
    }

    translate([0, MainCase_gps_antenna_housing_top_height / 2 - MainCase_gps_antenna_housing_screw_offset,  MainCase_gps_antenna_housing_depth - MainCase_gps_antenna_lid_thickness])
    cylinder(d=m3_screw_diameter_loose, h=10, $fn=32);
  }

  if (enable_text) {
    translate([5,-13 ,0])rotate([0,0,90])linear_extrude(MainCase_gps_antenna_lid_thickness+.4)text("GPS",font="open sans", size=10);
  }
}

module SwitchboxPolygon(padding=0,height=1, depth=12, width=15) {
  linear_extrude(height)polygon(
    polyRound([
    [-width-1-padding,.05,0],
    [-width-padding,0.1,1.5],
    [-width+4-padding,-depth-padding,3],
    [width-4+padding,-depth-padding,3],
    [width+padding,0.05,1.5],
    [width+1+padding,0.05,0]
    ]),$fn=$pfn
  );
}


module MainCase(without_inserts=false, top_rider=MainCase_top_rider, back_rider=MainCase_back_rider) {
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
            translate([MainCase_pcb_offset[0], MainCase_pcb_offset[1], 0]) {
              translate([MainCase_pcb_holes[0].x, MainCase_pcb_holes[0].y, 0])
              HeatsetInsertStandoff(MainCase_pcb_holes[0].x + MainCase_pcb_offset[0]);

              translate([MainCase_pcb_holes[1].x, MainCase_pcb_holes[1].y, 0])
              HeatsetInsertStandoff();

              translate([MainCase_pcb_holes[2].x, MainCase_pcb_holes[2].y, 0])
              rotate([0, 0, 180])
              HeatsetInsertStandoff(OBS_height - MainCase_pcb_holes[2].x - 2 * wall_thickness - MainCase_pcb_offset[0]);

              translate([MainCase_pcb_holes[3].x, MainCase_pcb_holes[3].y, 0])
              rotate([0, 0, 0])
              HeatsetInsertStandoff(OBS_height - MainCase_pcb_holes[3].x - 2 * wall_thickness - MainCase_pcb_offset[0]);
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
              [8, 7, 2],
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


            // The switch box
            slope_length = (OBS_height)/cos(frontside_angle);
            difference(){
              translate([0, OBS_width_small, 0])
              linear_extrude(OBS_depth)
              rotate([0,0,-90+frontside_angle])
              polygon(polyRound([
                [0,(MainCase_switch_offset_x)/OBS_height*slope_length-11, 0],

                [13,(MainCase_switch_offset_x)/OBS_height*slope_length-11,03],
                [13,(MainCase_switch_offset_x)/OBS_height*slope_length+11,03],
                [8,(MainCase_switch_offset_x)/OBS_height*slope_length+11,03],
                //[12,(MainCase_switch_offset_x)/OBS_height*slope_length+25, 5],

                [8,MainCaseLid_hole_positions[4][0]/OBS_height*slope_length+4,5],
                [0,(MainCase_switch_offset_x)/OBS_height*slope_length+27, 0]

              ], fn=$pfn));
              translate([0, 64, 0])
              cube([16,10,12]);
            }
            translate([MainCase_switch_offset_x, OBS_width_small+tan(frontside_angle)*MainCase_switch_offset_x, 0])
               rotate([0, 0, frontside_angle])
               SwitchboxPolygon(padding=wall_thickness, height=100);

            // hole 5
            difference(){
              translate([wall_thickness, 75, 0])
              linear_extrude(OBS_depth)
              polygon(polyRound([
              [0, -4, 0],
              [8, -4, 1],
              [8, 2.9, 1],
              [0,8, 0],
              ], fn=$pfn));
              translate([0, 64, 0])
              cube([16,10,12]);
            }

          }
        }

        // A "house" shape that cuts away the middle of the columns, leaving
        // behind a top piece with a slanted underside (for 3D printing) and a
        // flat bottom piece, on which the PCB rests.
        difference() {
          translate([0, 88, 0])
          rotate([90,0,0])
          linear_extrude(OBS_width+0.05)
          polygon(polyRound([
            [wall_thickness, wall_thickness+m3_insert_hole_depth, 0],
            [OBS_height-wall_thickness, wall_thickness+m3_insert_hole_depth, 0],
            [OBS_height-wall_thickness, OBS_depth-2*m3_insert_hole_depth, 0],
            [OBS_height/2, OBS_depth-20+OBS_height/2, 0],
            [wall_thickness, OBS_depth-2*m3_insert_hole_depth, 0],
          ], fn=$pfn));

          translate([10, 78, 0])
          cube([OBS_height-26,30,100]);
          translate([0, OBS_width_small-6, 0])
          cube([OBS_height-16,30,100]);

          translate([0, MainCase_pcb_offset.y + wall_thickness-30, 0])
          cube([OBS_height-16,30,100]);
        }
      }

      // Housing for the GPS antenna
      translate([OBS_height, MainCase_gps_antenna_y_offset, OBS_depth/2])
      rotate([0, 90, 0])
      GpsAntennaHousing();

      // Access for the USB-C port
      intersection() {
        MainCaseBody();

        difference() {
          union() {
            // not shift on y by wall_thickness
            translate([wall_thickness, 0, wall_thickness])
            linear_extrude(MainCase_usb_port_housing_height)
            polygon(polyRound([
              [0, 0, 0],
              [MainCase_usb_port_housing_width, 0, 0],
              [MainCase_usb_port_housing_width, MainCase_usb_port_housing_depth + 0.92, 3],
              [0, MainCase_usb_port_housing_depth + 0.92, 0],
            ], fn=$pfn));

            // a little standoff for the PCB
            translate([wall_thickness, MainCase_pcb_offset.y + wall_thickness, wall_thickness])
            linear_extrude(m3_insert_hole_depth)
            polygon(polyRound([
              [0, 0, 0],
              [4, 0, 0],
              [4, 3, 1],
              [0, 3, 0],
            ], fn=$pfn));

            translate([wall_thickness+68-8, MainCase_pcb_offset.y + wall_thickness-4, wall_thickness])
            linear_extrude(m3_insert_hole_depth)
            polygon(polyRound([
              [0, 0, 0],
              [8, 0, 0],
              [8, 6, 0],
              [0, 6, 3],
            ], fn=$pfn));
          }
        }
      }

      if (back_rider) {
        translate([OBS_height/2, 0, OBS_depth-4])
        rotate([90, 90, 0])
        MountAttachment();
      }

      if (top_rider) {
        translate([0, OBS_height/2, OBS_depth-4])
        rotate([0, 90, 180])
        MountAttachment();
      }
    }

    // The hole for the sensor
    translate([OBS_height-16, OBS_width-1/tan((90-frontside_angle)/2)*16, 0]) {
      translate([0, 0, -2])
      cylinder(r=MainCase_sensor_hole_diameter/2, h=70+4);

      // In the main case, we have to cut the clearance hole larger than
      // requeste, to account for the width and twice the clearance of the rim
      // in the lid
      translate([0, 0, wall_thickness])
      cylinder(r=MainCase_sensor_hole_diameter/2+MainCase_sensor_hole_ledge+MainCaseLid_rim_width+MainCaseLid_rim_clearance*2, h=70);
    }

    // Hole for accessing Micro-USB of the ESP32 from underneath the GPS
    // antenna
    translate([OBS_height, MainCase_micro_usb_offset-MainCase_micro_usb_chamfer/sqrt(2), OBS_depth/2])
      rotate([0, 90, 0])
      minkowski() {
        rotate([0,0,45])cube([MainCase_micro_usb_chamfer, MainCase_micro_usb_chamfer ,epsilon]);
        cube([MainCase_micro_usb_height-2*MainCase_micro_usb_chamfer/sqrt(2), MainCase_micro_usb_width-2*MainCase_micro_usb_chamfer/sqrt(2), 8], center=true);
    }
    // Hole for GPS antenna cable from the inside of the antenna housing to the
    // inside of the main case
    translate([OBS_height, MainCase_gps_antenna_y_offset, OBS_depth/2])
    rotate([0, 90, 0]) {
      translate([0, -13.5, 0])
      cylinder(d=MainCase_gps_antenna_housing_cable_hole_diameter, h=MainCase_gps_antenna_housing_cable_hole_diameter, center=true);

      *translate([0, -13.5+4, 0])
      cube([4, 8, 4], center=true);
    }

    // Cutouts and hole for switch
    translate([MainCase_switch_offset_x, OBS_width_small+tan(frontside_angle)*MainCase_switch_offset_x, wall_thickness+4])
    rotate([0, 0, frontside_angle]) {
      SwitchboxPolygon(padding=0, height=21.6);
      if (enable_easy_print) {
        intersection(){
          SwitchboxPolygon(padding=0, height=29.2);
          if (enable_easy_print) {
            translate([0, 0, 21.6/2]){
              union(){
                translate([0,-(24-6)/2+3,0.3])cube([60,6, 21.6], center=true);
                translate([0,-(24-6)/2+3,0.6])cube([6,6, 21.6], center=true);
              }
            }
          }
        }
      }
      // Hole for the switches' lever
      translate([0, -4-wall_thickness, 8])
      cylinder(d=6, h=20);

      if(enable_text) {
        translate([11,-1.5,-0.49])linear_extrude(0.6)rotate([0,0,180]) text("I / O",font="open sans:style=Bold", size=8);
      }

      // Rounded cutout on the inside, the main switch body sits in this place.
      translate([0, -wall_thickness, 24])
      linear_extrude(200)
      polygon(polyRound([
        [-15.1, -20, 0],
        [-15.1, 0, 2],
        [15.1, 0, 2],
        [15.1, -20, 0],
      ], fn=$pfn));
    }


    // Hole for USB Cover
    translate([MainCase_usb_port_x_offset, UsbCover_depth, 0])
    rotate([0, 0, 180]) {
      UsbCoverMainBody(clearance=MainCase_usb_port_cover_clearance, counter_magnets=true);
    }

    // Hole for USB Charger Port
    translate([MainCase_usb_port_x_offset, 0, m3_insert_hole_depth + wall_thickness - MainCase_usb_port_vertical_offset])
    hull()for(i=[-1, 1])for(j=[-1, 1]) {
      translate([i/2*6.5, 0, j/2*0.7])
      rotate([-90, 0, 0])
      cylinder(r=1.5, h=20, center=true);
    }

    // Holes in the attachment
    if (back_rider) {
      translate([OBS_height/2, wall_thickness, OBS_depth-4])
      rotate([90, 90, 0])
      MountAttachmentHolePattern(with_cable_hole=MainCase_back_rider_cable);
    }

    if (top_rider) {
      translate([wall_thickness, OBS_height/2, OBS_depth-4])
      rotate([0, 90, 180])
      MountAttachmentHolePattern(with_cable_hole=MainCase_top_rider_cable);
    }

    // Holes for inserts on top of the columns created earlier. Can be disabled
    // to generate the outline for the lid without the holes (the lid generates
    // those holes differently, as they contain M3 screws, not inserts).
    if (!without_inserts) {
      for (hole = MainCaseLid_hole_positions) {
        translate([hole.x, hole.y, OBS_depth])
        HeatsetInsertHole();
      }
    }
  }
}

module HexNutHole(nut_depth=3, screw_depth=0) {
  mirror([0, 0, 1])
  union() {
    cylinder(d=m3_hex_nut_diameter, h=nut_depth, $fn=6);

    if (screw_depth > nut_depth) {
      translate([0, 0, nut_depth])
      cylinder(d=m3_screw_diameter_loose, h=screw_depth - nut_depth, $fn=32);
    }
  }
}

module MountAttachment() {
  intersection() {
    translate([-50, -50, 0])
    cube([100, 100, 100]);

    hull() {
      translate([0, 0, -1])
      linear_extrude(1)
      polygon(polyRound([
        [0, MountAttachment_height/2+MountAttachment_depth, 2],
        [MountAttachment_width+MountAttachment_depth, MountAttachment_height/2+MountAttachment_depth, 5+MountAttachment_depth],
        [MountAttachment_width+MountAttachment_depth, -MountAttachment_height/2-MountAttachment_depth, 5+MountAttachment_depth],
        [0, -MountAttachment_height/2-MountAttachment_depth, 2],
      ], fn=$pfn));


      translate([0, 0, MountAttachment_depth-1])
      linear_extrude(1)
      polygon(polyRound([
        [0, MountAttachment_height/2, 2],
        [MountAttachment_width, MountAttachment_height/2, 5],
        [MountAttachment_width, -MountAttachment_height/2, 5],
        [0, -MountAttachment_height/2, 2],
      ], fn=$pfn));
    }
  }
}

module MountAttachmentHolePattern(with_cable_hole=true) {
  if (with_cable_hole) {
    union () {
      hull() {
        for (i=[2,8]) {
          translate([
            MountAttachment_width / 2 + MountAttachment_holes_x_offset ,
            0,
            wall_thickness + MountAttachment_depth - i,
          ])
          linear_extrude(1)
          polygon(roundedRectangle(11+i*2, 7+i*2, i));
        }
      }

      translate([
          MountAttachment_width / 2 + MountAttachment_holes_x_offset ,
          0,
          wall_thickness + MountAttachment_depth - 1,
      ])
      linear_extrude(1)
      polygon(roundedRectangle(11+2*2, 7+2*2, 2));
    }
  }

  mirror([0, 0, 1]) {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([
          MountAttachment_width / 2 + i * MountAttachment_holes_dx / 2 + MountAttachment_holes_x_offset ,
          j * MountAttachment_holes_dy / 2,
          0,
        ])
        HexNutHole(nut_depth = MountAttachment_depth + wall_thickness - (8 - m3_hex_nut_thickness)/2,
                  screw_depth = MountAttachment_depth + wall_thickness - (8 - m3_hex_nut_thickness)/2 + 8 - m3_hex_nut_thickness); // 8mm shaft lenght - nut depth
      }
    }
  }
}

module GenerateWithLogo(mode=logo_mode, part=logo_part) {
  module _logo_cutout(extra_depth=0) {
    linear_extrude(height=logo_depth+extra_depth, center=false, convexity = logo_convexity)
    children();
  }

  module _logo_cutout_with_mode() {
    if (mode == "normal") {
      _logo_cutout()children();
    } else if (mode == "inverted") {
      difference() {
        translate([-1000, -1000, 0])
        cube([2000, 2000, logo_depth]);

        translate([0, 0, -1])
        _logo_cutout(2)children();
      }
    } else {
      assert(false, str("unknown mode ", mode));
    }
  }

  if (!logo_enabled) {
    children(0);
  } else {
    if (part == "main") {
      difference() {
        children(0);
        _logo_cutout_with_mode()children(1);
      }
    } else if (part == "highlight") {
      intersection() {
        children(0);
        _logo_cutout_with_mode()children(1);
      }
    } else {
      assert(false, str("unknown logo part ", part));
    }
  }
}

if (logo_generate_templates) {
  rotate([0, 0, -90])
  projection(cut=true)
  mirror([1, 0, 0])
  MainCase();
} else {
  GenerateWithLogo() {
    if (logo_use_prebuild) {
      import("../../export/MainCase/MainCase.stl");
    } else {
      MainCase();
    }

    mirror([0, 1, 0])
    rotate([0, 0, -90])
    translate([0, -72-72, 0])
    import(str("../../logo/", logo_name, "/MainCase.svg"));
  }
}

// Draw the PCB for debugging (disable with *, highlight with #)
*#translate([1.5,0,0])#DebugPCB();

// Draw the previous MainCase for debugging. (disable with *, highlight with #)
*#translate([0,72+36.5,0])rotate([0,0,270])import("../../legacy/MainCase/VerticalCase_JSN-AJ/OBS-MainCase-B-001a_MainCase_with_0.4mm_OBS-logo.stl");

