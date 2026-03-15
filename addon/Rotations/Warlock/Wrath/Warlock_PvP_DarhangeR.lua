local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_Warlock_PvP.xml",
	{ type = "title", text = "Warlock PvP by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },
	{ type = "entry", text = "\124T"..ni.spell.icon(6603, 26, 26)..":26:26\124t Auto Target", tooltip = "Auto target nearest enemy in combat", enabled = true, key = "autotarget" },
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, value = 1.5, key = "Debug" },
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %", enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "\124T"..data.mpotionIcon()..":26:26\124t Mana Potion", tooltip = "Use Mana Potions (if you have) when player mana < %", enabled = true, value = 25, key = "manapotionuse" },
	{ type = "separator" },
	{ type = "page", number = 2, text = "|cff00BFFFTrinkets (Config)" },
	{ type = "separator" },
	{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = false, key = "trinketenabled" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
	{ type = "input", value = "target", width = 80, height = 15, key = "trinket13unit" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
	{ type = "input", value = "target", width = 80, height = 15, key = "trinket14unit" },
};

local function GetSetting(name)
	for k, v in ipairs(items) do
		if v.type == "entry" and v.key ~= nil and v.key == name then
			return v.value, v.enabled
		end
		if v.type == "dropdown" and v.key ~= nil and v.key == name then
			for k2, v2 in pairs(v.menu) do
				if v2.selected then
					return v2.value
				end
			end
		end
		if v.type == "input" and v.key ~= nil and v.key == name then
			return v.value
		end
	end
end;

local function OnLoad()
	ni.GUI.AddFrame("Warlock_PvP_DarhangeR", items);
end

local function OnUnLoad()
	ni.GUI.DestroyFrame("Warlock_PvP_DarhangeR");
end

local queue = {
	"Universal pause",
	"AutoTarget",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Trinkets (Config)",
	"Trinkets",
	"Window",
}

local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if data.UniPause() then
			return true
		end
		ni.vars.debug = select(2, GetSetting("Debug"));
	end,
-----------------------------------
	["AutoTarget"] = function()
		local _, enabled = GetSetting("autotarget")
		if enabled and UnitAffectingCombat("player")
		 and ((ni.unit.exists("target") and UnitIsDeadOrGhost("target") and not UnitCanAttack("player", "target"))
		 or not ni.unit.exists("target")) then
			ni.player.runtext("/targetenemy")
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if UnitCanAttack("player", "target") == nil
		 or UnitIsDeadOrGhost("player")
		 or UnitIsDeadOrGhost("target") then
			return true
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local value, enabled = GetSetting("healthstoneuse");
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if enabled and ni.player.hp() < value and ni.player.hasitem(hstones[i]) and ni.player.itemcd(hstones[i]) == 0 then
				ni.player.useitem(hstones[i])
				return true
			end
		end
	end,
-----------------------------------
	["Heal Potions (Use)"] = function()
		local value, enabled = GetSetting("healpotionuse");
		local hpot = { 33447, 43569, 40087, 41166, 40067 }
		for i = 1, #hpot do
			if enabled and ni.player.hp() < value and ni.player.hasitem(hpot[i]) and ni.player.itemcd(hpot[i]) == 0 then
				ni.player.useitem(hpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Mana Potions (Use)"] = function()
		local value, enabled = GetSetting("manapotionuse");
		local mpot = { 33448, 43570, 40087, 42545, 39671 }
		for i = 1, #mpot do
			if enabled and ni.player.power() < value and ni.player.hasitem(mpot[i]) and ni.player.itemcd(mpot[i]) == 0 then
				ni.player.useitem(mpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Trinkets (Config)"] = function()
		if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 then
			ni.player.useinventoryitem(13)
		else
			if data.CDorBoss("target", 5, 35, 5, enabled)
			 and ni.player.slotcastable(14)
			 and ni.player.slotcd(14) == 0 then
				ni.player.useinventoryitem(14)
				return true
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
			ni.debug.popup("Warlock PvP by DarhangeR for 3.3.5a", "Welcome to Warlock PvP profile.")
			popup_shown = true;
		end
	end,
}

ni.bootstrap.profile("Warlock_PvP_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Warlock_PvP_DarhangeR", queue, abilities);
end
