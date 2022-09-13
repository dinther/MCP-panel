use <MPC_pushbuttons.scad>;
use <segmentdisplayboard.scad>;
include <MCP_knobs.scad>;
include <arduino_mega_board.scad>;

/*
 kts/mach indicator
 | command speed
 | |  CRS
 | |  |     HDG VS
 | |  |     |          ALT   Spare
":000_000" "000_0000" "00000_00"
*/
$fn = 45;
height = 72;
depth = 35;
thickness = 3;
wall = 2;
text_size = 4.5;

display_outer_width = 60.7; //60.4;
display_outer_height = 14.5;
ridge = 0.35;
spacing = 23.0;
row_spacing = 13;
bottom_row = 10;
digit_width = display_outer_width / 8;
digit_height = display_outer_height;
left_margin = 16;
right_margin = 16;
display_base = height - 28;
face_layers = 2;
layer_height = 0.3;
board_height = 27;

font = "Liberation Sans:style=Normal"; //"Liberation Sans:style=Bold";

hole_dia_encoder = 7.2;  //  7.2 is final
toggle_switch_dia = 6.5;  //  6.5 is final
led_dia = 3.12;  //  3.12 is final



display_slots_1 = [1,1,1,0,1,1,1,2]; // 1 indicator kts/mach, 3 IAS, 1 blank, 3 CRS
display_slots_2 = [1,1,1,3,1,1,1,1]; // 3 HDG, 1 minus, 4 VS
display_slots_3 = [1,1,1,1,1,3,1,1]; // 5 ALT, 1 blank, 2 spare

button_height = 3.9;
button_light_offset = 0;
button_size = [18,16];

module hole_test(){
    difference(){
        translate([-4,-7,0]) cube([50,14,thickness]);
        translate([0, 0, -1]) cylinder(d=led_dia,h=thickness+2);
        translate([7,-1,0]) encoder_hole();
        translate([17,0,-1]) cylinder(d=toggle_switch_dia,h=thickness+2);
        translate([27,0,0]) push_button_hole();   
        translate([39,0,-1]) cylinder(d=9.85, h=thickness+2);
    }
}

module displayslot(slot){
    translate([0, 0, -0.1]) linear_extrude(thickness-0.9) union(){
        for (i =[0:7]){
            translate([digit_width * i, 0]) square([digit_width, digit_height]);
        }
    }
    translate([0, 0, -1]) linear_extrude(thickness+2) offset(delta=-ridge) union(){
        for (i =[0:7]){
            //  1 = Full digit hole
            if (slot[i] == 1){
                translate([digit_width * i, 0]) square([digit_width, digit_height]);
                
            }
        }
    }
    for (i =[0:7]){
        //  2 = two signal light holes
        if (slot[i] == 2){
            translate([digit_width * (i+0.5), display_outer_height-3.5, -1]) cylinder(d=1.75, h=thickness+2); //  Top hole
            translate([digit_width * (i+0.5), 3, -1]) cylinder(d=1.75, h=thickness+2);  //  Bottom hole
        }
        //  3 = minus sign
        if (slot[i] == 3){
            translate([digit_width * (i+0.5)-1.9, 6.7, -1]) cube([4, 0.7, thickness+2]);
        }
    }
}

module anglebracket(hole){
    t = 2;
    s = 8.5;
    d = 16;
    translate([-d*0.5, -s-t-t, 0]){
        difference(){
            translate([-12,0,0]) cube([t+d+t+12,s+t+t,s+t+t+1]);
            translate([t-14,-0.01,-0.01]) cube([d+14,s+t,s+t+4]);
            translate([-1,0,6]) rotate([40,0,0]) cube(d*2);
            translate([d*0.5+t,s+t-1,9]){
               if (hole == hole_dia_encoder){
                   rotate([-90,0,0]) encoder_hole(0.3);
               } else {
                   rotate([-90,0,0]) cylinder(d=hole, h=t*2);
               }
            }
        }
    }
}

module push_button_hole(){
    union(){
        translate([0, 0, -0.1+thickness * 0.5]) cube([6.7, 7.8, thickness+0.1], true);
        translate([0, 0, thickness - 0.9]) cylinder(d = 9.1, h = 0.91);
    }
}

module encoder_hole(tolerance = 0){
    translate([0, 0, -1]) cylinder(d=7.2 + tolerance, h=thickness + 2);
    translate([-1.1, -7.15, -1]) cube([2.2,7.15, thickness+2]);
}

module selector_hole(tolerance = 0){
    translate([0, 0, -1]) cylinder(d = 9.4 + tolerance, h = thickness + 2);
    translate([0, 9.5, -1]) cylinder(d = 3.4, h = 3);
}

module ring(d1, d2){
    difference(){
        circle(d=d1);
        circle(d=d2);
    }
}

module tube(d1, d2, h){
    linear_extrude(h) ring(d1, d2);
}

module cut_out_shape(){
            fm = 0;
    union(){
        text_y = 4;
        translate([left_margin + digit_width * 1.5, display_base+display_outer_height + text_y, 0])
        text(text = "CRS", font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + digit_width * 1.5, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3, fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3, fm + display_outer_height], r=1, offset=-0.75);
        }
        translate([left_margin + digit_width * 5.5, display_base+display_outer_height + text_y, 0])
        text(text = "SPD", font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + digit_width * 5.5, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3,fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3,fm + display_outer_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width, display_base + display_outer_height - 2.55, 0])
        text(text = "Mach", font = font, size = text_size, valign = "center", halign = "left");

        translate([left_margin + display_outer_width, display_base + 3.15, 0])
        text(text = "IAS", font = font, size = text_size, valign = "center", halign = "left");

        translate([left_margin + display_outer_width + spacing + digit_width * 1.5, display_base + display_outer_height + text_y, 0])
        text(text = "HDG", font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + digit_width * 1.5, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3,fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3,fm + display_outer_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + digit_width * 6, display_base + display_outer_height + text_y, 0])
        text(text = "V/S", font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + digit_width * 6, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 4,fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 4,fm + display_outer_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + digit_width * 7.5, display_base-row_spacing+6, 0])
        text(text = "DN", font = font, size = text_size, valign = "center", halign = "center");

        translate([left_margin + display_outer_width + spacing + digit_width * 7.5, display_base-row_spacing-22, 0])
        text(text = "UP", font = font, size = text_size, valign = "center", halign = "center");
        
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2.5, display_base + display_outer_height + text_y, 0])
        text(text = "ALT", font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2.5, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 5,fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 5,fm + display_outer_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 7, display_base + display_outer_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 2,fm + display_outer_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 2,fm + display_outer_height], r=1, offset=-0.75);
        }


        translate([13, bottom_row + 12, thickness - 0.6])
        difference(){
            circle(d=9);
            text(text = "AP", font = font, size = text_size, valign = "center", halign = "center");
        }
        //  arrow up down
        translate([left_margin + display_outer_width + spacing + digit_width * 7.5 -2.5, display_base-row_spacing-8, 0])
        polygon([[-0.3,2],[-0.3,8], [-1.5,8],[0,10],[1.5,8],[0.3,8],[0.3,2]]);
        translate([left_margin + display_outer_width + spacing + digit_width * 7.5 -2.5, display_base-row_spacing-8, 0])
        polygon([[-0.3,-2],[0.3,-2],[0.3,-8],[1.5,-8],[0,-10],[-1.5,-8],[-0.3,-8]]);
        translate([left_margin + display_outer_width + spacing + digit_width * 7.5 -4.5, display_base-row_spacing-8.3, 0])
        square([4,0.6]);
        
        //  encoder markings
        translate([left_margin + digit_width*1.5, display_base - row_spacing]){ ring(d1=19, d2=18); translate([-0.25,9]) square([0.5,4]); }
        translate([left_margin + digit_width*5.5, display_base - row_spacing]){ ring(d1=21, d2=20); translate([-0.25,10]) square([0.5,3.0]); }
        translate([left_margin + display_outer_width + spacing + digit_width*1.5, display_base - row_spacing]){ ring(d1=19, d2=18); translate([-0.25,9]) square([0.5,4]); }
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2, display_base - row_spacing]){ ring(d1=19, d2=18); translate([-0.25,9]) square([0.5,4]); }
        
        //  V/S line link
        translate([left_margin+display_outer_width+spacing+digit_width*3.5+6,bottom_row-0.3]) square([6, 0.6]);
        
        //  gear down lights
        translate([left_margin + display_outer_width + spacing + display_outer_width + 8, bottom_row]) ring(d1 = 8, d2 = 7);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing * 0.5+4, display_base - row_spacing]) ring(d1 = 8, d2 = 7);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing, bottom_row]) ring(d1 = 8, d2 = 7);
        
        //  toggle switch marking
        translate([13,bottom_row,-1]) ring(d1 = 12, d2 = 11);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin - 13,bottom_row,-1]) ring(d1 = 12, d2 = 11);

        //  selector switch marking
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*6.5,display_base - row_spacing - 3, thickness + 0.25]){
            rotate([0,0,-60]) translate([-0.45,11]) square([0.9, 3]);
            rotate([0,0,-30]) translate([-0.45,11]) square([0.9, 3]);
            translate([-0.45,10]) square([0.9, 4]);
            rotate([0,0,30]) translate([-0.45,11]) square([0.9, 3]);
            rotate([0,0,60]) translate([-0.45,11]) square([0.9, 3]);
        }

    }
}

module panelbox(){
    union(){
        //  make the box
        w = left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width +right_margin;
        difference(){
            translate([0, 0, -depth + thickness]) linear_extrude(depth) polygon([[0, 0],[10, -10],[w - 10, -10],[w, 0],[w, height - 10],[w - 10, height],[10, height],[0, height - 10]]);
            translate([wall, wall, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin - wall - wall, display_base - wall + display_outer_height + 1, depth]);
            translate([-1, height-10.5, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin + 2, display_base - wall + display_outer_height + 1, depth]);
            translate([-1, -height + 10.5 + wall + wall, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin + 2, display_base - wall + display_outer_height + 1, depth]);
        }
    }    
}

module panellid(){
    w = left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width +right_margin;
    l = 2.1;
    echo(w);
    difference(){
        translate([wall,wall,0]) cube([w-(wall*2), height-10.5-(wall*2),30]);
        translate([(wall*2), (wall*2), layer_height * 4]) cube([w-(wall*4), height-10.5-(wall*4),30]);
        translate([wall+wall+0.25,wall+l,3.5]){
            USB_plug_cut();
            DC_plug_cut();
        }
    }
    translate([wall+wall+0.25,wall+l,layer_height * 4]) pcb_holes(2.8,5 );
    //translate([wall+wall+0.25,wall+l,3.5]) arduino_mega();
}



module panel(){
    difference(){
        union(){
            panelbox();
            //  additions to the box
    
            //  angle bracket
            translate([left_margin + display_outer_width + spacing + digit_width*6 - 6, display_base - row_spacing - 10, 0]) rotate([180,0,90]) anglebracket(hole_dia_encoder);
            translate([left_margin + display_outer_width + spacing + digit_width*6 + 4.2, display_base - row_spacing - 10, 0]) rotate([180,0,90]) mirror([0,1,0]) anglebracket(6);
            //  ap led stud
            translate([13, bottom_row + 12,-thickness]) cylinder(d = led_dia * 2, h = 4);
            
            //  display mounts
            
            
            
            //  display studs
            d1 = 6.5;
            d2 = 2.65;
            sh = 5.5;
            translate([left_margin,display_base,-sh]){
                translate([-9.7,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
            }
            
            translate([left_margin + display_outer_width + spacing,display_base,-sh]){
                translate([-9.7,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
            }            

            translate([left_margin + display_outer_width + spacing + display_outer_width + spacing,display_base,-sh]){
                translate([-9.7,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,3,0]) tube(d1=d1, d2=d2, h=sh);
                translate([-9.7+76.5,8.5+3,0]) tube(d1=d1, d2=d2, h=sh);
            }   

            //  arduino mega studs
            beam = 13;
            translate([68.35,8.1 + wall,-board_height]){
                tube(d1=7, d2=d2, h=board_height);
                translate([-1.5,-9,10]) cube([3,7,board_height-10]);
                difference(){
                    translate([-1.5,2,1]) cube([3,48,beam]);
                    translate([-3,15.4,-1]) cube([6,15,10]);
                    translate([-3,42.3,-1]) cube([6,3,10]);
                }
                //translate([-1.5,30,0]) cube([3,21,beam]);
            }
            
            translate([68.35,36.0 + wall,-board_height]) tube(d1=7, d2=d2, h=12);
            

        }
               
        //  display slots
        translate([left_margin, display_base, 0]) displayslot(display_slots_1);
        translate([left_margin + display_outer_width + spacing, display_base, 0]) displayslot(display_slots_2);        
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing, display_base, 0]) displayslot(display_slots_3);
        
        //  encoder slots
        translate([left_margin + digit_width*1.5, display_base - row_spacing, 0]) encoder_hole();
        translate([left_margin + digit_width*5.5, display_base - row_spacing, 0]) encoder_hole();
        translate([left_margin + display_outer_width + spacing + digit_width*1.5, display_base - row_spacing, 0]) encoder_hole();
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2, display_base - row_spacing, 0]) encoder_hole();
        
        //  selector slots
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*6.5,display_base - row_spacing - 3, 0]) selector_hole();
        
        //  V/S wheel slot
        translate([left_margin + display_outer_width + spacing + digit_width*5.5, display_base-row_spacing-8, -6-thickness]) rotate([0,90,0]) cylinder(d=41, h=8, $fn=90);
      
        //  toggle switch slots
        translate([13,bottom_row,-1]) cylinder(d=toggle_switch_dia, h=thickness+2);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width +right_margin-13,bottom_row,-1]) cylinder(d=toggle_switch_dia, h=thickness+2);

        //  AP light insert
        translate([13,bottom_row + 12,-thickness]) cylinder(d=led_dia, h=thickness*2-2);
        translate([13,bottom_row + 12,thickness-2]) cylinder(d1=led_dia, d2=9, h=1.4);
        
        //  switch slots
        translate([left_margin+digit_width*3.5,bottom_row,0]) push_button_hole();
        translate([left_margin+display_outer_width-digit_width*0.5+spacing*0.5,bottom_row,0]) push_button_hole();
        translate([left_margin+display_outer_width-digit_width*0.5+spacing*0.5,display_base-row_spacing,0]) push_button_hole();
        translate([left_margin+display_outer_width+spacing+digit_width*3.5,bottom_row,0]) push_button_hole();
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*4.5,bottom_row,0]) push_button_hole();       
        
        //  gear down lights
        translate([left_margin+display_outer_width+spacing+display_outer_width+8,bottom_row,-1]) cylinder(d=led_dia, h=thickness+2);
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing*0.5+4,display_base-row_spacing,-1]) cylinder(d=led_dia, h=thickness+2);
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing,bottom_row,-1]) cylinder(d=led_dia, h=thickness+2);

        //  cutouts for infill
        translate([0,0,thickness-layer_height * face_layers]) linear_extrude(layer_height * face_layers+1) cut_out_shape();
        
        //  USB plug slot
        translate([-1,32.65 + wall, -board_height - 0.5]) cube([10, 12.6, 11.4]);
        translate([-1,4.4 + wall, -board_height - 0.5]) cube([10, 9.3, 11.4]);
    }
}

module buttons(){
    //translate([0, 0,0]) MCP_button(text1 = "N1", text_offset1 = 3.5, show_light = true);
    /*
    translate([0, button_size[1]*1.2,0]) MCP_button(text1 = "LVL", text2 = "CHG", show_light = true);
    translate([0, button_size[1]*2.4,0]) MCP_button(text1 = "VOR", text2 = "LOC", show_light = true);
    translate([button_size[0]*3.4, 0,0]) MCP_button(text1 = "ALT", text2 = "HLD", show_light = true);
    translate([button_size[0]*3.4, button_size[1]*1.2,0]) MCP_button(text1 = "L", text2 = "NAV", show_light = true);
    translate([button_size[0]*3.4, button_size[1]*2.4,0]) MCP_button(text1 = "V", text2 = "NAV", show_light = true);
    translate([button_size[0]*6.8, 0,0]) MCP_button(text1 = "VS", text2 = "", show_light = true);
    translate([button_size[0]*6.8, button_size[1]*1.2,0]) MCP_button(text1 = "SPD", text2 = "", show_light = true);
    translate([button_size[0]*6.8, button_size[1]*2.4,0]) MCP_button(text1 = "APP", text2 = "", show_light = true);
    */
}

module knobs(){
    translate([142.5, 23, -9.4]) color("whitesmoke") rotate([0,90,0]) VS_knob(radius = 19, shaft = shaft_radius, height = 6, standoff=1);
    translate([27,display_base - row_spacing, thickness + 0.25]) course_knob(radius = outer_radius, shaft = shaft_radius, height = 15, print=false);
    translate([58,display_base - row_spacing, thickness + 0.25]) IAS_knob(radius = outer_radius, shaft = shaft_radius, height = 15, print=false);
    translate([111,display_base - row_spacing, thickness + 0.25]) heading_knob(radius = outer_radius, shaft = shaft_radius, height = 15,  print=false);
    translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*2,display_base - row_spacing, thickness + 0.25]) altitude_knob(radius = outer_radius, shaft = shaft_radius, height = 15,  print=false);
    translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*6.5,display_base - row_spacing - 3, thickness + 0.25]) selector_knob(radius = outer_radius, shaft = shaft_radius, height = 15,  print=false);
}

module displays(){
    translate([2.9, 44.32,-6.9]) display_board();
    translate([2.9+display_outer_width+spacing, 44.32,-6.9]) display_board();
    translate([2.9+display_outer_width+spacing+display_outer_width+spacing, 44.32,-6.9]) display_board();
}

//translate([180, 100])hole_test();

//color("dimgray") panel();
difference(){
    translate([0,0,-50]) panellid();
    panel();
}
//displays();
//knobs();
//buttons();

//translate([wall+0.25,wall+0.5,-board_height-1.6]) arduino_mega();

//color("whitesmoke") translate([0,0,thickness-layer_height * face_layers]) linear_extrude(layer_height * face_layers+0.01) cut_out_shape();

// Debug
//translate([148,23,-9]) rotate([-90,0,90]) cylinder(d=39, h=6.0); //  V/S wheel



//displayslot([1,1,1,0,1,1,1,2]);