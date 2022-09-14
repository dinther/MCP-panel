use <standard_holes.scad>;
use <arduino_mega_board.scad>;
include <8_digit_7_segment_max9219_display_module.scad>;

/* [General] */
$fn = 45;
// distance between the face plate and back wall
depth = 35;
//  Face plate thickness
thickness = 3;
//  Thickness of side walls
wall = 2;
font = "Liberation Sans:style=Normal"; //"Liberation Sans:style=Bold";
//  Height of the text font. Beware of 3D printer limitations.
text_size = 4.5;
//  layer height you intend to use for the slicer.
layer_height = 0.3;
//  Thickness of inlay in terms of print layers.
face_layers = 2;

/* [Text labels] */
display_1_text = "CRS";
display_2_text = "SPD";
display_3_text = "HDG";
display_4_text = "V/S";
display_5_text = "ALT";
display_6_text = "Aux";
lit_panel_text = "FD";
display_led_1_text = "Mach";
display_led_2_text = "IAS";
vertical_wheel_top_text = "DN";
vertical_wheel_bottom_text = "UP";


/* [Render] */
show_panel = true;
show_lid = true;
show_inlay = true;
show_hole_test = true;

/* [hidden] */
spacing = 23.0;
row_spacing = 13;
bottom_row = 10;
left_margin = 16;
right_margin = 16;
display_base = 44;
height = 72;
ridge = 0.35;

// 1 - digit, 0 - blank, 2 - two led's, 3 - minus sign only
display_slots_1 = [1,1,1,0,1,1,1,2];  //  CRS, SPD, Mach/IAS
display_slots_2 = [1,1,1,3,1,1,1,1];  //  HDG, V/S
display_slots_3 = [1,1,1,1,1,3,1,1];  //  ALT, Aux

//  helpful modules
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

module ring(d1, d2){
    difference(){
        circle(d=d1);
        circle(d=d2);
    }
}

module tube(d1, d2, h){
    linear_extrude(h) ring(d1, d2);
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
               if (is_num(hole) && (hole > 0)){
                   rotate([-90,0,0]) cylinder(d=hole, h=t*2);
               } else {
                   rotate([-90,180,0]) encoder_hole(thickness, 0.3);
               }
            }
        }
    }
}

module cut_out_shape(){
            fm = 0;
    union(){
        text_y = 4;
        translate([left_margin + digit_width * 1.5, display_base+digit_height + text_y, 0])
        text(text = display_1_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + digit_width * 1.5, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3, fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3, fm + digit_height], r=1, offset=-0.75);
        }
        translate([left_margin + digit_width * 5.5, display_base+digit_height + text_y, 0])
        text(text = display_2_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + digit_width * 5.5, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3,fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3,fm + digit_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width, display_base + digit_height - 2.55, 0])
        text(text = display_led_1_text, font = font, size = text_size, valign = "center", halign = "left");

        translate([left_margin + display_outer_width, display_base + 3.15, 0])
        text(text = display_led_2_text, font = font, size = text_size, valign = "center", halign = "left");

        translate([left_margin + display_outer_width + spacing + digit_width * 1.5, display_base + digit_height + text_y, 0])
        text(text = display_3_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + digit_width * 1.5, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 3,fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 3,fm + digit_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + digit_width * 6, display_base + digit_height + text_y, 0])
        text(text = display_4_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + digit_width * 6, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 4,fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 4,fm + digit_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + digit_width * 7.5, display_base-row_spacing+6, 0])
        text(text = vertical_wheel_top_text, font = font, size = text_size, valign = "center", halign = "center");

        translate([left_margin + display_outer_width + spacing + digit_width * 7.5, display_base-row_spacing-22, 0])
        text(text = vertical_wheel_bottom_text, font = font, size = text_size, valign = "center", halign = "center");
        
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2.5, display_base + digit_height + text_y, 0])
        text(text = display_5_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2.5, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 5,fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 5,fm + digit_height], r=1, offset=-0.75);
        }
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 7, display_base + digit_height + text_y, 0])
        text(text = display_6_text, font = font, size = text_size, valign = "bottom", halign = "center");
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 7, display_base + digit_height * 0.5, 0]) difference(){
            rsquare(s= [fm + digit_width * 2,fm + digit_height], r=1, offset=0);
            rsquare(s= [fm + digit_width * 2,fm + digit_height], r=1, offset=-0.75);
        }

        translate([13, bottom_row + 12, thickness - 0.6])
        difference(){
            circle(d=9);
            text(text = lit_panel_text, font = font, size = text_size, valign = "center", halign = "center");
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
            translate([wall, wall, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin - wall - wall, display_base - wall + digit_height + 1, depth]);
            translate([-1, height-10.5, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin + 2, display_base - wall + digit_height + 1, depth]);
            translate([-1, -height + 10.5 + wall + wall, -depth]) cube([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width + right_margin + 2, display_base - wall + digit_height + 1, depth]);
        }
    }    
}

//  stl modules


//  Small object to test hole sizes for mounting components
module hole_test(){
    difference(){
        translate([-4, -11, 0]) cube([50,22,thickness]);
        translate([0, 0, 0]) 3mm_led_hole(thickness, 0);
        translate([7, -1, 0]) encoder_hole(thickness, 0);
        translate([17, 0, 0]) toggle_switch_hole(thickness, 0);
        translate([27, 0, 0]) push_button_hole(thickness, 0);   
        translate([39, 0, 0]) selector_hole(thickness, 0); //cylinder(d=9.85, h=thickness);
    }
}

//  back cover lid for the display panel
module panellid(){
    w = left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width +right_margin;
    l = 2.1;
    difference(){
        union(){
            translate([wall,wall,0]) cube([w-(wall*2), height-10.5-(wall*2),10]);
            translate([0,0,0]) cube([w, height-10.5,thickness - 0.01]);
        }
        translate([(wall*2), (wall*2), layer_height * 4]) cube([w-(wall*4), height-10.5-(wall*4),30]);
        translate([wall+wall+0.25,wall+l,3.5]){
            arduino_mega_USB_plug_cut();
            arduino_mega_DC_plug_cut();
        }
    }
    translate([111.5,20,1]) rotate([0, -5, 0]) translate([-5, 0, 0]) cube([5, 20, 7]);
    translate([wall+wall+0.25,wall+l,layer_height * 4]) arduino_mega_pcb_holes(2.8,5 );
}


//  Main panel for the MCP
module panel(){
    difference(){
        union(){
            panelbox();
            //  additions to the box
    
            //  angle bracket
            translate([left_margin + display_outer_width + spacing + digit_width*6 - 6, display_base - row_spacing - 10, 0]) rotate([180,0,90]) anglebracket();
            translate([left_margin + display_outer_width + spacing + digit_width*6 + 4.2, display_base - row_spacing - 10, 0]) rotate([180,0,90]) mirror([0,1,0]) anglebracket(6);
            //  ap led stud
            translate([13, bottom_row + 12,-thickness]) cylinder(d = 7, h = 4);

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
        }
               
        //  display slots
        translate([left_margin, display_base, 0]) displayslot(display_slots_1);
        translate([left_margin + display_outer_width + spacing, display_base, 0]) displayslot(display_slots_2);        
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing, display_base, 0]) displayslot(display_slots_3);
        
        //  encoder slots
        translate([left_margin + digit_width*1.5, display_base - row_spacing, 0]) encoder_hole(thickness, 0);
        translate([left_margin + digit_width*5.5, display_base - row_spacing, 0]) encoder_hole(thickness, 0);
        translate([left_margin + display_outer_width + spacing + digit_width*1.5, display_base - row_spacing, 0]) encoder_hole(thickness, 0);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + digit_width * 2, display_base - row_spacing, 0]) encoder_hole(thickness, 0);
        
        //  selector slots
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*6.5,display_base - row_spacing - 3, 0]) selector_hole(thickness, 0);
        
        //  V/S wheel slot
        translate([left_margin + display_outer_width + spacing + digit_width*5.5, display_base-row_spacing-8, -6-thickness]) rotate([0,90,0]) cylinder(d=41, h=8, $fn=90);
      
        //  toggle switch slots
        translate([13,bottom_row,0]) toggle_switch_hole(thickness, 0);
        translate([left_margin + display_outer_width + spacing + display_outer_width + spacing + display_outer_width +right_margin-13,bottom_row, 0]) toggle_switch_hole(thickness, 0);

        //  AP light insert
        translate([13,bottom_row + 12,-4]) 3mm_led_hole(4 + thickness,0);
        translate([13,bottom_row + 12,thickness-3]) cylinder(d1=1, d2=9, h=2.5);
        
        //  switch slots
        translate([left_margin+digit_width*3.5,bottom_row,0]) push_button_hole(thickness, 0);
        translate([left_margin+display_outer_width-digit_width*0.5+spacing*0.5,bottom_row,0]) push_button_hole(thickness, 0);
        translate([left_margin+display_outer_width-digit_width*0.5+spacing*0.5,display_base-row_spacing,0]) push_button_hole(thickness, 0);
        translate([left_margin+display_outer_width+spacing+digit_width*3.5,bottom_row,0]) push_button_hole(thickness, 0);
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing+digit_width*4.5,bottom_row,0]) push_button_hole(thickness, 0);       
        
        //  gear down lights
        translate([left_margin+display_outer_width+spacing+display_outer_width+8,bottom_row, 0]) 3mm_led_hole(thickness,0);
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing*0.5+4,display_base-row_spacing, 0]) 3mm_led_hole(thickness, 0);
        translate([left_margin+display_outer_width+spacing+display_outer_width+spacing,bottom_row, 0]) 3mm_led_hole(thickness, 0);

        //  cutouts for infill
        translate([0,0,thickness-layer_height * face_layers]) linear_extrude(layer_height * face_layers+1) cut_out_shape();
        
        //  Arduino plug cutouts
        translate([wall+wall+0.25,wall+2.1,-depth+3.5]){
            arduino_mega_USB_plug_cut();
            arduino_mega_DC_plug_cut();
        }
    }
         
}

//  Rendering

if (show_hole_test) translate([180, 110]) color("dimgray") hole_test();

if (show_panel) color("dimgray") panel();
    
if (show_lid) translate([0,0,-depth]) color("gray") panellid();

if (show_inlay) color("whitesmoke") translate([0,0,thickness-layer_height * face_layers]) linear_extrude(layer_height * face_layers) cut_out_shape();



