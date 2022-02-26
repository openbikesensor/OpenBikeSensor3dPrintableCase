include <../../variables.scad>
use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

module AttachmentCover(height = MainCase_gps_antenna_lid_thickness, cover_number="undef") {
  difference(){
    hull(){
      translate([0,0,0]) linear_extrude(epsilon) polygon(polyRound([
          [0, MountAttachment_height/2, 2],
          [MountAttachment_width, MountAttachment_height/2, 5],
          [MountAttachment_width, -MountAttachment_height/2, 5],
          [0, -MountAttachment_height/2, 2],
        ], fn=$pfn));

      translate([-1,0,2-epsilon]) linear_extrude(epsilon) offset(r=-1) polygon(polyRound([
          [0, MountAttachment_height/2, 2],
          [MountAttachment_width, MountAttachment_height/2, 5],
          [MountAttachment_width, -MountAttachment_height/2, 5],
          [0, -MountAttachment_height/2, 2],
        ], fn=$pfn));
    }
    mirror([0, 0, 0]) {
      for(i = [-1, 1]) {
        for(j = [-1, 1]) {
          translate([
            MountAttachment_width / 2 + i * MountAttachment_holes_dx / 2 + MountAttachment_holes_x_offset ,
            j * MountAttachment_holes_dy / 2,
            2,
          ])
          ScrewHole( 2,
                    m3_screw_diameter_loose,
                    head_depth=1,
                    head_diameter=m3_screw_head_diameter);
        }
      }
    }
  }
  if (cover_number!="undef") {
    #translate([MountAttachment_width/2+4.5,-3.4*len(cover_number),MainCase_gps_antenna_lid_thickness])rotate([0,0,90])linear_extrude(2*layer_height)text(cover_number,font="open sans", size=10,center=false);
  }
}
translate([-MountAttachment_width/4-6,0,0])AttachmentCover(cover_number=str(attachment_cover_number_text));
