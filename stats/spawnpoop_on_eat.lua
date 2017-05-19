
function init()
    storage.timeBetweenSpawn = status.statusProperty("timeBetweenNextPoopSpawn")
    storage.currentTime = 0.0
    storage.lastFoodValue = 0.0
    script.setUpdateDelta(60) -- Setup a largish value here to prevent it from updating too often. Still trying to figure out a way to stop the script from running, calling uninit doesn't work, so may take a die() call, which isn't viable for the player character
end

function update(dt)
  -- Setup a versioning system here with token values to prevent the constant update calls from applying the status effect multiple times. Only need one.
  -- Yes, I know I could do something like if not status.statusProperty( "modSetup" ), but I prefer this look
    if storage.currentTime >= storage.timeBetweenSpawn then 
        storage.currentTime = 0.0
        if storage.lastFoodValue == 0.0 then
          storage.lastFoodValue = status.stat("food")
        end
    else
      storage.currentTime = storage.currentTime + dt
    end
end

function uninit() -- forgot this earlier for some reason
  status.setStatusProperty( "modSetup", 0 ) --Have to set it back, so the system starts up again
end
