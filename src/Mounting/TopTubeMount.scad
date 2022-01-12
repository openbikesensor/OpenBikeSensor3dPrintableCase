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

rotate([90, 0, 0])
TopTubeMount();
