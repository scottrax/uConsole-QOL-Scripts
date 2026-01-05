# uConsole QOL Scripts

Small, focused scripts for quality-of-life tweaks on the uConsole.

## Scripts

- `brightness-step.sh` adjusts backlight in 10% steps using `brightnessctl`.
- `volume-step.sh` adjusts audio volume in 5% steps using `amixer`.

## Requirements

- `brightnessctl`
- `alsa-utils` (for `amixer`)

## Labwc keybinds (Wayland)

Add these entries to your labwc config at `~/.config/labwc/rc.xml` and reload with `labwc --reconfigure`:

```xml
<keybind key="A-Up">
  <action name="Execute" command="/home/scottrax/bin/brightness-step.sh up"/>
</keybind>
<keybind key="A-Down">
  <action name="Execute" command="/home/scottrax/bin/brightness-step.sh down"/>
</keybind>
<keybind key="A-Left">
  <action name="Execute" command="/home/scottrax/bin/volume-step.sh down"/>
</keybind>
<keybind key="A-Right">
  <action name="Execute" command="/home/scottrax/bin/volume-step.sh up"/>
</keybind>
<keybind key="A-1">
  <action name="ToggleFullscreen"/>
</keybind>
```

## Install

Copy the scripts into `~/bin/` and ensure `~/bin` is on your `PATH`:

```bash
mkdir -p ~/bin
cp brightness-step.sh volume-step.sh ~/bin/
```

## Labwc reload helper

Run this from a terminal inside your labwc session to reload keybinds and config:

```bash
./labwc-reconfigure.sh
```
