// Four-servo knob actuator for Carr Super Bee: Treble, Mid, Bass, Reverb.
// Servos hang upside down over the pots (output spline pointing down) and drive
// the 1/4" shafts through 3-piece Oldham couplers, which absorb misalignment.
// Each servo sits on a tube whose bottom pocket slips over that pot's mounting
// nut, so the nuts themselves locate the frame. Nothing is drilled into the amp.
//
// Units: mm. Z = 0 is the control-panel surface; X runs along the row of knobs.
// Values marked MEASURE must be checked with calipers before printing.

part = "assembly";  // "assembly" | "frame" | "test_station" | "coupler_set" | "hub_pot" | "hub_servo" | "disc" | "couplers"

/* ---------- Amp ---------- */
n_pots      = 4;
pitch       = 34.70;  // measured: 1.366" center-to-center (1.616" outside-to-outside minus 1/4")
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
screw_pilot    = 2.5;   // for the self-tapping screws that come with the servo (skip the rubber grommets)
spline_offset  = 10.0;  // output axis distance from body center, along length
flange_to_horn = 10.2;  // spline-side face of ears to spline tip (goBILDA drawing; 2.6 ear, 4.1 spline)
spline_h       = 4.1;
servo_dir      = -1;    // +1 / -1: which way the servo bodies extend in Y (away from handle)

/* ---------- Servo horn: 19.8 mm aluminum 25T disc, boss toward the servo, 4 x M3 tapped ---------- */
horn_d      = 19.8;
horn_t      = 2.45;  // disc thickness
horn_h      = 4.5;   // overall, disc + 9 mm spline boss
horn_bc     = 14.0;  // tapped-hole circle; the coupler uses two opposite holes
horn_screw  = 3.4;   // M3 x 6 button head, from below, into the horn's threads
horn_head_d = 6.2;   // counterbore for the M3 button heads
horn_cscrew_d = 6.5; // recess for the head of the horn's center screw

/* ---------- Coupler ---------- */
hub_d     = 22.0;     // room for M3 button-head counterbores on the 14 mm horn bolt circle
grip_len  = 10.0;    // depth of shaft bore
key_w     = 4.0;     // Oldham tongue width
key_offset = 1.2;    // tongues sit off-center so each joint only goes together one way round
                     // (kept small enough that the slot clears the horn-screw counterbores)
key_h     = 3.0;     // Oldham slot depth
fit       = 0.25;    // clearance per side on Oldham keys
gap       = 0.4;     // axial gap between coupler pieces
setscrew  = 2.9;     // M3 set screw clearance hole (thread-forming) ...
m3_nut_af = 5.7;     // ... with a captive nut slot

/* ---------- Frame ---------- */
floor_t   = 1.2;     // floor under the servo pocket, so the tube walls don't start in midair when printing
plate_t   = flange_to_horn - spline_h + 0.4 + floor_t;  // pocket swallows the servo case below the ears
wall      = 2.5;
clear     = 1.0;     // radial clearance around rotating parts
tube_id   = max(horn_d, hub_d) + 2 * clear;
tube_od   = tube_id + 2 * wall;
pocket_d  = nut_af / cos(30) + 0.6;   // round, so nut orientation doesn't matter
window_w  = 12;      // set-screw access window

/* ---------- Phidgets 1061 board, hung under a shelf on the side away from the servo bodies ---------- */
board            = true;
board_L          = 58.4;   // 2.300"
board_W          = 48.3;   // 1.900"
board_hole_dx    = 50.8;   // 2.000"
board_hole_dy    = 40.6;   // 1.600"
board_parts_h    = 11.5;   // 0.453" tallest component, which hangs downward
stud_h           = 5.0;    // same as the 5 mm spacers supplied with the board
stud_d           = 7.0;
board_bolt       = 3.4;    // M3 clearance: supplied M3 x 20 bolt up through board, stud and shelf
board_nut_af     = 5.7;    // M3 nut, in a recess on the top of the shelf
board_nut_h      = 2.6;
board_gap        = 3.0;    // board edge clearance from the main plate edge

$fn = 72;
eps = 0.01;

/* ---------- Derived stack heights ---------- */
tongue_h = key_h - 0.2;
hubA_h   = grip_len + 3;                    // body; its tongue stands on top
hubA_z0  = shaft_top - grip_len;
disc_h   = 2 * key_h + 1.5;                 // slot in each face, 1.5 mm web where they cross
hubB_h   = 6.0;                             // body; its tongue hangs below
hubB_z0  = hubA_z0 + hubA_h + gap + disc_h + gap;
horn_z0  = hubB_z0 + hubB_h;
flange_z = horn_z0 + horn_h + flange_to_horn - spline_h;  // horn bottoms out at the spline root
plate_z0 = flange_z - plate_t;

assert(hubA_z0 > bushing_top + 0.5, "shaft too short: hub would hit bushing; reduce grip_len");
assert(hubA_z0 > nut_h + 0.3 + (tube_id - (nut_af / cos(30) + 0.6)) / 2, "pot hub would sit in the cone under the bore");
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
    // the case below the ears sits in a pocket in the plate; the horn turns in a hole through its floor
    translate([-(servo_W + 1) / 2, c - (servo_L + 1) / 2, plate_z0 + floor_t])
        cube([servo_W + 1, servo_L + 1, plate_t]);
    translate([0, 0, plate_z0 - 1]) cylinder(d = tube_id, h = floor_t + 2);
}

// Plate edge on the side away from the servo bodies, as a distance from the pot axes.
function plate_near_edge() = max(ear_span / 2 - spline_offset, tube_od / 2) + 3;
function frame_cx() = x_of(n_pots - 1) / 2;
// center of the board, in the same coordinates
function board_cy() = -servo_dir * (plate_near_edge() + board_gap + board_W / 2);

module plate_outline() {
    c = servo_dir * spline_offset;
    y0 = min(c - ear_span / 2, -tube_od / 2) - 3;
    y1 = max(c + ear_span / 2,  tube_od / 2) + 3;
    translate([-tube_od / 2 - 2, y0, plate_z0])
        cube([x_of(n_pots - 1) + tube_od + 4, y1 - y0, plate_t]);
    if (board) {
        // shelf carrying the board
        w = board_L + 8;
        d = plate_near_edge() + board_gap + board_W + 4;
        translate([frame_cx() - w / 2, servo_dir < 0 ? 0 : -d, plate_z0]) cube([w, d, plate_t]);
    }
}

module board_holes(d, h, z0) {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([frame_cx() + sx * board_hole_dx / 2, board_cy() + sy * board_hole_dy / 2, z0])
            cylinder(d = d, h = h);
}

module board_studs() {
    board_holes(stud_d, stud_h + eps, plate_z0 - stud_h);
}

module board_stud_cuts() {
    board_holes(board_bolt, stud_h + plate_t + 2, plate_z0 - stud_h - 1);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([frame_cx() + sx * board_hole_dx / 2, board_cy() + sy * board_hole_dy / 2, flange_z - board_nut_h])
            cylinder(d = board_nut_af / cos(30), h = board_nut_h + 1, $fn = 6);
}

module tube(i) {
    translate([x_of(i), 0, 0]) difference() {
        cylinder(d = tube_od, h = plate_z0 + eps);
        translate([0, 0, -eps]) cylinder(d = tube_id, h = plate_z0 + 1);
    }
}

module nut_seat(i) {
    // solid at the bottom of the tube; frame() cuts the nut pocket and the cone up to the bore from it
    translate([x_of(i), 0, 0]) cylinder(d = tube_od, h = nut_h + 0.3 + (tube_id - pocket_d) / 2);
}

module frame() {
    difference() {
        union() {
            plate_outline();
            if (board) board_studs();
            for (i = [0 : n_pots - 1]) { tube(i); nut_seat(i); }
            // webs tying neighboring tubes together low down, for stiffness
            for (i = [0 : n_pots - 2])
                translate([x_of(i), -wall, 0]) cube([pitch, 2 * wall, plate_z0]);
        }
        if (board) board_stud_cuts();
        for (i = [0 : n_pots - 1]) translate([x_of(i), 0, 0]) {
            // keep the webs out of the bore and the nut pocket
            // pocket over the nut, then a 45-degree cone up to the bore so the frame prints
            // plate-down without a flat overhang
            cone_h = (tube_id - pocket_d) / 2;
            translate([0, 0, -eps]) cylinder(d = pocket_d, h = nut_h + 0.3 + 2 * eps);
            translate([0, 0, nut_h + 0.3]) cylinder(d1 = pocket_d, d2 = tube_id, h = cone_h + eps);
            translate([0, 0, nut_h + 0.3 + cone_h]) cylinder(d = tube_id, h = plate_z0 - nut_h - 0.3 - cone_h - eps);
            servo_body_cut();
            servo_holes();
            // set-screw window, on the servo-body side so the board doesn't block the hex key
            translate([0, servo_dir * tube_od / 2, hubA_z0 + grip_len / 2])
                cube([window_w, tube_od, window_w * 1.6], center = true);
            // wire / view slot on the board side
            translate([0, -servo_dir * tube_od / 2, (nut_h + 2 + plate_z0) / 2])
                cube([window_w, tube_od, 10], center = true);
        }
    }
}

// One station cut from the frame (first tube and its servo mount), for checking fits before
// printing the whole thing: nut pocket, servo holes, coupler clearance, set-screw access.
module test_station() {
    intersection() {
        frame();
        translate([-pitch / 2, -100, -1]) cube([pitch, 200, flange_z + 2]);
    }
}

/* ---------- Oldham coupler ----------
   The hubs carry the tongues and the middle disc carries the slots, so every piece prints flat
   without supports (the disc's bottom slot is a short bridge). */
module key_slot(rot) {
    rotate([0, 0, rot]) translate([0, key_offset, 0]) cube([hub_d + 2, key_w + 2 * fit, 2 * key_h], center = true);
}

module tongue(rot, h) {
    intersection() {
        cylinder(d = hub_d, h = h);
        rotate([0, 0, rot]) translate([-hub_d / 2, key_offset - key_w / 2, 0]) cube([hub_d, key_w, h]);
    }
}

// Groove down the side and across the top rim, on the +Y side. On the pot hub it is the knob's
// pointer: when fitting the hub, point it where the chickenhead pointed.
module pointer(h) {
    translate([0, hub_d / 2, h / 2]) cube([1.2, 1.6, h + 2], center = true);
}

module hub_pot() {
    // grips the pot shaft with an M3 set screw; tongue along X on top
    translate([0, 0, hubA_h - eps]) tongue(0, tongue_h + eps);
    difference() {
        cylinder(d = hub_d, h = hubA_h);
        pointer(hubA_h);
        translate([0, 0, -eps]) cylinder(d = shaft_d + 0.2, h = grip_len + eps);
        // set screw, radial, with captive nut slot opening at the bottom
        translate([0, 0, grip_len / 2]) rotate([0, 90, 0]) cylinder(d = setscrew, h = hub_d);
        translate([shaft_d / 2 + 2.2, -m3_nut_af / 2, -eps]) cube([2.6, m3_nut_af, grip_len / 2 + m3_nut_af / 2]);
    }
}

module disc() {
    // slot along X below, along Y above
    difference() {
        cylinder(d = hub_d, h = disc_h);
        key_slot(0);
        translate([0, 0, disc_h]) key_slot(90);
    }
}

module hub_servo() {
    // tongue along Y underneath; flat top screws to the servo's round horn
    translate([0, 0, -tongue_h]) tongue(90, tongue_h + eps);
    difference() {
        cylinder(d = hub_d, h = hubB_h);
        translate([0, 0, hubB_h - 2.5]) cylinder(d = horn_cscrew_d, h = 4);   // horn center screw head
        for (a = [0, 180]) rotate([0, 0, a]) translate([horn_bc / 2, 0, -1]) {
            cylinder(d = horn_screw, h = hubB_h + 2);
            cylinder(d = horn_head_d, h = hubB_h - 3.5 + 1);                   // leaves 3.5 mm under the head
        }
        // matches the pot hub's pointer when the coupler is assembled
        pointer(hubB_h);
    }
}

/* ---------- Placeholders for the assembly view ---------- */
module ghost_servo(i) {
    c = servo_dir * spline_offset;
    translate([x_of(i), 0, 0]) color("dimgray", 0.6) {
        translate([-servo_W / 2, c - servo_L / 2, flange_z - (flange_to_horn - 4)]) cube([servo_W, servo_L, 38]);
        translate([-servo_W / 2 + 4, c - ear_span / 2, flange_z]) cube([servo_W - 8, ear_span, 2.5]);
        translate([0, 0, horn_z0]) cylinder(d = horn_d, h = horn_t);
        translate([0, 0, horn_z0 + horn_t]) cylinder(d = 9, h = horn_h - horn_t);
    }
}

module ghost_board() {
    z = plate_z0 - stud_h - 1.6;
    color("darkgreen") translate([frame_cx() - board_L / 2, board_cy() - board_W / 2, z]) cube([board_L, board_W, 1.6]);
    color("dimgray", 0.6) translate([frame_cx() - board_L / 2 + 4, board_cy() - board_W / 2 + 4, z - board_parts_h])
        cube([board_L - 8, board_W - 8, board_parts_h]);
}

module assembly() {
    color("orange", 0.85) frame();
    if (board) ghost_board();
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
if (board) echo(str("1061 board hangs component-side down; its lowest parts are ",
    plate_z0 - stud_h - 1.6 - board_parts_h, " mm above the panel, and it reaches ",
    abs(board_cy()) + board_W / 2, " mm from the pot axes"));
echo(str("tube OD = ", tube_od, " mm; frame length = ", x_of(n_pots - 1) + tube_od + 4, " mm"));

/* ---------- Output ---------- */
if (part == "assembly") assembly();
else if (part == "frame") rotate([180, 0, 0]) translate([0, 0, -flange_z]) frame();  // print plate-down
else if (part == "test_station") rotate([180, 0, 0]) translate([0, 0, -flange_z]) test_station();
else if (part == "hub_pot") hub_pot();
else if (part == "hub_servo") rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
else if (part == "disc") disc();
else if (part == "coupler_set") {   // one of each, for a fit test
    hub_pot();
    translate([hub_d + 4, 0, 0]) disc();
    translate([2 * (hub_d + 4), 0, 0]) rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
}
else if (part == "couplers")
    for (i = [0 : n_pots - 1]) translate([i * (hub_d + 4), 0, 0]) {
        hub_pot();
        translate([0, hub_d + 4, 0]) disc();
        translate([0, 2 * (hub_d + 4), 0]) rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
    }
