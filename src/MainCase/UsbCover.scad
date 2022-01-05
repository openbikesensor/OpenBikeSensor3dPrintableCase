include <../../variables.scad>

$fn = 64;
inf = 0.01; // infinitesimal thicknes for slabs in hull - can be increased to see if offsets were done right.
depth = UsbCover_depth+UsbCover_foot_length;


module 2DBase(inset=0) {
    // inset is required for chamfer
    UsbCover_r1=UsbCover_r1-inset;
    UsbCover_r2=UsbCover_r2-inset;
    rMax=max(UsbCover_r1,UsbCover_r2);
    
    // one side of the rounded rectangle
    difference(){
      offset(r=UsbCover_r1) square([depth-UsbCover_r1*2-inset*2,UsbCover_width-UsbCover_r1*2-inset*2],center=true);   
      translate([depth/4 + rMax/2,0])square([depth/2+rMax,UsbCover_width+rMax], center=true);
    }
    // other side - slightly different radius
    difference(){
      offset(r=UsbCover_r2) square([depth-UsbCover_r2*2-inset*2,UsbCover_width-UsbCover_r2*2-inset*2],center=true);     
      translate([-(depth/4 + rMax/2),0])square([depth/2+rMax,UsbCover_width+rMax], center=true);
    }
}

module 2DRail(inset=0)
{
    // only the side rail
    translate([-depth/2+UsbCover_wing_width/2+UsbCover_wing_offset,0,0])square([UsbCover_wing_width-inset*2,UsbCover_width+2*UsbCover_wing_length-inset*2],center=true);
}

module 2DTop(inset=0) {
    // the top shape is the bottom shape with a cutoff at the edge
    difference() {
        2DBase(inset=inset);
        translate([7.4,0])square([depth+UsbCover_r1,UsbCover_width+UsbCover_r1],center=true);
    }
}


module UsbCoverMainBody(chamfer=0.5, clearance=0) {
    // translation into world coordinates
    rotate([0,0,90])translate([depth/2,0,0])

    if (clearance > 0) {
        minkowski(){
            USBPlugBody(chamfer=0,clearance=0);
            cylinder(r=clearance,h=clearance);
        }
    } else {
        //rail with chamfer top and bottom
        hull() {
            linear_extrude(0.01){2DRail(inset=chamfer);}
            translate([0,0,chamfer])linear_extrude(inf){2DRail(inset=0);}
            translate([0,0,UsbCover_height-chamfer-inf])linear_extrude(inf){2DRail(inset=0);}
            translate([0,0,UsbCover_height-inf])linear_extrude(inf){2DRail(inset=chamfer);}
        }
        // bottom with chamfer up to grip
        hull()
        {
            linear_extrude(0.01){2DBase(inset=chamfer);}
            translate([0,0,chamfer])linear_extrude(inf){2DBase(inset=0);}
            translate([0,0,UsbCover_foot_height-inf])linear_extrude(inf){2DBase(inset=0);}
        }
        // top with chamfer
        hull(){
            translate([0,0,UsbCover_foot_height])linear_extrude(inf){2DTop(inset=0);}
            translate([0,0,UsbCover_height-chamfer-inf])linear_extrude(inf){2DTop(inset=0);}
            translate([0,0,UsbCover_height-inf])linear_extrude(inf){2DTop(inset=chamfer);}
        }
        //top chamfers are moved down by slice thickness
    }
}

module MagnetHole() {
    // a cube with clearance and a smaller section on top that grips the magnet.
    {
          translate([-UsbCover_magnet_clearance/2,-UsbCover_magnet_clearance/2,-UsbCover_magnet_clearance])
             cube(UsbCover_magnet_size+UsbCover_magnet_clearance,center=false);
          translate([0,0,inf])
             cube([UsbCover_magnet_size,UsbCover_magnet_size,UsbCover_magnet_depth+inf]);
      }
  }

module MagnetHoles() {
    // translation into world coordinates
    rotate([0,0,90])translate([depth/2,0,0])
    for (i=[-1,1])
        translate([-UsbCover_magnet_size/2-depth/2+UsbCover_depth/2,-UsbCover_magnet_size/2-i*UsbCover_magnet_spacing/2,UsbCover_height-UsbCover_magnet_depth]) MagnetHole();
}

module ChamferPyramid(l)       polyhedron(
  points=[ [l,l,0],[l,-l,0],[-l,-l,0],[-l,l,0], 
           [0,0,l]  ],                                 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],             
              [1,0,3],[2,1,3] ]                     
 );

module 3DGripMould(){
    // translation into world coordinates
    rotate([0,0,90])translate([depth/2,0,0])
    
    // a lengthy "cube" minkowski-summed with a pyramid
    translate([depth/2-UsbCover_foot_length,-UsbCover_indent_width/2+UsbCover_indent_depth,UsbCover_foot_height])minkowski(){
       //pyramid
       rotate([0,0,45])ChamferPyramid(UsbCover_indent_depth);
       //cube
       cube([UsbCover_indent_depth, UsbCover_indent_width-2*UsbCover_indent_depth, UsbCover_indent_height-UsbCover_indent_depth/2]);
    }
}
    
module UsbCover(chamfer=0.5){
    difference(){
        UsbCoverMainBody(chamfer=chamfer);
        3DGripMould();
        MagnetHoles();
    }
}


UsbCover();
