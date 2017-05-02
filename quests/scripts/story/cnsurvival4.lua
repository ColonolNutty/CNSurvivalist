require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"
require "/quests/scripts/questutil.lua"

function init()
  self.descriptions = config.getParameter("descriptions")
  self.foodCategory = config.getParameter("foodCategory")
  
  setPortraits()
  
  storage.complete = storage.complete or false

  storage.stage = storage.stage or 1
  self.stages = {
    collectFood,
    questComplete
  }

  self.state = FSM:new()
  self.state:set(self.stages[storage.stage])
end

function questStart()
end

function update(dt)
  if storage.complete then
    return
  end
  self.state:update(dt)
end

function questComplete()
  if storage.complete then
    return
  end
  storage.complete = true
  setPortraits()
  questutil.questCompleteActions()
  quest.complete()
end

function collectFood()
  quest.setCompassDirection(nil)

  while storage.stage == 1 do
    quest.setObjectiveList({{self.descriptions.collectFood, false}})
    hasFood = player.hasItemWithParameter("category", self.foodCategory)
    if hasFood then
      storage.stage = 2
    end
    coroutine.yield()
  end

  quest.setObjectiveList({})

  self.state:set(self.stages[storage.stage])
end