//translate([0,40,-10/2])cube([340,310,10],center=true);
//Defines

sin60 = 0.866025;
cos60 = 0.5;
explode = 0.0;   // set > 0.0 to push the parts apar1t

delta_min_angle = 21; // the minimul angle of the diagonal rod as full extension while still being on the print surface  

frame_motor_h = 60;  //heaight of motor fram vertex
frame_top_h = 20;
 
frame_extrusion_l = 353; //length of extrusions for horizontals, need cut length
frame_extrusion_h = 920; //length of extrusions for towers, need cut length
frame_extrusion_w = 20;
frame_depth = frame_extrusion_w/2; // used when calculating offsets

// Offsets from a virtual point connecting axles of the two horizontal beams...
// ...to the vertical beam axle
vertex_v_beam_offset = 14.12; //+10/sin(30);
// ...to the horizontal beam butt-end
vertex_h_beam_offset = 30.51; //+10/tan(30);

frame_wall_thickness = 3.6;
// need the distance from the center of the vertical beam to the center of the machine
//frame_r = (frame_extrusion_l/2+vertex_h_beam_offset)/sin60-vertex_v_beam_offset;
frame_r = (frame_extrusion_l/2+vertex_h_beam_offset)/cos(30)-vertex_v_beam_offset;
//cos(60) = Adjacent/hypotenuse so hypotenuse = adjacent/cos(60)
frame_size = frame_r  + explode;//151.5 + explode;
//frame_offset = (frame_r * cos60) + frame_extrusion_w - vertex_x_offset/2 + explode;//92 + explode;    
frame_offset = (frame_r + vertex_v_beam_offset) * sin(30) + frame_extrusion_w/2;
// distance to move a centered extrusion from center of build area to where it needs to be in relation to verticies
frame_top = frame_extrusion_h - frame_extrusion_w + explode; 
// I use 30mm based on my own printer. This could vary on how you set up your tensioning/belt length and may allow you to regain soem lost Z if you need it.

effector_h = 8; //height of effector so we can get it centered. From effector.scad
effector_offset = 28; // horizontal distance from center to pivot from effector.scad
rod_separation = 22.5; // Distance from one rod to it's parallel

//rail_depth= 17.55 - 7.5;   // 17.55 from the tower_slides.scad file
//rail_depth = 25; // the further the carriage is from the slider, the shorter the diagonal rod and we regain max z
//truck_depth=0; // no trucks for printed slides

rail_length = 650;
rail_r_offset = frame_depth + explode; 
rail_depth = 8 + explode;    // mgn12 rail is 8mm high
truck_depth = 5 + explode;   // mgn12H/C rail is 5mm high
//rail_z_offset = 112;         // distance from top of motor frame to bottom of rail


endstop_h = 15;              // from endstop.scad
endstop_depth = 7;     // from endstop.scad
endstop_r_offset = frame_depth;

carriage_length = 40;        //from carriage.scad
carriage_pivot_offset = carriage_length/2;  // the distance from the bottom of the carriage to the pivot point, from the carriage.scad and after the 4mm shift to align the bottom of the carriage.stl with 0
carriage_depth = 13;         //from carriage.scad
carriage_r_offset = rail_depth + truck_depth + frame_depth + explode; // how far to move the carriage away from center

// diagonal rods
DELTA_SMOOTH_ROD_OFFSET = frame_r;///cos(30);  //COS(60/2) = A/H  H is our smooth rod offset
DELTA_RADIUS = DELTA_SMOOTH_ROD_OFFSET - effector_offset - (frame_depth + rail_depth + truck_depth + carriage_depth/2 );
DELTA_DIAGONAL_ROD =((DELTA_RADIUS*2) - effector_offset) / cos(delta_min_angle); // remember we need to subtract the effector offset so we account for keeping the hotend tip on the edge of the build surface
rod_r = 6/2; // 6mm carbon fiber rods? Just for show anyways
delta_rod_angle = acos(DELTA_RADIUS/DELTA_DIAGONAL_ROD); // angle of delta diagonal rod when homed
delta_vert_l = sqrt((DELTA_DIAGONAL_ROD*DELTA_DIAGONAL_ROD)-(DELTA_RADIUS*DELTA_RADIUS));  //the distance from the pivot on the effecto to the pivot on the carriage
surface_r = DELTA_SMOOTH_ROD_OFFSET * sin(30) + effector_offset - frame_depth - frame_wall_thickness ;  //the -4 is the thickness of the motor frame wall

echo("Horizontal length:", frame_extrusion_l, "mm");
echo("Vertical length:",frame_extrusion_h,"mm");
echo("DELTA_RADIUS:", DELTA_RADIUS, "mm");
echo("DELTA_SMOOTH_ROD_OFFSET:",DELTA_SMOOTH_ROD_OFFSET,"mm");
echo("DELTA_DIAGONAL_ROD:",DELTA_DIAGONAL_ROD,"mm");
echo("DELTA vertical length:",delta_vert_l,"mm");
echo("Delta_rod_angle:",delta_rod_angle,"mm when homed");
echo("Build plate radius:",surface_r,"mm");

//translate([0,DELTA_RADIUS/2+20,370])rotate([0,0,0])cube([8,DELTA_RADIUS,8],center=true);

//frame_color=[0.7,0.25,0.7,0.98];
//frame_color2=[0.9,0.3,0.9,0.88];
frame_color=[0.6,0.6,0.6,0.98];
frame_color2=[0.65,0.65,0.65,0.88];
rod_color=[0.1,0.1,0.1,0.88];
t_slot_color="silver";
rail_color = [1,1,1,1];
plate_color=[0.7,0.7,1.0,0.5];

//calc_slider_z = frame_top - (frame_motor_h + frame_top_h + endstop_h ) - delta_vert_l ;
calc_slider_z = frame_top - (endstop_h + carriage_length + delta_vert_l + effector_h + 25);
//calc_slider_z = frame_motor_h + rail_z_offset + rail_length - carriage_length - delta_vert_l - endstop_h; // need to know where to draw the linear trucks or sliders
effector_z = calc_slider_z; // need to know where to draw the effector

plate_d = surface_r * 2;
plate_thickness = 3;
glass_tab_thickness = 15;
plate_z = plate_thickness/2 + frame_motor_h +glass_tab_thickness;// + plate_thickness; //not added yet, but there will be glass tabes (5mm) and the plate thickness is 3)

calc_carriage_z = frame_top - endstop_h - carriage_length;
//echo (calc_carriage_z);
hotend_l = 30;
calc_max_z = calc_carriage_z - ( plate_z + hotend_l + delta_vert_l);

rail_z_offset = glass_tab_thickness+plate_thickness/2+hotend_l+DELTA_DIAGONAL_ROD*sin(delta_min_angle)-carriage_pivot_offset;
echo(str("Rail Z offset: ", rail_z_offset, "mm"));

echo("Max Build Height:",calc_max_z,"mm assuming a narrow tower or cone shaped build.");


$fn=32;

//Horizontal t-slot
for (al = [0:120:360-1]) {
    rotate(al) {
        translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2-explode])rotate([0,90,0]) color(t_slot_color) extrusion_20(frame_extrusion_l);
        translate([-frame_extrusion_l/2,-frame_offset,frame_motor_h-frame_extrusion_w/2-explode])rotate([0,90,0]) color(t_slot_color)extrusion_20(frame_extrusion_l);
    }
}

//motor_frame
translate([-(sin60*frame_size),-(cos60*frame_size),0-explode]) rotate([0,0,-60])color(frame_color)import("frame_motor.stl"); //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),0-explode]) rotate([0,0,60])color(frame_color)import("frame_motor.stl");   //y-tower
translate([0,frame_size,0-explode])rotate([0,0,180]) color(frame_color)import("frame_motor.stl");       //z-tower
//translate([0,frame_size,frame_motor_h-explode])rotate([0,0,180]) color(frame_color)import("../../kossel-master/BOM_tight/frame_motor.stl");       //z-tower


//vertical t-slot
translate([-(sin60*frame_size),-(cos60*frame_size),0]) rotate([0,0,-60])color(t_slot_color)extrusion_20(frame_extrusion_h);  //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),0]) rotate([0,0,60])color(t_slot_color)extrusion_20(frame_extrusion_h);   //y-tower
translate([0,frame_size,0]) rotate([0,0,180])color(t_slot_color)extrusion_20(frame_extrusion_h);   //z-tower


//top frame
translate([-(sin60*frame_size),-(cos60*frame_size),frame_top]) rotate([0,0,-60])color(frame_color)import("frame_top.stl"); //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),frame_top]) rotate([0,0,60])color(frame_color)import("frame_top.stl");   //y-tower
translate([0,frame_size,frame_top]) rotate([0,0,180])color(frame_color)import("frame_top.stl");       //z-tower

//Top t-slot
translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_20(frame_extrusion_l); //X-Y
rotate([0,0,120])translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_20(frame_extrusion_l); //Y-Z
rotate([0,0,-120])translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_20(frame_extrusion_l); //X-Z


/*//slides
translate([-(sin60*(frame_size)),-(cos60*(frame_size)),calc_carriage_z])rotate([0,0,-60])color(frame_color)import("tower_slides.stl");
translate([(sin60*(frame_size)),-(cos60*(frame_size)),calc_carriage_z])rotate([0,0,60])color(frame_color)import("tower_slides.stl");
translate([0,frame_size,calc_carriage_z])rotate([0,0,180])color(frame_color)import("tower_slides.stl");
*/

//rails
translate([-(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),calc_carriage_z+carriage_length-rail_length]) rotate([0,0,-60])color(rail_color) rail(rail_length);//import("rail_400mm.stl"); //x-tower rail
translate([(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),calc_carriage_z+carriage_length-rail_length]) rotate([0,0,60])color(rail_color) rail(rail_length);//import("rail_400mm.stl"); //y-tower rail
translate([0,frame_size-rail_r_offset,calc_carriage_z+carriage_length-rail_length]) rotate([0,0,180])color(rail_color)rail(rail_length);//import("rail_400mm.stl"); //z-tower rail
//trucks mgn12H
translate([-(sin60*(frame_size-rail_r_offset-explode)),-(cos60*(frame_size-rail_r_offset-explode)),calc_carriage_z-6.5]) rotate([0,0,-60])color("green")import("mgn12c.stl"); //z-tower truck
translate([(sin60*(frame_size-rail_r_offset-explode)),-(cos60*(frame_size-rail_r_offset-explode)),calc_carriage_z-6.5]) rotate([0,0,60])color("green")import("mgn12c.stl"); //z-tower truck
translate([0-explode,frame_size-rail_r_offset-explode,calc_carriage_z-6.5]) rotate([0,0,180])color("green")import("mgn12c.stl"); //z-tower truck


//Carriages
translate([-(sin60*(frame_size-carriage_r_offset)),-(cos60*(frame_size-carriage_r_offset)),calc_carriage_z])  rotate([90,0,120])translate([0,carriage_length/2,0])color(frame_color2)import("carriage.stl"); //x-tower rail
translate([(sin60*(frame_size-carriage_r_offset)),-(cos60*(frame_size-carriage_r_offset)),calc_carriage_z])  rotate([90,0,60+180])translate([0,carriage_length/2,0])color(frame_color)import("carriage.stl"); //y-tower rail
translate([0,frame_size-carriage_r_offset,calc_carriage_z]) rotate([90,0,0])translate([0,carriage_length/2,0])color(frame_color2)import("carriage.stl"); //z-tower rail

//endstops
//X tower
//translate([-(sin60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),-(cos60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),calc_carriage_z+carriage_length-rail_length-endstop_h-explode]) rotate([0,0,-60+180])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([-(sin60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),-(cos60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),calc_carriage_z+carriage_length+explode]) rotate([0,0,-60+180])color(frame_color)import("endstop.stl"); //x-tower upper endstop
//Y tower
//translate([(sin60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),-(cos60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),calc_carriage_z+carriage_length-rail_length-endstop_h-explode]) rotate([0,0,60+180])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([(sin60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),-(cos60*(frame_size-endstop_r_offset-endstop_depth/2-explode)),calc_carriage_z+carriage_length+explode]) rotate([0,0,60+180])color(frame_color)import("endstop.stl"); //x-tower upper endstop
//z tower
//translate([0-explode,frame_size-endstop_r_offset-endstop_depth/2-explode,calc_carriage_z+carriage_length-rail_length-endstop_h-explode])rotate([0,0,0])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([0-explode,frame_size-endstop_r_offset-endstop_depth/2-explode,calc_carriage_z+carriage_length+explode]) rotate([0,0,0])color(frame_color)import("endstop.stl"); //x-tower upper endstop


//effector - need to flip it and move it up by 1 height to get it to zero on bottom of effector
translate([0,0,frame_motor_h + effector_h + effector_z - explode*2]) rotate([0,180,60])color(frame_color)import("effector.stl"); //x-tower upper endstop

//hotend
translate([0,0,frame_motor_h + effector_h + effector_z -hotend_l/2 - explode*2]) color(t_slot_color) cylinder(h=hotend_l,r=10,center=true);

// Build plate
translate([0,0,plate_z+explode])
    bed();

/*translate([0,0,plate_z+explode])color(plate_color)cylinder(h=plate_thickness,r=plate_d/2,center=true,$fn=120);
// Glass tabs
for(i=[0:2]) {
 rotate(i*120){
  translate([0,-frame_offset,frame_motor_h+explode/4]) rotate([0,180,0]) color(frame_color)import("glass_tab.stl"); //X-Z
  //translate([0,-frame_offset,frame_motor_h+7.5+3+explode*2]) rotate([0,180,-30]) translate([2,-2,0])color(frame_color)import("Spiral_Bed_Clamp.stl"); // needed to translate the clamp so the hole was centered.
 }
}*/

//Diagonal Rods
for(i=[0:2]) {
  rotate(i*120) {
   translate([rod_separation,effector_offset,frame_motor_h + effector_h/2 + effector_z - explode]) rotate([-(90-delta_rod_angle),0,0]) color(rod_color) cylinder(h=DELTA_DIAGONAL_ROD, r=rod_r);
   translate([-rod_separation,effector_offset,frame_motor_h + effector_h/2 + effector_z - explode]) rotate([-(90-delta_rod_angle),0,0]) color(rod_color) cylinder(h=DELTA_DIAGONAL_ROD, r=rod_r);
  }
}
translate([rod_separation,effector_offset,frame_motor_h + effector_h/2 + effector_z - explode]) rotate([0,-90,-90]) color("blue") cylinder(h=DELTA_RADIUS, r=rod_r);
translate([rod_separation,effector_offset+DELTA_RADIUS,frame_motor_h + effector_h/2 + effector_z - explode]) rotate([0,0,-90]) color("orange") cylinder(h=delta_vert_l, r=rod_r);
//Ramps mount
//translate([-80,145,40])rotate([0,0,-120]) color(frame_color)import("mega2560_kutu_Kulak.stl");


// This module is used to create a dynamic length extrusion from a 1000mm extrusion STL file
module extrusion_15(len=240){
  difference(){
    import("1515_1000mm.stl", convexity=10);
    translate([-10,-10,len])cube([20,20,(1000-len)+2]);
  }

}

// This module is used to create a dynamic length rail from a 1000mm rail STL file
module rail(len=240){
  difference(){
    import("rail_1000mm.stl", convexity=10);
    translate([-10,-10,len])cube([20,20,(1000-len)+2]);
  }

}

module extrusion_20(len=240){
  difference(){
    import("2020_1000mm.stl", convexity=10);
    translate([-12,-12,len])cube([24,24,(1000-len)+2]);
  }

}

module bed()
{
    bed_d = 265;
    ear_w = 100;
    ear_h = 5;
    ear_hole_shift_w = 7;
    ear_hole_shift_h = 8;
    
    screw_d = 3.2;

    // Build area
    translate([0,0,plate_thickness/2])
        color("red",0.5)
            cylinder(r=surface_r,h=0.01,$fn=128);

    color(plate_color)
    linear_extrude(height=plate_thickness,center=true) {
        difference() {
            union() {
                circle(d=bed_d,$fn=128);
                for (a = [0:120:360-1]) {
                    rotate(a+180)
                        translate([-ear_w/2,0])
                            square([ear_w,bed_d/2+ear_h]);
                }
            }
    
            for (a = [0:120:360-1]) {
                for (m = [0,1]) {
                    rotate(a+180)
                        mirror([m,0,0])
                            translate([ear_w/2-ear_hole_shift_w,bed_d/2+ear_h-ear_hole_shift_h])
                                circle(d=screw_d);
                }
            }
        }
    }
}