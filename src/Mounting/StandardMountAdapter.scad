include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

// This is the hole in which the locking pin is set. Its origin is on the
// surface that it is bored into, at the center of the pin.
module LockingPinHole(depth=16) {
  union() {
    // the pin
    translate([0, 0, -depth-4])
    cylinder(h=depth, d=m3_screw_diameter_loose);

    // the chamber
    translate([-6, -5.5/2, -4])
    cube([11.5, 5.5*1.5, 2.5]);

    // the window
    translate([0, 0, -1.5])
    cylinder(d=5.5, h=1.5);
    translate([-6, -5.5/2, -1.5])
    cube([6, 5.5, 1.5]);
  }
}

module StandardMountAdapterScrewHoles(head_depth=6, depth=100) {
  for(i=[-1,1])for(j=[-1,1])
  translate([i*MountAttachment_holes_dx/2, j*MountAttachment_holes_dy/2])
  rotate([0, 0, 90])
  children();
}

module StandardMountAdapterBody() {
  module _half_base_shape(width=StandardMountAdapter_width) {
    union () {
      // base
      translate([-width/2, 0, 0])
      cube([width, StandardMountAdapter_length/2, StandardMountAdapter_thickness]);

      // gripper
      translate([-width/2, StandardMountAdapter_length/2, StandardMountAdapter_thickness])
      rotate([90, 0, 90])
      linear_extrude(width)
      polygon(polyRound([
        [-StandardMountAdapter_side_width, 0, 0],
        [-StandardMountAdapter_side_width, MountRail_base_height, 0],
        [-StandardMountAdapter_side_width-MountRail_chamfer_height, MountRail_base_height+MountRail_chamfer_height, 0],
        [-StandardMountAdapter_side_width-MountRail_chamfer_height, MountRail_base_height+MountRail_chamfer_height+0.5, 0],
        [0, MountRail_base_height+MountRail_chamfer_height+0.5, 3],
        [0, 0, 0],
      ], fn=$pfn));
    }
  }

  module _body_half() {
    difference() {
      _half_base_shape();

      // locking pin hole
      translate([0, StandardMountAdapter_length/2, StandardMountAdapter_thickness])
      rotate([-90, 0, 0])
      LockingPinHole();
    }
  }


  union () {
    _body_half();

    rotate([0, 0, 180])
    _body_half();
  }
}

module StandardMountAdapter(channels=true, screwholes=true) {
  difference() {
    StandardMountAdapterBody();

    if(screwholes)translate([0, 0, StandardMountAdapter_thickness])
    StandardMountAdapterScrewHoles()
    ScrewHoleM3(depth=100, head_depth= StandardMountAdapter_thickness - (8 - m3_hex_nut_thickness)/2 );

    if(channels) {
      rotate([0, 0, -90])
      StandardMountAdapterCableChannel();
      StandardMountRescueStripChannel();
    }
  }
}

module StandardMountAdapterCableChannel() {
  translate([0, 0, 4.5])
  difference() {
    union () {
      translate([0, 0, -4.5/2])
      rotate([90, 0, 0])
      translate([0, 0, -5])
      cylinder(d=4.5, h=100);

      translate([-4.5/2, -95, -4.5])
      cube([4.5, 100, 4.5/2]);
    }

    rotate([45, 0, 0])
    translate([-10, 0, -10])
    cube([20, 20, 20]);
  }
}

module StandardMountRescueStripChannel() {
  rotate([90, 0, 90])
  translate([10,0, -50])
  cylinder(d=3.5, h=100);
}

if (orient_for_printing) {
  translate([0, 0, StandardMountAdapter_width/2])
  rotate([0, 90, 0])
  StandardMountAdapter();
} else {
  rotate([0, 0, 90])
  StandardMountAdapter();
}
