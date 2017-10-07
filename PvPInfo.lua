
HEALING_SPECS = {"Restoration", "Mistweaver", "Holy", "Discipline"}
CLASS_COLORS = {
	{"Hunter", "|cfffabd473" },
	{"Warlock", "|cfff8788ee" },
	{"Priest", "|cffffffff" },
	{"Paladin", "|cfff58cba" },
	{"Mage", "|cff3fc7eb" },
	{"Rogue", "|cfffff569" },
	{"Druid", "|cffff7d0a" },
	{"Shaman", "|cff0070de" },
	{"Warrior", "|cffc79c6e" },
	{"Death Knight",  "|cffc41f3b" },
	{"Monk", "|cff00ff96" },
	{"Demon Hunter", "|cffa330c9" },
}

players = {}
--each player consists of {name, faction, class, spec}
healers = {}
allianceHealers= {}
hordeHealers = {}
playersInBG = 0

enterBattlegroundFrame = CreateFrame("Frame")
enterBattlegroundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

enterBattlegroundFrame:SetScript("OnEvent", function(self, event, ...)
		-- print("entered world")
		if UnitInBattleground("player") then
			-- print("unit inbg")
			inBattleground()
		end
		enterBattlegroundFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end)

function makeButton()
	button = CreateFrame("Button", button, UIParent, "UIPanelButtonTemplate")
	button:SetSize(110, 30)
	button:SetText("Display Healers")
	button:SetPoint("CENTER", 400, 300)
	--when button is clicked, display healers 
	button:SetScript("OnClick", function(self, button, down)
		displayHealers()
	end)
	return button
end

function initialize()
	-- print("initializing")
	--each player consists of {name, faction, class, spec}
	players = {}
	--number
	playersInBG = 0	
	makeButton()
end

function getClassColor(className)
	for i, v in ipairs(CLASS_COLORS) do
		if v[1] == className then
			return v[2]
		end
	end
	print("couldn't find class color :(")
end

function printTable(t)
	for i, v in ipairs(t) do
		print(v)
	end
end

function printNestedTable(t)
	print("inprinttable")
	for i, v in ipairs(t) do
		print(stringTable(v))
	end
end

function stringTable(t)
	tableAsString = ""
	for i, v in ipairs(t) do
		tableAsString = tableAsString..v
	end
	return tableAsString
end

function tableLength(t)
	count = 0
	for i, v in ipairs(t) do
		count = count + 1
	end
	return count
end

function getSpecs()
	-- ChatFrame1:AddMessage("in getspecs")
	-- ChatFrame1:AddMessage("numscores"..GetNumBattlefieldScores())
	-- ChatFrame1:AddMessage(GetBattlefieldScore(1))
	playersInBG = GetNumBattlefieldScores()
	-- print("playersinbg"..playersInBG)
	if playersInBG == 0 then
		inBattleground()
	end

	for i=1, playersInBG do
		playerInfo = {GetBattlefieldScore(i)}
		--{name, faction, class, spec}
		players[i] = {playerInfo[1], playerInfo[6], playerInfo[8], playerInfo[16]}
	end
	identifyHeals()
end

--TODO: check if in bg, run if in bg
function inBattleground()
	initialize()
	-- ChatFrame1:AddMessage("entered inbg")
	--get bg data
	-- print("inbg")
	RequestBattlefieldScoreData()
	updateBattlefieldFrame = CreateFrame("Frame")
	updateBattlefieldFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	updateBattlefieldFrame:SetScript("OnEvent", function(self,event,...) 
		-- ChatFrame1:AddMessage("updated bscores")
		-- print("score has been updated")
		getSpecs()
		updateBattlefieldFrame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	end)
	
end

function identifyHeals()
	--for each player in battleground, check if they are a healing spec
	healers = {}
	for i, v in ipairs(players) do
 		for j, t in ipairs(HEALING_SPECS) do
 			--check specialization name
 			-- print(v[3])
    		if v[4] == t then
      			table.insert(healers, v)
      		end
    	end
 	end
end

function sortByFaction()
	--TODO: get unit faction to determine enemy/ally
	allianceHealers = {}
	hordeHealers = {}
	for i, v in ipairs(healers) do
		--horde
		if v[2] == 0 then
			table.insert(hordeHealers, v)
		else
			table.insert(allianceHealers, v)
		end
	end
end

function displayHealers() 
	--print healers in format spec class (playername)
	
	sortByFaction()

	print("|cff00aeef Alliance healers".."("..tableLength(allianceHealers).."):")
	for i, v in ipairs(allianceHealers) do
		print(getClassColor(v[3])..v[4]..' '..v[3]..' ('..v[1]..')')
	end
	print("\n")
	print("|cffff0000Horde healers".."("..tableLength(hordeHealers).."):")
	for i, v in ipairs(hordeHealers) do
		print(getClassColor(v[3])..v[4]..' '..v[3]..' ('..v[1]..')')
	end
end



