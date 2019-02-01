require "/scripts/util.lua"
require "/quests/scripts/questutil.lua"
require "/scripts/vec2.lua"
require "/quests/scripts/portraits.lua"

function init()
  storage.complete = storage.complete or false;
  self.compassUpdate = config.getParameter("compassUpdate", 0.5);
  self.descriptions = config.getParameter("descriptions");
  self.teleportBookmark = config.getParameter("teleportBookmark");

  self.estherUid = config.getParameter("estherUid");

  self.findRange = config.getParameter("findRange");
  storage.exploreTimer = storage.exploreTimer or 0;

  setPortraits();

  storage.stage = storage.stage or 1;
  self.stages = {
    findEsther
  };

  self.state = FSM:new();
  self.state:set(self.stages[storage.stage]);

  storage.gateActive = true;
end

function questInteract(entityId)
  if self.onInteract then
    return self.onInteract(entityId);
  end
end

function questStart()
end

function update(dt)
  self.state:update(dt);

  quest.setCanTurnIn(true);
end

function findEsther(dt)
  quest.setCompassDirection(nil);
  quest.setParameter("esther", {type = "entity", uniqueId = self.estherUid});
  quest.setIndicators({"esther"});
  quest.setObjectiveList({{self.descriptions.findEsther, false}});

  local trackEsther = util.uniqueEntityTracker(self.estherUid, self.compassUpdate);
  while true do
    if not storage.complete then
      local estherResult = trackEsther();
      questutil.pointCompassAt(estherResult);
      if estherResult then
        if not storage.bookmarked then
          player.addTeleportBookmark(self.teleportBookmark);
          storage.bookmarked = true;
        end
        if world.magnitude(estherResult, mcontroller.position()) < self.findRange then
          player.playCinematic(config.getParameter("findEstherCinema"));
          storage.complete = true;
        end
      end
    else
      quest.setCanTurnIn(true);
      quest.setIndicators({});
    end
    coroutine.yield();
  end
  self.state:set(self.stages[storage.stage]);
end

function questComplete()
  player.giveEssentialItem("beamaxe", "beamaxe")
  setPortraits();
  questutil.questCompleteActions();
end
