module 3mm_led_hole(thickness = 1, tolerance = 0){
    translate([0, 0, -0.1]) cylinder(d = 3.12, h = thickness + 0.2);
}

module push_button_hole(thickness = 1, tolerance = 0){
    union(){
        translate([-3.35, -3.9, -0.1]) cube([6.7, 7.8, thickness -0.75]);
        translate([0, 0, thickness - 0.9]) cylinder(d = 9.1 + tolerance, h = 0.91);
    }
}

module push_button_hole1(thickness = 1, tolerance = 0){
    union(){
        translate([0, 0, -0.1 + thickness * 0.5]) cube([6.7, 7.8, thickness + 0.1], true);
        translate([0, 0, thickness - 0.9]) cylinder(d = 9.1 + tolerance, h = 0.91);
    }
}

module encoder_hole(thickness = 1, tolerance = 0){
    translate([0, 0, -0.1]) cylinder(d=7.2 + tolerance, h=thickness + 0.2);
    translate([-1.1, -7.15, -0.1]) cube([2.2, 7.15, thickness + 0.2]);
}

module selector_hole(thickness = 1, tolerance = 0){
    translate([0, 0, -0.1]) cylinder(d = 9.4 + tolerance, h = thickness + 0.2);
    translate([0, 9.5, -0.1]) cylinder(d = 3.4, h = thickness); //Doesn't go all the way through. Stops 1mm short.
}

module toggle_switch_hole(thickness = 1, tolerance = 0){
    translate([0, 0, -0.1]) cylinder(d = 6.5 + tolerance, h = thickness + 0.2);
}