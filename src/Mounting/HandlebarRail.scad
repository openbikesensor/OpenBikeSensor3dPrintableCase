include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/MountRails.scad>
use <../../lib/utils.scad>

module HandlebarRailRail() {
  mirrorCopy([1, 0, 0])
  difference() {
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(HandlebarRailRail_length)
    polygon([
      [0, 0],
      [8, 0],
      [8, 7],
      [8 - 1.95, HandlebarRailRail_total_height - 1.25 - 1.95 - 1.3],
      [8 - 1.95, HandlebarRailRail_total_height - 1.95 - 1.3],
      [8, HandlebarRailRail_total_height - 1.3],
      [8, HandlebarRailRail_total_height],
      [0, HandlebarRailRail_total_height],
    ]);

    translate([8-2, HandlebarRailRail_length, -2])
    rotate([0, 0, -45])
    translate([-1, 0, 0])
    cube([10, 10, 20]);
  }
}

module HandlebarRailStopblock() {
  difference() {
    hull() {
      for(i=[-1,1])for(j=[0,1])
      translate([i*(HandlebarRailStopblock_width/2-HandlebarRailStopblock_radius), j*(-HandlebarRailStopblock_depth+2*HandlebarRailStopblock_radius)-HandlebarRailStopblock_radius, 0])
      cylinder(r=HandlebarRailStopblock_radius, h=HandlebarRailStopblock_height);
    }

    // cutout for magnets
    translate([0, -HandlebarRailStopblock_magnet_wall_thickness, 0]) {
      // hole for pushing magnet out
      translate([0, -HandlebarRailStopblock_magnet_thickness/2, 0])
      cylinder(d=HandlebarRailStopblock_magnet_thickness, h=HandlebarRailStopblock_height);

      translate([0, -HandlebarRailStopblock_magnet_thickness, HandlebarRailRail_total_height + HandlebarRailStopblock_magnet_lift + HandlebarRailStopblock_magnet_height / 2])
      cube([HandlebarRailStopblock_magnet_width, HandlebarRailStopblock_magnet_thickness * 2, HandlebarRailStopblock_magnet_height], center=true);

      translate([0, -HandlebarRailStopblock_magnet_thickness/2, HandlebarRailStopblock_height-3])
      cube([HandlebarRailStopblock_magnet_width, HandlebarRailStopblock_magnet_thickness, 6], center=true);
    }
  }
}

module HandlebarRailZiptieCutout(width) {
  translate([0, width, 0])
  rotate([90, 0, 0])
  difference() {
    cylinder(r=HandlebarRail_tube_radius*1.3, h=width, $fn=$fn*2);
    cylinder(r=HandlebarRail_tube_radius*1.2, h=width, $fn=$fn*2);
  }
}

module HandlebarRail() {
  difference() {
    union() {
      HandlebarRailRail();
      HandlebarRailStopblock();
    }

    translate([0, 0, -HandlebarRail_tube_radius + HandlebarRail_tube_indent]) {
      union () {
        // tube
        translate([0, 50, 0])
        rotate([90, 0, 0])
        cylinder(r=HandlebarRail_tube_radius, h=100);

        // ziptie wide
        translate([0, 4, 0])
        HandlebarRailZiptieCutout(11);

        // ziptie small
        translate([0, HandlebarRailRail_length - 4 - 5.5, 0])
        HandlebarRailZiptieCutout(5.5);
      }
    }
  }
}

HandlebarRail();
