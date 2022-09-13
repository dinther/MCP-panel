$fn=45;

module segmentblock(){
    translate([0,0,7.2]) color("black") cube([30,14,0.1]);
    color("ivory") difference(){
        cube([30,14,7.2]);
        translate([3,-1,0]) cube([24,16,0.6]);
        translate([-1,3,0]) cube([32,8,0.6]);
        
    }
    translate([8.7, 1.6, -1.4]) for (i =[0:5]) translate([i*13.3/5,0,0]){ cylinder(d=0.3, h=1.9); translate([0, 0,3]) cylinder(d=0.6, h=0.2);}
    translate([8.7, 14-1.6, -1.4]) for (i =[0:5]) translate([i*13.3/5,0,0]){ cylinder(d=0.3, h=1.9); translate([0, 0,3]) cylinder(d=0.6, h=0.2);}
    translate([0.4,2.6,7.2]) color("red") linear_extrude(0.15) text("8888",size = 9.5,font="Liberation Sans:style=Italic");
}

module display_board(){
    difference(){
        color("blue") cube([82.4, 15, 1.4]);
        s = (15-8.5)*0.5; //76.4
        translate([s,s,-1]) cylinder(d=3.2, h=3.4);
        translate([s,15-s,-1]) cylinder(d=3.2, h=3.4);
        translate([s+76.4,s,-1]) cylinder(d=3.2, h=3.4);
        translate([s+76.4,15-s,-1]) cylinder(d=3.2, h=3.4);
        
        translate([7.4, 0, -1.7]) for (i =[1:5]) translate([0,i*2.5,0]) cylinder(d=0.3, h=1.9);
        translate([82.4-7.4, 0, -1.7]) for (i =[1:5]) translate([0,i*2.5,0]) cylinder(d=0.3, h=1.9);
    }
    translate([13.1,0.5,1.41]) segmentblock();
    translate([43.2,0.5,1.41]) segmentblock();

    translate([35.9,4,-2.8]) color("black") cube([15.2,7,2.8]);
    translate([34.7, 4.1, -1.1]) for (i =[1:12]) translate([i*14.5/11,0,0]) rotate([55,0,0]) color("silver") cylinder(d=0.3, h=2);
    translate([34.7, 12.6, 0.1]) for (i =[1:12]) translate([i*14.5/11,0,0]) rotate([125,0,0]) color("silver") cylinder(d=0.3, h=2);
}

display_board();