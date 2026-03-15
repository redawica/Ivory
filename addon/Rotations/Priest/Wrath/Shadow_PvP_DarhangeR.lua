local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_Shadow_PvP.xml",
	{ type = "title", text = "Priest Shadow PvP by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },
	{ type = "entry", text = "\124T"..ni.spell.icon(6603, 26, 26)..":26:26\124t Auto Target", tooltip = "Auto target nearest enemy in combat", enabled = true, key = "autotarget" },
        { type = "entry", text = "Arena Assist (Smart Target)", tooltip = "Auto target arena healer/lowest HP when target is invalid", enabled = true, key = "arenaassist" },
        { type = "entry", text = "PvP Trinket/Break CC", tooltip = "Use racial/trinket to break hard control", enabled = true, value = 2.0, key = "trinketcc" },
        { type = "entry", text = "Arena Focus Interrupt", tooltip = "Try focus interrupt if spell ID is configured", enabled = false, key = "arenafocusinterrupt" },
        { type = "input", value = "", width = 80, height = 15, key = "focusinterruptspell" },
	{ type = "entry", text = "\124T"..data.controlIcon()..":26:26\124t Racial Abilities (PvP)", tooltip = "Use race-specific PvP racials (offensive/defensive control breaks)", enabled = true, key = "racialpvp" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "Auto" },
		{ selected = false, value = 2, text = "Offensive" },
		{ selected = false, value = 3, text = "Defensive" },
	}, key = "racialmode" },
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Profile Pause", tooltip = "Enable for debug if you have problems", enabled = false, value = 1.5, key = "Debug" },
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
	ni.GUI.AddFrame("Shadow_PvP_DarhangeR", items);
end

local function OnUnLoad()
	ni.GUI.DestroyFrame("Shadow_PvP_DarhangeR");
end

local queue = {
	"Universal pause",
	"AutoTarget",
        "Arena Cache",
        "Arena Assist",
	"Combat specific Pause",
        "PvP Trinket Break",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial PvP",
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
	["Arena Cache"] = function()
		data.UpdateArenaCache()
	end,
-----------------------------------
	["Arena Assist"] = function()
		if data.TryArenaAutoTarget(GetSetting) then
			return true
		end
		local sid = tonumber(GetSetting("focusinterruptspell") or "")
		if sid and sid > 0 and data.TryArenaFocusInterrupt(GetSetting, sid) then
			return true
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
	["PvP Trinket Break"] = function()
		local _, enabled = GetSetting("trinketcc")
		if enabled and data.TryPvPTrinketBreak(GetSetting) then
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
	["Racial PvP"] = function()
		local _, enabled = GetSetting("racialpvp")
		local mode = GetSetting("racialmode")
		if not enabled then
			return false
		end
		local offensive = mode == 1 or mode == 2
		local defensive = mode == 1 or mode == 3

		if defensive and IsSpellKnown(7744) and ni.spell.available(7744) and (ni.player.isfleeing() or ni.player.isconfused() or ni.player.issilenced()) then
			ni.spell.cast(7744)
			return true
		end
		if defensive and IsSpellKnown(59752) and ni.spell.available(59752) and (ni.player.isstunned() or ni.player.isfleeing() or ni.player.isconfused()) then
			ni.spell.cast(59752)
			return true
		end
		if defensive and IsSpellKnown(20589) and ni.spell.available(20589) and ni.player.isrooted() then
			ni.spell.cast(20589)
			return true
		end
		if defensive and IsSpellKnown(20594) and ni.spell.available(20594) and ni.player.hp() < 70 then
			ni.spell.cast(20594)
			return true
		end
		if defensive and IsSpellKnown(58984) and ni.spell.available(58984) and ni.player.hp() < 40 then
			ni.spell.cast(58984)
			return true
		end
		if defensive and IsSpellKnown(59542) and ni.spell.available(59542) and ni.player.hp() < 55 then
			ni.spell.cast(59542)
			return true
		end
		if offensive and IsSpellKnown(20572) and ni.spell.available(20572) and ni.unit.exists("target") and UnitCanAttack("player", "target") then
			ni.spell.cast(20572)
			return true
		end
		if offensive and IsSpellKnown(26297) and ni.spell.available(26297) and ni.unit.exists("target") and UnitCanAttack("player", "target") then
			ni.spell.cast(26297)
			return true
		end
		if offensive and IsSpellKnown(28730) and ni.spell.available(28730) and ni.unit.exists("target") and UnitCanAttack("player", "target") and ni.unit.distance("target") < 8 then
			ni.spell.cast(28730)
			return true
		end
		if offensive and IsSpellKnown(20549) and ni.spell.available(20549) and ni.unit.exists("target") and UnitCanAttack("player", "target") then
			ni.spell.cast(20549)
			return true
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
			ni.debug.popup("Priest Shadow PvP by DarhangeR for 3.3.5a", "Welcome to Priest Shadow PvP profile. Racials are configured for PvP mode.")
			popup_shown = true;
		end
	end,
}

ni.bootstrap.profile("Shadow_PvP_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Shadow_PvP_DarhangeR", queue, abilities);
end
