include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module BikeRackMountSide() {
  r1 = 1;
  w = 8;
  W = 20;
  r2 = BikeRackMount_rail_diameter/2 + w;
  r3 = 4;
  l = 0; // parameter to widen the part on the screw side.

  difference() {
    rotate([90, 0, -90])
    linear_extrude(BikeRackMountSide_length, center=true, convexity=2)
    polygon(polyRound([
      [-l, 0, r1+l],
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
    translate([0, 0,  -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
    cube([MountRail_width, MountRail_width,0.5],center=true);
    translate([0,(-w+l)/2,  -BikeRackMountSide_height]){
      cylinder(d=HeatsetInsert_diameter,h=HeatsetInsert_full_depth,center=false);
      translate([0,0,HeatsetInsert_full_depth])
        cylinder(d=HeatsetInsert_diameter+2*HeatsetInsert_extra_radius,h=HeatsetInsert_height-HeatsetInsert_full_depth,center=false);
      cylinder(d=ScrewHole_diameter_M3,h=BikeRackMountSide_height);
      translate([0,0,BikeRackMountSide_height-ScrewHead_height_M3-BikeRackMount_rail_diameter/2])
        cylinder(d=ScrewHead_diameter_M3,h=ScrewHead_height_M3+BikeRackMount_rail_diameter/2);
    }
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
    // slit for clamping
    translate([0, 0,  -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
    rotate([0, 0, longitudinal?90:0])
    cube([MountRail_width, MountRail_width,0.5],center=true);
    rotate([0, 0, longitudinal?90:0])
    for(i=[-1,1])
    translate([6*i,0,  -BikeRackMountSide_height]){
      cylinder(d=HeatsetInsert_diameter,h=HeatsetInsert_full_depth,center=false);
      translate([0,0,HeatsetInsert_full_depth])
        cylinder(d=HeatsetInsert_diameter+2*HeatsetInsert_extra_radius,h=HeatsetInsert_height-HeatsetInsert_full_depth,center=false);
      cylinder(d=ScrewHole_diameter_M3,h=BikeRackMountSide_height-vertical_offset);
      translate([0,0,BikeRackMountSide_height-vertical_offset-ScrewHead_height_M3])
        cylinder(d=ScrewHead_diameter_M3,h=ScrewHead_height_M3);
    }
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

// !BikeRackMountCenter();

if (orient_for_printing) {
  translate([0, 0, MountRail_width/2])
  rotate([0, -90, 0])
  translate([0, 0, BikeRackMountSide_height])
  BikeRackMountCenter(false);
} else {
  rotate([0, 0, 90])
  BikeRackMountCenter(false);
}

