error = 0.2; // how much increase for error during print

// Zigarettenanzünder
module kfz() {
    union() {
        cylinder(d=28.5, h=55, $fn=60); // core
        translate([0,-1,0]) cube([15.5,2,22]);
        scale([1.60,1,1]) cylinder(d=35.5, h=2.5, $fn=60); // rubber
        translate([20,0,0]) cylinder(d=2.5,h=12, $fn=30); //screw
        translate([-20,0,0]) cylinder(d=2.5,h=12, $fn=30); //screw
    }
}

module din() {
    translate([0,0,-30]) cylinder(h=45, d=26.5, $fn=60); // core
    translate([0,0,-02]) cube([36.5, 36.5, 4], center=true); //screw plate
    translate([0,-6,-25]) cube([30, 50, 15], center=true); // cover
    translate([15,15,0]) cylinder(h=7, d=2, $fn=30); // screw
    translate([-15,15,0]) cylinder(h=7, d=2, $fn=30); // screw
    translate([-15,-15,0]) cylinder(h=7, d=2, $fn=30); // screw
    translate([15,-15,0]) cylinder(h=7, d=2, $fn=30); // screw
}

module wireStrapHolder(center=[0,0,0], rotation=[0,90,0], inner=2.0, outer=5.5, width=2.75+2*error) {
    translate(center){
        rotate(rotation){
            difference(){
                translate([0,0,-width/2]) cylinder(h=width, r=outer, center = true);
                translate([0,0,-width/2]) cylinder(h=width, r=inner, center = true);
                translate([0,0,outer]) cube(2*outer, center=true);

            };
        };
    };
};

module edgeHolder(angle=0, center=[0,0,0]) {
    translate(center) rotate([0,0,angle]) {
        translate([-4,0,-20]) cube([3,7,45], center=true);
        translate([0,0,-1]) cube([5,7,7], center=true);
        translate([0,0,-15]) cube([5,5,3], center=true);
        translate([0,0,-32]) cube([5,5,3], center=true);
    }
};
module switch() {
    translate([0,-2,0]) cube([32.5,2,15]); // front
    translate([2.25,0,1.5]) cube([28+2*error,35,12]); // case
    translate([08,0,0.8]) cube([3,4,13.4]); // dent for the small triangles at the side
    translate([21,0,0.8]) cube([3,4,13.4]); // dent for the small triangles at the side
    translate([-1.25,2,1.5]) cube([35,35,12]); // wider space inside
}

module pcbHolder(h=41, d=5.5){
    difference() {
        translate([-d/2,-d/2,-h]) cube([d, d, h]);
        translate([0, 0, -10]) cylinder(d=2, h=10.1, $fn=20);        
    }
}

module wireHolder() {
    translate([-1, 1, 0]) rotate([90,0,0]) intersection() {
        union() {
            translate([1,0,-1]) rotate([0,0,0]) difference() {cylinder(r=7,h=2); translate([0,0,-1]) cylinder(r=5,h=4);};
            translate([0,0,0]) rotate([0,90,0]) difference() {cylinder(r=7,h=2); translate([0,0,-1]) cylinder(r=5,h=4);};
        }
        translate([-8,0,-8]) cube(16);
    }    
}

color("white") difference() {
    translate([-9.2,-1,-41.5]) intersection() {
        translate([0.75,0.75,0.75]) minkowski() {
            cube([148.5,78.5,42.25]);
            sphere(d=1.5, $fn=180);
        }
        cube([150,80,43]);
    };
    // pcb
    cube([100 + 2*error, 60 + 2*error, 1.6 + error]);
    // space below PCB, about 5mm needed (max)
    translate([2.5,2.5,-6]) cube([95,55,7.001]);
    // powerOutlets
    translate([28.5-9.2,-2.5,-41.5+19.5]) rotate([-90,15,0]) kfz();
    translate([83-9.2,-2.5,-41.5+19.5]) rotate([-90,-165,0]) kfz();
    translate([150-9.2+0.1,56,-20]) rotate([-90,0,0]) rotate([0,-90,0]) din();
   
    // switches
    translate([150-9.2+0.1,4,-20]) rotate([0,0,90]) switch();
    translate([150-9.2+0.1,4,-35]) rotate([0,0,90]) switch();
    // add to virtual switches to open the "cut" fully, avoid unprintable bridges
    translate([150-9.2+0.1,4,-10]) rotate([0,0,90]) switch();
    translate([150-9.2+0.1,4,-27.5]) rotate([0,0,90]) switch();

    // free space for cables, & stoff
    translate([10-9.2,12-1,-41.5+2]) cube([130,58,45]);
    
    // mounting options (wire straps)
    wireStrapHolder(center=[0-9.2,-1,-2.0], rotation=[0,0,0], inner=7.5, outer=10, width=5);
    wireStrapHolder(center=[0-9.2,-1,-34.0], rotation=[0,0,0], inner=7.5, outer=10, width=5);
    wireStrapHolder(center=[0-9.2,80-1,-2.0], rotation=[0,0,0], inner=7.5, outer=10, width=5);
    wireStrapHolder(center=[0-9.2,80-1,-34.0], rotation=[0,0,0], inner=7.5, outer=10, width=5);
    wireStrapHolder(center=[61-9.2,0-1,-41.5], rotation=[90,90,90], inner=7.5, outer=10, width=5);
    
    edgeHolder(center=[130,80-1,0], angle=90);
    edgeHolder(center=[92,80-1,0], angle=90);
    edgeHolder(center=[54,80-1,0], angle=90);
    edgeHolder(center=[16,80-1,0], angle=90);
    
    edgeHolder(center=[-9.2,24,0], angle=180);
    edgeHolder(center=[-9.2,54,0], angle=180);

    // additional screw, addition to the from the PCB
    translate([150-9.2-5, 45 -1, -8]) cylinder(h=10, d=2, $fn=20);
}

// pcb holder
color("blue") translate([5,3.75,0]) pcbHolder(h=9);
color("blue") translate([95,5,0]) pcbHolder(h=9);
color("blue") translate([95,55,0]) intersection() {pcbHolder(d=8); translate([0,0,-50]) cylinder(d=10, h=55);}
color("blue") translate([5,55,0]) pcbHolder();
color("blue") translate([0,52.25,-41]) cube([3,5.5,41]); 


// wireHolder on the bottom
color("blue") translate([48,22,-40]) wireHolder(); 
color("blue") translate([48,60,-40]) wireHolder(); 
color("blue") translate([80,60,-40]) wireHolder(); 

// parts
//color("red") translate([100,60,0]) rotate([0,0,180]) import("PCB.stl");
//color("red") translate([28.5-9.2,-2.5,-41.5+19.5]) rotate([-90,15,0]) kfz();
//color("red") translate([83-9.2,-2.5,-41.5+19.5]) rotate([-90,-165,0]) kfz();
//color("red") translate([150-9.2+0.1,56,-20]) rotate([-90,0,0]) rotate([0,-90,0]) din();
//color("red") translate([150-9.2+0.1,4,-20]) rotate([0,0,90]) switch();
//color("red") translate([150-9.2+0.1,4,-35]) rotate([0,0,90]) switch();


