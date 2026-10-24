# ampservos

Computer control of the Treble, Mid, Bass and Reverb knobs on a Carr Super Bee,
using four hobby servos driven by a Phidgets RCC1000. Nothing gets drilled into the amp.

![panel](docs/amp_panel.jpeg) ![assembly](docs/assembly.png)

## How it works

- **Servos:** goBILDA 2000-series Dual Mode Servo, set to servo mode: 300° over 500–2500 µs,
  which matches the pots' 300° travel, and gives absolute position with no homing.
- **Frame** (`part="frame"`): one printed bridge. Under each servo is a tube whose
  bottom pocket slips over that pot's mounting nut, so the four nuts locate the frame
  coaxially and stop it from rotating. The servos hang upside down, splines pointing down.
- **Couplers** (`part="couplers"`): 3-piece Oldham couplers, so the servo and the pot don't
  have to line up perfectly. The pot hub grips the 1/4" shaft with an M3 set screw
  (captive nut), which you reach through a window in the tube. The servo hub screws to the
  servo's round horn.
- **Electronics:** VINT hub → RCC1000 (16-channel RC servo Phidget) set to 6 V servo
  power, channels 0–3 = treble, mid, bass, reverb.
- **Software:** `ampservos.py` engages each servo only while it moves, then releases it.
  The pot's friction holds the setting, and the amp never hears PWM chatter or a servo hunting.

## Before printing: measure these

Edit the `MEASURE` values at the top of `amp_servo_mount.scad`:

| parameter | what |
|---|---|
| `pitch` | shaft center-to-center spacing (most important) |
| `nut_af`, `nut_h` | pot nut size across flats, and nut + washer height |
| `bushing_top`, `shaft_top` | heights above the panel, with the knobs removed |
| `flange_to_horn`, horn dims | from the actual servo and horn |

Then: `openscad -o stl/frame.stl -D 'part="frame"' amp_servo_mount.scad` (and the same for `couplers`).

Print in **PETG or ASA**, not PLA: the top panel of a tube amp gets warm.
Print the frame plate-down.

## Use

```
pip install -r requirements.txt
./ampservos.py --calibrate treble     # repeat for each channel; writes calibration.json
./ampservos.py treble=6 mid=4.5 bass=7 reverb=2
```

Calibrate before anything else. These servos have far more torque than the pots
need, and driving a servo into a pot's end stop will stall the servo or strip the pot.
Record knob 0 and knob 10 a few degrees inside each stop.

## Notes

- Keep the servo wiring away from the input jack and route it out the back.
- The servo system makes no electrical connection to the amp; keep it that way (plastic couplers isolate the pot shafts).
