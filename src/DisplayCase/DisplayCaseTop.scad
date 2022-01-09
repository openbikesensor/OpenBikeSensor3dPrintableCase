include <../../variables.scad>

use <Round-Anything/polyround.scad>
use <../../lib/MountRails.scad>
use <../../lib/utils.scad>

// $fn=128;

module essCurve(r1, r2, w, h) {
  a = acos(1 - w / (r1 + r2));
  l = sin(a) * (r1 + r2);
  c = [w - r1 + cos(a) * r1, sin(a) * r1];

  intersection() {
    cube([w, l, h]);
    difference() {
      union() {
        translate([w-r1, 0, 0])
        cylinder(r=r1, h=h);

        linear_extrude(h)
        polygon([[0, 0], [r1, 0], c, [0, l]]);
      }

      translate([r2, l, -1])
      cylinder(r=r2, h=h+2);
    }
  }
}

module tripleEssCurve() {
  w = 9;
  h = 8;
  r1 = 5;
  r2 = 5;
  r3 = 2;
  d1 = r1 + r2;
  d2 = r2 + r3;
  d3 = sqrt((w-r3)^2 + (h-r1)^2);
  a2 = acos((d3^2-d1^2-d2^2) / (-2 * d1 * d2));
  a4 = acos((d2^2-d1^2-d3^2) / (-2 * d1 * d3));
  a5 = acos((d1^2-d2^2-d3^2) / (-2 * d2 * d3));
  a6 = atan((w-r3) / (h-r1));
  a7 = atan((h-r1) / (w-r3));
  a3 = 180 - a5 - a7;
  a1 = 180 - a4 - a6;
  p1 = [-w, -r1];
  p2 = [-r3+d2*cos(a3), -h+d2*sin(a3)];
  p3 = [-r3, -h];
  t1 = [(p1.x*r2+p2.x*r1)/(r1+r2), (p1.y*r2+p2.y*r1)/(r1+r2)];
  t2 = [(p2.x*r3+p3.x*r2)/(r2+r3), (p2.y*r3+p3.y*r2)/(r2+r3)];

  difference() {
    intersection() {
      union () {
        translate(p1)
        circle(r1);

        translate(p3)
        circle(r3);

        polygon([[-w, 0], t1, t2, [0, -h], [-w, -h]]);
      }

      translate([-w, -h])
      square([w, h]);
    }

    translate(p2)
    circle(r2);
  }
}

module DisplayCaseBasicShape(height=20, magnet_depth) {
  difference() {
    union() {
      difference() {
        hull() {
          translate([DisplayCase_outer_radius, -DisplayCase_outer_radius, 0])
          cylinder(r=DisplayCase_outer_radius, h=height);

          translate([25, -DisplayCase_outer_radius, 0])
          cylinder(r=DisplayCase_outer_radius, h=height);

          translate([DisplayCase_outer_width - DisplayCase_outer_large_radius, -45, 0])
          cylinder(r=DisplayCase_outer_large_radius, h=height);

          intersection() {
            translate([20, -30, 0])
            cylinder(r=20, h=height);

            translate([0, -45, 0])
            cube([DisplayCase_outer_width, 45, height]);
          }
        }
        translate([DisplayCase_outer_width+DisplayCase_magnet_housing_width-9, -8, -1])
        cube([9, 8, height+2]);
      }

      linear_extrude(height)
      translate([DisplayCase_outer_width+DisplayCase_magnet_housing_width, 0, 0])
      tripleEssCurve();

      translate([DisplayCase_outer_width, -8-DisplayCase_magnet_length, 0])
      mirror([0, 1])
      essCurve(2, 5, DisplayCase_magnet_housing_width, height);

      translate([DisplayCase_outer_width, -8-DisplayCase_magnet_length, 0])
      cube([DisplayCase_magnet_housing_width, DisplayCase_magnet_length, height]);
    }

    translate([DisplayCase_outer_width, -8-DisplayCase_magnet_length, height-magnet_depth])
    cube([DisplayCase_magnet_thickness*2, DisplayCase_magnet_length, height]);
  }
}

module DisplayCaseHolePattern() {
  translate([DisplayCase_outer_radius, -DisplayCase_outer_radius])children();
  translate([25, -DisplayCase_outer_radius])children();
  translate([DisplayCase_outer_radius+2, -(DisplayCase_outer_radius+DisplayCaseTop_pcb_height+DisplayCaseTop_hole_diameter)])rotate([0, 0, 180])children();
}

module DisplayCaseTop() {
  // translate with pcb_origin to move origin to center of PCB, top side
  pcb_origin = [-DisplayCase_outer_width/2, -DisplayCase_outer_radius-DisplayCaseTop_hole_diameter/2-DisplayCaseTop_pcb_height/2, DisplayCaseTop_height];
  pcb_depth = DisplayCaseTop_height-DisplayCaseTop_window_depth;

  standoff_width = (DisplayCaseTop_pcb_width-DisplayCaseTop_cable_clearance)/2;
  standoff_height = 3.35;

  union () {
    difference() {
      mirror([1, 0, 0])
      DisplayCaseBasicShape(DisplayCaseTop_height, DisplayCaseTop_magnet_depth);

      mirror([1, 0, 0])
      DisplayCaseHolePattern() {
        difference() {
          union () {
            translate([0, 0, -100])
            cylinder(d=3.3, h=200);

            translate([0, 0, 0])
            cylinder(d=6.4, h=2.7);

            translate([-3.3/2, -3.3, 8-3.3])
            cube([3.3, 3.3, 20]);
          }

          if(enable_easy_print)
          translate([0, 0, 2.7])
          EasyPrintHoleShink(3.3, 6.4, 2);
        }
      }

      // hole for PCB
      translate(pcb_origin) {
        cube([DisplayCaseTop_pcb_width, DisplayCaseTop_pcb_height, pcb_depth*2], center=true);
      }

      // window
      translate([pcb_origin.x, pcb_origin.y-DisplayCaseTop_window_offset, 0]) {
        d = DisplayCaseTop_window_depth/2;
        union () {
          hull() {
            translate([0, 0, d-0.1])
            linear_extrude(0.1)
            polygon(roundedRectangle(DisplayCaseTop_window_width, DisplayCaseTop_window_height, DisplayCaseTop_window_radius));

            translate([0, 0, -d])
            linear_extrude(d)
            polygon(roundedRectangle(DisplayCaseTop_window_width+d*2, DisplayCaseTop_window_height+d*2, DisplayCaseTop_window_radius+d));
          }

          translate([0, 0, d])
          linear_extrude(d*2)
          polygon(roundedRectangle(DisplayCaseTop_window_width, DisplayCaseTop_window_height, DisplayCaseTop_window_radius));
        }
      }

      // hole for button
      translate([-DisplayCase_outer_width+DisplayCase_outer_large_radius, -45, 0]) {
        difference() {
          union () {
            translate([0, 0, -1])
            cylinder(d=DisplayCaseTop_button_diameter, h=20);

            translate([0, 0, -1])
            cylinder(d=DisplayCaseTop_button_outside_diameter, h=1+DisplayCaseTop_button_outside_depth);
          }

          if(enable_easy_print)
          translate([0, 0, DisplayCaseTop_button_outside_depth])
          EasyPrintHoleShink(DisplayCaseTop_button_diameter, DisplayCaseTop_button_outside_diameter, 3);
        }
      }
    }

    translate(pcb_origin)
    mirrorCopy([0, 1, 0])
    mirrorCopy([1, 0, 0])
    translate([-DisplayCaseTop_pcb_width/2, -DisplayCaseTop_pcb_height/2, -pcb_depth])
    linear_extrude(DisplayCaseTop_pcb_standoff)
    polygon(polyRound([
      [0, 0, 0],
      [standoff_width, 0, 0],
      [standoff_width, standoff_height, 1],
      [0, standoff_height, 0],
    ]));
  }
}

module EasyPrintHoleShink(inner_diameter, outer_diameter, n=2, lh=layer_height) {
  mirror([0, 0, 1])
  intersection() {
    cylinder(h=lh*2, d=outer_diameter);

    union()for(z=[0,1])for(i=[1:n]) {
      rotate([0, 0, 360/n*(i+z*0.5)])
      translate([inner_diameter/2, -100, 0])
      cube([(outer_diameter-inner_diameter)/2, 200, (z+1)*lh]);
    }
  }
}

DisplayCaseTop();
