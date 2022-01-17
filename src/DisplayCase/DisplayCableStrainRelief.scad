include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module DisplayCableStrainRelief() {
  rotate([0, 0, -90])
  intersection() {
    translate([0, -50, -50])
    cube(100);

    difference() {
      union () {
        scale([1, 12/14, 1])
        cylinder(r=8.2, h=1.5);

        translate([0, 0, 1.5])
        scale([1, 12/14, 1])
        cylinder(r=6.7, h=1.3);

        translate([0, 0, 2.8])
        scale([1, 12/14, 1])
        cylinder(r=7.7, h=2);

        translate([0, 0, 4.8])
        cylinder(r1=6.23, r2=5.5, h=2);

        translate([0, 0, 6.8])
        cylinder(r=5.5, h=8.2);

        for(i=[-1,1])
        translate([0, i*4.4, 10])
        rotate([0, 90, 0])
        cylinder(d=m3_screw_head_diameter, h=3);
      }

      // for the cable
      translate([0, 0, -1])
      cylinder(r=2.5, h=100);

      // clearance for fitting in
      rotate([0, -30, 0])
      translate([0, -50, -20])
      cube([1, 100, 40]);

      translate([3, 4.4, 10])
      rotate([0, 90, 0])
      rotate([0, 0, 360/6/2])
      cylinder(d=m3_hex_nut_diameter, h=200, $fn=6);

      translate([3, -4.4, 10])
      rotate([0, 90, 0])
      cylinder(d=m3_screw_head_diameter, h=200);

      for(i=[-1,1])
      translate([0, i*4.4, 10])
      rotate([0, 90, 0])
      cylinder(d=2.75, h=200);
    }
  }
}

DisplayCableStrainRelief();
