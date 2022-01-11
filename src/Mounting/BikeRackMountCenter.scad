include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

BikeRackMount_rail_diameter = 14; // add a bit for padding
BikeRackMount_rod_diameter = 10;
BikeRackMount_rod_distance = 24;

BikeRackMount_with_threaded_inserts = true;

BikeRackMountSide_channel_width = 8;

BikeRackMount_bottom_spacing = BikeRackMount_with_threaded_inserts ? HeatsetInsert_height + 1 : 3;

BikeRackMountSide_length = 80;
BikeRackMountSide_height = 24 + BikeRackMount_bottom_spacing;
BikeRackMountSide_width = BikeRackMount_rail_diameter + 10; // 2 sides * (3mm wall + 2mm channel)

module BikeRackMountSide() {
  difference() {
    // main body
    hull() {
      r=2;
      for(i=[-1,1]) {
        translate([i*(BikeRackMountSide_width/2-r), 0, -r])
        rotate([90, 0, 0])
        cylinder(r=r, h=BikeRackMountSide_length, center=true);

        translate([i*(BikeRackMountSide_width/2-r-1.5), 0, -(BikeRackMountSide_height-r)])
        rotate([90, 0, 0])
        cylinder(r=r, h=BikeRackMountSide_length, center=true);
      }
    }

    // Channel for bikerack rail
    translate([0, -BikeRackMountSide_length, 0])
    rotate([-90, 0, 0])
    cylinder(d=BikeRackMount_rail_diameter, h=BikeRackMountSide_length*2);

    // Channels for ziptie
    for(i=[-1,1])
    translate([0, i*(BikeRackMountSide_length/2-BikeRackMountSide_channel_width), 0])
    difference() {
      translate([-BikeRackMountSide_width/2+3, -BikeRackMountSide_channel_width/2, -BikeRackMountSide_height])
      cube([BikeRackMountSide_width-6, BikeRackMountSide_channel_width, BikeRackMountSide_height]);

      hull() {
        translate([-BikeRackMountSide_width/2+5, -BikeRackMountSide_channel_width, -BikeRackMountSide_height+BikeRackMount_rail_diameter])
        cube([BikeRackMountSide_width-10, BikeRackMountSide_channel_width*2, BikeRackMountSide_height-BikeRackMount_rail_diameter*1.5]);

        translate([0, 0, -BikeRackMountSide_height+BikeRackMount_rail_diameter])
        rotate([90, 0, 0])
        cylinder(d=BikeRackMountSide_width-10, h=BikeRackMountSide_channel_width*2, center=true);
      }
    }

    RodHoles(half=!BikeRackMount_with_threaded_inserts);
  }
}

module RodHoles(half=false) {
  // holes for cross rods
  for(i=[-1,1])
  translate([0, i*BikeRackMount_rod_distance/2, -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
  rotate([0, 90, 0])
  cylinder(d=BikeRackMount_rod_diameter, h=100, center=!half);

  // holes for heatset inserts to hold the cross rods (unless they are glued)
  if (BikeRackMount_with_threaded_inserts) {
    for(i=[-1,1])
    translate([0, i*BikeRackMount_rod_distance/2, -BikeRackMountSide_height])
    cylinder(d=HeatsetInsert_diameter, h=HeatsetInsert_height+2);
  }
}


module BikeRackMountCenter() {
  vertical_offset = 10;

  difference() {
    union () {
      translate([MountRail_width/2, 0, -vertical_offset-MountRail_total_height])
      rotate([0, 0, 90])
      mirror([0, 0, 1])
      MountRail(MountRail_clearance);

      w = MountRail_plate_width - 2 * MountRail_clearance;
      r = 5;
      hull () {
        translate([-MountRail_width/2, -w/2, -BikeRackMountSide_height+r])
        cube([MountRail_width, w, BikeRackMountSide_height-vertical_offset-MountRail_total_height-r]);

        for(i=[-1,1])
        translate([-MountRail_width/2, i*(w/2-r), -BikeRackMountSide_height+r])
        rotate([0, 90, 0])
        cylinder(r=r, h=MountRail_width);
      }

    }

    RodHoles();
  }
}

module BikeRackMountDebug() {
  translate([-60, 0, 0])
  BikeRackMountSide();

  rotate([0, 0, 180])
  translate([-60, 0, 0])
  BikeRackMountSide();

  BikeRackMountCenter();

  *for(i=[-1,1])
  translate([0, i*BikeRackMount_rod_distance/2, -BikeRackMountSide_height + BikeRackMount_rod_diameter/2+BikeRackMount_bottom_spacing])
  rotate([0, 90, 0])
  cylinder(d=BikeRackMount_rod_diameter, h=200, center=true);
}

BikeRackMountCenter();
