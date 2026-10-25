// Four-servo knob actuator for Carr Super Bee: Treble, Mid, Bass, Reverb.
// Servos hang upside down over the pots (output spline pointing down) and drive
// the 1/4" shafts through 3-piece Oldham couplers, which absorb misalignment.
// Each servo sits on a tube whose bottom slips over a printed collar on that pot's
// mounting nut, so the nuts themselves locate the frame. Nothing is drilled into the amp.
// The tube bore is wider than the couplers all the way down, so the frame lifts straight
// off, leaving the collars and pot hubs on the amp.
//
// Units: mm. Z = 0 is the control-panel surface; X runs along the row of knobs.
// Values marked MEASURE must be checked with calipers before printing.

part = "assembly";  // "assembly" | "frame" | "test_station" | "coupler_set" | "hub_pot" | "hub_servo" | "disc" | "couplers" | "collar" | "collars" | "insert_test" | "coupon"

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
pocket_L       = 40.5;  // opening for the case below the ears (39.7 mm on the goBILDA drawing)
spline_offset  = 10.0;  // output axis distance from body center, along length
flange_to_horn = 10.2;  // spline-side face of ears to spline tip (goBILDA drawing; 2.6 ear, 4.1 spline)
spline_h       = 4.1;
servo_dir      = -1;    // +1 / -1: which way the servo bodies extend in Y (away from handle)
ear_rib_w      = 1.0;   // gusset on the spline side of each ear, between its two slots,
ear_rib_h      = 1.5;   // standing this far above the 2.7 mm ear

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
setscrew_seat = 1.5; // the hub's set-screw insert sits this far below the surface, so an M3 x 6 set screw
                     // reaches the shaft without sticking out into the tube clearance

/* ---------- Heat-set inserts (M3) ---------- */
insert_d   = 3.9;    // hole for the kit's M3 brass inserts (4.2 mm over the knurls): 3.9 fit best on the coupon
m3_clear   = 3.4;
ear_insert = 4;      // M3 x 4 inserts in the top face for the servo ears (M3 x 8 bolts and washers)
board_insert = 5;    // M3 x 5 inserts in the board studs (M3 x 8 bolts up through the board)
hub_insert = 4;      // M3 x 4 insert, radial, for the pot hub's set screw (M3 x 6)

/* ---------- Frame ---------- */
plate_t   = flange_to_horn - spline_h + 1.6;  // deeper than the servo case below the ears
wall      = 2.5;
clear     = 1.0;     // radial clearance around rotating parts
tube_id   = max(horn_d, hub_d) + 2 * clear;
tube_od   = tube_id + 2 * wall;
window_w  = 12;      // set-screw access window
overhang  = 60;      // steepest unsupported slope, degrees from horizontal (45 printed rough in PETG)
flare_r   = 4;       // radius easing the tube wall off vertical into that slope
chamfer   = 1;       // on the plate's outside edges, both faces

/* ---------- Nut collar: stays on each pot nut; the tube bottom slips over it ---------- */
collar_fit = 0.3;                        // radial clearance in the tube bore
collar_od  = tube_id - 2 * collar_fit;
collar_h   = nut_h + 2.5;                // socket over the nut and washer, then a lip on top of the nut
collar_af  = nut_af + 0.3;               // hex socket, snug on the nut so the collar can't turn

/* ---------- Phidgets 1061 board, hung under a shelf on the side away from the servo bodies ---------- */
board            = true;
board_L          = 58.4;   // 2.300"
board_W          = 48.3;   // 1.900"
board_hole_dx    = 50.8;   // 2.000"
board_hole_dy    = 40.6;   // 1.600"
board_parts_h    = 11.5;   // 0.453" tallest component, which hangs downward
stud_h           = 5.0;    // same as the 5 mm spacers supplied with the board
stud_d           = 8.0;    // room around the insert in its end
board_gap        = 3.0;    // board edge clearance from the main plate edge
shelf_t          = 5.7;    // thinner than the main plate; flush with it on the top (print-bed) face

/* ---------- Logo: an electric guitar engraved in the board shelf's top face ---------- */
logo       = true;
logo_len   = 46;     // nut of the headstock to the bottom of the body
logo_line  = 0.9;    // stroke width: two extrusions, and the layer above only bridges this far
logo_depth = 0.6;

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
shelf_z0 = flange_z - shelf_t;              // underside of the board shelf

assert(hubA_z0 > bushing_top + 0.5, "shaft too short: hub would hit bushing; reduce grip_len");
assert(hubA_z0 > collar_h + 0.5, "pot hub would sit on the nut collar");
assert(pitch > servo_W + 3, "pitch too tight for side-by-side servos");
if (pitch < tube_od + 2) echo("WARNING: tubes merge; fine, but check knob spacing");

function x_of(i) = i * pitch;

/* ---------- Frame ---------- */
module servo_holes() {
    // relative to the pot axis: an insert in the top face, and clearance below it for the bolt's end
    c = servo_dir * spline_offset;
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * ear_hole_dx / 2, c + sy * ear_hole_dy / 2, 0]) {
            translate([0, 0, flange_z - ear_insert - 0.5]) cylinder(d = insert_d, h = ear_insert + 1.5);
            translate([0, 0, plate_z0 - 1]) cylinder(d = m3_clear, h = plate_t + 2);
        }
}

module servo_body_cut() {
    c = servo_dir * spline_offset;
    // The servo case and the coupler hub both pass straight through the plate, so a servo with its
    // horn and hub already screwed on drops in from above.
    translate([-(servo_W + 1) / 2, c - pocket_L / 2, plate_z0 - 1])
        cube([servo_W + 1, pocket_L, plate_t + 2]);
    translate([0, 0, plate_z0 - 1]) cylinder(d = tube_id, h = plate_t + 2);
    // grooves in the top face for the gussets under the ears
    for (sy = [-1, 1])
        translate([-(ear_rib_w + 0.5) / 2, c + (sy < 0 ? -ear_span / 2 - 1 : servo_L / 2), flange_z - ear_rib_h - 0.6])
            cube([ear_rib_w + 0.5, (ear_span - servo_L) / 2 + 1, ear_rib_h + 1]);
    // Where that opening undercuts the tube wall, the wall is cut back with a flare down to the
    // set-screw slot, so it prints plate-down without starting in midair: a radius eases it off
    // vertical, then it narrows at the overhang angle.
    translate([0, c + pocket_L / 2, plate_z0]) rotate([90, 0, 0]) linear_extrude(pocket_L) flare_profile();
}

// Half-width runs from the servo opening (at z = 0) down to the slot (below), mirrored about x = 0.
module flare_profile() {
    xo = (servo_W + 1) / 2;
    a  = 90 - overhang;
    arc = [for (t = [0 : a / 8 : a]) [xo - flare_r + flare_r * cos(t), -flare_r * sin(t)]];
    e  = arc[len(arc) - 1];
    f  = [window_w / 2, e[1] - (e[0] - window_w / 2) * tan(overhang)];
    right = concat(arc, [f]);
    polygon(concat([[-xo, eps], [xo, eps]], right, [for (i = [len(right) - 1 : -1 : 0]) [-right[i][0], right[i][1]]]));
}

// Box with its outside edges chamfered on the top and bottom faces.
module chamfered_box(size, ch) {
    hull() {
        translate([ch, ch, 0]) cube([size[0] - 2 * ch, size[1] - 2 * ch, size[2]]);
        translate([0, 0, ch]) cube([size[0], size[1], size[2] - 2 * ch]);
    }
}

// Single-cut electric guitar along +X (lower bout at the origin), drawn as filled shapes.
module guitar_shape() {
    difference() {
        hull() { scale([1.08, 1]) circle(r = 10); translate([14, 0]) circle(r = 7.2); }
        for (sy = [-1, 1]) translate([7.8, sy * 12.6]) circle(r = 6);    // waist
        translate([19.2, -4.6]) circle(r = 4.2);                         // cutaway
    }
    translate([18, -1.7]) square([24, 3.4]);                             // neck
    translate([42, 0]) polygon([[0, -2.2], [10, -3.4], [11.5, -2.4], [11.5, 3], [0, 2.2]]);  // headstock
    for (i = [0 : 2], sy = [-1, 1]) translate([44.5 + i * 3.2, sy * (2.6 + i * 0.35) - 0.7, 0]) square([1.4, 1.4]);  // tuner pegs
}

module guitar_logo(len) {
    k = len / 64;
    scale(k) {
        difference() { offset(r = logo_line / k / 2) guitar_shape(); offset(r = -logo_line / k / 2) guitar_shape(); }
        for (x = [0.5, 8]) translate([x - 1.3, -4.2]) square([2.6, 8.4]);   // humbuckers
        translate([-5.2, -3.6]) square([1.4, 7.2]);                          // bridge
        for (p = [[-3.5, -6.2], [0.5, -7.2], [-5.5, 5.2], [-1.5, 6.6]]) translate(p) circle(d = 2.2);  // knobs
    }
}

// The logo centered on the origin, ready to cut into a face at z = 0 (reads correctly from +Z).
module logo_cut(len) {
    translate([0, 0, -logo_depth]) linear_extrude(logo_depth + 1) translate([-21.4 * len / 64, 0]) guitar_logo(len);
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
        chamfered_box([x_of(n_pots - 1) + tube_od + 4, y1 - y0, plate_t], chamfer);
    if (board) {
        // shelf carrying the board
        w = board_L + 8;
        d = plate_near_edge() + board_gap + board_W + 4;
        translate([frame_cx() - w / 2, servo_dir < 0 ? 0 : -d, shelf_z0]) chamfered_box([w, d, shelf_t], chamfer);
    }
}

module board_holes(d, h, z0) {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([frame_cx() + sx * board_hole_dx / 2, board_cy() + sy * board_hole_dy / 2, z0])
            cylinder(d = d, h = h);
}

module board_studs() {
    board_holes(stud_d, stud_h + eps, shelf_z0 - stud_h);
}

module board_stud_cuts() {
    // insert in the end of each stud; the bolt's end runs on into the clearance hole above it
    board_holes(insert_d, board_insert + 1.5, shelf_z0 - stud_h - 1);
    board_holes(m3_clear, stud_h + shelf_t + 2, shelf_z0 - stud_h - 1);
}

module tube(i) {
    translate([x_of(i), 0, 0]) difference() {
        cylinder(d = tube_od, h = plate_z0 + eps);
        translate([0, 0, -eps]) cylinder(d = tube_id, h = plate_z0 + 1);
    }
}

module collar() {
    // as fitted, hex socket down over the nut; it prints lip-down, so the socket opens upward
    difference() {
        hull() {
            cylinder(d = collar_od - 2, h = collar_h);
            cylinder(d = collar_od, h = collar_h - 1);   // lead-in for the tube
        }
        translate([0, 0, -eps]) cylinder(d = collar_af / cos(30), h = nut_h + 0.2 + eps, $fn = 6);
        cylinder(d = bushing_d + 1, h = collar_h + 1);
    }
}

// Slot through the tube wall on the +Y (side = 1) or -Y side, straight from z0 to z1, with a
// teardrop end below z0 (round, then pointed at the overhang angle) so its panel-side end prints
// plate-down without a flat bridge. The point is window_w / 2 / cos(overhang) below z0.
module slot(side, z0, z1) {
    translate([-window_w / 2, side < 0 ? -tube_od : 0, z0]) cube([window_w, tube_od, z1 - z0]);
    translate([0, side < 0 ? 0 : tube_od, z0]) rotate([90, 0, 0]) linear_extrude(tube_od) hull() {
        circle(d = window_w);
        translate([0, -window_w / 2 / cos(overhang)]) square(eps, center = true);
    }
}

module frame() {
    difference() {
        union() {
            plate_outline();
            if (board) board_studs();
            for (i = [0 : n_pots - 1]) tube(i);
            // webs tying neighboring tubes together low down, for stiffness
            for (i = [0 : n_pots - 2])
                translate([x_of(i), -wall, 0]) cube([pitch, 2 * wall, plate_z0]);
        }
        if (board) board_stud_cuts();
        if (board && logo) translate([frame_cx(), board_cy(), flange_z]) logo_cut(logo_len);
        for (i = [0 : n_pots - 1]) translate([x_of(i), 0, 0]) {
            // keep the webs out of the bore, which runs full width to the bottom so the frame lifts
            // off over the pot hubs; a 45-degree lead-in at the bottom for the collar
            translate([0, 0, -eps]) cylinder(d = tube_id, h = plate_z0);
            translate([0, 0, -eps]) cylinder(d1 = tube_id + 2, d2 = tube_id, h = 1 + eps);
            servo_body_cut();
            servo_holes();
            // set-screw slot, on the servo-body side so the board doesn't block the hex key; it runs
            // up into the servo opening, which leaves the coupler and horn screws in view
            tip = window_w / 2 / cos(overhang);
            ws = hubA_z0 + grip_len / 2 - window_w * 0.8 + tip;   // point stays 9.6 mm below the set screw
            slot(servo_dir, ws, plate_z0 + eps);
            // wire / view slot on the board side, its point kept 1 mm above the collar
            wz = collar_h + 1 + tip;
            slot(-servo_dir, wz, wz + 8);
        }
    }
}

// One station cut from the frame (first tube and its servo mount), for checking fits before
// printing the whole thing: collar fit, servo holes, coupler clearance, set-screw access.
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
    // grips the pot shaft with two M3 set screws; tongue along X on top
    translate([0, 0, hubA_h - eps]) tongue(0, tongue_h + eps);
    difference() {
        cylinder(d = hub_d, h = hubA_h);
        pointer(hubA_h);
        translate([0, 0, -eps]) cylinder(d = shaft_d + 0.2, h = grip_len + eps);
        // two set screws 90 degrees apart (clear of the pointer), so the shaft sits in a V against the
        // bore; each in an insert pressed down to the step at the bottom of its hole
        for (a = [0, -90]) rotate([0, 0, a]) translate([0, 0, grip_len / 2]) rotate([0, 90, 0]) {
            cylinder(d = m3_clear, h = hub_d);
            translate([0, 0, hub_d / 2 - setscrew_seat - hub_insert - 0.3]) cylinder(d = insert_d, h = hub_d);
        }
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

/* ---------- Coupon ---------- */
// M3 insert holes (4.2 mm knurls) from 3.7 to 4.1 mm: pick the one that grips best. The logo is cut
// into the bottom face, as on the frame's board shelf, and reads correctly with the coupon turned over.
coupon_ds = [3.7, 3.8, 3.9, 4.0, 4.1];
coupon_L  = len(coupon_ds) * 9 + 5;
coupon_W  = 22;
module insert_test() {
    difference() {
        cube([coupon_L, coupon_W, 7]);
        for (i = [0 : len(coupon_ds) - 1]) translate([7 + i * 9, 0, 0]) {
            translate([0, 15, 1.2]) cylinder(d = coupon_ds[i], h = 7);
            translate([0, 6, 7 - 0.6]) linear_extrude(1) text(str(coupon_ds[i] * 10), size = 3, halign = "center", valign = "center");
        }
        translate([coupon_L / 2, coupon_W / 2, 0]) rotate([180, 0, 0]) logo_cut(coupon_L - 6);
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
    z = shelf_z0 - stud_h - 1.6;
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
        color("tomato") collar();
        cylinder(d = shaft_d, h = shaft_top);
    }
}

echo(str("plate underside at z = ", plate_z0, " mm; servo ears at z = ", flange_z, " mm above panel"));
if (board) echo(str("1061 board hangs component-side down; its lowest parts are ",
    shelf_z0 - stud_h - 1.6 - board_parts_h, " mm above the panel, and it reaches ",
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
else if (part == "collar") rotate([180, 0, 0]) translate([0, 0, -collar_h]) collar();
else if (part == "collars")
    for (i = [0 : n_pots - 1]) translate([i * (collar_od + 4), 0, 0]) rotate([180, 0, 0]) translate([0, 0, -collar_h]) collar();
else if (part == "insert_test") insert_test();
else if (part == "coupon") {   // insert sizing, with the logo underneath as it prints on the frame, and one collar
    insert_test();
    translate([coupon_L + 4 + collar_od / 2, coupon_W / 2, 0]) rotate([180, 0, 0]) translate([0, 0, -collar_h]) collar();
}
else if (part == "couplers")
    for (i = [0 : n_pots - 1]) translate([i * (hub_d + 4), 0, 0]) {
        hub_pot();
        translate([0, hub_d + 4, 0]) disc();
        translate([0, 2 * (hub_d + 4), 0]) rotate([180, 0, 0]) translate([0, 0, -hubB_h]) hub_servo();
    }
