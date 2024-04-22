# lovr_sandbox

# Licence: MIT

# Created by: Lightnet

# Status:
 * Network tests.
 * UI tests.
 
# Information:
  This is 3D lovr lua scripting build test.

  Base on Love2D to Lovr for 3D.

  For reason to create this project is small file. It size is 4.63 MB. As simalar to game gotot engine.

  Lovr have prebuilt camera and scene. It just empty scene with the camera movement.

  Read more on https://lovr.org

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
 - 