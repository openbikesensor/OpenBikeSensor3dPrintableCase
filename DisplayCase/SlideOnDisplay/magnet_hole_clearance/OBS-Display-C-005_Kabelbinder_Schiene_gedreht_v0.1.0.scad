l=0.25;
h=0.4;
filename="../OBS-Display-C-005_Kabelbinder_Schiene_gedreht_v0.1.0.stl";

difference()

{
    translate([10.97,0.14,-24.4])rotate([0,-90,0])import(filename);
    
    translate([-3.05+l/2,14.7+h/2,0]) cube([4+l,10+h,20+l],center=true);
    translate([-4.05+l/2,16.7+h/2,0]) cube([2+l,10+h,20+l],center=true);

}
