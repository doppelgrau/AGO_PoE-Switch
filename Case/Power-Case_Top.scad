error = 0.2; // how much increase for error during print
height = 16.0;

module screwHole(center=[0,0,0]) {
    bottomClearance = 0.6;
    $fn=40;
    translate(center) translate([0,0,bottomClearance]) {
        difference() {
            cylinder(h=height - bottomClearance, d=6 + 2*1.2);
            translate([0,0,-0.1]) cylinder(h=height + 0.1, d= 3.5);
            translate([0,0,1.2]) cylinder(h=0.75, d1=3.5, d2=6); 
            translate([0,0,1.9]) cylinder(h=height, d=6); 
        }
    }
}

module switch() {
    translate([0,-2,0]) cube([32.5,2,15]); // front
    translate([2.25,0,1.5]) cube([28+2*error,35,12]); // case
    translate([08,0,0.8]) cube([3,4,13.4]); // dent for the small triangles at the side
    translate([21,0,0.8]) cube([3,4,13.4]); // dent for the small triangles at the side
    translate([-1.25,2,1.5]) cube([35,35,12]); // wider space inside
}

module black() {
    color("white") difference() {
        translate([-9.2,-1,0]) intersection() {
            translate([0.75,0.75,-0.75]) minkowski() {
                cube([148.5,78.5,height]);
                sphere(d=1.5, $fn=180);
            }
            cube([150,80,height]);
        };
        // free above PCB (enough for most parts)
        translate([-0.25,1,-0.1]) cube([101,60,12.6+0.1]);
        // chane to get power to the top of the pcb
        translate([100,6,10.1]) rotate([0,220,0]) mirror([1,0,0]) cube([101,50,12.6+0.1]);

        // opening for the ethernet ports
        translate([11.15,-1.1,-0.1]) cube([59.6,23,14.25+0.1]);
        translate([53.95,24.3,0.1]) cube([16.3,12.3, height]);
        
        // space above connector
        translate([84,13,-0.1]) cube([13,12.5,14.25+0.1]);
        
        // holes for the screws
        translate([150-9.2-5, 45 -1, -0.1]) cylinder(h=17, d=6, $fn=30);
        translate([5,3.75,0]) cylinder(h=17, d=6, $fn=30);
        translate([95,5,0]) cylinder(h=17, d=6, $fn=30);
        translate([95,55,0]) cylinder(h=17, d=6, $fn=30);
        translate([5,55,0]) cylinder(h=17, d=6, $fn=30);
        
        // thin area above LEDs and make sure no transparent parts is filled with black
        translate([22,52,-0.1]) cube([33,11,height - 1.0 +0.1]);
        transparent();
        
        // mark the LEDs
        for (x=[1:1:5])  translate([22 + x*4.75 - 4.75/2,57.5 + 10,height - 0.5]) linear_extrude(height = 0.55) text(text=str(x), size=5, valign = "center", halign = "center"); 
       translate([51,57.5 + 10,height - 0.5]) linear_extrude(height = 0.55) text(text="P", size=5, valign = "center", halign = "center"); 

        // mark the ports
        for (x=[1:1:4])  translate([10 + x*15 - 7.5,7,height - 0.5]) linear_extrude(height = 0.55) text(text=str(x), size=8, valign = "center", halign = "center"); 
       translate([75,30,height - 0.5]) linear_extrude(height = 0.55) text(text="5", size=8, valign = "center", halign = "center"); 
       translate([45,30,height - 0.5]) linear_extrude(height = 0.55) text(text="PC", size=8, valign = "center", halign = "center"); 

    }

    // pcb holder
    color("blue") screwHole(center=[5,3.75,0]);
    color("blue") screwHole(center=[95,5,0]);
    color("blue") screwHole(center=[95,55,0]);
    color("blue") screwHole(center=[5,55,0]);
    color("blue") screwHole(center=[150-9.2-5, 45 -1, 0]);

    // close the hole created for the switches
    color("blue") difference() {
        union() {
            translate([150-9.2 - 10, 4 -0.25, -10]) cube([8.0,33,12]);
            translate([150-9.2 - 2, 4 +2.7 , -10]) cube([2,27.5,12]);        
        }
        translate([150-9.2+0.1,4,-22.0]) rotate([0,0,90]) switch();
    }

    // LEDs
    color("blue") for (x=[22:4.75:50])  translate([x,50,0.75]) cube([0.8, 18, height - 0.75 - 0.8]);
    color("blue") translate([54.5,50,0.75]) cube([0.8, 18, height - 0.75 - 0.8]);
    color("blue") translate([22,50,5]) cube([33, 0.8, height - 5 - 0.8]);
    

}

module transparent() {
    translate([21,51,height - 1.1]) cube([35,13,0.301]);
    translate([22,52,height - 0.8]) cube([33,11,0.801]);
}

//black();
transparent();

//parts
//color("red") translate([100,60,-1.5]) rotate([0,0,180]) import("PCB.stl");
