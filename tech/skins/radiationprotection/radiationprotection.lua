function init()
  status.setPersistentEffects("radiationprotectionTech", {{stat = "biomeradiationImmunity", amount = 1}})
end

function input(args)
  return nil
end

function uninit()
  status.clearPersistentEffects("radiationprotectionTech")
end