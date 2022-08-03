# GDTLancer
![Progress][Progress]

A space game inspired by Freelancer, Orbiter and EVE Online. 
Developed in Godot 3 for desktop (Windows, Linux) and mobile (Android) platforms.

[Progress]: Doc/Images/Progress.png "Progress"

## Recent changelog
### Since v0.10-alpha (current)
- New release (and some last-minute tweaks)!

### Since v0.9-alpha
- CCD is disabled upon reaching specific velocity threshold.
- Tweaked autopilot to perform some rotation (approach is slightly spiraled).
- Introduced star system coordinates databank for main galaxy (50k stars for now).
- Split targeting into "selection" and "autopilot" controls for clarity.
- Upon picking a stellar coordinate - spawn a system scene there (currently only a star).
- Keep a track of recently visited star systems and do not despawn them if their number is within limit.
- Proper spawner / despawner of stellar systems upon selecting them in order to create seamless travel.
- Moved galaxy mesh into decoration background (scoping the space down for gameplay sake).
- Temporarily disabled procedural coords.
- Tweaked systems.
- Tweaked velocity, damping is implemented in the game (due to recent engine changes).
- Removed textures and uneeded sources.
- Refactored UI a little.
- Added panic screen.
- Refactored cloud shaders.
- Re-implemented LOD system (again).
- Refactored cloud meshes.
- Tweaked camera decorations.
- Optimized background decorations.
- Reworked primitive shapes scene (for importing).
- Implemented planet surface shader (based on old implementation of star surface shader, but not animated).
- Tweaked planetary shader to include lava layer.
- Added a sector-level nebula.
- Refactored names of local spaces and markers to reflect what they are clearly.
- Added a new star system.
- Added a new planetary shader (ice).
- Pre-release tweaks.

### Since v0.8-alpha
- Tweaks to desktop UI.
- Fixed lag due to complex collision trimesh.
- Autopilot added.
- New UI elements.
- Default window size is 720p.
- Some tweaks to superliminal velocity effects.

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

## Priority TODO list:
- Info / help window.
- Refactor ship code.
- Prevent camera orbiting from interrupting autopilot and warp effect adjustments.
- Investigate flickering on high velocity.
- Due to space being a complex sandwich got to figure out how to just teleport and spawn at will.
- Make autopilot detect obstacles.

## TODO list:
- Make primitive building blocks with simple collision shapes (performace).
- Investigate enabling/disabling trimesh collision shapes on the go.
- Scalable UI (control panel, texts, buttons, etc).
- Make "Orient only" autopilot feature.
- Add a list (options) of allowed post-effects (which work with log depth).

## How to
You can download one of the pre-compiled binary in the [releases](https://github.com/roalyr/GDTLancer/releases) section.
If you want to open it in editor, then you must use a custom Godot build: https://github.com/roalyr/godot-for-3d-open-worlds


## Support
<a href="https://www.buymeacoffee.com/roalyr" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
