l=0.25;
h=0.4;
filename="../OBS-Display-A-005_Kabelbinder_Schiene_v0.1.0.stl";

difference()

{
    import(filename);
    
    translate([-3.05+l/2,14.7+h/2,0]) cube([4+l,10+h,20+l],center=true);
    translate([-4.05+l/2,16.7+h/2,0]) cube([2+l,10+h,20+l],center=true);

}
