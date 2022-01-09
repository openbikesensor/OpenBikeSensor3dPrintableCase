include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/utils.scad>
use <./DisplayCaseTop.scad>

module DisplayCaseBottomStandoffs() {
  dx = DisplayCaseTop_pcb_width - 2 * default_clearance - DisplayCaseBottom_standoff_size;
  dy = DisplayCaseTop_pcb_height - 2 * default_clearance - DisplayCaseBottom_standoff_size;

  translate(DisplayCaseBottom_pcb_origin) {
    for(i=[-1,1])translate([i*dx/2-DisplayCaseBottom_standoff_size/2, 0, 0]) {
      for(j=[-1,1])translate([0, j*dy/2-DisplayCaseBottom_standoff_size/2, 0])
      cube([DisplayCaseBottom_standoff_size, DisplayCaseBottom_standoff_size, DisplayCaseBottom_standoff_height]);

      translate([0, -dy/2-DisplayCaseBottom_standoff_size/2, 0])
      cube([DisplayCaseBottom_standoff_size, dy+DisplayCaseBottom_standoff_size, DisplayCaseBottom_standoff_bridge_height]);
    }
  }
}

module DisplayCaseBottom() {
  union () {
    difference() {
      union() {
        render()
        DisplayCaseBasicShape(DisplayCaseBottom_height, DisplayCaseBottom_magnet_depth);

        DisplayCaseBottomStandoffs();
      }

      DisplayCaseHolePattern() {
        translate([0, 0, DisplayCaseBottom_height])
        HeatsetInsertHole();
      }

      translate([DisplayCase_outer_width-DisplayCase_outer_large_radius, -45, 0]) {
        // cavity for the wiring
        translate([0, 0, 1])
        cylinder(d=21, h=100);

        // cable hole (ellipse)
        translate([0, 0, -1])
        scale([14/12, 1, 1]) // scale to a side ratio of 14:12
        cylinder(d=12, h=100);

        left = DisplayCase_outer_width-DisplayCase_outer_large_radius-(DisplayCase_outer_radius+2+HeatsetInsert_diameter/2+1);
        right =  DisplayCase_outer_width/2+DisplayCaseTop_pcb_width/2-default_clearance-DisplayCaseBottom_standoff_size-(DisplayCase_outer_width-DisplayCase_outer_large_radius);
        translate([-left, 0, 4])
        cube([left+right, 5+21/2, 30]);

        translate([-left, 0, 9])
        cube([left+right, 5+21/2+3, 30]);
      }

      translate([0, -10-DisplayRail_width/2, 0])
      rotate([0, 0, 90])
      translate([0, -50, 0])
      mirror([0, 0, 1])
      rotate([-90, 0, 0])
      mirrorCopy([1, 0, 0])
      linear_extrude(100)
      polygon([
        [0, 0],
        [0, DisplayRail_chamfer_size + DisplayRail_top_height + DisplayRail_bottom_height],
        [DisplayRail_width/2, DisplayRail_bottom_height + DisplayRail_chamfer_size + DisplayRail_top_height],
        [DisplayRail_width/2, DisplayRail_bottom_height + DisplayRail_chamfer_size],
        [DisplayRail_width/2 - DisplayRail_chamfer_size, DisplayRail_bottom_height],
        [DisplayRail_width/2 - DisplayRail_chamfer_size, 0],
      ]);
    }
  }
}

DisplayCaseBottom();
