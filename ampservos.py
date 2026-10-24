#!/usr/bin/env python3
"""Drive the Treble/Mid/Bass/Reverb servos on the amp through a Phidgets RCC1000.

Usage:
    ampservos.py treble=6 mid=4.5 bass=7 reverb=2   # set knobs on a 0-10 scale
    ampservos.py --calibrate treble                  # jog one channel to find its end stops
    ampservos.py --park                              # all knobs to 5, before lifting the frame off

Positions are on the knob's 0-10 scale. Each servo is engaged only while it
moves, then released: the pot's own friction holds the setting, and the amp
doesn't hear PWM chatter or servo hunting.
"""
import argparse
import json
import sys
import time
from pathlib import Path

from Phidget22.Devices.RCServo import RCServo
from Phidget22.RCServoVoltage import RCServoVoltage

# "RCC1000" (VINT, on a hub port) or "1061" (older PhidgetAdvancedServo 8-Motor, USB).
CONTROLLER = "RCC1000"
HUB_PORT = 0           # RCC1000 only: VINT hub port it's plugged into
SERIAL = -1            # -1 = any; set it if more than one hub/controller is attached
CHANNELS = {"treble": 0, "mid": 1, "bass": 2, "reverb": 3}

# goBILDA 2000-series in servo mode: 500-2500 us spans 300 degrees.
SERVO_MIN_US = 500
SERVO_MAX_US = 2500
SERVO_RANGE_DEG = 300.0

# Per-channel pulse widths (us) at knob 0 and knob 10, found with --calibrate.
# Keep them a few degrees inside the pot's end stops so the servo never stalls.
CAL_FILE = Path(__file__).with_name("calibration.json")
DEFAULT_CAL = {name: [600, 2400] for name in CHANNELS}

PARK = 5.0             # knob setting for --park; turn the bare pot hubs here before refitting
VELOCITY_DEG_S = 90.0  # slow enough to sound like a hand turning the knob


def load_cal():
    if CAL_FILE.exists():
        return {**DEFAULT_CAL, **json.loads(CAL_FILE.read_text())}
    return dict(DEFAULT_CAL)


def open_servo(name):
    s = RCServo()
    s.setDeviceSerialNumber(SERIAL)
    if CONTROLLER == "RCC1000":
        s.setHubPort(HUB_PORT)
    s.setChannel(CHANNELS[name])
    s.openWaitForAttachment(5000)
    if CONTROLLER == "RCC1000":
        s.setVoltage(RCServoVoltage.RCSERVO_VOLTAGE_6V)  # the 1061 is fixed at 5 V
    s.setMinPulseWidth(SERVO_MIN_US)
    s.setMaxPulseWidth(SERVO_MAX_US)
    s.setMinPosition(0.0)
    s.setMaxPosition(SERVO_RANGE_DEG)
    s.setSpeedRampingState(True)
    s.setVelocityLimit(VELOCITY_DEG_S)
    return s


def us_to_deg(us):
    return (us - SERVO_MIN_US) / (SERVO_MAX_US - SERVO_MIN_US) * SERVO_RANGE_DEG


def knob_to_deg(name, value, cal):
    lo, hi = cal[name]
    value = min(max(value, 0.0), 10.0)
    return us_to_deg(lo + (hi - lo) * value / 10.0)


def move(servos, targets, timeout=10.0):
    for name, deg in targets.items():
        servos[name].setTargetPosition(deg)
        servos[name].setEngaged(True)
    deadline = time.time() + timeout
    while time.time() < deadline and any(servos[n].getIsMoving() for n in targets):
        time.sleep(0.05)
    time.sleep(0.3)  # let the servo settle on target before letting go
    for name in targets:
        servos[name].setEngaged(False)


def set_knobs(settings):
    cal = load_cal()
    servos = {name: open_servo(name) for name in settings}
    try:
        move(servos, {n: knob_to_deg(n, v, cal) for n, v in settings.items()})
    finally:
        for s in servos.values():
            s.close()


def calibrate(name):
    """Interactive jog: find pulse widths just inside each end stop."""
    cal = load_cal()
    s = open_servo(name)
    us = sum(cal[name]) / 2
    print(f"Calibrating {name}. Commands: number = absolute us, +N / -N = jog,"
          " 'lo' / 'hi' = record current as knob 0 / 10, 'q' = save and quit.")
    try:
        while True:
            s.setTargetPosition(us_to_deg(us))
            s.setEngaged(True)
            cmd = input(f"{us:.0f} us> ").strip()
            if cmd == "q":
                break
            elif cmd == "lo":
                cal[name][0] = us
            elif cmd == "hi":
                cal[name][1] = us
            elif cmd[:1] in "+-":
                us += float(cmd)
            elif cmd:
                us = float(cmd)
            us = min(max(us, SERVO_MIN_US), SERVO_MAX_US)
    finally:
        s.setEngaged(False)
        s.close()
    CAL_FILE.write_text(json.dumps(cal, indent=2) + "\n")
    print(f"{name}: knob 0 = {cal[name][0]:.0f} us, knob 10 = {cal[name][1]:.0f} us -> {CAL_FILE}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--calibrate", choices=CHANNELS)
    ap.add_argument("--park", action="store_true", help=f"move every knob to {PARK:g}")
    ap.add_argument("settings", nargs="*", help="name=value, value 0-10")
    args = ap.parse_args()
    if args.calibrate:
        calibrate(args.calibrate)
        return
    if args.park:
        set_knobs({name: PARK for name in CHANNELS})
        return
    settings = {}
    for item in args.settings:
        name, _, value = item.partition("=")
        if name not in CHANNELS or not value:
            sys.exit(f"bad setting {item!r}; expected one of {list(CHANNELS)}=0..10")
        settings[name] = float(value)
    if not settings:
        ap.print_help()
        return
    set_knobs(settings)


if __name__ == "__main__":
    main()
