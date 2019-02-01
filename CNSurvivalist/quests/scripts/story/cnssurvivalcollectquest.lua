require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"
require "/quests/scripts/questutil.lua"

function init()
  self.questType = config.getParameter("questType", None);
  self.questStages = config.getParameter("questStages", None);
  self.questDescriptions = config.getParameter("questDescriptions");
  self.questItemsToCollect = config.getParameter("questItemsToCollect", None);
  self.shipUpgrade = config.getParameter("shipUpgrade", None);
  self.consumeOnComplete = config.getParameter("consumeOnComplete", None);
  self.teleportBookmark = config.getParameter("teleportBookmark", None)

  setPortraits();

  storage.complete = storage.complete or false;

  storage.stage = storage.stage or 1;
  self.stages = {};
  local currentStage = 1;
  for idx, questStage in ipairs(self.questStages) do
    if self.questType == "COLLECT_ITEM" then
      table.insert(self.stages, createCollectItemStage(self.questDescriptions[questStage], self.questItemsToCollect[questStage], currentStage));
    end
    currentStage = currentStage + 1;
  end
  table.insert(self.stages, questComplete);

  self.state = FSM:new();
  self.state:set(self.stages[storage.stage]);
end

function createCollectItemStage(description, itemInfo, currentStage)
  local description = description;
  local itemInfo = itemInfo;
  local currentStage = currentStage;
  local collectItem = function()
    acquireTheThing(description, itemInfo, currentStage);
  end
  return collectItem;
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
  if self.shipUpgrade then
    player.upgradeShip(self.shipUpgrade);
  end
  if self.consumeOnComplete then
    for idx, item in ipairs(self.consumeOnComplete) do
      player.consumeItem(item);
    end
  end
  if self.teleportBookmark then
    player.addTeleportBookmark(self.teleportBookmark);
  end
  storage.complete = true;

  setPortraits();
  quest.complete();
  questutil.questCompleteActions();
end

function acquireTheThing(description, itemInfo, currentStage)
  if storage.complete then
    return;
  end
  quest.setCompassDirection(nil);

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