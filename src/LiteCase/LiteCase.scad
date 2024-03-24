// 0,0,0: Mitte des Lite-PCB, auf der Seite mit dem OpenBIkeSensor logo, x: Richtung USB-Port, Z: Richtung Ultraschallsensoren
$fn = 100;

Lite_PCB_x = 44;
Lite_PCB_y = 29.2;
Lite_PCB_z = 1.7;
Lite_PCB_Dimensions = [Lite_PCB_x, Lite_PCB_y, Lite_PCB_z];

Lite_ESP_socket_x = 38;
Lite_ESP_socket_y = 2.54;
Lite_ESP_socket_z = 9;
Lite_ESP_socket_dimensions = [Lite_ESP_socket_x, Lite_ESP_socket_y, Lite_ESP_socket_z];

Lite_transducer_position = [23.8, 0, 20.1];
Lite_transducer_variance = 0.8;
Lite_transducer_diameter = 16 + Lite_transducer_variance;
Lite_transducer_diameter_small = 12.5 + Lite_transducer_variance;



Lite_ESP_position_x = 0;
Lite_ESP_position_y = 0;
Lite_ESP_position_z = - 15.2;

Lite_USB_position_x = 0;
Lite_USB_position_y = 0;
Lite_USB_position_z = 0;

Lite_ESP_position = [Lite_ESP_position_x, Lite_ESP_position_y, Lite_ESP_position_z];
module ESP() color("black")translate([25, 0, 0])cube([51.5, 28.5, 4.5], center = true);
module Ultrasonic(i) {
  color("blue") translate([23.9, i * 7.3, 17.99])cube([41.5, 1.4, 36], center = true);
  #translate([23.9, 0, 16.99])cube([41.5, 19.5, 35], center = true);

  translate(Lite_transducer_position - [0, 8 * i, 100])rotate([i * 90, 0, 0])cylinder(d2 = Lite_transducer_diameter, h = 8.5);


  #translate(Lite_transducer_position - [0, 8 * i, 0])rotate([i * 90, 0, 0])cylinder(d = Lite_transducer_diameter_small, h = 40);
}


module LiteElectronics(onlyboards = false) {
  // the rendered model from stls (not closed, only for preview)
  translate([15, 0, 0])rotate([180, 00, 00])rotate([0, 0, 90])import("../../lib/OpenBikeSensor-Lite-PCB-0.1.2.stl");

  // board cube
  color("green")translate(- [0, Lite_PCB_y / 2, Lite_PCB_z])cube(Lite_PCB_Dimensions, center = false);

  // sockets for ESP
  for (i = [- 1, 1]) color("darkgrey")translate([3.5, i * Lite_PCB_y / 2 - (i + 1) * Lite_ESP_socket_y / 2 - i * 0.45, - Lite_ESP_socket_dimensions[2] - Lite_PCB_Dimensions[2]])
    cube(Lite_ESP_socket_dimensions);

  #translate(Lite_ESP_position)ESP();

  for (i = [- 1, 1])Ultrasonic(i);
}
LiteElectronics();
difference() {
  //translate([12.5, - 18, 9])cube([23, 36, 28]);
  for (i = [- 1, 1])Ultrasonic(i);
}