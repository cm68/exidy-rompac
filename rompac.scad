/*
 * $Id: rompac.scad 2028 2025-03-01 18:28:49 curt
 */

width = 100;
length = 135;
basethick = 2;
pin = 82;
bevel_width = 6;
bevel_len = 16;
high = 20;
plat = 11;
sidethick = 2;

// edit this to generate either "b" - bottom
// or "t" - top
// or both -"tb"
express = "b";

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
    difference() {
        linear_extrude(height = basethick) 
            polygon([
                [ 0, bevel_width],
                [ 0, width - bevel_width],
                [ bevel_len, width],
                [ length, width],
                [ length, 0],
                [ bevel_len, 0]]);
        translate([10, 14, 1]) cube([120, 70, 2]);
    }
    translate([0, 54, 0]) cube([length, 8, 2]);
    translate([0, 27, 0]) cube([length, 6, 2]);
    translate([pin - 5, 0, 0]) cube([10, width, 2]);
}

module edge() {
    union() {
        translate([bevel_len, 0, 0]) cube([length - bevel_len, sidethick, high]);
        translate([length - sidethick, 0, 0]) cube([sidethick, width, high]);
        translate([bevel_len, width - sidethick, 0]) cube([length - bevel_len, sidethick, high]);
        linear_extrude(height = high) union() {
            polygon([[0, bevel_width + sidethick], [0, bevel_width], 
                [bevel_len, 0], [bevel_len, sidethick]]);
            polygon([[0, width - bevel_width], [0, width - bevel_width - sidethick], 
                [bevel_len, width - sidethick], [bevel_len, width]]);
        }
    }
}

module top() {
    toplip = 6;
    linear_extrude(height = basethick) 
        polygon([
                [ 0, bevel_width],
                [ 0, width - bevel_width],
                [ bevel_len, width],
                [ length, width],
                [ length, 0],
                [ bevel_len, 0]]);
    
    translate([pin, width / 2, 0]) cylinder(high - 6, r = 1.8);

    translate([bevel_len, sidethick, 0]) cube([length - bevel_len - sidethick, 1, toplip]);
    translate([length - sidethick - 1, sidethick, 0]) cube([1, width - (sidethick * 2), toplip]);
    translate([bevel_len, width - sidethick - 1, 0]) cube([length - bevel_len - sidethick, 1, toplip]);
    linear_extrude(height = 18) {
        polygon([[0, bevel_width + (sidethick *2)], [0, bevel_width + sidethick], 
                [bevel_len, sidethick], [bevel_len, (sidethick*2)]]);
        polygon([[0, width - bevel_width - sidethick], [0, width - bevel_width - (sidethick * 2)], 
                [bevel_len, width - (sidethick * 2)], [bevel_len, width-sidethick]]);
    }
    translate([8,15,0]) cube([2,72, high - plat - 1.6]);
    translate([36, 12, 0]) cube([96,4,high - plat - 1.6]);
    translate([8, 86, 0]) cube([124,4,high - plat -1.6]);
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
        color("red") translate([0, width, high]) rotate([180, 0, 0]) top();
        echo("tb");
    } else {
        top();
    }
}

 
