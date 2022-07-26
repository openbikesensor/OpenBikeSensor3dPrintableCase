include <../../variables.scad>
include <../../lib/utils.scad>

$fn = 64;
depth = UsbCover_depth+UsbCover_foot_length;


module 2DBase(inset=0, clearance=0) {
    // inset is required for chamfer
    UsbCover_r1=UsbCover_r1-inset;
    UsbCover_r2=UsbCover_r2-inset;
    rMax=max(UsbCover_r1,UsbCover_r2);

    // one side of the rounded rectangle
    translate([clearance, 0, 0])
    difference(){
      offset(r=UsbCover_r1) square([depth-UsbCover_r1*2-inset*2,UsbCover_width-UsbCover_r1*2-inset*2-2*clearance],center=true);
      translate([depth/4 + rMax/2,0])square([depth/2+rMax,UsbCover_width+rMax-clearance], center=true);
    }
    // other side - slightly different radius
    difference(){
      offset(r=UsbCover_r2) square([depth-UsbCover_r2*2-inset*2,UsbCover_width-UsbCover_r2*2-inset*2-2*clearance],center=true);
      translate([-(depth/4 + rMax/2),0])square([depth/2+rMax,UsbCover_width+rMax-clearance], center=true);
    }
}

module 2DRail(inset=0, clearance=0)
{
    // only the side rail
    translate([-depth/2+UsbCover_wing_width/2+UsbCover_wing_offset,0,0])square([UsbCover_wing_width-inset*2-clearance,UsbCover_width+2*(UsbCover_wing_length-clearance)-inset*2],center=true);
}

module 2DTop(inset=0, clearance=0) {
    // the top shape is the bottom shape with a cutoff at the edge
    difference() {
        2DBase(inset=inset, clearance=clearance);
        translate([7.4,0])square([depth+UsbCover_r1,UsbCover_width+UsbCover_r1],center=true);
    }
}


module UsbCoverMainBody(chamfer=0.5, clearance=0, counter_magnets=false) {
    // translation into world coordinates

    if (clearance > 0) {
        // Positive clearance is used in the cutout of the MainCase.
        
        // clearance by minkowski with cylinder
        minkowski(){
            UsbCoverMainBody(chamfer=0,clearance=0);
            cylinder(r=clearance,h=clearance);
        }
        if (counter_magnets) {
            CounterMagnetHoles(clearance=clearance);
        }

    } else {
        // Negative clearance is used in the correction of the actual UsbCover
        // part for printing smaller items to fit existing cases with not
        // enough actual clearance.

        rotate([0,0,90])translate([depth/2,0,0]) {
            //rail with chamfer top and bottom
            hull() {
                linear_extrude(0.01){2DRail(inset=chamfer,clearance=-clearance);}
                translate([0,0,chamfer])linear_extrude(epsilon){2DRail(inset=0,clearance=-clearance);}
                translate([0,0,UsbCover_height-chamfer-epsilon])linear_extrude(epsilon){2DRail(inset=0,clearance=-clearance);}
                translate([0,0,UsbCover_height-epsilon])linear_extrude(epsilon){2DRail(inset=chamfer,clearance=-clearance);}
            }
            // bottom with chamfer up to grip
            hull()
            {
                linear_extrude(0.01){2DBase(inset=chamfer,clearance=-clearance);}
                translate([0,0,chamfer])linear_extrude(epsilon){2DBase(inset=0,clearance=-clearance);}
                translate([0,0,UsbCover_foot_height-epsilon])linear_extrude(epsilon){2DBase(inset=0,clearance=-clearance);}
            }
            // top with chamfer
            hull(){
                translate([0,0,UsbCover_foot_height])linear_extrude(epsilon){2DTop(inset=0,clearance=-clearance);}
                translate([0,0,UsbCover_height-chamfer-epsilon])linear_extrude(epsilon){2DTop(inset=0,clearance=-clearance);}
                translate([0,0,UsbCover_height-epsilon])linear_extrude(epsilon){2DTop(inset=chamfer,clearance=-clearance);}
            }
            //top chamfers are moved down by slice thickness
        }
    }
}

module MagnetHole(inverse=false) {
    // a cube with clearance and a smaller section on top that grips the magnet.
    union() {
          updown = inverse ? UsbCover_magnet_clearance : -UsbCover_magnet_clearance;
          translate([-UsbCover_magnet_clearance/2,-UsbCover_magnet_clearance/2,updown])
             cube(UsbCover_magnet_size+UsbCover_magnet_clearance,center=false);
          translate([0,0,inverse?-epsilon:epsilon])
             cube([UsbCover_magnet_size,UsbCover_magnet_size,UsbCover_magnet_depth+epsilon]);
      }
  }

module MagnetHoles() {
    // translation into world coordinates
    rotate([0,0,90])translate([depth/2,0,0])
    for (i=[-1,1])
        translate([-UsbCover_magnet_size/2-depth/2+UsbCover_depth/2,-UsbCover_magnet_size/2-i*UsbCover_magnet_spacing/2,UsbCover_height-UsbCover_magnet_depth]) MagnetHole();
}

module CounterMagnetHoles(clearance=0) {
  // these are used to punch the magnet holes into the MainCase, together with a bridging helper ridge
  // translation into world coordinates
  rotate([0,0,90])translate([depth/2,0,0]){
    for (i=[-1,1])
      translate([-UsbCover_magnet_size/2-depth/2+UsbCover_depth/2,-UsbCover_magnet_size/2-i*UsbCover_magnet_spacing/2,UsbCover_height+clearance]) MagnetHole(inverse=true);
    if (enable_easy_print) {
      translate([-UsbCover_magnet_size/2-depth/2+UsbCover_depth/2,-UsbCover_width/2-clearance,UsbCover_height+clearance])
        cube([UsbCover_magnet_size,UsbCover_width+2*clearance,.25]);
    }
  }
}

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
        UsbCoverMainBody(chamfer=chamfer, clearance=-UsbCover_clearance_correction);
        3DGripMould();
        MagnetHoles();
    }
}

rotate([0, 0, 180])
UsbCover();
