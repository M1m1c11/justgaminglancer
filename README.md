# GDTLancer
![Progress][Progress]

A space arcade game inspired by Freelancer. Developed in Godot 3 for desktop  
and mobile (Android) platforms.

[Progress]: Assets/Images/Progress.png "Progress"

## Recent changelog
- Switched to full-scale stellar bodies (stars and planets are up to scale now).
- Using `meters` instead of `units` now. Updated distance prefixes according to 
https://en.wikipedia.org/wiki/Metric_prefix.
- Updated galaxy mesh and colors.
- Updtaed camera motion on acceleartion for smoother experience.
- Updated velocity increment mechanism, it is now exponential, which allows to 
accelerate rapidly.
- Space markers are removed from `Debug` overlay.
- Switched to custom LOD script which is based on zones.
- Refactored stellar objects and their hierarchy for clarity.
- Implemented multilayer local space, which tackles precision errors in object positioning.

- Further refactoring and tweaks.


## How to
You can download one of the pre-compiled binary in the [releases](https://github.com/roalyr/GDTLancer/releases) section.

If you want to open it in editor, then you must use a custom Godot build: https://github.com/roalyr/godot-for-3d-open-worlds
