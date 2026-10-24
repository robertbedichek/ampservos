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
  power, or an older 1061 AdvancedServo 8-Motor on USB. Channels 0–3 = treble, mid, bass, reverb.
- **Software:** `ampservos.py` engages each servo only while it moves, then releases it.
  The pot's friction holds the setting, and the amp never hears PWM chatter or a servo hunting.

## Parts list

Besides the printed frame and couplers. Prices are rough.

### Electronics (Phidgets)

| Qty | Part | Notes | ~Price |
|---|---|---|---|
| 1 | **RCC1000** 16× RC Servo Phidget | Drives all four servos on channels 0–3 | $30 |
| 1 | **HUB0000** VINT Hub Phidget (USB) | Or HUB5000 for network; skip if you have a free VINT port | $30 |
| 1 | VINT / Phidget cable | Hub to RCC1000; usually included, get a longer one if needed | $3 |
| 1 | USB cable for the hub | | — |
| 1 | 12 V 2 A DC supply for the RCC1000 | Check the RCC1000 spec page for its input range | $15 |

**Alternative:** an older **PhidgetAdvancedServo 8-Motor (1061)** works in place of the RCC1000,
hub and cable. Its pulses go to 2.7 ms, so the full 300° is available. Servo power is fixed at
5 V, which is within the goBILDA's 4.8–7.4 V range. It takes 6–15 V in, so the same 12 V supply
works, and it connects straight to USB. Set `CONTROLLER = "1061"` in `ampservos.py`.

### Servos

| Qty | Part | Notes | ~Price |
|---|---|---|---|
| 4 (+1 spare) | **goBILDA 2000-0025-0002** Dual Mode Servo (25-2 Torque) | 300° in servo mode over 500–2500 µs. **Not** the 5-turn 2000-0025-0502, which spreads ~1800° over the same pulses. Not on Amazon: buy from [goBILDA](https://www.gobilda.com/2000-series-dual-mode-servo-25-2-torque/), [ServoCity](https://www.servocity.com/2000-series-dual-mode-servo-25-2) or [RobotShop](https://www.robotshop.com/products/servocity-2000-series-dual-mode-servo-25-2-torque). | $37 ea |
| 4 | Round disc servo horns, **25-tooth spline**, ~24 mm | Horns don't appear to come with the servo; goBILDA sells 25T arms and hubs, so order them with the servos. Set the `horn_*` values to match. | $5 ea |
| 4 | Servo extension cables, 300 mm | Only if the leads don't reach; route away from the input jack | $2 ea |

### Hardware

| Qty | Part | Used for |
|---|---|---|
| 4 (+spares) | M3 × 6 cup-point set screws | Pot hub onto the 1/4" shaft |
| 4 | M3 hex nuts | Captive nut in each pot hub |
| 16 | M4 × 12 pan-head thread-forming screws for plastic | Servo ears into the plate (3.3 mm pilot) |
| 8 | M2 × 6 self-tapping screws | Servo horn to the servo-side hub |
| 4 | M3 horn screws (into the spline's M3 × 0.5 tapped hole) | Horn onto the servo; usually included |
| — | Thin felt or rubber pads (optional) | Under the tube bottoms to protect the panel |
| — | Velcro strap or Command strips (optional) | Only if the frame rocks |

### Tools

Calipers, 1.5 mm hex key (M3 set screws), small screwdriver.

**Rough total:** $260–300.

## Before printing: measure these

Edit the `MEASURE` values at the top of `amp_servo_mount.scad`:

| parameter | what |
|---|---|
| `pitch` | shaft center-to-center spacing (measured: 1.366" = 34.70 mm) |
| `nut_af`, `nut_h` | pot nut size across flats, and nut + washer height |
| `bushing_top`, `shaft_top` | heights above the panel, with the knobs removed |
| horn dims | from the actual horn (servo dims are from the goBILDA drawing) |

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
