require '/objects/wired/light/light.lua'

function update(dt)
  if not storage.lightDuration then
    storage.lightDuration = config.getParameter("duration", 60)
    storage.currentDuration = 0.0
    storage.disabled = false
  end
  if storage.disabled then
    --below breaks
    world.breakObject(entity.id(), false)
    --below disabled
    --currentState = animator.animationState("light")
    --if currentState == "on" then
    --  setLightState(false)
    --end
  end
  if storage.currentDuration >= storage.lightDuration then
   storage.disabled = true
  end
  storage.currentDuration = storage.currentDuration + dt
end