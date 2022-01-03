include <../variables.scad>

use <Round-Anything/polyround.scad>


module mirrorCopy(v, mirrorOffset=0) {
  children();

  translate([v[0]*mirrorOffset, v[1]*mirrorOffset, v[2]*mirrorOffset])
  mirror(v)
  translate([-v[0]*mirrorOffset, -v[1]*mirrorOffset, -v[2]*mirrorOffset])
  children();
}


module draft(vertical, offs) {
  hull() {
    translate([0, 0, vertical])linear_extrude(0.01)children();
    linear_extrude(0.01)offset(offs)children();
  }
}

module roundedCube(dimen, radii) {
  if (is_num(radii)) {
    radii = [radii, radii, radii, radii];
  }

  linear_extrude(dimen[2])
  polygon(polyRound([
    [0, 0, radii[0]],
    [dimen[0], 0, radii[1]],
    [dimen[0], dimen[1], radii[2]],
    [0, dimen[1], radii[3]],
  ]));
}

module HeatsetInsertHole(bottom=false) {
  translate([0, 0, bottom ? 0 : -HeatsetInsert_height])
  cylinder(d=HeatsetInsert_diameter, h=HeatsetInsert_height);
}

function roundedRectangle(width, height, radius) =
  polyRound([
    [width/2, height/2, radius],
    [-width/2, height/2, radius],
    [-width/2, -height/2, radius],
    [width/2, -height/2, radius],
  ], fn=polyRoundFn);
