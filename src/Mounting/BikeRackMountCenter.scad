include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module BikeRackMountSide() {
  r1 = 1;
  w = 10;
  W = 20;
  r2 = BikeRackMount_rail_diameter/2 + w;
  r3 = 4;
  l = 0; // parameter to widen the part on the screw side.

  difference() {
    rotate([90, 0, -90])
    linear_extrude(BikeRackMountSide_length, center=true, convexity=2)
    polygon(polyRound([
      [-l, 0, r1+2],
      [W, 0, r1],

      [W, -r2/2, r2],
      // [W - r2, -r2, 0],
      // [w + r3, -r2, 0],
      [w, -r2, r2],
      [w, -BikeRackMountSide_height, r1],
      [-l, -BikeRackMountSide_height, r1],
    ], fn=$pfn));

    // rail
    translate([-10, -W/2, 0])
    rotate([90, 0, -90])
    cylinder(d=BikeRackMount_rail_diameter, h=BikeRackMountSide_length+20, center=true);

    // zip ties
    for(i=[-1,1])
    translate([i*BikeRackMount_rod_distance/2, 0, -2])
    intersection() {
      translate([-50, -50, -100])
      cube(100);

      difference() {
        translate([0, -W/2, 0])
        rotate([90, 0, -90])
        cylinder(r=W/2+3, h=BikeRackMountSide_channel_width, center=true);

        translate([0, -W/2, 0])
        rotate([90, 0, -90])
        cylinder(r=W/2, h=BikeRackMountSide_channel_width, center=true);
      }
    }

    rotate([0, 0, 90])
    RodHoles();

    translate([0, -w/2, 0])
    ClampSlit(double_holes=false);
  }
}

module RodHoles() {
  // holes for cross rods
  for(i=[-1,1])
  translate([0, i*BikeRackMount_rod_distance/2, -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
  rotate([0, 90, 0])
  cylinder(d=BikeRackMount_rod_diameter, h=100, center=true);
}


vertical_offset = 10;

module ClampSlit(double_holes=false) {
  slit_size = 0.5;
  slit_z = -BikeRackMountSide_height + BikeRackMount_rod_diameter/2 + BikeRackMount_bottom_spacing - slit_size/2;

  translate([-MountRail_width/2, -BikeRackMount_rod_distance/2, slit_z])
  cube([MountRail_width, BikeRackMount_rod_distance, slit_size]);

  for(i=double_holes ? [-1, 1] : [0])
  translate([6*i, 0, 0]) {
    translate([0, 0, -BikeRackMountSide_height])
    mirror([0, 0, 1])
    HeatsetInsertHole();

    // how far down does the screw go? to the bottom, but 1/3 up the insert
    // depth (grips 2/3 of the insert's threads, that should be enough)
    d = BikeRackMountSide_height - m3_insert_hole_depth*1/3;
    translate([0, 0, 0])
    ScrewHoleM3(head_depth=d-8, depth=d); // head depth is 8mm less than screw depth for M3x8
  }
}


module BikeRackMountCenter(longitudinal=false) {
  w = MountRail_plate_width - 2 * MountRail_clearance;
  r = 5;
  difference() {
    union () {
      translate([MountRail_width/2, 0, -vertical_offset-MountRail_total_height])
      rotate([0, 0, 90])
      mirror([0, 0, 1])
      MountRail(MountRail_clearance);
      if (longitudinal) {
        difference() {
          hull()
          for(x=[-1,1])
          for(z=[-vertical_offset-r, -BikeRackMountSide_height+r])
          translate([x*((BikeRackMount_rod_distance+BikeRackMount_rod_diameter+BikeRackMount_bottom_spacing*2)/2-r), 0, z])
          rotate([-90, 0, 0])
          cylinder(r=r, h=w/2, center=true);

          // cut away the center so it does not overlap and fill the pin channels in the mount
          translate([0, 0, -vertical_offset])
          cube([5, 200, 5], center=true);
        }
      } else {
        hull () {
          translate([-MountRail_width/2, -w/2, -BikeRackMountSide_height+r])
          cube([MountRail_width, w, BikeRackMountSide_height-vertical_offset-MountRail_total_height-r]);

          for(i=[-1,1])
          translate([-MountRail_width/2, i*(w/2-r), -BikeRackMountSide_height+r])
          rotate([0, 90, 0])
          cylinder(r=r, h=MountRail_width);
        }
      }
    }

    if (longitudinal) {
      rotate([0, 0, 90])
      RodHoles();
    } else {
      RodHoles();
    }

    rotate([0, 0, longitudinal?90:0])
    ClampSlit(double_holes=true);
  }
}

module BikeRackMountDebug() {
  translate([-60, 0, 0])
  rotate([0, 0, -90])
  BikeRackMountSide();

  rotate([0, 0, 180])
  translate([-60, 0, 0])
  rotate([0, 0, -90])
  BikeRackMountSide();

  BikeRackMountCenter();

  %for(i=[-1,1])
  translate([0, i*BikeRackMount_rod_distance/2, -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
  rotate([0, 90, 0])
  cylinder(d=BikeRackMount_rod_diameter, h=200, center=true);
}

// !BikeRackMountDebug();

if (orient_for_printing) {
  translate([0, 0, MountRail_width/2])
  rotate([0, -90, 0])
  translate([0, 0, BikeRackMountSide_height])
  BikeRackMountCenter(false);
} else {
  rotate([0, 0, 90])
  BikeRackMountCenter(false);
}
