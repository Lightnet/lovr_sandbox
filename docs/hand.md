

```lua
for i, hand in ipairs(lovr.headset.getHands()) do
  print("IDX: "..i)
  local x, y, z = lovr.headset.getPosition(hand)
  pass:sphere(x, y, z, .01)
end
```
If window default is the mouse. Count 1. The other is VR controller.