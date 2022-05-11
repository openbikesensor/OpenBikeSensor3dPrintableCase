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
      translate([0, -HandlebarRail_stopblock_magnet_thickness*1.5, 0])
      cylinder(d=HandlebarRail_stopblock_magnet_thickness, h=HandlebarRail_stopblock_height);

      translate([0, -HandlebarRail_stopblock_magnet_thickness, HandlebarRail_rail_total_height + HandlebarRail_stopblock_magnet_lift + HandlebarRail_stopblock_magnet_height / 2])
      cube([HandlebarRail_stopblock_magnet_width, HandlebarRail_stopblock_magnet_thickness * 2, HandlebarRail_stopblock_magnet_height], center=true);

      translate([0, -HandlebarRail_stopblock_magnet_thickness*1.5, HandlebarRail_stopblock_height-3+epsilon])
      cube([HandlebarRail_stopblock_magnet_width, HandlebarRail_stopblock_magnet_thickness, 6], center=true);
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

module HandlebarRailOringCutout(r_torus=9.2,r_oring=1.7) {
    rotate_extrude()translate([r_torus,0,0])circle(r_oring);
    difference(){hull(){cylinder(h=epsilon,r=r_torus+r_oring);
        translate([0,5,10])cylinder(h=epsilon,r=r_torus+r_oring);}
        hull(){cylinder(h=epsilon,r=r_torus-r_oring);
        translate([0,5,10])cylinder(h=epsilon,r=r_torus-r_oring);}}
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
          translate([7.6,HandlebarRail_rail_length/2,HandlebarRail_tube_radius - HandlebarRail_tube_indent+5])
        rotate([0,10,0])HandlebarRailOringCutout(r_torus=6,r_oring=1.2);
          translate([-7.6,HandlebarRail_rail_length/2,HandlebarRail_tube_radius - HandlebarRail_tube_indent+5])
        rotate([0,-10,0])HandlebarRailOringCutout(r_torus=6,r_oring=1.3);
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
