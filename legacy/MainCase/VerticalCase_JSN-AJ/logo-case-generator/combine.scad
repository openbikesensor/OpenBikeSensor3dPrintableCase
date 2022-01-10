include <BOSL2/std.scad>

// Build settings
logo_depth = 0.4;
folder = "obs-logo";
part = "lid"; // "maincase" or "lid"
mode = "main"; // "main" or "inner"
inverted = true;

// Advanced settings
logo_convexity = 10;


// Derived variables
logo_file = str_format("{}/{}.svg", [folder, part]);


module main() {
  color([1.0, 0, 0]) {
    if (part == "maincase") {
      import("../OBS-MainCase-A-001_MainCase_without_logo_v0.1.4.stl");
    } else {
      union() {

        // TODO: Proper placement of input file should eliminate the need to
        // translate and rotate it here.
        translate([108, 72, -47.1]) {
          rotate([0,-90,0]) {
            import("../OBS-MainCase-A-002_Lid_v0.1.0.stl");
          };
        };

        // Fill the existing logo in the imported STL file, so we can cut out our own logo.
        // TODO: Export the original without a logo in it.
        translate([33, 2, -0.5]) {
          cube([66, 68, 0.5]);
        };

      };
    }
  };
};

module slice() {
  translate([0, 0,  part == "maincase" ? 0 : -logo_depth]) {
    cube([1000, 1000, logo_depth]);
  }
}

module inner(inverted=false) {
  if (inverted) {
    difference() {
      intersection() {
        main();
        slice();
      }
      inner(inverted=false);
    }
  } else {
    color([0, 1.0, 0]) {
      mirror([part == "maincase" ? 1 : 0, 0, 0]) {
        translate([0, 0,  part == "maincase" ? 0 : -logo_depth]) {
          linear_extrude(height = logo_depth, center=false, convexity = logo_convexity) {
            import(file = logo_file);
          };
        }
      }
    };
  }
}

rotate([0, part == "maincase" ? 0 : 180, 0]) {
  if (mode  == "main" && inverted) {
      difference() {
        main();
        slice();
      }
      inner(inverted=false);
  } else if (mode  == "main") {
    difference() {
      main();
      inner();
    }
  } else if (mode  == "inner") {
    inner(inverted=inverted);
  }
}
