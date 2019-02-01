require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"
require "/quests/scripts/questutil.lua"

function init()
  self.descriptions = config.getParameter("descriptions");
  self.items = config.getParameter("items");
  
  setPortraits();
  
  storage.complete = storage.complete or false;

  storage.stage = storage.stage or 1;
  self.stages = {
    collectFood,
    questComplete
  };

  self.state = FSM:new();
  self.state:set(self.stages[storage.stage]);
end

function questStart()
end

function update(dt)
  if storage.complete then
    return;
  end
  self.state:update(dt);
end

function questComplete()
  if storage.complete then
    return;
  end
  storage.complete = true;
  setPortraits();
  quest.complete();
  questutil.questCompleteActions();
end

function collectFood()
  acquireTheThingWithCategory(self.descriptions.collectFood, self.items.collectFood.category, 1);
end


function acquireTheThingWithCategory(description, parameter, currentStage)
  if storage.complete then
    return;
  end
  quest.setCompassDirection(nil);

  local nextStage = currentStage + 1;

  while storage.stage == currentStage do
    quest.setObjectiveList({{description, false}});
    if player.hasItemWithParameter("category", parameter) then
      storage.stage = nextStage;
    end
    coroutine.yield();
  end

  quest.setProgress(0);
  quest.setObjectiveList({});

  self.state:set(self.stages[storage.stage]);
end