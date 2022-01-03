$fs = 0.2;
$fa = 1;
$fn = $preview ? 32 : 16;
$pfn = $preview ? 20 : 20; // for polyRound

HeatsetInsert_diameter = 4;
HeatsetInsert_height = 5.35;

// Holes for M3 screws, including clearance
ScrewHole_diameter_M3 = 3.2;

SensorHole_diameter = 22.3; // 0.3 clearance
SensorHole_ledge = 1.0;

wall_thickness = 2;

UsbCover_height = 10;
UsbCover_foot_height = 1.5;
UsbCover_width = 15.5;
UsbCover_depth = 6.5;
UsbCover_foot_length = 2.5;
UsbCover_radius = 1.5;
UsbCover_magnet_size = 3.0; // increase if your printer needs more clearance for press fit
UsbCover_magnet_depth = 3.3;
UsbCover_magnet_spacing = 6.5; // center to center

UsbCover_indent_depth = 1.5;
UsbCover_indent_radius = 0.85;
UsbCover_indent_height = 4;
UsbCover_indent_width = 12;

UsbCover_wing_offset = 1.88;
UsbCover_wing_width = 2.75;
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

GpsAntennaLid_thickness = 1.5;
GpsAntennaLid_offset = 3;
GpsAntennaLid_tab_width = 10;
GpsAntennaLid_tab_depth = 2;
GpsAntennaLid_tab_height = 1;

USB_offset = 30 + PCB_offset[1];

TopHole4_offset_top = 35;
TopHole_distance = 3.5;

Switch_offset_bottom = 22;

// TODO: this is only almost correct
frontside_angle = asin((OBS_width - OBS_width_small) / OBS_height);

Lid_clearance = 0.1;
Lid_rim_thickness = 4.0;
Lid_rim_width = 1;
Lid_thickness = 2.1;

Lid_hole_positions = [
  [TopHole_distance+wall_thickness, TopHole_distance+wall_thickness],
  [OBS_height-TopHole_distance-wall_thickness, TopHole_distance+wall_thickness],
  [TopHole_distance+wall_thickness, OBS_width_small-TopHole_distance-wall_thickness-8],
  [OBS_height-TopHole_distance-wall_thickness, OBS_width_small-TopHole_distance-wall_thickness-8],
  [OBS_height-TopHole4_offset_top+4.5, OBS_width-sin(frontside_angle)*TopHole4_offset_top-3],
];

MountRail_base_width = 47.6;
MountRail_base_height = 2.3;
MountRail_plate_width = 41.6;
MountRail_plate_height = 2.2;
MountRail_chamfer_height = (MountRail_base_width - MountRail_plate_width) / 2; // to get 45 degree chamfer
MountRail_total_height = MountRail_base_height + MountRail_chamfer_height + MountRail_plate_height;

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
SeatPostMount_angled_spacing = 24; // [15:100]

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
