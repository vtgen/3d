dimension = 100;


module image() {

   text(
        "Lani", size = dimension, 
        valign = "center", 
        halign = "center"
   );
}

module lamp() {
stereographic_extrude(shadow_side_leng = dimension*2, convexity = 5, $fn=100)
    image();
}


module shadow() {
    image();
}




use <dotScad/experimental/foliage_scroll.scad>
use <dotScad/polyline_join.scad>
use <dotScad/stereographic_extrude.scad>
use <dotScad/util/count.scad>

$fn = 48;

model = "BOTH"; // [BOTH, SPHERE, SHADOW]
width = 400;
height = 400;
shadow_thickness = 1;
max_spirals = 244; 
angle_step = 360 / $fn; 
min_radius = 5; 
init_radius = 5;

stereographic_foliage_scroll();

module stereographic_foliage_scroll() {
    module draw(spirals) {    
        for(i = [0:1]) {
            r = spirals[i][0];
            path = spirals[i][1];
            polyline_join(path)
                circle(r / 16);
        }

        for(i = [2:len(spirals) - 1]) {
            r = spirals[i][0];
            path = spirals[i][1];
            polyline_join([for(i = [1:len(path) - 1]) path[i]])
                circle(r / 16);
        }

image();
    }

    spirals = foliage_scroll([width, height], max_spirals, init_radius, min_radius);

    if(model != "SHADOW") {
        color("green")
        stereographic_extrude(shadow_side_leng = width, convexity = 10, $fn = $fn * 2)
            draw(spirals);
    }

    if(model != "SPHERE") {
        color("red")
        linear_extrude(shadow_thickness)
            draw(spirals);
    }
}