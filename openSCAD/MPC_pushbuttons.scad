$fn=45;
MCP_font = "Bahnschrift:style=Light";
MCP_button_height = 3.9;
MCP_button_light_offset = 0;
MCP_button_size = [18,16];
MCP_button_radius = 2;
MCP_layer_height = 0.3;
MCP_text_size = 4.5;

MCP_wall_thickness = 0.75;
MCP_panel_gap = 0.5;


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

module inlay(text1 = "ABC", text_offset1 = 3.5, text2 = "", text_offset2 = -3.5, show_light = true){
    difference(){
        translate([0, 0, 0])
        linear_extrude(MCP_layer_height * 2)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap);
        
        translate([0, 0, MCP_layer_height])
        linear_extrude(MCP_layer_height)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap - 0.5);
    }
    
    translate([0,text_offset1,MCP_layer_height])
    linear_extrude(MCP_layer_height)
    text(text = text1, font = MCP_font, size = MCP_text_size, valign = "center", halign = "center");
    
    translate([0,text_offset2,MCP_layer_height])
    linear_extrude(MCP_layer_height)
    text(text = text2, font = MCP_font, size = MCP_text_size, valign = "center", halign = "center");

    if (show_light) translate([-2, -MCP_button_light_offset-0.3,MCP_layer_height]) cube([4, 0.6, MCP_layer_height]);    
}

module buttonlid(text1 = "ABC", text_offset1 = 3.5, text2 = "", text_offset2 = -3.5, show_light = true){
    h = 2 + MCP_layer_height + MCP_layer_height;
    color("dimgray") linear_extrude(h) difference(){
        rsquare(MCP_button_size, MCP_button_radius);
        rsquare(MCP_button_size, MCP_button_radius, offset=-MCP_wall_thickness);
    }

    //  hinge line
    translate([-6, MCP_button_size[1] * 0.5 - 1.7, h - 0.15 -  MCP_layer_height -  MCP_layer_height]) color("dimgray") cube([12, 1.7, 0.3]);
    
    translate([0, 0, 2 + MCP_layer_height]) difference(){
        color("dimgray") linear_extrude(MCP_layer_height)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap);
        
        translate([0, 0, -MCP_layer_height])        inlay(text1 = text1, text_offset1 = text_offset1, text2 = text2, show_light = show_light);
    }
     
}

module MCP_button(text1 = "ABC", text_offset1 = 3.5, text2 = "", text_offset2 = -3.5, show_light = true, print=true){
    color("dimgray") difference(){
        union(){
            linear_extrude(MCP_button_height - 2 - MCP_layer_height)
            rsquare(MCP_button_size, MCP_button_radius, offset=0);
            
            translate([0, 0, MCP_button_height-2-MCP_layer_height * 2])
            linear_extrude(1.5)
            rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness);
        }
        translate([0,MCP_button_light_offset,-1])
        cylinder(d=9.85, h=1+ MCP_button_height - MCP_layer_height);     
    }
    if (print){
        translate([MCP_button_size[0]*1.1,0,2 + MCP_layer_height + MCP_layer_height])
        rotate([0,180,0]) color("dimgray") buttonlid(text1 = text1, text_offset1 = text_offset1, text2 = text2, show_light = show_light);
    
        translate([MCP_button_size[0]*2.1,0,MCP_layer_height * 2])
        color("white") rotate([0,180,0]) inlay(text1 = text1, text_offset1 = text_offset1, text2 = text2, text_offset2 = text_offset2, show_light = show_light);
    } else {
        translate([0, 0, 1 + MCP_layer_height + MCP_layer_height])
        buttonlid(text1 = text1, text_offset1 = text_offset1, text2 = text2, show_light = show_light);
    
        //translate([0, 0, 3 +MCP_layer_height * 2])      color("white") inlay(text1 = text1, text_offset1 = text_offset1, text2 = text2, text_offset2 = text_offset2, show_light = show_light);
    }
}


//translate([0, 0,0]) MCP_button(text1 = "N1", text_offset1 = 3.5, show_light = true);

//    translate([0, MCP_button_size[1]*1.2,0]) MCP_button(text1 = "LVL", text2 = "CHG", show_light = true);
    translate([0, MCP_button_size[1]*2.4,0]) MCP_button(text1 = "VOR", text2 = "LOC", show_light = true, print = false);
/*
    translate([MCP_button_size[0]*3.4, 0,0]) MCP_button(text1 = "ALT", text2 = "HLD", show_light = true);
    translate([MCP_button_size[0]*3.4, MCP_button_size[1]*1.2,0]) MCP_button(text1 = "L", text2 = "NAV", show_light = true);
    translate([MCP_button_size[0]*3.4, MCP_button_size[1]*2.4,0]) MCP_button(text1 = "V", text2 = "NAV", show_light = true);
    translate([MCP_button_size[0]*6.8, 0,0]) MCP_button(text1 = "VS", text2 = "", show_light = true);
    translate([MCP_button_size[0]*6.8, MCP_button_size[1]*1.2,0]) MCP_button(text1 = "SPD", text2 = "", show_light = true);
    translate([MCP_button_size[0]*6.8, MCP_button_size[1]*2.4,0]) MCP_button(text1 = "APP", text2 = "", show_light = true);
*/
