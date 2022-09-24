use <SPST_PCB_Mount_Tactile_Switch_with_LED.scad>


/* [General] */
$fn=45;
cr = 0.01; //  avoid z fighting
//  Layer height you intend to print this at. Setting this correctly helps with a more accurate print.
MCP_layer_height = 0.3;
MCP_inlay_height_in_layers = 4;
MCP_font = "Bahnschrift:style=normal";
// Caption for the button when MCP_show_just_one is set to true.
MCP_caption = "FLY";
//  Change and add as many captions as you wish. 3, sometimes 4 characters is the maximum unless you increase the button size of course.
MCP_captions = ["N1", "LVL", "VOR", "ALT", "SPD", "HOLD", "VS", "YD", "FLC", "NAV", "HDG", "VNAV", "LNAV", "APP", "AP", "WAR", "", "", " ", " " ];

//  Depth from button base to activation surface when pressed down.
MCP_button_face_depth = 2.5;
MCP_base_height = MCP_layer_height * 2;
// Outer width of the button
MCP_button_width = 20;
// Outer height of the button
MCP_button_height = 16;
// Radius of the outer button corner
MCP_button_corner_radius = 2;
// An offset can be given in order to get the LED to shine vertically off-center.
MCP_hole_offset = 1.8;
// An offset can be given to get the text vertically off-center
MCP_text_offset = 2.5;
// Add a railing to the sides of the button

MCP_railing_width = 1.4;
MCP_show_light = true;


// Gap between button active surface and the caption plate hovering above
MCP_activation_gap = 0.0;
MCP_text_size = 4.35;
//  Wall thickness for the button caps
MCP_wall_thickness = 0.75;
//  The gab between the moving button face flap and the cap sidewalls.
MCP_flap_gap = 0.4;
MCP_lid_height = MCP_button_face_depth - MCP_base_height + MCP_activation_gap + (MCP_layer_height * MCP_inlay_height_in_layers);

//  Organize buttons in rows up to max_rows then start a new column.
MCP_max_rows = 7;
MCP_show_base = true;
MCP_show_caps = true;
MCP_show_inlays = true;
MCP_show_switch = false;
MCP_show_one = false;
// Shows exploded view when not zero
MCP_explode = 0; // [0:0.01:2]
MCP_actual_button_width = MCP_button_width - (MCP_railing_width * 2);

module rsquare(s= [1,1], r=0.2, offset=0){
    x = s[0]*0.5;
    y = s[1]*0.5;
    offset(delta = offset)
    hull(){
        translate([-x,-y]) translate([r,r]) circle(r=r);
        translate([-x,y]) translate([r,-r]) circle(r=r);
        translate([x,y]) translate([-r,-r]) circle(r=r);
        translate([x,-y]) translate([-r,r]) circle(r=r);
    }
}

module inlay(text = "ABC", height = 1, show_light = true){
    color("white"){
        difference(){
            translate([0, 0, 0])
            linear_extrude(height)
            rsquare([MCP_actual_button_width, MCP_button_height], MCP_button_corner_radius, offset = -MCP_wall_thickness - MCP_flap_gap);
            
            translate([0, 0, height * 0.5])
            linear_extrude(height * 0.5 + 0.1)
            rsquare([MCP_actual_button_width, MCP_button_height], MCP_button_corner_radius, offset = -MCP_wall_thickness - MCP_flap_gap - 0.5);
        }
        
        translate([0, MCP_text_offset, height * 0.5])
        linear_extrude(height * 0.5)
        text(text = text, font = MCP_font, size = MCP_text_size, valign = "center", halign = "center");
        
        if (show_light) translate([-2, -MCP_hole_offset-0.3, height * 0.5]) cube([4, 0.6, height * 0.5]);    
    }
}

module buttoncap(text = "ABC", show_light = true){
    inlay_height = MCP_layer_height * MCP_inlay_height_in_layers;
    color("dimgray") linear_extrude(MCP_lid_height) difference(){
        rsquare([MCP_actual_button_width, MCP_button_height], MCP_button_corner_radius);
        rsquare([MCP_actual_button_width, MCP_button_height], MCP_button_corner_radius, offset=-MCP_wall_thickness);
    }

    //  hinge line
    translate([-6, MCP_button_height * 0.5 - 1.8, MCP_lid_height - inlay_height]) color("dimgray") cube([12, 1.8, inlay_height - MCP_layer_height]);
    
    translate([0, 0, MCP_lid_height - (inlay_height * 0.5)]) difference(){
        color("dimgray") linear_extrude(inlay_height * 0.5)
        rsquare([MCP_actual_button_width - cr, MCP_button_height - 0.1], MCP_button_corner_radius, offset = -MCP_wall_thickness - MCP_flap_gap);
        translate([0, 0, -cr - inlay_height*2]) inlay(text = text, height =inlay_height * 4, show_light = show_light);
    }
}

module rail(w, l, h){
    h = h - (w*  0.5);
    hull(){
        translate([0, 0, 0]) cylinder(d=w, h=h);
        translate([0, l, 0]) cylinder(d=w, h=h);
        translate([0, l, h]) sphere(d=w);
        translate([0, 0, h]) sphere(d=w);        
    }
}

module buttonbase(){
    rail_extend = 0.5;
    color("dimgray") difference(){
        union(){
            linear_extrude(MCP_base_height) rsquare([MCP_actual_button_width + (MCP_railing_width * 2), MCP_button_height], MCP_button_corner_radius, offset=0);
            translate([0, 0, 0]) linear_extrude(MCP_button_face_depth) rsquare([MCP_actual_button_width, MCP_button_height], MCP_button_corner_radius, offset = -MCP_wall_thickness);

            if (MCP_railing_width> 0){
                translate([-(MCP_railing_width * 0.5) - 0.1 - MCP_actual_button_width * 0.5, -MCP_button_height * 0.75 * 0.5, 0]) rail(MCP_railing_width - 0.2, MCP_button_height * 0.75, MCP_base_height + MCP_lid_height + rail_extend); 
                translate([(MCP_railing_width * 0.5) + 0.1 + MCP_actual_button_width * 0.5, -MCP_button_height * 0.75 * 0.5, 0]) rail(MCP_railing_width - 0.2, MCP_button_height * 0.75, MCP_base_height + MCP_lid_height + rail_extend);
            }
        }
        translate([0,-MCP_hole_offset,-1]) cylinder(d=9.85, h= MCP_button_face_depth + 2);
        //  screw driver slot to remove cap
        translate([-1.5, -MCP_button_height * 0.5, -1]) cube([3, MCP_wall_thickness, MCP_base_height+2]);
    }
}

module MCP_button(text = "ABC", show_light = true, explode = 0){
    if (MCP_show_switch) translate([0, 0, -cr -(10 * explode)]) SPST_PCB_Mount_Tactile_Switch_with_LED();
    if (MCP_show_base) translate([0, MCP_hole_offset, 0]) buttonbase();
    if (MCP_show_caps) translate([0, MCP_hole_offset, MCP_base_height + 20 * explode]) buttoncap(text = text, show_light = show_light);
    if (MCP_show_inlays) translate([0, MCP_hole_offset, MCP_base_height + MCP_lid_height - (MCP_layer_height * MCP_inlay_height_in_layers) + 10 * explode + cr]) color("white") inlay(text = text, height = MCP_layer_height * MCP_inlay_height_in_layers, show_light = show_light);
}


module buttons(){
    row = MCP_button_height*1.2;
    col = MCP_button_width*1.5;
    if (MCP_show_one){
        MCP_button(text = MCP_caption, show_light = MCP_caption != " ", explode = MCP_explode);
    } else {
        for (i = [0: len(MCP_captions)-1]){
            pos = [col * floor(i/MCP_max_rows), row * (i - (floor(i/MCP_max_rows) * MCP_max_rows))];
            translate([pos[0], pos[1], 0]){
                MCP_button(text = MCP_captions[i], show_light = MCP_show_light && MCP_captions[i] != " ", explode = MCP_explode);
            }
        }
    }
}


buttons();
