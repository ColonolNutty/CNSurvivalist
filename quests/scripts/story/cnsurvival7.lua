require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"
require "/quests/scripts/questutil.lua"

function init()
  self.descriptions = config.getParameter("descriptions")
  self.fuelHatchRepairItem = config.getParameter("fuelHatchRepairItem")
  self.fuelHatchRepairItemCount = config.getParameter("fuelHatchRepairItemCount")
  
  setPortraits()
  
  storage.complete = storage.complete or false

  storage.stage = storage.stage or 1
  self.stages = {
    acquireIron,
    questComplete
  }

  self.state = FSM:new()
  self.state:set(self.stages[storage.stage])
end

function questInteract(entityId)
  if self.onInteract then
    return self.onInteract(entityId)
  end
end

function questStart()
end

function update(dt)
  self.state:update(dt)
end

function questComplete()
  player.upgradeShip(config.getParameter("shipUpgrade"))

  setPortraits()
  questutil.questCompleteActions()
  quest.complete()
end

function acquireIron()
  quest.setCompassDirection(nil)

  while storage.stage == 1 do
    quest.setObjectiveList({{self.descriptions.collectRepairItem, false}})
    quest.setProgress(player.hasCountOfItem(self.fuelHatchRepairItem) / self.fuelHatchRepairItemCount)
    if player.hasItem({name = self.fuelHatchRepairItem, count = self.fuelHatchRepairItemCount}) then
      storage.stage = 2
    end
    coroutine.yield()
  end

  quest.setObjectiveList({})

  self.state:set(self.stages[storage.stage])
end
