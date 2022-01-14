// GLOBAL SETTINGS
// ------------------------

extrude_width = 0.46; // to ensure minimum wall thickness is given (0.46mm is the PrusaSlicer default for a 0.4mm nozzle)
enable_easy_print = true; // simplifies printing by adding smart bridges to remove need for supports
layer_height = 0.2; // used e.g. by easy print algorithms
default_clearance = 0.2; // distance between two things that should fit into each other
fast = $preview; // in fast mode, not all features are rendered

// Quality parameters

$fs = 0.2;
$fa = 1;
$fn = fast ? 32 : 128;
$pfn = fast ? 20 : $fn; // for polyRound

// Variations on MainCase
// ------------------------

// A "back rider" is a case that has the attachment on front, riding e. g.
// behind the seat post
MainCase_back_rider = true;

// A "top rider" is a case that has an attachment on its bottom, sitting on top
// of a compatible mount, such as on the top tube or luggage rack. A single
// MainCase can be both back rider and top rider.
MainCase_top_rider = false;

// Decide which attachment (of those that exist) has a hole for a cable. Both
// or none are possible. Each hole should be covered with an adapter or cover
// to seal the enclosure.
MainCase_back_rider_cable = true;
MainCase_top_rider_cable = !(MainCase_back_rider && MainCase_back_rider_cable);

// Dimensions for parts
// ------------------------

HeatsetInsert_diameter = 4;
HeatsetInsert_height = 5.75;
HeatsetInsert_full_depth = 4.5; // how far the normal hole reaches before it expands to the cavity
HeatsetInsert_extra_radius = 0.5;

// Holes for M3 screws, including clearance
ScrewHole_diameter_M3 = 3.2;

SensorHole_diameter = 22.3; // 0.3 clearance
SensorHole_ledge = 1.0;

wall_thickness = 2;

UsbCover_height = 9.7;
UsbCover_foot_height = 1.5;
UsbCover_width = 15.5;
UsbCover_depth = 6.5;
UsbCover_foot_length = 2.5;
UsbCover_radius = 1.5;

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

UsbPort_clearance = 0.2;
// found through experimentation
UsbPort_offset = 20.2;
UsbPort_vertical_offset = 3.13; // center below the board bottom

PCB_dimensions = [64.64, 68.17, 2];
PCB_offset = [1, UsbCover_depth + 0.5];
PCB_holes = [
  // x, y, d
  [3.29, 23.75, 3.2],
  [8.89, 49.3, 3.2],
  [60.8, 41.63, 3.2],
];

OBS_height = 72;
OBS_width = 109;
OBS_width_small = 88;
OBS_depth = 48;


GPS_antenna_offset = 32;

GpsAntennaHousing_hole_width = 26;
GpsAntennaHousing_hole_height = 26;

GpsAntennaHousing_depth = 10;

GpsAntennaHousing_top_width = 25;
GpsAntennaHousing_top_height = 38;
GpsAntennaHousing_top_radius = 2;

GpsAntennaHousing_bottom_offset = 2;
GpsAntennaHousing_bottom_width = GpsAntennaHousing_top_width + 2 * GpsAntennaHousing_depth;
GpsAntennaHousing_bottom_height = GpsAntennaHousing_top_height + 2 * GpsAntennaHousing_depth - GpsAntennaHousing_bottom_offset;
GpsAntennaHousing_bottom_radius = GpsAntennaHousing_top_radius + GpsAntennaHousing_depth;
GpsAntennaHousing_screw_offset = 3;

GpsAntennaHousing_cable_hole_diameter = 6;

GpsAntennaLid_thickness = 1.5;
GpsAntennaLid_offset = 3;
GpsAntennaLid_tab_width = 10;
GpsAntennaLid_tab_depth = 2;
GpsAntennaLid_tab_height = 1;

MainCase_micro_usb_offset = 30 + PCB_offset.y + wall_thickness;
MainCase_micro_usb_width = 16;
MainCase_micro_usb_height = 14;

TopHole4_offset_top = 35;
TopHole_distance = 3.5;

Switch_offset_bottom = 22;

// TODO: this is only almost correct
frontside_angle = asin((OBS_width - OBS_width_small) / OBS_height);

MainCaseLid_rim_clearance = 0.3;
MainCaseLid_rim_thickness = 3.0;
MainCaseLid_rim_width = 1;
MainCaseLid_rim_radius = 12;
MainCaseLid_thickness = 2.1;

MainCaseLid_hole_positions = [
  [TopHole_distance+wall_thickness, TopHole_distance+wall_thickness],
  [OBS_height-TopHole_distance-wall_thickness, TopHole_distance+wall_thickness],
  [TopHole_distance+wall_thickness, OBS_width_small-TopHole_distance-wall_thickness-8],
  [OBS_height-TopHole_distance-wall_thickness, OBS_width_small-TopHole_distance-wall_thickness-8],
  [OBS_height-TopHole4_offset_top+4.5, OBS_width-sin(frontside_angle)*TopHole4_offset_top-3],
];

MountRail_base_width = 48;
MountRail_base_height = 2.5;
MountRail_chamfer_height = 3;
MountRail_plate_width = MountRail_base_width - 2 * MountRail_chamfer_height;
MountRail_plate_distance = 2;
MountRail_total_height = MountRail_base_height + MountRail_chamfer_height + MountRail_plate_distance;
MountRail_clearance = 0.2;

MountRail_width = 29.0;

MountRail_pin_radius = 1.6;
MountRail_pin_length = 15;

BatteryHolder_lift = 1.5;
BatteryHolder_inner_radius = 8;
BatteryHolder_inner_width = 18.3;
BatteryHolder_height = 11.5;
BatteryHolder_length = 37.6;

BatteryHolderChannel_depth = 2;
BatteryHolderChannel_radius = 5;
BatteryHolderChannel_extra_length = 5;
BatteryHolderChannel_width = 5;
BatteryHolderChannel_spacing = 17.6 + 5;


// Width of the small (top) section, including the stop plate
SeatPostMount_width = 22; // [18:25]

// Angle of the seat post
SeatPostMount_angle = 20; // [0:35]

// Diameter of your seat post
SeatPostMount_diameter = 28; // [18:36]

// Thickness of the stop plate that stops the sliding
SeatPostMount_stop_plate_thickness = 2; // [1:0.1:3]

// Width of the stop plate, a bit wider than the rail
SeatPostMount_stop_plate_width = MountRail_base_width  + 4;

// Distance from the bottom to the edge that touches the seat post.
SeatPostMount_length = 20; // [15:100]

// Depth of the round channel
SeatPostMount_channel_depth = 4; // [1:20]

SeatPostMount_total_width = SeatPostMount_stop_plate_thickness + MountRail_width;

UsbCharger_height = 14;
UsbCharger_width = 32;
UsbCharger_depth = PCB_offset.y;


MountAttachment_depth = 4;
MountAttachment_height = 47;
MountAttachment_width = 27;

MountAttachment_holes_x_offset = -0.5;
MountAttachment_holes_dx = 15;
MountAttachment_holes_dy = 33;

HexNutHole_diameter = 6.5;
HexNutHole_depth = 4;

HandlebarRailRail_height = 7;
HandlebarRailRail_length = 32.4;

HandlebarRailRail_total_height = HandlebarRailRail_height + 1.25 + 1.95 + 1.3;

HandlebarRailStopblock_width = 24;
HandlebarRailStopblock_radius = 1;
HandlebarRailStopblock_depth = 6.6;
HandlebarRailStopblock_height = 26.2;

HandlebarRailStopblock_magnet_wall_thickness = 0.8;
HandlebarRailStopblock_magnet_lift = 3.2;
HandlebarRailStopblock_magnet_height = 10;
HandlebarRailStopblock_magnet_width = 22;
HandlebarRailStopblock_magnet_thickness = 1.9;

HandlebarRail_tube_radius = 18;
HandlebarRail_tube_indent = 1;

DisplayCaseTop_height = 8;
DisplayCase_magnet_length = 20;
DisplayCase_magnet_thickness = 1.9;
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

DisplayCaseBottom_height = 11;
DisplayCaseBottom_magnet_depth = 10.4 - DisplayCaseTop_magnet_depth;
DisplayCaseBottom_standoff_size = 2.8;
DisplayCaseBottom_standoff_height = 2;
DisplayCaseBottom_standoff_bridge_height = 0.5;

DisplayCase_magnet_housing_width = 4.6;
DisplayCase_outer_radius = 5;
DisplayCase_outer_width = 30;
DisplayCase_outer_large_radius = 12;

DisplayCaseTop_pcb_origin = [-DisplayCase_outer_width/2, -DisplayCase_outer_radius-DisplayCaseTop_hole_diameter/2-DisplayCaseTop_pcb_height/2, DisplayCaseTop_height];

DisplayCaseBottom_pcb_origin = [-DisplayCaseTop_pcb_origin.x, DisplayCaseTop_pcb_origin.y, DisplayCaseBottom_height];

DisplayRail_width = 16.50;
DisplayRail_chamfer_size = 2;
DisplayRail_top_height = 2;
DisplayRail_bottom_height = 1;

DisplayRail_total_height = DisplayRail_chamfer_size + DisplayRail_top_height + DisplayRail_bottom_height;

StandardMountAdapter_width = 29;
StandardMountAdapter_length = 62;
StandardMountAdapter_thickness = 7;

StandardMountAdapter_side_width = (StandardMountAdapter_length - MountRail_base_width)/2;

BikeRackMount_rail_diameter = 14; // add a bit for padding, e.g. 2*1mm for a cut piece rubber tube
BikeRackMount_rod_diameter = 10.5; // add a bit of clearance, e.g. 0.5mm
BikeRackMount_rod_distance = 24;

BikeRackMountSide_channel_width = 6;

BikeRackMount_bottom_spacing = 3;

BikeRackMountSide_length = BikeRackMount_rod_distance + BikeRackMount_rod_diameter + 2 * BikeRackMount_bottom_spacing;
BikeRackMountSide_height = 28 + BikeRackMount_bottom_spacing;

TopTubeMount_diameter = 72;
TopTubeMount_height = 20;
