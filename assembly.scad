include <variables.scad>

use <src/MainCase/MainCase.scad>
use <src/MainCase/MainCaseLid.scad>
use <src/Mounting/LockingPin.scad>
use <src/Mounting/SeatPostMount.scad>

explode = $t;

MainCase();

translate([0, 0, OBS_depth])
translate([0, -5, 0])
rotate([180 * explode, 0, 0])
translate([0, 5, 0])
MainCaseLid();

translate([
  OBS_height + MainCase_gps_antenna_housing_depth - MainCase_gps_antenna_lid_thickness + 10 * max(0, explode - 0.2) / 0.8,
  MainCase_gps_antenna_y_offset + 6 * (min(1, explode + 0.2) - 0.2) / 0.8,
  OBS_depth/2,
])
rotate([0, 90, 0])
GpsAntennaLid();
