// Belt parameters
belt_width = 6;                    // width of the belt, typically 6 (mm)     
tooth_radius = 0.8;                // belt tooth radius, 0.8 for GT2 (mm)

$fn = 40;

inside_radius = 30;
outside_radius = 32;

dTheta_inside = 2/inside_radius;
dTheta_outside = 2/outside_radius;
pi = 3.14159;
  
union(){
  difference() {
      difference() {
        cylinder(r=outside_radius, h=belt_width,$fn=pi*2/dTheta_outside);
        cylinder(r=inside_radius, h=belt_width,$fn=pi*2/dTheta_inside);
      };
      belt_cutout(outside_radius, dTheta_inside);
  }
  belt_cutout(inside_radius, dTheta_inside);
}

module belt_cutout(clamp_radius, dTheta) {
  // Belt paths
  for (theta = [0:dTheta:pi*2]) {
    translate([clamp_radius*cos(theta*180/pi), clamp_radius*sin(theta*180/pi),0]) cylinder(r=tooth_radius, h=belt_width);
  }
}

