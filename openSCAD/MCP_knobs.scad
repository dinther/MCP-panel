/* [General] */
$fn = 90;
outer_radius = 8;
shaft_radius = 3.06; //still to print and try
knob_height = 15;
layer_height = 0.15;
nut_cutout_height = 4;
nut_radius = 7.0;

ribble_radius = 0.5;
font = "Liberation Sans:style=Bold";
body_color = "silver"; //"whitesmoke";
inlay_color = "white"; //"dimgray";

module cap_carve(radius, x = 1.5, y = 1.5){
    difference(){
        translate([0,0,-1])color(body_color)cylinder(r=radius + 2, h=y+1);
         color(body_color)cylinder(r1=radius - x, r2=radius, h=y+0.01);
    }
}

module base_knob(radius, shaft, height, texture){
    difference(){
        union(){
            difference(){
                color(body_color) cylinder(r=radius, h=height);  //  body
                translate([0,0,3.0]) cylinder(r=shaft, h=height);    //  cut shaft
                translate([0,0,height - nut_cutout_height]) cylinder(r=nut_radius, h=nut_cutout_height+1);           //  cut space for nut
                
                if (texture == "carved"){
                    for (i =[0:30:360]) rotate([0,0,i]) translate([radius+0.25,0,0]) color(body_color) cylinder(r=ribble_radius*3, h=height, $fn=32);
                }
            }
            if (texture == "ribble"){
                for (i =[0:10:360]) rotate([0,0,i]) translate([radius+0.2,0,0]) color(body_color)cylinder(r=ribble_radius, h=height-1, $fn=3);
            }
        }
        translate([0,0,0]) cap_carve(radius+2, 2.5, 3);
    }
}

module selector_knob(radius, shaft, height){
    difference(){
        base_knob(radius = radius, shaft = 0, height = height, texture = "ribble");
        translate([0,0,height - nut_cutout_height]) cylinder(r=nut_radius, h=nut_cutout_height+1);
        translate([0,0,-0.1]) selector_decal(outer_radius, 0.1 + layer_height * 2);
        translate([0,0,3.0]) {
            rotate([0,0,165]) intersection(){
                cylinder(r=shaft, h=height);    //  re-cut shaft
                translate([-shaft,-shaft,0]) cube([5.5, shaft *2, height+1]);
            }
        }
    }
}

module selector_decal(radius, height){
    difference(){
        color(inlay_color) translate([-1.3*0.5,outer_radius * 0.2, 0]) cube([1.3,outer_radius * 0.7, height]);
    }
}

module heading_knob(radius, shaft, height){
    difference(){
        base_knob(radius = radius, shaft = shaft, height = height, texture = "ribble");
        translate([0,0,-0.1]) heading_decal(outer_radius, 0.1 + layer_height * 2);
    }
}

module heading_decal(radius, height){
    difference(){
        color(inlay_color) cylinder(r=radius-2, h=height, $fn=3);
        translate([0,0,-1]) color(inlay_color) cylinder(r=radius-4, h=height+2, $fn=3);
    }
}

module course_knob(radius, shaft, height){   
difference(){
        base_knob(radius = radius, shaft = shaft, height = height, texture = "ribble");
        translate([0,0,-0.1]) course_decal(outer_radius, 0.1 + layer_height * 2);
    }
}

module course_decal(radius, height){
    w = 1.3;
    color(inlay_color) union(){
        translate([-outer_radius* 0.5,outer_radius * 0.2, 0]) cube([outer_radius, w, height]);
        translate([-w*0.5,- outer_radius * 0.6, 0]) cube([w,outer_radius * 1.2, height]);
    }
}

module altitude_knob(radius, shaft, height){
    difference(){
        base_knob(radius = radius, shaft = shaft, height = height, texture = "ribble");
        translate([0,0,-0.1]) altitude_decal(outer_radius, 0.1 + layer_height * 2);
    }
}

module altitude_decal(radius, height){
    color(inlay_color) mirror([1,0,0]) linear_extrude(height) text(text="SEL", font = font, size=4.5, valign="center", halign="center");
}

module IAS_knob(radius, shaft, height){
    base_knob(radius = radius + 1, shaft = shaft, height = height, texture = "carved");
}


module VS_knob(radius, shaft, height, standoff=0){
    union(){
        difference(){
            union(){
                cylinder(r=radius, h=height);
                //  standoff
                cylinder(r=shaft +1, h=height + standoff); 
                for (i =[0:4:360]) rotate([0,0,i]) translate([radius+0.2,0,0]) cylinder(r=ribble_radius, h=height, $fn=3);   
            }
            for (i =[0:45:360]) rotate([0,0,i]) translate([radius+0.75,0,-0.5]) cylinder(r=ribble_radius*4, h=height+1, $fn=16);
            translate([0,0,0]) cap_carve(radius, 1, 1);
            translate([0,0,height]) rotate([180,0,0]) cap_carve(radius, 1, 1);
            translate([0,0,-1]) cylinder(r=shaft, h=height+2);
        }
        
    }
}

module knobs(){
    row = 50;
    col = 40;
    translate([col * 0, row * 0, 0]) course_knob(radius = outer_radius, shaft = shaft_radius, height = knob_height);
    translate([col * 1, row * 0, 0]) IAS_knob(radius = outer_radius, shaft = shaft_radius, height = knob_height);
    translate([col * 2, row * 0, 0]) heading_knob(radius = outer_radius, shaft = shaft_radius, height = knob_height);
    translate([col * 0, row * 1, 0]) altitude_knob(radius = outer_radius, shaft = shaft_radius, height = knob_height);
    translate([col * 1, row * 1, 0]) selector_knob(radius = outer_radius, shaft = shaft_radius + 0.4, height = knob_height);

    translate([col * 2, row * 1, 0]) VS_knob(radius = 19, shaft = shaft_radius, height = 6, standoff=1);
}

module inlays(){
    row = 50;
    col = 40;
    translate([col * 0, row * 0, 0]) course_decal(outer_radius, layer_height * 2);
    translate([col * 2, row * 0, 0]) heading_decal(outer_radius, layer_height * 2);
    translate([col * 0, row * 1, 0]) altitude_decal(outer_radius, layer_height * 2);
    translate([col * 1, row * 1, 0]) selector_decal(outer_radius, layer_height * 2);
}

knobs();
inlays();


