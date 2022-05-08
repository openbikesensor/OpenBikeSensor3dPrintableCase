// ==========================================================
//                      GLOBAL SETTINGS
// ==========================================================

// --------------
// Print settings
// --------------

// In some places we need to ensure a minimum wall thickness, so set this to
// your extrusion width. The default of 0.46mm is the PrusaSlicer default for a
// 0.4mm nozzle.
extrude_width = 0.46;

// Simplifies printing by adding smart bridges to remove need for supports.
enable_easy_print = true;
enable_text = true;
fix_svg = false;

// Used e.g. by easy print algorithms.
layer_height = 0.2;

// Size of the gap between two things that should fit into each other. This is
// gap size, so it applies to radii, not diameters.
default_clearance = 0.2;

// Set to false to generate nice previews and such, to true for printing output
// in proposed orientation.
orient_for_printing = false;

// ----------------------
// Model quality settings
// ----------------------

fast = $preview; // in fast mode, not all features are rendered
$fs = 0.2;
$fa = 1;
$fn = fast ? 24 : 120;
$pfn = $fn; // for polyRound
epsilon = 0.01; // infinitesimal thickness for slabs in hull - can be increased to see if offsets were done right.


// ==========================================================
//                    CUSTOMIZABLE OPTIONS
// ==========================================================

// A "back rider" is a case that has the attachment on front, riding e. g.
// behind the seat post. A "top rider" is a case that has an attachment on its
// bottom, sitting on top of a compatible mount, such as on the top tube or
// luggage rack. A single MainCase can be both back rider and top rider.
MainCase_back_rider = true;
MainCase_top_rider = true;
MainCase_back_rider_cable = true;
MainCase_top_rider_cable = true;

// General thickness of all walls of the main case and where applicable
wall_thickness = 2;

// -------------------------
// Dimensions of M3 hardware
// -------------------------

m3_screw_diameter_tight = 3.0; // screw should grab the plastic well
m3_screw_diameter_loose = 3.25; // screw should slide in nicely
m3_screw_head_depth = 3; // minimum depth for sinking the screw head
m3_screw_head_diameter = 6; // can have a little clearance
m3_hex_nut_diameter = 6.45; // outer circle, *not* wrench size (S), but `S*2/sqrt(3)`, plus clearance
m3_hex_nut_thickness = 2.5; // found different nut specifications, 2.5 is the maximum thickness I found named
m3_insert_hole_diameter = 4;
m3_insert_hole_depth = 5.75;
m3_insert_cavity_depth = 5.75 - 4.5;  // size of cavity on the bottom for displaced plastic
m3_insert_cavity_diameter = m3_insert_hole_diameter + 1;


// ==========================================================
//                     PART DIMENSIONS
// ==========================================================

// Warning: It may not be safe to modify all variables in this section, as they
// may not be tested for all desirable ranges and produce non-working results.
// Use at your own risk.

UsbCover_height = 9.7;
UsbCover_foot_height = 1.5;
UsbCover_width = 15.5;
UsbCover_depth = 6.5;
UsbCover_foot_length = 2.5;
UsbCover_r1 = 1.8; // the rounded corners with smaller radius
UsbCover_r2 = 2; // the rounded corners with bigger radius
UsbCover_magnet_size = 3.0; // decrease if magnets are too loose
UsbCover_magnet_clearance = 0.25; // increase if your printer needs more clearance for press fit
UsbCover_magnet_depth = 3.2;
UsbCover_magnet_spacing = 6.5; // center to center
UsbCover_indent_depth = 1.5;
UsbCover_indent_height = 4;
UsbCover_indent_width = 12;
UsbCover_wing_offset = 2.2;
UsbCover_wing_width = 2.6;
UsbCover_wing_length = 2.0;

MainCase_small_corner_radius = 5;
MainCase_switch_offset_x = 25;
MainCase_sensor_hole_diameter = 22.3; // 0.3 clearance
MainCase_sensor_hole_ledge = 1.0;

MainCase_pcb_offset = [1, UsbCover_depth + 0.5];
MainCase_pcb_holes = [[3.29+1.5, 23.75], [8.89+1.5, 49.3], [60.8+1.5, 41.63], [3.85+1.5, 61.65]];
// MainCase_pcb_dimensions = [64.64, 68.17, 2];

// found through experimentation
MainCase_usb_port_x_offset = 19.7+wall_thickness;
MainCase_usb_port_vertical_offset = 3.13; // center below the board bottom
MainCase_usb_port_housing_height = 14;
MainCase_usb_port_housing_width = 32;
MainCase_usb_port_housing_depth = MainCase_pcb_offset.y;
MainCase_usb_port_cover_clearance = default_clearance;

OBS_height = 72;
OBS_width = 113;
OBS_width_small = 88;
OBS_depth = 48;

MainCase_gps_antenna_y_offset = 32;
MainCase_gps_antenna_housing_hole_width = 26;
MainCase_gps_antenna_housing_hole_height = MainCase_gps_antenna_housing_hole_width;

MainCase_gps_antenna_lid_thickness = 2;
MainCase_gps_antenna_lid_offset = 3;
MainCase_gps_antenna_lid_tab_width = 10;
MainCase_gps_antenna_lid_tab_depth = 2;
MainCase_gps_antenna_lid_tab_height = 1;

MainCase_gps_antenna_height = 9;
MainCase_gps_antenna_housing_depth = MainCase_gps_antenna_height+MainCase_gps_antenna_lid_thickness;
MainCase_gps_antenna_housing_top_width = MainCase_gps_antenna_housing_hole_width-1;
MainCase_gps_antenna_housing_top_height = MainCase_gps_antenna_housing_hole_height+12;
MainCase_gps_antenna_housing_top_radius = 2;
MainCase_gps_antenna_housing_bottom_offset = 2;
MainCase_gps_antenna_housing_bottom_width = MainCase_gps_antenna_housing_top_width + 2 * MainCase_gps_antenna_height;
MainCase_gps_antenna_housing_bottom_height = MainCase_gps_antenna_housing_top_height + 2 * MainCase_gps_antenna_height - MainCase_gps_antenna_housing_bottom_offset;
MainCase_gps_antenna_housing_bottom_radius = MainCase_gps_antenna_housing_top_radius + MainCase_gps_antenna_housing_depth;
MainCase_gps_antenna_housing_screw_offset = 3;
MainCase_gps_antenna_housing_cable_hole_diameter = 6;

MainCase_micro_usb_offset = 30 + MainCase_pcb_offset.y + wall_thickness;
MainCase_micro_usb_width = 16;
MainCase_micro_usb_height = 14;
MainCase_micro_usb_chamfer = 4;

frontside_angle = atan((OBS_width - OBS_width_small) / OBS_height);

MainCaseLid_rim_clearance = 0.3;
MainCaseLid_rim_thickness = 3.0;
MainCaseLid_rim_width = 1;
MainCaseLid_rim_radius = 12;
MainCaseLid_thickness = 2.1;

MainCaseLid_hole4_offset_x = 35;
MainCaseLid_hole_offset = 3.5; // distance from inner wall
MainCaseLid_hole_positions = [
  [MainCaseLid_hole_offset+wall_thickness, MainCaseLid_hole_offset+wall_thickness],
  [OBS_height-MainCaseLid_hole_offset-wall_thickness, MainCaseLid_hole_offset+wall_thickness],
  [MainCaseLid_hole_offset+wall_thickness, OBS_width_small-MainCaseLid_hole_offset-wall_thickness-5],
  [OBS_height-MainCaseLid_hole_offset-wall_thickness, OBS_width_small-MainCaseLid_hole_offset-wall_thickness-5],
  [OBS_height-MainCaseLid_hole4_offset_x+4.5*cos(frontside_angle), OBS_width-tan(frontside_angle)*MainCaseLid_hole4_offset_x-3.5],
];

MainCaseLid_battery_holder_lift = 1.5;
MainCaseLid_battery_holder_inner_radius = 8;
MainCaseLid_battery_holder_inner_width = 18.3;
MainCaseLid_battery_holder_height = 11.5;
MainCaseLid_battery_holder_length = 37.6;

MainCaseLid_battery_holder_channel_depth = 2;
MainCaseLid_battery_holder_channel_radius = 5;
MainCaseLid_battery_holder_channel_extra_length = 5;
MainCaseLid_battery_holder_channel_width = 5;
MainCaseLid_battery_holder_channel_spacing = 17.6 + 5;

MountRail_base_width = 48;
MountRail_base_height = 2.5;
MountRail_chamfer_height = 3;
MountRail_plate_width = MountRail_base_width - 2 * MountRail_chamfer_height;
MountRail_plate_distance = 2;
MountRail_total_height = MountRail_base_height + MountRail_chamfer_height + MountRail_plate_distance;
MountRail_clearance = 0.2;
MountRail_width = 29.0;
MountRail_pin_length = 15;

SeatPostMount_width = 22; // [18:25]
SeatPostMount_angle = 20; // [0:35]
SeatPostMount_diameter = 28; // [18:36]
SeatPostMount_stop_plate_thickness = 2; // [1:0.1:3]
SeatPostMount_stop_plate_width = MountRail_base_width  + 4;
SeatPostMount_length = 20; // [15:100]
SeatPostMount_channel_depth = 4; // [1:20]

// TODO: decide on a namespace, at least `*_holes_dx/dy` are global
MountAttachment_depth = 4;
MountAttachment_height = 47;
MountAttachment_width = 27;
MountAttachment_holes_x_offset = -0.5;
MountAttachment_holes_dx = 15;
MountAttachment_holes_dy = 33;

DisplayCase_outer_radius = 5;
DisplayCase_outer_width = 30;
DisplayCase_outer_large_radius = 12;
DisplayCase_magnet_length = 20;
DisplayCase_magnet_thickness = 2;
DisplayCase_magnet_housing_width = 2*DisplayCase_magnet_thickness+default_clearance+2*extrude_width;

DisplayCaseTop_height = 8;
DisplayCaseTop_magnet_depth = 6.5;
DisplayCaseTop_window_depth = 3;
DisplayCaseTop_window_width = 21.5;
DisplayCaseTop_window_height = 12.5;
DisplayCaseTop_window_offset = 2; // to bottom
DisplayCaseTop_window_radius = 1.5;
DisplayCaseTop_pcb_width = 26.5;
DisplayCaseTop_pcb_height = 27.2;
DisplayCaseTop_pcb_standoff = 1.7;
DisplayCaseTop_hole_diameter = 3.3;
DisplayCaseTop_cable_clearance = 12.5;
DisplayCaseTop_button_diameter = 12;
DisplayCaseTop_button_outside_diameter = 18;
DisplayCaseTop_button_outside_depth = 4;
DisplayCaseTop_pcb_origin = [-DisplayCase_outer_width/2, -DisplayCase_outer_radius-DisplayCaseTop_hole_diameter/2-DisplayCaseTop_pcb_height/2, DisplayCaseTop_height];

DisplayCaseBottom_height = 11;
DisplayCaseBottom_magnet_depth = 10.4 - DisplayCaseTop_magnet_depth;
DisplayCaseBottom_standoff_size = 2.8;
DisplayCaseBottom_standoff_height = 2;
DisplayCaseBottom_standoff_bridge_height = 0.5;
DisplayCaseBottom_pcb_origin = [-DisplayCaseTop_pcb_origin.x, DisplayCaseTop_pcb_origin.y, DisplayCaseBottom_height];

// TODO: merge with HandlebarRail_* ?
DisplayRail_width = 16.50;
DisplayRail_chamfer_size = 2;
DisplayRail_top_height = 2;
DisplayRail_bottom_height = 1;
DisplayRail_total_height = DisplayRail_chamfer_size + DisplayRail_top_height + DisplayRail_bottom_height;

HandlebarRail_rail_height = 7;
HandlebarRail_rail_length = DisplayCase_outer_width+DisplayCase_magnet_housing_width;
HandlebarRail_rail_total_height = HandlebarRail_rail_height + 1.25 + 1.95 + 1.3;
HandlebarRail_stopblock_width = 25;
HandlebarRail_stopblock_radius = 1;
HandlebarRail_stopblock_depth = 6.6;
HandlebarRail_stopblock_height = 26.2;
HandlebarRail_stopblock_magnet_wall_thickness = 0.8;
HandlebarRail_stopblock_magnet_lift = 3.2;

HandlebarRail_tube_radius = 18;
HandlebarRail_tube_indent = 1;

StandardMountAdapter_width = 29;
StandardMountAdapter_length = 62;
StandardMountAdapter_thickness = 7;
StandardMountAdapter_side_width = (StandardMountAdapter_length - MountRail_base_width)/2;

BikeRackMount_rail_diameter = 14; // add a bit for padding, e.g. 2*1mm for a cut piece rubber tube
BikeRackMount_rod_diameter = 10.2; // add a bit of clearance, e.g. 0.2mm
BikeRackMount_rod_distance = 24;
BikeRackMount_bottom_spacing = 3;

BikeRackMountSide_channel_width = 6;
BikeRackMountSide_length = BikeRackMount_rod_distance + BikeRackMount_rod_diameter + 2 * BikeRackMount_bottom_spacing;
BikeRackMountSide_height = 28 + BikeRackMount_bottom_spacing;

TopTubeMount_diameter = 72;
TopTubeMount_height = 20;

LockingPin_diameter = 5.2;
LockingPin_small_hole_diameter = 2.0;
LockingPin_height = 15;
LockingPin_handle_length = 15.2;
LockingPin_handle_height = 3.5;
LockingPin_foot_height = 2.0;
LockingPin_fillet_radius = 2.0;

// ==========================================================
//                   LOGO GENERATOR OPTIONS
// ==========================================================

// You may change these values if you need to, but 2 layers tends to be a good
// balance of filament switching hassle and opacity.
logo_layers = 2;
logo_depth = logo_layers * layer_height;
logo_convexity = 10; // Increase if you get artifacts in the logo

// Please do not modify these, they are overwritten by the Makefile when you
// generate parts with logos.
logo_enabled = false; // set to true to generate logos into parts that support it
logo_use_prebuild = false; // used by makefile to speed up logo file export
logo_generate_templates = false; // set to true to generate 2D template SVGs
logo_name = "OpenBikeSensor"; // name of a folder inside `logo/`
logo_mode = "normal"; // "normal" or "inverted"
logo_part = "main"; // "main" or "highlight"
