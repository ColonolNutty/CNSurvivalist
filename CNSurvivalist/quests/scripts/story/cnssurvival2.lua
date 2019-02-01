require "/quests/scripts/main.lua"

local originalQuestComplete = questComplete;

function questComplete()
  player.giveEssentialItem("beamaxe", "cnsdebris")
  player.consumeItem({ name = "cnsdebris", count = 1 })
  originalQuestComplete();
end