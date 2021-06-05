l=0.25;
h=0.4;
filename="../OBS-Display-B-002_Sechskantmutter_Display_Bottom_v0.1.0.stl";

difference()
{
    import(filename);
    
    translate([29.8-l,-1.895+h/2-10,8-l/2]) cube([4+l,10+h,20+l]);
}
