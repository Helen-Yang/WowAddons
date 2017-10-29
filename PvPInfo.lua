
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
displayHealsButton = nil

enterBattlegroundFrame = CreateFrame("Frame")
enterBattlegroundFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")

enterBattlegroundFrame:SetScript("OnEvent", function(self, event, ...)
		-- print("entered world")
		if not displayHealsButton then 
			-- print("making a button for the first time")
			displayHealsButton = makeButton()
		end
		enterBattlegroundFrame:UnregisterEvent("PLAYER_ENTERING_BATTLEGROUND")
	end)

function makeButton()
	displayHealsButton = CreateFrame("Button", displayHealsButton, UIParent, "UIPanelButtonTemplate")
	displayHealsButton:SetSize(110, 30)
	displayHealsButton:SetText("Display Healers")
	displayHealsButton:SetPoint("CENTER", 400, 300)
	--when displayHealsButton is clicked, display healers 
	displayHealsButton:SetScript("OnClick", function(self, displayHealsButton, down)
		--TODO: refresh stats
		if UnitInBattleground("player") then
			inBattleground()
		end
		
	end)
end

function initialize()
	-- print("initializing")
	--each player consists of {name, faction, class, spec}
	players = {}
	--number
	playersInBG = 0	
	-- makeButton()
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
	playersInBG = GetNumBattlefieldScores()
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

function inBattleground()
	initialize()
	-- ChatFrame1:AddMessage("entered inbg")
	--get bg data
	RequestBattlefieldScoreData()
	updateBattlefieldFrame = CreateFrame("Frame")
	updateBattlefieldFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	updateBattlefieldFrame:SetScript("OnEvent", function(self, event,...) 
		getSpecs()
		displayHealers()
		updateBattlefieldFrame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	end)
	
end

function identifyHeals()
	--for each player in battleground, check if they are a healing spec
	healers = {}
	for i, v in ipairs(players) do
 		for j, t in ipairs(HEALING_SPECS) do
 			--check specialization name
    		if v[4] == t then
      			table.insert(healers, v)
      		end
    	end
 	end
end

function sortByFaction()
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

	print("|cff00aeef Alliance healers ("..tableLength(allianceHealers).."):")
	for i, v in ipairs(allianceHealers) do
		print(getClassColor(v[3])..v[4]..' '..v[3]..' ('..v[1]..')')
	end
	print("\n")
	print("|cffff0000Horde healers ("..tableLength(hordeHealers).."):")
	for i, v in ipairs(hordeHealers) do
		print(getClassColor(v[3])..v[4]..' '..v[3]..' ('..v[1]..')')
	end
end

