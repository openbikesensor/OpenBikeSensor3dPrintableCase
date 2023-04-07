difference(){
    union() {
        cube([4, 20, 8.7]);
        translate([11+5,0,0])cube([4, 20, 8.7]);
        translate([0,1.8+(16-1-1.4)/2,2.2])cube([18,2,5]);
    }
    #translate([-1,1.8,6.7])cube([40,1.4,10]);
    #translate([-1,2+16-1.2,6.7])cube([40,1.4,10]);
    #translate([0,1.8+(16-1-1.4)/2-2,-3])cube([22,6,5]);

}
