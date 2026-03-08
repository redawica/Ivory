local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");

local function icon(spellID)
	return select(3, GetSpellInfo(spellID)) or ""
end

if build == 30300 and level == 80 and data then
	local items = {
		settingsfile = "DarhangeR_Subtlety.xml",
		{ type = "title", text = "Subtlety Rogue by |c0000CED1DarhangeR" },
		{ type = "separator" },
		{ type = "title", text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "entry", text = "|T" .. icon(14185) .. ":26:26|t Auto Stealth", tooltip = "Auto stealth out of combat", enabled = true, key = "autostealth" },
		{ type = "entry", text = "|T" .. icon(1766) .. ":26:26|t Auto Interrupt", tooltip = "Auto Kick interrupts", enabled = true, key = "autointerrupt" },
		{ type = "entry", text = "|T" .. icon(3127) .. ":26:26|t Racial Stuff", tooltip = "Enable racial abilities", enabled = true, key = "racial" },
		{ type = "entry", text = "|T" .. icon(2382) .. ":26:26|t Debug Printing", tooltip = "Enable debug output", enabled = false, key = "Debug" },
		{ type = "separator" },
		{ type = "page", number = 1, text = "|cff00BFFFTrinkets (Config)" },
		{ type = "separator" },
		{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = true, key = "trinketenabled" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13unit" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14unit" },
	};

	local function GetSetting(name)
		for _, v in ipairs(items) do
			if v.type == "entry" and v.key ~= nil and v.key == name then
				return v.value, v.enabled
			end
			if v.type == "input" and v.key ~= nil and v.key == name then
				return v.value
			end
		end
	end;

	local function OnLoad()
		ni.GUI.AddFrame("Subtlety_DarhangeR", items);
	end

	local function OnUnLoad()
		ni.GUI.DestroyFrame("Subtlety_DarhangeR");
	end

	local queue = {
		"Universal pause",
		"AutoTarget",
		"Auto Stealth",
		"Combat specific Pause",
		"Healthstone (Use)",
		"Heal Potions (Use)",
		"Racial Stuff",
		"Use enginer gloves",
		"Trinkets (Config)",
		"Trinkets",
		"Kick (Interrupt)",
		"Shadowstep",
		"Shadow Dance",
		"Slice and Dice",
		"Hemorrhage",
		"Rupture",
		"Eviscerate",
		"Window",
	}

	local abilities = {
		["Universal pause"] = function()
			if data.UniPause() then
				return true
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
		end,

		["AutoTarget"] = function()
			if UnitAffectingCombat("player")
			 and ((ni.unit.exists("target") and UnitIsDeadOrGhost("target") and not UnitCanAttack("player", "target"))
			 or not ni.unit.exists("target")) then
				ni.player.runtext("/targetenemy")
			end
		end,

		["Auto Stealth"] = function()
			local _, enabled = GetSetting("autostealth")
			if enabled and not UnitAffectingCombat("player") and ni.spell.available(1784) and not ni.player.buff(1784) then
				ni.spell.cast(1784)
				return true
			end
		end,

		["Combat specific Pause"] = function()
			if not UnitAffectingCombat("player") or UnitCanAttack("player", "target") == nil then
				return true
			end
		end,

		["Healthstone (Use)"] = function()
			local hstones = { 36892, 36893, 36894 }
			for i = 1, #hstones do
				if ni.player.hp() < 35 and ni.player.hasitem(hstones[i]) and ni.player.itemcd(hstones[i]) == 0 then
					ni.player.useitem(hstones[i])
					return true
				end
			end
		end,

		["Heal Potions (Use)"] = function()
			local hpot = { 33447, 43569, 40087, 41166, 40067 }
			for i = 1, #hpot do
				if ni.player.hp() < 30 and ni.player.hasitem(hpot[i]) and ni.player.itemcd(hpot[i]) == 0 then
					ni.player.useitem(hpot[i])
					return true
				end
			end
		end,

		["Racial Stuff"] = function()
			local _, enabled = GetSetting("racial")
			if enabled and data.rogue and data.rogue.Race and data.rogue.Race() then
				return true
			end
		end,

		["Use enginer gloves"] = function()
			if ni.player.slotcastable(10) and ni.player.slotcd(10) == 0 and UnitAffectingCombat("player") then
				ni.player.useinventoryitem(10)
				return true
			end
		end,

		["Trinkets (Config)"] = function()
			if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
				return true
			end
		end,

		["Trinkets"] = function()
			if ni.player.slotcastable(13) and ni.player.slotcd(13) == 0 then
				ni.player.useinventoryitem(13)
				return true
			end
			if ni.player.slotcastable(14) and ni.player.slotcd(14) == 0 then
				ni.player.useinventoryitem(14)
				return true
			end
		end,

		["Kick (Interrupt)"] = function()
			local _, enabled = GetSetting("autointerrupt")
			if data.TryInterrupt("target", enabled, 1766, 0.35) then
				return true
			end
		end,

		["Shadowstep"] = function()
			if ni.spell.available(36554) and ni.spell.valid("target", 36554, true, true) then
				ni.spell.cast(36554, "target")
				return true
			end
		end,

		["Shadow Dance"] = function()
			if ni.spell.available(51713) and ni.player.buff(14177) then
				ni.spell.cast(51713)
				return true
			end
		end,

		["Slice and Dice"] = function()
			if ni.spell.available(6774)
			 and not ni.player.buff(6774)
			 and GetComboPoints("player", "target") > 0 then
				ni.spell.cast(6774)
				return true
			end
		end,

		["Hemorrhage"] = function()
			if ni.spell.available(48660)
			 and ni.spell.valid("target", 48660, true, true)
			 and GetComboPoints("player", "target") < 5 then
				ni.spell.cast(48660, "target")
				return true
			end
		end,

		["Rupture"] = function()
			if ni.spell.available(48672)
			 and ni.spell.valid("target", 48672, true, true)
			 and GetComboPoints("player", "target") >= 4
			 and not ni.unit.debuff("target", 48672, "player") then
				ni.spell.cast(48672, "target")
				return true
			end
		end,

		["Eviscerate"] = function()
			if ni.spell.available(48668)
			 and ni.spell.valid("target", 48668, true, true)
			 and GetComboPoints("player", "target") >= 5 then
				ni.spell.cast(48668, "target")
				return true
			end
		end,

		["Window"] = function()
			if not popup_shown then
				ni.debug.popup("Subtlety Rogue by DarhangeR for 3.3.5a",
				"Welcome to Subtlety Rogue Profile!\n\nAutonomous profile with utility, interrupts, trinkets and engineering support.")
				popup_shown = true;
			end
		end,
	}

	ni.bootstrap.profile("Subtlety_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
else
	local queue = { "Error" }
	local abilities = {
		["Error"] = function()
			ni.vars.profiles.enabled = false;
			if build > 30300 then
				ni.frames.floatingtext:message("This profile is meant for WotLK 3.3.5a! Sorry!")
			elseif level < 80 then
				ni.frames.floatingtext:message("This profile is meant for level 80! Sorry!")
			elseif data == nil then
				ni.frames.floatingtext:message("Data file is missing or corrupted!");
			end
		end,
	}
	ni.bootstrap.profile("Subtlety_DarhangeR", queue, abilities);
end
