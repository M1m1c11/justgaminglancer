# GDTLancer
![Progress][Progress]

A space game inspired by Freelancer, Orbiter and EVE Online. 
Developed in Godot 3 for desktop and mobile (Android) platforms.

[Progress]: Doc/Images/Progress.png "Progress"

## Recent changelog
### Since v0.7-alpha
- A new star system!
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
- Adjusted camera decorations to act as a boundary zone a size of 9e18 to prevent flickering.
(9e18 seems to be a sort of safe margin for transforms?)
- Fixed OmniLight and camera flickering (workarounds but robust).
- Removed unrelated files from within project scope.
- Removed Calinou's LOD plugin files.
- New dynamic star shader. Stars are much less in polycount now.
- Added icons for custom zone nodes.
- Optimized paths.
- Some temporary fixes for collision model (caused stuttering due to polygon number).
- Tweaks to desktop UI.

## TODO list:
- Make primitive building blocks with simple collision shapes (performace).
- Investigate enabling/disabling trimesh collision shapes on the go.
- Enable/disable CCD based on velocity?
- Scalable UI (control panel, texts, buttons, etc).
- Grouping for overlapping markers.
- Due to space being a complex sandwich got to figure out how to just teleport and spawn at will.


## How to
You can download one of the pre-compiled binary in the [releases](https://github.com/roalyr/GDTLancer/releases) section.
If you want to open it in editor, then you must use a custom Godot build: https://github.com/roalyr/godot-for-3d-open-worlds


## Support
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/U7U0BNQX5)
