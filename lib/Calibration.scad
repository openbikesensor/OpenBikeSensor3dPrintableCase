$fn = 64;

min_print_spacing = 0.46 * 3;
font = "Open Sans:style=bold";
text_size = 4.5;

function HexWidthToDiameter(width) = width * 2 / sqrt(3);
function HexDiameterToWidth(diameter) = diameter / 2 * sqrt(3);

module HolePattern(hex=false, nominal_diameter=3, cmin=0, cmax=0.6, n=13) {
  // dx = nominal_diameter + 2 * cmax;
  max_diameter = nominal_diameter + 2 * cmax;
  dist = max_diameter / sqrt(2) + min_print_spacing ;
  p = max_diameter / 2 + min_print_spacing;
  px = 2 * p + text_size;
  py = p;
  h = 3;

  W = 2*px+dist*(n-1);
  H = 2*py+dist;

  function lerp(f, a, b) = a + (b - a) * f;
  function steps(a, b, s) = ceil((b - a) / s);

  difference() {
    union() {
      cube([W, H, h]);

      translate([0, H/2, h]) {
        translate([p, 0, 0])
        rotate([0, 0, 90])
        CalibrationText(str(nominal_diameter+cmin));

        translate([W-p, 0, 0])
        rotate([0, 0, 90])
        CalibrationText(str(nominal_diameter+cmax));
      }
    }

    translate([0, 0, -1])
    for(i=[0:n-1])
    translate([i*dist+px, py+((i%2) * dist), 0])
    cylinder(d=nominal_diameter+2*lerp(i/(n-1), cmin, cmax), h=h+2, $fn=hex ? 6 : $fn);
  }
}

module CalibrationText(text, size=text_size) {
  linear_extrude(0.5, convexity=4)
  offset(r=0.1)
  text(text, size=size, halign="center", valign="center", font=font, spacing=1.0);
}

module HolePatternM3Screw() {
  HolePattern(hex=false, nominal_diameter=3, cmin=0, cmax=0.6, n=13);
}

function round_to(x, digits) = round(x*10^digits) / 10^digits;

module HolePatternM3HexNut() {
  d = round_to(HexWidthToDiameter(5.5), 2);
  HolePattern(hex=true, nominal_diameter=d, cmin=-0.2, cmax=0.2, n=9);
}

