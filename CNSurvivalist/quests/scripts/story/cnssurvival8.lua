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
    collectRepairItem,
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
  player.upgradeShip(config.getParameter("shipUpgrade"));
  player.consumeItem(self.items.collectRepairItem, false);
  storage.complete = true;

  setPortraits();
  quest.complete();
  questutil.questCompleteActions();
end

function collectRepairItem()
  acquireTheThing(self.descriptions.collectRepairItem, self.items.collectRepairItem, 1);
end

function acquireTheThing(description, itemInfo, currentStage)
  if storage.complete then
    return;
  end
  quest.setCompassDirection(nil)

  while storage.stage == currentStage do
    quest.setObjectiveList({{description, false}});
    quest.setProgress(player.hasCountOfItem(itemInfo.name) / itemInfo.count);
    if player.hasItem(itemInfo) then
      storage.stage = currentStage + 1;
    end
    coroutine.yield();
  end

  quest.setProgress(0);
  quest.setObjectiveList({});

  self.state:set(self.stages[storage.stage]);
end
