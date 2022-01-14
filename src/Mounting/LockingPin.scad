include <../../variables.scad>

LockingPin_diameter = 5.2;
LockingPin_hole_diameter = 3.0;
LockingPin_small_hole_diameter = 2.0;
LockingPin_height = 15;
LockingPin_handle_length = 15.2;
LockingPin_handle_height = 3.5;
LockingPin_foot_height = 2.0;
LockingPin_fillet_radius = 2.0;

// $fa = 1;
// $fs = 0.1;
$fn = 64;

module LockingPinRoundRect(h, l) {
  hull() {
    cylinder(h=h, d=LockingPin_diameter);

    translate([l - LockingPin_diameter, 0, 0])
    cylinder(h=h, d=LockingPin_diameter);
  }
}

module LockingPinFillet(handle_length) {
  intersection() {
    difference() {
      LockingPinRoundRect(LockingPin_fillet_radius, handle_length);

      // fillet on foot
      translate([0, 0, LockingPin_fillet_radius])
      rotate_extrude()
      translate([LockingPin_diameter/2 + LockingPin_fillet_radius, 0, 0])
      circle(r=LockingPin_fillet_radius);
    }

    cylinder(r=LockingPin_diameter / 2 + LockingPin_fillet_radius, h=LockingPin_fillet_radius);
  }
}

module LockingPin() {
  difference() {
    union() {
      // base cylinder
      cylinder(h=LockingPin_height, d=LockingPin_diameter);

      // foot
      translate([0, 0, LockingPin_height - LockingPin_foot_height])
      LockingPinRoundRect(LockingPin_foot_height, LockingPin_diameter + LockingPin_fillet_radius);

      // handle
      LockingPinRoundRect(LockingPin_handle_height, LockingPin_handle_length);

      // handle fillet
      translate([0, 0, LockingPin_handle_height])
      LockingPinFillet(LockingPin_handle_length);

      // foot fillet
      translate([0, 0, LockingPin_height - LockingPin_foot_height])
      mirror([0, 0, 1])
      LockingPinFillet(LockingPin_diameter + LockingPin_fillet_radius);
    }

    // holes
    union() {
      // hole in handle, for wire attachment
      translate([LockingPin_handle_length - LockingPin_diameter, 0, -1])
      cylinder(d=LockingPin_small_hole_diameter, h=LockingPin_handle_height+2);

      // hole in main shaft, for holding screw
      translate([0, 0, -1])
      cylinder(d=LockingPin_hole_diameter, h=LockingPin_height+2);
    }
  }
}

if (orient_for_printing) {
  LockingPin();
} else {
  translate([0, 0, LockingPin_height])
  rotate([180, 0, 0])
  LockingPin();
}
