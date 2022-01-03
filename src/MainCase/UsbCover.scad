include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module UsbCoverMainBody(clearance=0) {
  difference() {
    union() {
      translate([0, (UsbCover_depth + UsbCover_foot_length) / 2, -clearance])
      linear_extrude(UsbCover_height + clearance)
      polygon(roundedRectangle(UsbCover_width + 2 * clearance, UsbCover_depth + UsbCover_foot_length + 2 * clearance, UsbCover_radius));

      // wings
      translate([0, UsbCover_wing_offset + UsbCover_wing_width / 2, UsbCover_height / 2 - clearance / 2])
      cube([UsbCover_width + 2 * UsbCover_wing_length + 2 * clearance, UsbCover_wing_width + 2 * clearance, UsbCover_height + clearance], center=true);
    }
    // cut out the front side to produce the "foot" on the bottom
    translate([-UsbCover_width, UsbCover_depth+clearance, UsbCover_foot_height])
    cube([UsbCover_width * 2, 100, 100]);
  }
}

module UsbCover() {
  difference() {
    // Main body
    UsbCoverMainBody();

    // magnet holes
    for (i = [-1, 1]) {
      translate([UsbCover_magnet_spacing * i / 2, UsbCover_depth / 2, UsbCover_height - UsbCover_magnet_depth / 2])
      cube([UsbCover_magnet_size, UsbCover_magnet_size, UsbCover_magnet_depth], center=true);
    }

    // handle indentation for the index finger to pull out the cover
    translate([0, UsbCover_depth+0.1, UsbCover_foot_height])
    intersection() {
      translate([-100, 0, 0])
      rotate([90, 0, 90])
      linear_extrude(200)
      polygon(polyRound([
        [0, 0, 0],
        [-UsbCover_indent_depth, 0, 0],
        [-UsbCover_indent_depth, UsbCover_indent_height, 0],
        [0, UsbCover_indent_height, UsbCover_indent_radius],
        [0, UsbCover_indent_height+UsbCover_indent_radius * 2, 0],
      ], fn=$pfn));

      rotate([0, 0, 180])
      linear_extrude(20)
      polygon(polyRound(mirrorPoints([
        [0, 0, 0],
        [-UsbCover_indent_width/2-UsbCover_indent_radius, 0, 0],
        [-UsbCover_indent_width/2, 0, UsbCover_indent_radius],
        [-UsbCover_indent_width/2, UsbCover_indent_depth, 0],
        [0, UsbCover_indent_depth, 0],
        [0, 0, 0],
      ], 180), fn=$pfn));
    }
  }
}

// rotate([0, 0, 180])
UsbCover();
