include <../../variables.scad>

use <./SeatPostMount.scad>

module TopTubeMount() {
  difference() {
    SeatPostMountBase();
    SeatPostMountCutout(
      diameter=TopTubeMount_diameter,
      length=TopTubeMount_height,
      angle=0,
      cutaway=false
    );
  }
}

if (orient_for_printing) {
  rotate([90, 0, 0])
  TopTubeMount();
} else {
  rotate([0, 0, 180])
  TopTubeMount();
}
