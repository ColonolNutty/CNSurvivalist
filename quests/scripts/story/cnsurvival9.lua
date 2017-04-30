require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"
require "/quests/scripts/questutil.lua"

function init()
  self.descriptions = config.getParameter("descriptions")
  self.items = config.getParameter("items")
  
  setPortraits()
  
  storage.complete = storage.complete or false

  storage.stage = storage.stage or 1
  self.stages = {
    collectSimpleCraftingTable,
    collectTelescope,
    researchLesserKnowledge,
    researchAverageKnowledge,
    collectFtlDrive,
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

function collectSimpleCraftingTable()
  acquireTheThing(self.descriptions.collectSimpleCraftingTable, self.items.simpleCraftingTable, 1)
end

function collectTelescope()
  acquireTheThing(self.descriptions.collectTelescope, self.items.telescope, 2)
end

function researchLesserKnowledge()
  acquireTheThing(self.descriptions.researchLesserKnowledge, self.items.lesserKnowledge, 3)
end

function researchAverageKnowledge()
  acquireTheThing(self.descriptions.researchAverageKnowledge, self.items.averageKnowledge, 4)
end

function collectFtlDrive()
  acquireTheThing(self.descriptions.collectFtlDrive, self.items.ftl, 5)
end

function acquireTheThing(description, itemInfo, currentStage)
  quest.setCompassDirection(nil)
  
  item = itemInfo.item
  itemCount = itemInfo.count
  nextStage = currentStage + 1

  while storage.stage == currentStage do
    quest.setObjectiveList({{description, false}})
    quest.setProgress(player.hasCountOfItem(item) / itemCount)
    if player.hasItem({name = item, count = itemCount}) then
      storage.stage = nextStage
    end
    coroutine.yield()
  end

  quest.setObjectiveList({})

  self.state:set(self.stages[storage.stage])
end