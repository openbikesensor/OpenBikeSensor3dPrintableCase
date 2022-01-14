include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

HUGE = 1000;

module SeatPostMountBase() {
  union() {

    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    MountRail(MountRail_clearance);

    // Stop plate
    // translate([0, -MountRail_total_height, 0])
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(SeatPostMount_stop_plate_thickness)
    polygon(polyRound([
      [0, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 0, 2],
      [-SeatPostMount_stop_plate_width/2, HUGE+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, HUGE+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, 0, 2],
    ], fn=$pfn));

    // Main holder chunk
    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(MountRail_width)
    polygon(polyRound([
      [0, 0, 0],
      [-MountRail_plate_width/2+MountRail_clearance, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 4, 20],
      [-SeatPostMount_stop_plate_width/2, HUGE, 0],
      [SeatPostMount_stop_plate_width/2, HUGE, 0],
      [SeatPostMount_stop_plate_width/2, 4, 20],
      [MountRail_plate_width/2-MountRail_clearance, 0, 0],
    ], fn=$pfn));
  }
}


module SeatPostMountCutout(diameter, angle, length, cutaway) {
  width = cutaway ? SeatPostMount_width : (MountRail_width + SeatPostMount_stop_plate_thickness);

  translate([0, width/2, max(MountRail_total_height, length) + diameter/cos(angle)/2 + SeatPostMount_stop_plate_width/2 * sin(angle)]) {
    rotate([0, -90+angle, 0]) {
      union () {
        cylinder(d=diameter, h=200, center=true, $fn=$fn*4);

        translate([0, -HUGE/2, -HUGE/2])
        cube(HUGE);

        translate([-diameter/2+SeatPostMount_channel_depth, -20, -105])
        cube([50, 40, 210]);

        for (i = [-1, 1]) {
          w = 9;
          translate([0, 0, i*16-angle/5])
          difference() {
            cube([diameter+8, diameter+8, w], center=true);
            cylinder(r=diameter/2+3, h=w+2, center=true);
          }
        }
      }
    }
  }

  if (cutaway) {
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
}

module SeatPostMount(diameter=0, cutaway=false) {
  difference() {
    SeatPostMountBase();
    SeatPostMountCutout(
      diameter=SeatPostMount_diameter,
      length=SeatPostMount_length,
      angle=SeatPostMount_angle,
      cutaway=true
    );
  }
}

if (orient_for_printing) {
  rotate([90, 0, 0])
  SeatPostMount();
} else {
  rotate([0, -90, -180])
  SeatPostMount();
}
