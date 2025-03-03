/*
 * $Id: rompac.scad 2029 2025-03-02 08:44:02 curt
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

/* size of pin and hole */
pinouter = 4; // fixed by size of PCB hole
pininner = 2.3;
pinhole = 2.45;

// edit this to generate either "b" - bottom
// or "t" - top
// or both -"tb"
express = "tb";

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
    
    translate([pin, width / 2, 0]) cylinder(high - 4, r = pininner);

    translate([bevel_len, sidethick, 0]) cube([length - bevel_len - sidethick, 1, toplip]);
    translate([length - sidethick - 1, sidethick, 0]) cube([1, width - (sidethick * 2), toplip]);
    translate([bevel_len, width - sidethick - 1, 0]) cube([length - bevel_len - sidethick, 1, toplip]);
    linear_extrude(height = 20) {
        polygon([[0, bevel_width + (sidethick *2)], [0, bevel_width + sidethick], 
                [bevel_len, sidethick], [bevel_len, (sidethick*2)]]);
        polygon([[0, width - bevel_width - sidethick], [0, width - bevel_width - (sidethick * 2)], 
                [bevel_len, width - (sidethick * 2)], [bevel_len, width-sidethick]]);
    }
    translate([8,15,0]) cube([2,72, high - plat]);
    translate([36, 12, 0]) cube([96,4, high - plat]);
    translate([8, 86, 0]) cube([124,4, high - plat]);
}

if (search("b", express)) {
    difference() {
        union() {
            edge();
            base();
            translate([pin, width / 2, 0]) cylinder(high-2, r = pinouter);
            platform();
        }
        translate([pin, width / 2, -1]) cylinder(high+2, r = pinhole);
    }
    color("blue") lip();
}

if (search("t", express)) {
    echo("t");
    if (search("b", express)) {
        color("red") translate([0, width, high+2]) rotate([180, 0, 0]) top();
        echo("tb");
    } else {
        top();
    }
}

 
