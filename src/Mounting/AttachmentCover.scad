include <../../variables.scad>

use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module AttachmentCover(height=2) {
  difference() {
    intersection() {
      hull() {
        r0 = 2;
        r1 = 1;

        translate([0, 0, -1])
        linear_extrude(1)
        polygon(roundedRectangle(MountAttachment_width, MountAttachment_height, r0));

        translate([0, 0, height-1])
        linear_extrude(1)
        polygon(roundedRectangle(MountAttachment_width-2*(r0-r1), MountAttachment_height-2*(r0-r1), r1));
      }

      translate([-100, -100, 0])
      cube(200);
    }

    // Screw holes
    for(i=[-1,1])for(j=[-1,1])
    translate([i*MountAttachment_holes_dx/2, j*MountAttachment_holes_dy/2, height])
    ScrewHoleM3(height, head_depth=height/2);
  }
}

AttachmentCover();
