include <../../variables.scad>
use <../../lib/Round-Anything/polyround.scad>

use <../../lib/utils.scad>


$fn = 60;
z = [0, 0, 1];
y = [0, 1, 0];
x = [1, 0, 0];
cz = 1.2;
h = 15;
cxy = 13.7;
size = [cxy, cxy, h];
z1 = -h / 2;
sizeb = [cxy + 1, cxy, cz];
z2 = -cz * 1.5;
sizet = [cxy + 2, cxy + 2, 4];
sizef = [cxy + 5, cxy + 5, h];
z4 = -sizef[2] / 2;
SMALLEST_POSSIBLE = 0.01;

//if ($preview) import("/home/paulg/Downloads/kailh_low.stl");
module hole() {
    translate(z1 * z)cube(size, center = true);
    translate(z2 * z)cube(sizeb, center = true);
    translate(2 * z)cube(sizet, center = true);
}

module handlebar()
{
    translate((50) / 2 * y - 18.5 * z)rotate([90, 0, 0])cylinder(d = 25.4, h = 50);
}

module cable() {
    hull() {
        translate([4.5, 0, -5])rotate([90, 0, 0])cylinder(d = 4, h = 20);
        translate([4.5, 0, -12])rotate([90, 0, 0])cylinder(d = 4, h = 20);
    }
}

module hookprofile() {
    hull()for (i = [-1, 1])translate([0, i * 3])circle(d = 2.5);
}

module support(zoffset) {
    hull() {
        translate([-1.25, 0, -0.2])linear_extrude(0.2)hookprofile();
        translate([2.5, 0, -0.2])linear_extrude(0.2)hookprofile();
    }
    hull() {
        translate([2.5, 0, -0.01])linear_extrude(0.01)hookprofile();
        translate([2.5, 0, -zoffset + 2.5])linear_extrude(0.2)hookprofile();
        translate([2.2, 0, -zoffset + 2.5])rotate([0, 90, 0])linear_extrude(0.6)hookprofile();
    }
}
module hookbase(zoffset) {
    translate(-zoffset * z)rotate(-[90, 0, 0]) {
        rotate_extrude(angle = 180) translate([2.5, 0]) hookprofile();
        hull() {
            translate([2.2, 0, 0])rotate([90, 0, 90])linear_extrude(0.6)hookprofile();
            translate([2.5, 0, 0])rotate([90, 0, 00])linear_extrude(0.2)hookprofile();
        }
    }
    support(zoffset);

}



module button(detail = true) {
    difference() {
        union() {
            translate(z4 * z)cube(sizef, center = true);
                if (detail) {
        translate(0.5 * [cxy + 5 + 2.5, 0, 0])hookbase(6);
        mirror([1, 0, 0])translate(0.5 * [cxy + 5 + 2.5, 0, 0])hookbase(6);
    }
        }

        if (detail) {
            hole();
            handlebar();
            cable();
        }
    }

}

button();




module buttoncutter(spacing = .5) {
    translate(-(spacing + 3.5) * z)minkowski() {
        cube(spacing, center = true);
        union() {button(detail = false);
            hull() {
                linear_extrude(1)translate((-cxy / 2 - 1) * (x + y))square([cxy + 2, cxy + 2]);
                translate(z * 2.5)linear_extrude(1)translate((-cxy / 2) * (x + y))square([cxy, cxy]);
            }
        }
    }
}

module roundedsquare(sizes, r = 2) {
    points = [[0, 0, r],
            [sizes[0], 0, r],
            [sizes[0], sizes[1], r],
            [0, sizes[1], r]
        ];
    echo(points);
    translate(0.5 * [-sizes[0], -sizes[1]])polygon(polyRound(points));
}


module buttontop(wall = 3) {
    translate(-6 * z)rounded_cherry_stem(6, 0.2, 4);
    translate(-6 * z)rounded_cherry_stem(6, 0.2, 4);
    difference() {
        hull() {
            translate(-z)linear_extrude(1)roundedsquare([cxy + 3, cxy + 3]);
            translate(-5 * z)linear_extrude(1)translate((-(cxy + 5 + wall) / 2) * (x + y))square([cxy + 5 + wall, cxy +
                5 + wall]);
            translate(-11 * z)linear_extrude(1)translate((-(cxy + 5 + wall) / 2) * (x + y))square([cxy + 5 + wall, cxy +
                5 + wall]);

        }
        translate(-z)buttoncutter();
        translate(-4*z)cable();
    }
}

translate(-30 * y)buttontop();