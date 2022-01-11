include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <./MainCase.scad>

// This is nicely defined in MainCase.scad, as it is basically cutting
// something out of the antenna housing. So we just import it and use it in
// this file to get a standalone output file.
GpsAntennaLid();
