logo_depth = 0.4;
logo_convexity = 10;
logo_file = "obs-framed-maincase.svg";

mode = "main"; // or "inner"
inverted = false;

module main() {
  color([1.0, 0, 0]) {
    union() {
    rotate([0, 0, 0]){
          import("../OBS-MainCase-A-001_MainCase_without_logo_v0.1.0.stl");
      }
    };
  };
};

module slice() {
  translate([0, 0, 0]) {
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
      mirror([1, 0, 0]) {
        translate([0, 0, 0]) {
          linear_extrude(height = logo_depth, center=false, convexity = logo_convexity) {
            import(file = logo_file);
          };
        }
      }
    };
  }
}

rotate([0, 0, 0]) {
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
