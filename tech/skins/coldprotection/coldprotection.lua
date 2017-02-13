function init()
  status.setPersistentEffects("coldprotectionTech", {{stat = "biomecoldImmunity", amount = 1}})
end

function input(args)
  return nil
end

function uninit()
  status.clearPersistentEffects("coldprotectionTech")
end