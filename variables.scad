$fs = 0.2;
$fa = 1;
$fn = $preview ? 32 : undef;
$pfn = $preview ? 20 : 64; // for polyRound

HeatsetInsert_diameter = 4;
HeatsetInsert_height = 8.9;

// Holes for M3 screws, including clearance
ScrewHole_diameter_M3 = 3.5;

SensorHole_diameter = 22.3; // 0.3 clearance
SensorHole_ledge = 1.0;


wall_thickness = 2;

PCB_dimensions = [64.64, 68.17, 2];
PCB_offset = [1, 8];
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
