$fn=150;
z=[0,0,1];
y=[0,1,0];
cz=1.2;
h=15;
cxy=13.7;
size=[cxy,cxy,h];
z1=-h/2;
sizeb=[cxy+1,cxy,cz];
z2=-cz*1.5;
sizet=[cxy+2,cxy+2,4];
sizef=[cxy+5,cxy+5,h];
z4=-sizef[2]/2;

if ($preview) import("/home/paulg/Downloads/kailh_low.stl");
module hole() {
translate(z1*z)cube(size,center=true);
translate(z2*z)cube(sizeb,center=true);
translate(2*z)cube(sizet,center=true);
}

module handlebar()
{
    translate((25)/2*y-18.5*z)rotate([90,0,0])cylinder(d=25.4,h=50);
    }
    
module cable() {hull() {
translate([4.5,0,-5])rotate([90,0,0])cylinder(d=4,h=20);
    translate([4.5,0,-12])rotate([90,0,0])cylinder(d=4,h=20);

}
} 
difference() {
translate(z4*z)cube(sizef,center=true);
hole();

handlebar();
    cable();
}

