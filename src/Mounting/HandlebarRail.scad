include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module HandlebarRailRail() {
  mirrorCopy([1, 0, 0])
  difference() {
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(HandlebarRail_rail_length, convexity=3)
    polygon([
      [0, 0],
      [8, 0],
      [8, 7],
      [8 - 1.95, HandlebarRail_rail_total_height - 1.25 - 1.95 - 1.3],
      [8 - 1.95, HandlebarRail_rail_total_height - 1.95 - 1.3],
      [8, HandlebarRail_rail_total_height - 1.3],
      [8, HandlebarRail_rail_total_height],
      [0, HandlebarRail_rail_total_height],
    ]);

    translate([8-2, HandlebarRail_rail_length, -2])
    rotate([0, 0, -45])
    translate([-1, 0, 0])
    cube([10, 10, 20]);
  }
}

module HandlebarRailStopblock() {
  difference() {
    hull() {
      for(i=[-1,1])for(j=[0,1])
      translate([i*(HandlebarRail_stopblock_width/2-HandlebarRail_stopblock_radius), j*(-HandlebarRail_stopblock_depth+2*HandlebarRail_stopblock_radius)-HandlebarRail_stopblock_radius, 0])
      cylinder(r=HandlebarRail_stopblock_radius, h=HandlebarRail_stopblock_height);
    }

    // cutout for magnets
    translate([0, -HandlebarRail_stopblock_magnet_wall_thickness, 0]) {
      // hole for pushing magnet out
      translate([0, -HandlebarRail_stopblock_magnet_thickness/2, 0])
      cylinder(d=HandlebarRail_stopblock_magnet_thickness, h=HandlebarRail_stopblock_height);

      translate([0, -HandlebarRail_stopblock_magnet_thickness, HandlebarRail_rail_total_height + HandlebarRail_stopblock_magnet_lift + HandlebarRail_stopblock_magnet_height / 2])
      cube([HandlebarRail_stopblock_magnet_width, HandlebarRail_stopblock_magnet_thickness * 2, HandlebarRail_stopblock_magnet_height], center=true);

      translate([0, -HandlebarRail_stopblock_magnet_thickness/2, HandlebarRail_stopblock_height-3])
      cube([HandlebarRail_stopblock_magnet_width, HandlebarRail_stopblock_magnet_thickness, 7], center=true);
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

        block_width=18;

      // 90° block for handle stem
      translate([7, 18-(block_width/2), 0])
      cube([45,block_width,7]);
    }

    translate([0, 0, -HandlebarRail_tube_radius + HandlebarRail_tube_indent]) {
      union () {
        // tube
        // translate([0, 50, 0])
        // rotate([90, 0, 0])
        // cylinder(r=HandlebarRail_tube_radius, h=100);

        // ziptie wide
        //translate([0, 4, 0])
        //HandlebarRailZiptieCutout(11);

        // ziptie small
        //translate([0, HandlebarRail_rail_length - 4 - 5.5, 0])
        //HandlebarRailZiptieCutout(5.5);

        // 90° tube for handle stem
        translate([-40, 18, 0.4])
        rotate([90, 0, 90])
        cylinder(r=HandlebarRail_tube_radius, h=100);

        // 90° 1st zip for handle stem
        translate([18, 18, -1])
        rotate([0, 0, 90])
        HandlebarRailZiptieCutout(6);

        // 90° 2nd zip for handle stem
        translate([28, 18, -1])
        rotate([0, 0, 90])
        HandlebarRailZiptieCutout(6);

        // 90° 3rd zip for handle stem
        translate([38, 18, -1])
        rotate([0, 0, 90])
        HandlebarRailZiptieCutout(6);

        // 90° 4th zip for handle stem
        translate([48, 18, -1])
        rotate([0, 0, 90])
        HandlebarRailZiptieCutout(6);

      }
    }
  }
}

if (orient_for_printing) {
  translate([0, 0, HandlebarRail_stopblock_depth])
  rotate([90, 0, 0])
  HandlebarRail();
} else {
  rotate([0, 0, 90])
  HandlebarRail();
}
