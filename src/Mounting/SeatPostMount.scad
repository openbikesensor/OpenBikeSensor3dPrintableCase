include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/MountRails.scad>

max_height = MountRail_total_height + SeatPostMount_angled_spacing + sin(SeatPostMount_angle) * SeatPostMount_stop_plate_width;

module SeatPostMountBase() {
  union() {

    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    MountRail();

    // Stop plate
    // translate([0, -MountRail_total_height, 0])
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(SeatPostMount_stop_plate_thickness)
    polygon(polyRound([
      [0, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 0, 2],
      [-SeatPostMount_stop_plate_width/2, max_height+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, max_height+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, 0, 2],
    ]));

    // Main holder chunk
    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(MountRail_width)
    polygon(polyRound([
      [0, 0, 0],
      [-MountRail_plate_width/2, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 4, 20],
      [-SeatPostMount_stop_plate_width/2, max_height, 0],
      [SeatPostMount_stop_plate_width/2, max_height, 0],
      [SeatPostMount_stop_plate_width/2, 4, 20],
      [MountRail_plate_width/2, 0, 0],
    ]));
  }
}


module SeatPostMountCutout() {
  translate([0, SeatPostMount_width/2, MountRail_total_height + SeatPostMount_angled_spacing + SeatPostMount_stop_plate_width/2* sin(SeatPostMount_angle)]) {
    rotate([0, -90+SeatPostMount_angle, 0]) {
      union () {
        cylinder(d=SeatPostMount_diameter, h=200, center=true);

        translate([-SeatPostMount_diameter/2+SeatPostMount_channel_depth, -20, -105])
        cube([50, 40, 210]);

        for (i = [-1:2:1]) {
          w = 9;
          translate([0, 0, i*16-SeatPostMount_angle/5])
          difference() {
            cube([SeatPostMount_diameter+8, SeatPostMount_diameter+8, w], center=true);
            cylinder(r=SeatPostMount_diameter/2+3, h=w+2, center=true);
          }
        }
      }
    }
  }

  cutaway_width = MountRail_width - SeatPostMount_width + SeatPostMount_stop_plate_thickness;
  translate([-100, SeatPostMount_width, cutaway_width + MountRail_total_height]) {
    union() {
      cube([200, cutaway_width * 2, 100]);

      translate([0, cutaway_width, 0])
      rotate([0,90, 0])
      cylinder(r=cutaway_width, h=200);
    }
  }
}

difference() {
  SeatPostMountBase();
  SeatPostMountCutout();
}
