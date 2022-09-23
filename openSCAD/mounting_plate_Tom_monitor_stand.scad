hole = 5.2;
d = 60;
h = 35;
l = 15;
g=2.9;
t = 8+g;
w = d+(4*hole);

difference([]){
    union(){
        cube([w,h, t]);
        translate([0,h,0]) rotate([l,0,0]) cube([d+(4*hole),12, t]);
        //translate([0,h,0]) rotate([l,0,0]) translate([0,0,t+3]) cube([d+(4*hole),12, t]);
        
    }
    translate([-1,h,0]) rotate([l,0,0]) translate([0,2,4]) cube([d+(4*hole)+2,10.5, g]);
    translate([hole + hole, h * 0.4, -1]) cylinder(d=hole, h=t+ 2);
    translate([hole + hole + 60, h * 0.4, -1]) cylinder(d=hole, h=t+ 2);
}


