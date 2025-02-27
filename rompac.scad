/*
 * $Id: rompac.scad 2025 2025-02-26 09:34:19 curt
 */

width = 100;
length = 135;
thick = 2;
pin = 82;
bevel_width = 6;
bevel_len = 16;
high = 20;
plat = 12;

express = "t";

module platform() {
    translate([8,12,0]) cube([2,73,plat]);
    translate([8,12,0]) cube([124,2,plat]);
    translate([8,84,0]) cube([124,2,plat]);
    translate([130,12,0]) cube([2,73,plat]); 
}

module lip() {
    translate([8,10,0]) cube([126,2,plat+2]);
    translate([8,86,0]) cube([126,2,plat+2]);
    translate([132,10,0]) cube([2,78,plat+2]); 
}

module pin() {
    difference() {
        translate([pin, width / 2, 0]) cylinder(high-2, r = 4);
        translate([pin, width / 2, 0]) cylinder(high, r = 2);
    }
}
      
module base() {
    linear_extrude(height=thick) 
        polygon([
                [ 0, bevel_width],
                [ 0, width - bevel_width],
                [ bevel_len, width],
                [ length, width],
                [ length, 0],
                [ bevel_len, 0]]);
}

module edge() {
    union() {
        translate([bevel_len, 0, 0]) cube([length - bevel_len, 1, high]);
        translate([length - 1, 0, 0]) cube([1, width, high]);
        translate([bevel_len, width - 1, 0]) cube([length - bevel_len, 1, high]);
        linear_extrude(height = high) union() {
            polygon([[0, bevel_width + 1], [0, bevel_width], 
                [bevel_len, 0], [bevel_len, 1]]);
            polygon([[0, width - bevel_width], [0, width - bevel_width - 1], 
                [bevel_len, width - 1], [bevel_len, width]]);
        }
    }
}

module top() {
    toplip = 6;
    linear_extrude(height=thick) 
        polygon([
                [ 0, bevel_width],
                [ 0, width - bevel_width],
                [ bevel_len, width],
                [ length, width],
                [ length, 0],
                [ bevel_len, 0]]);
    translate([pin, width / 2, 0]) cylinder(high / 2, r = 1.5);

    translate([bevel_len, 1, 0]) cube([length - bevel_len - 1, 1, toplip]);
    translate([length - 2, 1, 0]) cube([1, width - 2, toplip]);
    translate([bevel_len, width - 2, 0]) cube([length - bevel_len - 1, 1, toplip]);
    linear_extrude(height = 10) {
        polygon([[0, bevel_width + 2], [0, bevel_width + 1], 
                [bevel_len, 1], [bevel_len, 2]]);
        polygon([[0, width - bevel_width - 1], [0, width - bevel_width - 2], 
                [bevel_len, width - 2], [bevel_len, width-1]]);
    }
}

if (search("b", express)) {
    edge();
    base();
    pin();
    platform();
    color("blue") lip();
}

if (search("t", express)) {
    echo("t");
    if (search("b", express)) {
        color("red") translate([0, width, 30]) rotate([180, 0, 0]) top();
        echo("tb");
    } else {
        top();
    }
}

 
