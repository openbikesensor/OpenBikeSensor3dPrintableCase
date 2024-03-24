include <../../variables.scad>
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

if ($preview) import("/home/paulg/Downloads/kailh_low.stl");
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
module hookbase()     linear_extrude(0.01) hull() {
    for(i=[-1,1])translate([0,i*3,0])circle(d=2.5);
}
hull(){
translate(0.5*[cxy+5,0,-17])rotate([0,90,0]) hookbase();
    
translate(0.5*[cxy+10,0,-17])rotate([0,45,0]) scale([sqrt(2),1,1])hookbase();

}
module button(detail = true) {
    difference() {
        union() {
            translate(z4 * z)cube(sizef, center = true);
            *if (detail) translate(-4 * z)cube([7, cxy + 16, 8], center = true);
        }

        if (detail) {
            hole();
            *for (i = [-1, 1]) translate((cxy + 8) / 2 * y * i) rubber_ring();
            handlebar();
            cable();
        }
    }
    *if (detail)difference() {
        translate(-0.1 * z)cube([7, cxy + 16, 0.2], center = true);
        hole();
    }
}

button();

module rubber_ring(inner=false) {
    translate(-18.5 * z)
        rotate([90, 0, 0])
            rotate_extrude()
                translate([25.4 / 2 + 1.5 + 1, 0, 0])
                    {
                        hull() {
                            circle(d = 3);
                            translate([inner?-5:5, 0, 0])circle(d = 3);
                        }
                    }
}


module bottom_shape(diam = 5) {
    difference() {
        translate([0, 0, -7.5])cube([15, 15, 15], center = true);
        translate(2 * z)handlebar();
        for (i = [-1, 1])rotate([0, 20 * i, 0])translate([i * (diam + 1.5), 0, 0])rotate_extrude() hull() {
            translate([4, 0, 0]) circle(d = 3);
            translate([4, 4, 0]) circle(d = 3);
        }

    }

}

//rotate(-x*90)linear_extrude(cxy-5*3)
module bottom(width = cxy, diam = 5) {
    rotate(-x * 90)linear_extrude(width - diam)    projection(cut = true) {
        rotate(x * 90)bottom_shape(diam);
    }
    difference() {
        bottom_shape(diam);
        translate(y * (20 +0.01))cube([40, 40, 40], center = true);
    }
    translate(y * (width - diam))difference() {
        bottom_shape(diam);
        translate(-y * (20 + 0.01))cube([40, 40, 40], center = true);
    }
}

translate(y * 25) bottom();
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


module buttontop(wall = 3) {
    translate(-6 * z)rounded_cherry_stem(6, 0.2, 4);
    translate(-6 * z)rounded_cherry_stem(6, 0.2, 4);
    difference() {
        hull() {
            translate(-z)linear_extrude(1)translate((-cxy / 2 - 1) * (x + y))square([cxy + 2, cxy + 2]);
            translate(-5 * z)linear_extrude(1)translate((-(cxy + 5 + wall) / 2) * (x + y))square([cxy + 5 + wall, cxy +
                5 + wall]);
            translate(-11 * z)linear_extrude(1)translate((-(cxy + 5 + wall) / 2) * (x + y))square([cxy + 5 + wall, cxy +
                5 + wall]);

        }
        translate(-z)buttoncutter();
        *for (i = [-1, 1]) translate((cxy + 8) / 2 * y * i+z*-6) rubber_ring(true);
    }
}

translate(-30 * y)buttontop();