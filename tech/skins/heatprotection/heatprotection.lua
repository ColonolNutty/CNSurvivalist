function init()
  status.setPersistentEffects("heatprotectionTech", {{stat = "biomeheatImmunity", amount = 1}})
end

function input(args)
  return nil
end

function uninit()
  status.clearPersistentEffects("heatprotectionTech")
end