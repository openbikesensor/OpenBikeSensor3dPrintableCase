include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

// This is the hole in which the locking pin is set. Its origin is on the
// surface that it is bored into, at the center of the pin.
module LockingPinHole(depth=16) {
  union() {
    // the pin
    translate([0, 0, -depth-4])
    cylinder(h=depth, d=3.2);

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

module StandardMountAdapterHalfBaseShape(width=StandardMountAdapter_width) {
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

module StandardMountAdapterHalf() {
  difference() {
    StandardMountAdapterHalfBaseShape();

    // locking pin hole
    translate([0, StandardMountAdapter_length/2, StandardMountAdapter_thickness])
    rotate([-90, 0, 0])
    LockingPinHole();
  }
}


module StandardMountAdapter() {
  difference() {
    union () {
      StandardMountAdapterHalf();

      rotate([0, 0, 180])
      StandardMountAdapterHalf();
    }

    // Screw holes
    for(i=[-1,1])for(j=[-1,1])
    translate([i*MountAttachment_holes_dx/2, j*MountAttachment_holes_dy/2, StandardMountAdapter_thickness])
    rotate([0, 0, 90])
    ScrewHoleM3(depth=100, head_depth=6);

    rotate([0, 0, -90])
    StandardMountAdapterCableChannel();
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

translate([0, 0, StandardMountAdapter_width/2])
rotate([0, 90, 0])
StandardMountAdapter();

*translate([-50, 0, StandardMountAdapter_width/2])
rotate([0, 90, 0])
color("#FFF176")
import("../../MainCase/VerticalCase_JSN-AJ/OBS-Mounting-A-001_StandardOBSMount_v0.1.1.stl");
