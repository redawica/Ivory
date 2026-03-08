local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_Combat.xml",
	{ type = "title", text = "Combat Rogue by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },
	{ type = "entry", text = "\124T"..data.rogue.interIcon()..":24:24\124t Auto Interrupt", tooltip = "Auto check and interrupt all interruptible spells", enabled = true, key = "autointerrupt" },
	{ type = "entry", text = "\124T"..data.debugIcon()..":24:24\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },		
	{ type = "separator" },
	{ type = "title", text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":24:24\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":24:24\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %", enabled = true, value = 30, key = "healpotionuse" },
	{ type = "separator" },
	{ type = "title", text = "Build Settings" },
    { type = "dropdown", menu = {
        { selected = true, value = 1, text = "Eviscerate Build" },
        { selected = false, value = 2, text = "Rapture Build" },
    }, key = "builds" },
		{ type = "separator" },
		{ type = "page", number = 99, text = "|cff00BFFFTrinkets (Config)" },
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
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
        if v.type == "dropdown"
         and v.key ~= nil
         and v.key == name then
            for k2, v2 in pairs(v.menu) do
                if v2.selected then
                    return v2.value
                end
            end
        end
        if v.type == "input"
         and v.key ~= nil
         and v.key == name then
            return v.value
        end
    end
end;
local function OnLoad()
	ni.GUI.AddFrame("Combat_DarhangeR", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Combat_DarhangeR");
end

local EviscerateBuild = {
	
	"Universal pause",
	"AutoTarget",
	"Poison Weapon",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Trinkets (Config)",
	"Racial Stuff",
		"Use enginer gloves",
		"Trinkets",
	"Kick (Interrupt)",
	"Tricks of the Trade",
	"Fan of Knives",
	"Riposte",
	"Garrote/Ambush",
	"Adrenaline Rush",
	"Blade Flurry",
	"Killing Spree",
	"Slice and Dice",
	"Sinister Strike",
	"Eviscerate",
}
local RaptureBuild = {
	
	"Universal pause",
	"AutoTarget",
	"Poison Weapon",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets",
	"Kick (Interrupt)",
	"Tricks of the Trade",
	"Fan of Knives",
	"Riposte",
	"Garrote/Ambush",
	"Adrenaline Rush",
	"Blade Flurry",
	"Killing Spree",
	"Slice and Dice",
	"Sinister Strike",
	"Rupture",
	"Eviscerate Dump",
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
		if UnitAffectingCombat("player")
		 and ((ni.unit.exists("target")
		 and UnitIsDeadOrGhost("target")
		 and not UnitCanAttack("player", "target")) 
		 or not ni.unit.exists("target")) then
			ni.player.runtext("/targetenemy")
		end
	end,
-----------------------------------
    ["Poison Weapon"] = function()
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if applypoison 
		 and GetTime() - applypoison > 4 then 
			applypoison = nil 
		end
		if not UnitAffectingCombat("player") 
		and not applypoison then
		applypoison = GetTime()
		if not mh 
		 and ni.player.hasitem(43231) then
			ni.player.useitem(43231)
			ni.player.useinventoryitem(16)
			return true
		end
		if not oh
		 and ni.player.hasitem(43233) then
			ni.player.useitem(43233)
			ni.player.useinventoryitem(17)
			return true
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.meleeStop("target")
		 or data.PlayerDebuffs("player")
		 or UnitCanAttack("player","target") == nil
		 or (UnitAffectingCombat("target") == nil 
		 and ni.unit.isdummy("target") == nil 
		 and UnitIsPlayer("target") == nil) then 
			return true
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local value, enabled = GetSetting("healthstoneuse");
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if enabled
			 and ni.player.hp() < value
			 and ni.player.hasitem(hstones[i]) 
			 and ni.player.itemcd(hstones[i]) == 0 then
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
			if enabled
			 and ni.player.hp() < value
			 and ni.player.hasitem(hpot[i])
			 and ni.player.itemcd(hpot[i]) == 0 then
				ni.player.useitem(hpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Racial Stuff"] = function()
		local hracial = { 33697, 20572, 33702, 26297 }
		local bloodelf = { 25046, 28730, 50613 }
		local alracial = { 20594, 28880 }
		local _, enabled = GetSetting("detect")	
		--- Undead
		if data.forsaken("player")
		 and IsSpellKnown(7744)
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and data.rogue.InRange() then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Blood Elf
		for i = 1, #bloodelf do
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.power() < 60 
		 and IsSpellKnown(bloodelf[i])
		 and ni.spell.available(bloodelf[i])
		 and data.rogue.InRange() then 
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if data.rogue.InRange()
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Use enginer gloves"] = function()
		local _, enabled = GetSetting("detect")	
		if ni.player.slotcastable(10) 
		 and ni.player.slotcd(10) == 0
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and data.rogue.InRange() then
			ni.player.useinventoryitem(10)
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
		 and ni.player.slotcd(13) == 0 
		 and data.rogue.InRange() then
			ni.player.useinventoryitem(13)
		else
		 if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and data.rogue.InRange() then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------	
	["Kick (Interrupt)"] = function()
		local _, enabled = GetSetting("autointerrupt")
		if data.TryInterrupt("target", enabled, 1766, 0.35) then
			return true
		end
	end,
-----------------------------------	
	["Tricks of the Trade"] = function()
		local _, enabled = GetSetting("detect")	
		if ( ni.unit.threat("player") >= 2
		 or data.CDorBoss("target", 5, 35, 5, enabled) )
		 and ni.unit.exists("focus")
		 and ni.spell.available(57934)
		 and ni.spell.valid("focus", 57934, false, true, true) then
			ni.spell.cast(57934, "focus")
			return true
		else 
		local tank = ni.tanks()
		if ( ni.unit.threat("player") >= 2
		 or data.CDorBoss("target", 5, 35, 5, enabled) )
		  and not ni.unit.exists("focus")
		  and ni.spell.available(57934)
		  and data.youInInstance() 
		  and ni.spell.valid(tank, 57934, false, true, true) then
			ni.spell.cast(57934, tank)
			return true
			end
		end
	end,
-----------------------------------
	["Fan of Knives"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(51723)
		 and ni.spell.valid("target", 48638, true, true) then
			ni.spell.castat(51723, "target")
			ni.player.runtext("/targetlasttarget")
			return true
		end
	end,
-----------------------------------
	["Riposte"] = function()
		if IsSpellKnown(14251)
		 and IsUsableSpell(GetSpellInfo(14251)) 
		 and ni.spell.available(14251)
		 and ni.spell.valid("target", 14251, true, true) then
			ni.spell.cast(14251, "target")
			return true
		end
	end,
-----------------------------------
	["Garrote/Ambush"] = function()
		local OGar = data.rogue.OGar()
		local _, enabled = GetSetting("detect")	
		if ni.player.buff(1784)
		 and data.CDorBoss("target", 5, 35, 5, enabled) then
		  if not OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(48676)
		   and ni.spell.valid("target", 48676, true, true) then
			  ni.spell.cast(48676, "target")
			  return true
		end
		  if OGar
		   and ni.player.isbehind("target")
		   and ni.spell.available(48691)
		   and ni.spell.valid("target", 48691, true, true) then
			  ni.spell.cast(48691, "target")
			  return true
			end
		end
	end,
-----------------------------------
	["Blade Flurry"] = function()
		local _, enabled = GetSetting("detect")	
		if ( data.CDorBoss("target", 5, 35, 5, enabled) 
		 or ni.vars.combat.aoe )
		 and ni.spell.available(13877)
		 and not ni.spell.available(51690)
		 and data.rogue.InRange() then
			ni.spell.cast(13877)
			return true
		end
	end,
-----------------------------------
	["Adrenaline Rush"] = function()
		local _, enabled = GetSetting("detect")	
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.power() < 35
		 and ni.spell.available(13750)
		 and not ni.spell.available(51690)
		 and data.rogue.InRange() then
			ni.spell.cast(13750)
			return true
		end
	end,
-----------------------------------
	["Killing Spree"] = function()
		local SnD = data.rogue.SnD()
		local _, enabled = GetSetting("detect")	
		if SnD
		 and ni.spell.available(51690)
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and data.rogue.InRange() then
			ni.spell.cast(51690, "target")
			return true
		end
	end,
-----------------------------------
	["Slice and Dice"] = function()
		local SnD = data.rogue.SnD()
		if GetComboPoints("player") > 3
		 and ( not SnD or ( SnD <= 4 ) )
		 and ni.spell.available(6774)
		 and data.rogue.InRange() then
			ni.spell.cast(6774)
			return true
		end
	end,
-----------------------------------
	["Sinister Strike"] = function()
		if GetComboPoints("player") < 5
		 and ni.spell.available(48638)
		 and ni.spell.valid("target", 48638, true, true) then
			ni.spell.cast(48638, "target")
			return true
		end
	end,
-----------------------------------
	["Rupture"] = function()
		local SnD = data.rogue.SnD()
		local Rup = data.rogue.Rup()
		if  GetComboPoints("player") == 5
		 and ( not Rup or ( Rup <= 3 ) )
		 and ( SnD and ( SnD > 5 ) )
		 and ni.spell.available(48672)
		 and ni.spell.valid("target", 48672, true, true) then
			ni.spell.cast(48672, "target")
			return true
		end
	end,
-----------------------------------
	["Eviscerate Dump"] = function()
		local SnD = data.rogue.SnD()
		local Rup = data.rogue.Rup()
		if  GetComboPoints("player") == 5
		 and Rup
		 and ( SnD and ( SnD > 5 ) )
		 and ni.spell.available(48668)
		 and ni.spell.valid("target", 48668, true, true) then
			ni.spell.cast(48668, "target")
			return true
		end
	end,
-----------------------------------
	["Eviscerate"] = function()
		local SnD = data.rogue.SnD()
		if  GetComboPoints("player") == 5
		 and ( SnD and ( SnD > 5 ) )
		 and ni.spell.available(48668)
		 and ni.spell.valid("target", 48668, true, true) then
			ni.spell.cast(48668, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Combat Rogue by DarhangeR for 3.3.5a", 
		 "Welcome to Combat Rogue Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-Focus ally target for use TofT on it or put tank name to Tank Overrides and press Enable Main.\n-Rotation developed for Rupture or Eviscerate builds.\n-For chose build select it in GUI menu.\n-For use Fan of Knives configure AoE Toggle key.")
		popup_shown = true;
		end 
	end,
}

local function queue()
	local build = GetSetting("builds")
	 if build == 1 then
	  return EviscerateBuild;
	elseif build == 2 then
	  return RaptureBuild;
	end
end

    ni.bootstrap.profile("Combat_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
else
    local queue = {
        "Error",
    }
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
    ni.bootstrap.profile("Combat_DarhangeR", queue, abilities);
end	
