include <BOSL2/std.scad>
include <BOSL2/gears.scad>
use <dotScad/hexagons.scad>;
// Parameters for the main disc
disc_diameter = 50;  // Diameter of the main disc
disc_thickness = 5;   // Thickness of the main disc

// Parameters for the magnets (impressions)
magnet_diameter = 6.2;  // Diameter of the magnet holes
magnet_depth = 2.2;     // Depth of the magnet holes
num_magnets = 12;     // Number of magnets around the disc
distance_from_edge = 2;  // Distance from the edge of the disc to the center of the magnets
hex_radius=3.8;
spacing=2;


//derived
hexagons_radius = disc_diameter/2 - (magnet_diameter + distance_from_edge);
levels = hexagons_radius / hex_radius;

//constant
pierce_depth=2;

// heigh adjustment
ha = pierce_depth/2;
pd = pierce_depth;
// Calculate the radius where magnets will be placed
magnet_radius = (disc_diameter / 2) - distance_from_edge/2 - (magnet_diameter / 2);


module main_disc() {
    cylinder(h=disc_thickness, r1=disc_diameter/2, r2=disc_diameter/2, $fn=100);
}

module hex_mask() {
        cylinder(h=disc_thickness, r1=hexagons_radius, r2=hexagons_radius, $fn=100);
}

module magnets() {
    for (i = [0 : 360/num_magnets : 360 - (360/num_magnets)]) {
        translate([cos(i) * magnet_radius, sin(i) * magnet_radius, disc_thickness - magnet_depth + ha])
        cylinder(h=magnet_depth+pd, r1=magnet_diameter/2, r2=magnet_diameter/2, center=true, $fn=50);
    }
}


module hexableFace() {
difference() {
  
    hex_mask();

}
}

module innerHex(){
difference() {
      
    hexableFace();
    translate([0,0,-disc_thickness*2])
    linear_extrude(disc_diameter+pd)
            hexagons(hex_radius,spacing,levels);
}
}

module outerRing(){
    difference() {
        main_disc();
        hex_mask();
    }
}

union(){
    spur_gear(
        circ_pitch=6, teeth=6, thickness=disc_thickness*2,
        $fa=1, $fs=1
    );

    union() {
        innerHex();
        difference() {
            outerRing();
            magnets();
    }
        

}}



