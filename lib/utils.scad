include <../variables.scad>

use <./Round-Anything/polyround.scad>


module mirrorCopy(v, mirrorOffset=0) {
  children();

  translate([v[0]*mirrorOffset, v[1]*mirrorOffset, v[2]*mirrorOffset])
  mirror(v)
  translate([-v[0]*mirrorOffset, -v[1]*mirrorOffset, -v[2]*mirrorOffset])
  children();
}

module mirrorRotate(r) {
  children();

  rotate(r)
  children();
}


module draft(vertical, offs) {
  hull() {
    translate([0, 0, vertical])linear_extrude(0.01)children();
    linear_extrude(0.01)offset(offs)children();
  }
}

module roundedCube(dimen, radii, center=false) {
  translate(center ? [-dimen.x/2, -dimen.y/2, -dimen.z/2] : [0, 0, 0])
  linear_extrude(dimen.z)
  polygon(polyRound([
    [0, 0, is_num(radii) ? radii : radii[0]],
    [dimen.x, 0, is_num(radii) ? radii : radii[1]],
    [dimen.x, dimen.y, is_num(radii) ? radii : radii[2]],
    [0, dimen.y, is_num(radii) ? radii : radii[3]],
  ], fn=$pfn));
}

module HeatsetInsertHole(bottom=false) {
  translate([0, 0, bottom ? 0 : -HeatsetInsert_height]) {

    rotate_extrude()
    polygon([
      [0, 0],
      [0, HeatsetInsert_height],
      [HeatsetInsert_diameter/2, HeatsetInsert_height],
      [HeatsetInsert_diameter/2, HeatsetInsert_height-HeatsetInsert_full_depth],
      [HeatsetInsert_diameter/2+HeatsetInsert_extra_radius, HeatsetInsert_height-HeatsetInsert_full_depth-HeatsetInsert_extra_radius],
      [HeatsetInsert_diameter/2+HeatsetInsert_extra_radius, 0],
    ]);
  }
}

function roundedRectangle(width, height, radius) =
  polyRound([
    [width/2, height/2, radius],
    [-width/2, height/2, radius],
    [-width/2, -height/2, radius],
    [width/2, -height/2, radius],
  ], fn=$pfn);


module ChamferPyramid(l)       polyhedron(
  //        P0        P1        P2         P3       P4
  points= [[l,l,0], [l,-l,0], [-l,-l,0], [-l,l,0], [0,0,l]],
  faces=  [[0,1,4], [1,2,4],  [2,3,4],    [3,0,4], [1,0,3],  [2,1,3] ]
 );

/**
 * Produces a rail with a smaller plate to attach to, and a bigger base that
 * holds it in the opposite rail. The rail is centered on one of the long edges
 * of the plate that can be built upon, ranging wide in both x directions and
 * short into the positive y direction.
 */
module MountRail(clearance=MountRail_clearance) {
  translate([0, 0, -MountRail_total_height ])
  rotate([90, 0, 180])
  mirrorCopy([1, 0, 0])
  difference() {
    linear_extrude(MountRail_width,convexity=2)
    polygon([
      [0, 0],
      [MountRail_base_width/2-clearance, 0],
      [MountRail_base_width/2-clearance, MountRail_base_height-clearance],
      [MountRail_plate_width/2-clearance, MountRail_base_height+MountRail_chamfer_height-clearance],
      [MountRail_plate_width/2-clearance, MountRail_total_height],
      [0, MountRail_base_height+MountRail_chamfer_height+MountRail_plate_distance]
    ]);

    translate([MountRail_base_width/2, 0, MountRail_width/2])
    rotate([0, -90, 0])
      cylinder(r=MountRail_pin_radius, h=MountRail_pin_length, $fn=32);
  }
}

module ScrewHole(
  depth, // total depth, including head
  diameter=ScrewHole_diameter_M3,
  head_depth=0,
  head_diameter=0,
  elongation=0,
) {
  union () {
    // Screw head hole or slot
    if (head_depth > 0) {
      head_diameter_actual = head_diameter ? head_diameter  : diameter * 2;

      hull() {
        for(i=elongation ? [-1,1] : 0)
        translate([i*elongation/2, 0, -head_depth])
        cylinder(d=head_diameter_actual, h=head_depth);
      }
    }

    // Screw hole or slot
    hull() {
      for(i=elongation ? [-1,1] : 0)
      translate([i*elongation/2, 0, -depth])
      cylinder(d=diameter, h=depth);
    }
  }
}

module ScrewHoleM3(depth, head_depth=0, elongation=0) {
  ScrewHole(
    depth,
    diameter=ScrewHole_diameter_M3,
    head_depth=head_depth,
    head_diameter=ScrewHole_diameter_M3*2,
    elongation=elongation
  );
}
