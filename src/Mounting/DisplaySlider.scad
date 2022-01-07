include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/MountRails.scad>
use <../../lib/utils.scad>

module DisplaySliderRail() {
  mirrorCopy([1, 0, 0])
  difference() {
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(DisplaySliderRail_length)
    polygon([
      [0, 0],
      [8, 0],
      [8, 7],
      [8 - 1.95, DisplaySliderRail_total_height - 1.25 - 1.95 - 1.3],
      [8 - 1.95, DisplaySliderRail_total_height - 1.95 - 1.3],
      [8, DisplaySliderRail_total_height - 1.3],
      [8, DisplaySliderRail_total_height],
      [0, DisplaySliderRail_total_height],
    ]);

    translate([8-2, DisplaySliderRail_length, -2])
    rotate([0, 0, -45])
    translate([-1, 0, 0])
    cube([10, 10, 20]);
  }
}

module DisplaySliderStopblock() {
  difference() {
    hull() {
      for(i=[-1,1])for(j=[0,1])
      translate([i*(DisplaySliderStopblock_width/2-DisplaySliderStopblock_radius), j*(-DisplaySliderStopblock_depth+2*DisplaySliderStopblock_radius)-DisplaySliderStopblock_radius, 0])
      cylinder(r=DisplaySliderStopblock_radius, h=DisplaySliderStopblock_height);
    }

    // cutout for magnets
    translate([0, -DisplaySliderStopblock_magnet_wall_thickness, 0]) {
      // hole for pushing magnet out
      translate([0, -DisplaySliderStopblock_magnet_thickness/2, 0])
      cylinder(d=DisplaySliderStopblock_magnet_thickness, h=DisplaySliderStopblock_height);

      translate([0, -DisplaySliderStopblock_magnet_thickness, DisplaySliderRail_total_height + DisplaySliderStopblock_magnet_lift + DisplaySliderStopblock_magnet_height / 2])
      cube([DisplaySliderStopblock_magnet_width, DisplaySliderStopblock_magnet_thickness * 2, DisplaySliderStopblock_magnet_height], center=true);

      translate([0, -DisplaySliderStopblock_magnet_thickness/2, DisplaySliderStopblock_height-3])
      cube([DisplaySliderStopblock_magnet_width, DisplaySliderStopblock_magnet_thickness, 6], center=true);
    }
  }
}

module DisplaySliderZiptieCutout(width) {
  translate([0, width, 0])
  rotate([90, 0, 0])
  difference() {
    cylinder(r=DisplaySlider_tube_radius*1.3, h=width, $fn=$fn*2);
    cylinder(r=DisplaySlider_tube_radius*1.2, h=width, $fn=$fn*2);
  }
}

module DisplaySlider() {
  difference() {
    union() {
      DisplaySliderRail();
      DisplaySliderStopblock();
    }

    translate([0, 0, -DisplaySlider_tube_radius + DisplaySlider_tube_indent]) {
      union () {
        // tube
        translate([0, 50, 0])
        rotate([90, 0, 0])
        cylinder(r=DisplaySlider_tube_radius, h=100);

        // ziptie wide
        translate([0, 4, 0])
        DisplaySliderZiptieCutout(11);

        // ziptie small
        translate([0, DisplaySliderRail_length - 4 - 5.5, 0])
        DisplaySliderZiptieCutout(5.5);
      }
    }
  }
}

DisplaySlider();
