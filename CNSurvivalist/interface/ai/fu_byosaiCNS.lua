require "/interface/ai/fu_byosai.lua"

function defaultShipCNS() 
  if(racial) then
    racial()
  end
	local defaultShipUpgrade = config.getParameter("defaultShipUpgrade")
  player.upgradeShip(defaultShipUpgrade)
end