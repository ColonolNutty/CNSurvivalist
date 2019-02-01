require "/quests/scripts/story/bootship.lua"

local originalQuestStart = questStart;

function questStart()
  originalQuestStart();
  player.removeEssentialItem("beamaxe")
end
