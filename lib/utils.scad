include <../variables.scad>

use <./Round-Anything/polyround.scad>

function remove_conseq_dupes(list) = [for (i = [0 : 1 : len(list) - 2]) if (!((abs(list[i][0] - list[i+1][0])<0.01) && (abs(list[i][1] - list[i+1][1])<0.01))) list[i]];


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
  translate([0, 0, bottom ? 0 : -m3_insert_hole_depth]) {
    rotate_extrude()
    polygon([
      [0, 0],
      [0, m3_insert_hole_depth],
      [m3_insert_hole_diameter/2, m3_insert_hole_depth],
      [m3_insert_hole_diameter/2, m3_insert_cavity_depth+(m3_insert_cavity_diameter-m3_insert_hole_diameter)/2],
      [m3_insert_cavity_diameter/2, m3_insert_cavity_depth],
      [m3_insert_cavity_diameter/2, 0],
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
    // slightly less to not have mising triangles at the holes of the bike rack mount.
    // safe because the PinLength is currently the full length of the screw (including the part in the clamp)
    cylinder(d=m3_screw_diameter_loose, h=MountRail_pin_length-0.4);
  }
}

module ScrewHole(
  depth, // total depth, including head
  diameter,
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
    diameter=m3_screw_diameter_loose,
    head_depth=head_depth,
    head_diameter=m3_screw_head_diameter,
    elongation=elongation
  );
}

module load_svg(filename) {
  // some SVG produce strange geometry. This is a bit slower but fixes the issues.
  if (fix_svg) {
    offset(delta = epsilon) import(filename);
  }
  else {
    import(filename);
  }
}


/*
The code below is from keyv2
https://github.com/rsheldiii/KeyV2

which is licensed under GPL

We only need the round cherry key stem
*/



module rounded_cherry_stem(depth, slop, throw) {
    difference() {
        cylinder(d = $rounded_cherry_stem_d, h = depth);

        // inside cross
        // translation purely for aesthetic purposes, to get rid of that awful lattice
        inside_cherry_cross($stem_inner_slop);
    }
}

module inside_cherry_cross(slop) {
    // inside cross
    // translation purely for aesthetic purposes, to get rid of that awful lattice
    translate([0, 0, -SMALLEST_POSSIBLE]) {
        linear_extrude(height = $stem_throw) {
            square(cherry_cross(slop, extra_vertical)[0], center = true);
            square(cherry_cross(slop, extra_vertical)[1], center = true);
        }
    }

    // Guides to assist insertion and mitigate first layer squishing
    if ($cherry_bevel) {
        for (i = cherry_cross(slop, extra_vertical)) hull() {
            linear_extrude(height = 0.01, center = false) offset(delta = 0.4) square(i, center = true);
            translate([0, 0, 0.5]) linear_extrude(height = 0.01, center = false)  square(i, center = true);
        }
    }
}

function cherry_cross(slop, extra_vertical = 0) = [
    // horizontal tine
        [4.03 + slop, 1.25 + slop / 3],
    // vertical tine
        [1.15 + slop / 3, 4.23 + extra_vertical + slop / 3 + SMALLEST_POSSIBLE],
    ];
