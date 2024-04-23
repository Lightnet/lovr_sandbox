# lovr_sandbox

# Licence: MIT

# Created by: Lightnet

# Status:
 * Network tests.
 * UI tests.
 
# Information:
  This is 3D Lovr lua scripting build test. Base on Love2D to Lovr for 3D. Lovr have prebuilt camera and scene for virtual reality devices. It can be disable. It just empty scene with the camera movement.

  For reason to create this project is small file if possible. It size is 4.63 MB for application to run. As simalar to game Gotot Engine. But does not have editor.

  The smallest first person shooter game. https://en.wikipedia.org/wiki/.kkrieger

  Read more on https://lovr.org

  Will build simple minecraft block world but not the procedure terrain generater. As well simple chat message test.

# Features:
 * Network Enet
   * [x] simple test
 * UI
   * [x] network
   * [x] chat
   * [ ] hud
   * [ ] inventory
   * [ ] in game
   * [ ] quest
   * [ ] npc
 * game
   * [ ] block types
   * [ ] player
   * [ ] inventory
   * [ ] World
   * [ ] emitter
   * [ ] npc
   * [ ] monster
   * [ ] boss

# VSCode:
 Install Love2D Support.


 settings.json
```
{
  "pixelbyte.love2d.path": "path/lovr.exe"
}
```
  Alt + L

  Run Application.

# Run App:
  Install program. https://lovr.org Note there is no installer. Need to set path in system variable for testing.

Command line for current project folder.
```
lovr .
```
Run project dir.

# File System:
```
Windows	C:\Users\<user>\AppData\Roaming\LOVR\<identity>
```
lovr.conf

conf.lua
```lua
function lovr.conf(t)
  t.identity = '<identity>'
end
```

# links:

 - https://lovr.org/docs/v0.17.0/Plugins
 - https://tylerneylon.com/a/learn-lua/
 - https://lovr.org/docs/v0.17.0/lovr.filesystem
 - https://www.youtube.com/watch?v=dZ_X0r-49cw Love2D | Entity Component System | Episode 1

# Lovr:
 - https://lovr.org/docs/Libraries
 - https://lovr.org/docs/Plugins
 - https://github.com/immortalx74/lovr-ui
 - https://github.com/mcclure/lovr-ent
 - https://github.com/jmiskovic/chui
 - 