
/* [General] */
$fn=45;
MCP_font = "Bahnschrift:style=Light";
MCP_button_height = 3.9;
MCP_button_light_offset = 0;
MCP_button_size = [18,16];
MCP_button_radius = 2;
MCP_layer_height = 0.3;
MCP_text_size = 4.25;

MCP_wall_thickness = 0.75;
MCP_panel_gap = 0.5;
MCP_print = true;


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

module inlay(text = "ABC", text_offset = 2.5, hole_offset = 2, show_light = true){
    difference(){
        translate([0, 0, 0])
        linear_extrude(MCP_layer_height * 2)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap);
        
        translate([0, 0, MCP_layer_height])
        linear_extrude(MCP_layer_height)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap - 0.5);
    }
    
    translate([0,text_offset,MCP_layer_height])
    linear_extrude(MCP_layer_height)
    text(text = text, font = MCP_font, size = MCP_text_size, valign = "center", halign = "center");
    
    if (show_light) translate([-2, -hole_offset-0.3,MCP_layer_height]) cube([4, 0.6, MCP_layer_height]);    
}

module buttonlid(text = "ABC", text_offset = 2.5, hole_offset = 2, show_light = true){
    h = 2 + MCP_layer_height + MCP_layer_height;
    color("dimgray") linear_extrude(h) difference(){
        rsquare(MCP_button_size, MCP_button_radius);
        rsquare(MCP_button_size, MCP_button_radius, offset=-MCP_wall_thickness);
    }

    //  hinge line
    translate([-6, MCP_button_size[1] * 0.5 - 1.8, h - 0.3 - MCP_layer_height]) color("dimgray") cube([12, 1.8, MCP_layer_height]);
    
    translate([0, 0, 2 + MCP_layer_height]) difference(){
        color("dimgray") linear_extrude(MCP_layer_height)
        rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness - MCP_panel_gap);
        translate([0, 0, -MCP_layer_height]) inlay(text = text, text_offset = text_offset, hole_offset = hole_offset, show_light = show_light);
    }
     
}

module rail(w, l, h){
    hull(){
        translate([0, 0, 0]) sphere(d=w);
        translate([0, l, 0]) sphere(d=w);
        translate([0, l, h]) sphere(d=w);
        translate([0, 0, h]) sphere(d=w);        
    }
}


module MCP_button(text = "ABC", text_offset = 2.5, hole_offset = 2, show_light = true, railing=true, print=true){
    rw = railing? 1.2 : 0;
    color("dimgray") difference(){
        union(){
            linear_extrude(MCP_button_height - 2 - MCP_layer_height)
            rsquare([MCP_button_size[0] + (rw * 2), MCP_button_size[1]], MCP_button_radius, offset=0);
            
            translate([0, 0, MCP_button_height-2-MCP_layer_height * 2])
            linear_extrude(1.5)
            rsquare(MCP_button_size, MCP_button_radius, offset = -MCP_wall_thickness);
            if (rw> 0){
                translate([-(rw * 0.5)-0.1-MCP_button_size[0] * 0.5, -MCP_button_size[1] * 0.75 * 0.5,rw * 0.50]) rail(rw-0.2, MCP_button_size[1] * 0.75, MCP_button_height); 
                translate([(rw * 0.5)+0.1+MCP_button_size[0] * 0.5, -MCP_button_size[1] * 0.75 * 0.5,rw * 0.50]) rail(rw-0.2, MCP_button_size[1] * 0.75, MCP_button_height);                 
            }
        }
        translate([0,-hole_offset,-1])
        cylinder(d=9.85, h=1+ MCP_button_height - MCP_layer_height);     
    }

    if (print){
        translate([MCP_button_size[0]*1.1,0,2 + MCP_layer_height + MCP_layer_height])
        rotate([0,180,0]) color("dimgray") buttonlid(text = text, text_offset = text_offset, hole_offset = hole_offset, show_light = show_light);
    
        translate([MCP_button_size[0]*2.1,0,MCP_layer_height * 2])
        color("white") rotate([0,180,0]) inlay(text = text, text_offset = text_offset, hole_offset = hole_offset, show_light = show_light);
    } else {
        translate([0, 0, 1 + MCP_layer_height + MCP_layer_height])
        buttonlid(text = text, text_offset = text_offset, hole_offset = hole_offset, show_light = show_light);
    
        translate([0, 0, 3 +MCP_layer_height * 2]) color("white") inlay(text = text, text_offset = text_offset, hole_offset = hole_offset, show_light = show_light);
    }
}


module buttons(print = true){
    row = MCP_button_size[1]*1.2;
    col = MCP_print? MCP_button_size[0]*3.5 : MCP_button_size[0] * 1.5;
    // N1 LVL VOR ALT SPD HOLD VS FLC NAV HDG VNAV APP AP WAR
    translate([col * 0, row * 0, 0]) MCP_button(text = "N1", show_light = true, print = print);
    translate([col * 0, row * 1, 0]) MCP_button(text = "LVL", show_light = true, print = print);
    translate([col * 0, row * 2, 0]) MCP_button(text = "VOR", show_light = true, print = print);
    translate([col * 0, row * 3, 0]) MCP_button(text = "ALT", show_light = true, print = print);
    translate([col * 0, row * 4, 0]) MCP_button(text = "SPD", show_light = true, print = print);
    translate([col * 0, row * 5, 0]) MCP_button(text = "HOLD", show_light = true, print = print);
    translate([col * 0, row * 6, 0]) MCP_button(text = "VS", show_light = true, print = print);
    translate([col * 0, row * 7, 0]) MCP_button(text = "APPR", show_light = true, print = print);
    translate([col * 0, row * 8, 0]) MCP_button(text = "", show_light = true, print = print);
    translate([col * 1, row * 0, 0]) MCP_button(text = "FLC", show_light = true, print = print);
    translate([col * 1, row * 1, 0]) MCP_button(text = "NAV", show_light = true, print = print);
    translate([col * 1, row * 2, 0]) MCP_button(text = "HDG", show_light = true, print = print);
    translate([col * 1, row * 3, 0]) MCP_button(text = "VNAV", show_light = true, print = print);
    translate([col * 1, row * 4, 0]) MCP_button(text = "LNAV", show_light = true, print = print);
    translate([col * 1, row * 5, 0]) MCP_button(text = "APP", show_light = true, print = print);
    translate([col * 1, row * 6, 0]) MCP_button(text = "AP", show_light = true, print = print);
    translate([col * 1, row * 7, 0]) MCP_button(text = "WARN", show_light = true, print = print);
    translate([col * 1, row * 8, 0]) MCP_button(text = "", show_light = true, print = print);
}


//buttons(MCP_print);
MCP_button(text = "HDG", show_light = true, print = MCP_print);
