// Four-servo knob actuator for Carr Super Bee: Treble, Mid, Bass, Reverb.
// Servos hang upside down over the pots (output spline pointing down) and drive
// the 1/4" shafts through 3-piece Oldham couplers, which absorb misalignment.
// Each servo sits on a tube whose bottom pocket slips over that pot's mounting
// nut, so the nuts themselves locate the frame. Nothing is drilled into the amp.
//
// Units: mm. Z = 0 is the control-panel surface; X runs along the row of knobs.
// Values marked MEASURE must be checked with calipers before printing.

part = "assembly";  // "assembly" | "frame" | "hub_pot" | "hub_servo" | "disc" | "couplers"

/* ---------- Amp ---------- */
n_pots      = 4;
pitch       = 38.0;   // MEASURE: shaft center-to-center spacing
nut_af      = 12.7;   // MEASURE: pot nut across flats (1/2" typical for 3/8"-32 bushings)
nut_h       = 3.5;    // MEASURE: nut + washer height above the panel
bushing_d   = 9.6;    // 3/8" threaded bushing
bushing_top = 7.0;    // MEASURE: bushing top above panel
shaft_d     = 6.35;   // 1/4"
shaft_top   = 20.0;   // MEASURE: shaft tip above panel (knob removed)

/* ---------- Servo (standard size; defaults are goBILDA 2000-series) ---------- */
servo_L        = 40.0;  // body length
servo_W        = 20.0;  // body width
ear_hole_dx    = 10.0;  // ear hole spacing across body width
ear_hole_dy    = 48.0;  // ear hole spacing along body length (goBILDA drawing)
ear_span       = 54.3;  // flange length, tip to tip
screw_pilot    = 3.3;   // M4 thread-forming into plastic (or 4.0 for heat-set M3 insert)
spline_offset  = 10.0;  // output axis distance from body center, along length
flange_to_horn = 10.2;  // spline-side face of ears to spline tip (goBILDA drawing; 2.6 ear, 4.1 spline)
servo_dir      = -1;    // +1 / -1: which way the servo bodies extend in Y (away from handle)

/* ---------- Servo horn (round disc horn) ---------- */
horn_d     = 24.0;   // MEASURE
horn_t     = 2.5;    // MEASURE: disc thickness
horn_hub_d = 9.0;    // raised hub around spline on the coupler side, if any
horn_hub_h = 0.0;
horn_bc    = 14.0;   // MEASURE: bolt circle of the two horn holes used
horn_screw = 1.8;    // pilot for M2 self-tappers through the horn

/* ---------- Coupler ---------- */
hub_d     = 18.0;
grip_len  = 10.0;    // depth of shaft bore
key_w     = 6.0;     // Oldham slot width
key_h     = 3.0;     // Oldham slot depth
fit       = 0.25;    // clearance per side on Oldham keys
gap       = 0.4;     // axial gap between coupler pieces
setscrew  = 2.9;     // M3 set screw clearance hole (thread-forming) ...
m3_nut_af = 5.7;     // ... with a captive nut slot

/* ---------- Frame ---------- */
plate_t   = 6.0;
wall      = 2.5;
clear     = 1.0;     // radial clearance around rotating parts
tube_id   = max(horn_d, hub_d) + 2 * clear;
tube_od   = tube_id + 2 * wall;
pocket_d  = nut_af / cos(30) + 0.6;   // round, so nut orientation doesn't matter
window_w  = 12;      // set-screw access window

$fn = 72;
eps = 0.01;

/* ---------- Derived stack heights ---------- */
hubA_h   = grip_len + 2 + key_h;
hubA_z0  = shaft_top - grip_len;
disc_t   = 3.0;
disc_h   = disc_t + 2 * (key_h - 0.2);
hubB_h   = key_h + 3.0;
hubB_z0  = hubA_z0 + hubA_h + gap + disc_t + gap;
horn_z0  = hubB_z0 + hubB_h;
flange_z = horn_z0 + horn_t + horn_hub_h + flange_to_horn;
plate_z0 = flange_z - plate_t;

assert(hubA_z0 > bushing_top + 0.5, "shaft too short: hub would hit bushing; reduce grip_len");
assert(pitch > servo_W + 3, "pitch too tight for side-by-side servos");
if (pitch < tube_od + 2) echo("WARNING: tubes merge; fine, but check knob spacing");

function x_of(i) = i * pitch;

/* ---------- Frame ---------- */
module servo_holes() {
    // relative to the pot axis
    c = servo_dir * spline_offset;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * ear_hole_dx / 2, c + sy * ear_hole_dy / 2, -1])
            cylinder(d = screw_pilot, h = 50);
}

module servo_body_cut() {
    c = servo_dir * spline_offset;
    // body passes through the plate, plus clearance below it for the case top
    translate([-(servo_W + 1) / 2, c - (servo_L + 1) / 2, plate_z0 - (flange_to_horn - plate_t) - 1])
        cube([servo_W + 1, servo_L + 1, flange_to_horn + 2]);
}

module plate_outline() {
    c = servo_dir * spline_offset;
    y0 = min(c - ear_span / 2, -tube_od / 2) - 3;
    y1 = max(c + ear_span / 2,  tube_od / 2) + 3;
    translate([-tube_od / 2 - 2, y0, plate_z0])
        cube([x_of(n_pots - 1) + tube_od + 4, y1 - y0, plate_t]);
}

module tube(i) {
    translate([x_of(i), 0, 0]) difference() {
        cylinder(d = tube_od, h = plate_z0 + eps);
        translate([0, 0, -eps]) cylinder(d = tube_id, h = plate_z0 + 1);
    }
}

module nut_seat(i) {
    // thick ring at the bottom that registers on the nut
    translate([x_of(i), 0, 0]) difference() {
        cylinder(d = tube_od, h = nut_h + 2);
        translate([0, 0, -eps]) cylinder(d = pocket_d, h = nut_h + 0.3);
        translate([0, 0, -eps]) cylinder(d = bushing_d + 2, h = 20);
    }
}

module frame() {
    difference() {
        union() {
            plate_outline();
            for (i = [0 : n_pots - 1]) { tube(i); nut_seat(i); }
            // webs tying neighboring tubes together low down, for stiffness
            for (i = [0 : n_pots - 2])
                translate([x_of(i), -wall, 0]) cube([pitch, 2 * wall, plate_z0]);
        }
        for (i = [0 : n_pots - 1]) translate([x_of(i), 0, 0]) {
            // keep the webs out of the bore and the nut pocket
            translate([0, 0, nut_h + 2]) cylinder(d = tube_id, h = plate_z0 - nut_h - 2 - eps);
            translate([0, 0, -eps]) cylinder(d = pocket_d, h = nut_h + 0.3);
            translate([0, 0, -eps]) cylinder(d = bushing_d + 2, h = nut_h + 3);
            servo_body_cut();
            servo_holes();
            // set-screw window, facing the open side of the tube
            translate([0, -servo_dir * tube_od / 2, hubA_z0 + grip_len / 2])
                cube([window_w, tube_od, window_w * 1.6], center = true);
            // wire / view slot on the other side
            translate([0, servo_dir * tube_od / 2, (nut_h + 2 + plate_z0 - (flange_to_horn - plate_t)) / 2])
                cube([window_w, tube_od, 10], center = true);
        }
    }
}

/* ---------- Oldham coupler ---------- */
module key_slot(rot) {
    rotate([0, 0, rot]) cube([hub_d + 2, key_w + 2 * fit, 2 * key_h], center = true);
}

module hub_pot() {
    // grips the pot shaft with an M3 set screw; slot along X on top
    difference() {
        cylinder(d = hub_d, h = hubA_h);
        translate([0, 0, -eps]) cylinder(d = shaft_d + 0.2, h = grip_len + eps);
        translate([0, 0, hubA_h]) key_slot(0);
        // set screw, radial, with captive nut slot opening at the bottom
        translate([0, 0, grip_len / 2]) rotate([0, 90, 0]) cylinder(d = setscrew, h = hub_d);
        translate([shaft_d / 2 + 2.2, -m3_nut_af / 2, -eps]) cube([2.6, m3_nut_af, grip_len / 2 + m3_nut_af / 2]);
    }
}

module disc() {
    // tongue along X below, along Y above
    tongue = key_h - 0.2;
    cylinder(d = hub_d, h = disc_t);
    translate([0, 0, -tongue / 2]) cube([hub_d, key_w, tongue + eps], center = true);
    translate([0, 0, disc_t + tongue / 2]) rotate([0, 0, 90]) cube([hub_d, key_w, tongue + eps], center = true);
}

module hub_servo() {
    // slot along Y underneath; flat top screws to the servo's round horn
    difference() {
        cylinder(d = hub_d, h = hubB_h);
        key_slot(90);
        if (horn_hub_h > 0) translate([0, 0, hubB_h - horn_hub_h]) cylinder(d = horn_hub_d + 0.6, h = horn_hub_h + 1);
        for (a = [0, 180]) rotate([0, 0, a]) translate([horn_bc / 2, 0, key_h]) cylinder(d = horn_screw, h = hubB_h);
        // indicator notch so knob position is visible through the window
        translate([hub_d / 2, 0, hubB_h / 2]) cube([2, 1.5, hubB_h + 1], center = true);
    }
}

/* ---------- Placeholders for the assembly view ---------- */
module ghost_servo(i) {
    c = servo_dir * spline_offset;
    translate([x_of(i), 0, 0]) color("dimgray", 0.6) {
        translate([-servo_W / 2, c - servo_L / 2, flange_z - (flange_to_horn - 4)]) cube([servo_W, servo_L, 38]);
        translate([-servo_W / 2 + 4, c - ear_span / 2, flange_z]) cube([servo_W - 8, ear_span, 2.5]);
        translate([0, 0, horn_z0]) cylinder(d = horn_d, h = horn_t);
        translate([0, 0, horn_z0 + horn_t]) cylinder(d = 6, h = flange_to_horn);
    }
}

module assembly() {
    color("orange", 0.85) frame();
    for (i = [0 : n_pots - 1]) {
        ghost_servo(i);
        translate([x_of(i), 0, 0]) {
            color("royalblue") translate([0, 0, hubA_z0]) hub_pot();
            color("gold")      translate([0, 0, hubA_z0 + hubA_h + gap]) disc();
            color("seagreen")  translate([0, 0, hubB_z0]) hub_servo();
        }
    }
    color("silver") for (i = [0 : n_pots - 1]) translate([x_of(i), 0, 0]) {
        cylinder(d = nut_af / cos(30), h = nut_h, $fn = 6);
        cylinder(d = bushing_d, h = bushing_top);
        cylinder(d = shaft_d, h = shaft_top);
    }
}

echo(str("plate underside at z = ", plate_z0, " mm; servo ears at z = ", flange_z, " mm above panel"));
echo(str("tube OD = ", tube_od, " mm; frame length = ", x_of(n_pots - 1) + tube_od + 4, " mm"));

/* ---------- Output ---------- */
if (part == "assembly") assembly();
else if (part == "frame") rotate([180, 0, 0]) translate([0, 0, -flange_z]) frame();  // print plate-down
else if (part == "hub_pot") hub_pot();
else if (part == "hub_servo") rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
else if (part == "disc") translate([0, 0, key_h - 0.2]) disc();
else if (part == "couplers")
    for (i = [0 : n_pots - 1]) translate([i * (hub_d + 4), 0, 0]) {
        hub_pot();
        translate([0, hub_d + 4, key_h - 0.2]) disc();
        translate([0, 2 * (hub_d + 4), 0]) rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
    }
