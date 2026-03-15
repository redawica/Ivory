local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
local function ActiveEnemies()
	return data.GetActiveEnemies("target", 7, true, 0.15)
end
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_Enchancment.xml",
	{ type = "title", text = "Enhancement Shaman by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },		
	{ type = "title", text = "Lightning/Water Shields" },
	{ type = "dropdown", menu = {
        { selected = true, value = 49281, text = "\124T"..data.shaman.lightIcon()..":20:20\124t Lightning Shield" },
        { selected = false, value = 57960, text = "\124T"..data.shaman.waterIcon()..":20:20\124t Water Shield" },	
	}, key = "Shields" },
	{ type = "entry", text = " "},
	{ type = "entry", text = "\124T"..data.shaman.interIcon()..":26:26\124t Auto Interrupt", tooltip = "Auto check and interrupt all interruptible spells", enabled = true, key = "autointerrupt" },	
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },		
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.shaman.lhwaveIcon()..":26:26\124t  /  \124T"..data.shaman.hwaveIcon()..":26:26\124t Lesser/Healing Wave (Self)", tooltip = "Use spell when player HP < %. Work only in open world!", enabled = true, value = 65, key = "waves" },
	{ type = "entry", text = "Enable everywhere Lesser/Healing Wave (Self)", tooltip = "After enable igonore settings and use spell everywhere", enabled = false, key = "wavesevery" },
	{ type = "entry", text = "\124T"..data.shaman.rageIcon()..":26:26\124t Shamanistic Rage no T10 (Mana threshold)", tooltip = "Use spell when player mana < %", enabled = true, value = 35, key = "rage" },	
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %",  enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "\124T"..data.mpotionIcon()..":26:26\124t Mana Potion", tooltip = "Use Mana Potions (if you have) when player mana < %", enabled = true, value = 25, key = "manapotionuse" },
	{ type = "separator" },
	{ type = "page", number = 2, text = "|cffEE4000Rotation Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.controlIcon()..":26:26\124t Auto Control (Member)", tooltip = "Auto check and control member if he mindcontrolled or etc.", enabled = true, key = "control" },	
	{ type = "entry", text = "\124T"..data.shaman.purgeIcon()..":26:26\124t Purge", tooltip = "Purge proper spell. You can edit table in Data file.", enabled = true, key = "purge" },	
	{ type = "entry", text = "\124T"..data.shaman.totemIcon()..":26:26\124t Pull Totems (Auto)", tooltip = "Auto pull totem", enabled = true, key = "totempull" },	
	{ type = "entry", text = "\124T"..data.shaman.novaIcon()..":26:26\124t Fire Nova (CD's Dump)", tooltip = "Work if Pull Totems enabled to", enabled = true, key = "firenova" },
	{ type = "separator" },
	{ type = "title", text = "Dispel" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.shaman.cureIcon()..":26:26\124t Cure Toxins", tooltip = "Auto dispel debuffs from player", enabled = true, key = "toxins" },
	{ type = "entry", text = "\124T"..data.shaman.cureIcon()..":26:26\124t Cure Toxins (Member)", tooltip = "Auto dispel debuffs from members", enabled = false, key = "toxinsmemb" },	
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
	ni.GUI.AddFrame("Enhancement_DarhangeR", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Enhancement_DarhangeR");
end

local queue = {
	
	"Universal pause",
	"AutoTarget",
	"Enchant Weapon",
	"Lightning/Water Shield",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Trinkets (Config)",
	"Racial Stuff",
		"Use enginer gloves",
		"Trinkets",
	"Wind Shear (Interrupt)",
	"Totems pull",
	"Magma Totem",
	"Feral Spirit",
	"Shamanistic Rage",
	"Purge",
	"Control (Member)",
	"Lesser/Healing Wave (Self)",
	"Cure Toxins (Member)",
	"Cure Toxins (Self)",
	"Chain Lightning/Bolt",
	"Fire Nova",
	"Stormstrike",
	"Flame Shock",
	"Earth Shock",
	"Lava Lash",
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
    ["Enchant Weapon"] = function()
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if not mh
		 and ni.spell.available(58804) then
			ni.spell.cast(58804)
			return true
		end
		if not oh
		 and ni.spell.available(58790) then
			ni.spell.cast(58790)
			return true
		end
	end,
-----------------------------------
	["Lightning/Water Shield"] = function()
		local shield = GetSetting("Shields");
		 if not ni.player.buff(shield)
		 and ni.spell.available(shield) then
			ni.spell.cast(shield)
			return true
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and ni.unit.exists("playerpet")
		 and ni.unit.exists("target")
		 and UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			data.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and ni.unit.exists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and ni.unit.exists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then 
			data.petAttack()
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
	["Mana Potions (Use)"] = function()
		local value, enabled = GetSetting("manapotionuse");
		local mpot = { 33448, 43570, 40087, 42545, 39671 }
		for i = 1, #mpot do
			if enabled
			 and ni.player.power() < value
			 and ni.player.hasitem(mpot[i])
			 and ni.player.itemcd(mpot[i]) == 0 then
				ni.player.useitem(mpot[i])
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
		 and data.shaman.InRange() then 
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
		 and data.shaman.InRange() then 
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if data.shaman.InRange()
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
		 and data.shaman.InRange() then
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
		 and data.shaman.InRange() then
			ni.player.useinventoryitem(13)
		else
		 if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and data.shaman.InRange() then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------		
	["Wind Shear (Interrupt)"] = function()
		local _, enabled = GetSetting("autointerrupt")
		if data.TryInterrupt("target", enabled, 57994, 0.35) then
			return true
		end
	end,
-----------------------------------
	["Totems pull"] = function()
		local _, enabled = GetSetting("totempull")
		if enabled
		 and not tContains(UnitName("target"), ni.IgnoreUnits) then
		 local earthTotem = select(2, GetTotemInfo(2))
		 local totem_distance = ni.unit.distance("target", "totem1")
		 local target_distance = ni.player.distance("target")
		 if data.shaman.InRange()
		 and (earthTotem == ""
		 or (earthTotem ~= ""
		 and target_distance ~= nil
		 and target_distance < 6
		 and totem_distance ~= nil
		 and totem_distance > 10))
		 and not ni.player.ismoving() then
			ni.spell.cast(66842)
			return true
			end
		end
	end,
-----------------------------------
	["Magma Totem"] = function()
		local _, enabled = GetSetting("totempull")
		if enabled
		 and not tContains(UnitName("target"), ni.IgnoreUnits) then
 		 local fireTotem = select(2, GetTotemInfo(1))
		 local totem_distance = ni.unit.distance("target", "totem1")
		 local target_distance = ni.player.distance("target")
		 if data.shaman.InRange()
		 and (fireTotem == ""
		 or (fireTotem ~= ""
		 and target_distance ~= nil
		 and target_distance < 6
		 and totem_distance ~= nil
		 and totem_distance > 10))
		 and not ni.player.ismoving() then
			ni.spell.cast(58734)
			return true
			end
		end
	end,
-----------------------------------
	["Shamanistic Rage"] = function()
		local value, enabled1 = GetSetting("rage");
		local _, enabled = GetSetting("detect")	
		if data.checkforSet(data.shaman.itemsetT10Enc, 2)
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.spell.available(30823)
		 and data.shaman.InRange() then
			ni.spell.cast(30823, "target")
			return true
		end
		if enabled1
		 and ni.player.power() < value
		 and ni.spell.available(30823)
		 and data.shaman.InRange() then
			ni.spell.cast(30823, "target")
			return true
		end
	end,
-----------------------------------
	["Feral Spirit"] = function()
		local _, enabled = GetSetting("detect")	
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and not ni.unit.exists("playerpet")
		 and ni.spell.available(51533)
		 and data.shaman.InRange() then
			ni.spell.cast(51533)
			return true
		end
	end,
-----------------------------------
	["Chain Lightning/Bolt"] = function()
		if ni.player.buffstacks(53817) == 5 then
		 if ( ActiveEnemies() > 1 or ActiveEnemies() == 1 )
		 and ni.spell.isinstant(49271)
		 and ni.spell.available(49271)
		 or not data.shaman.InRange()
		 and ni.spell.valid("target", 49271, true, true) then 
			ni.spell.cast(49271, "target")
			return true
		end
		if not ni.spell.available(49271)
		 and ni.spell.isinstant(49238)
		 and ni.spell.available(49238)
		 and ni.spell.valid("target", 49238, true, true) then 
			ni.spell.cast(49238, "target")
			return true
		end
		 if ActiveEnemies() < 1
		 and ni.spell.isinstant(49238)
		 and ni.spell.available(49238)
		 or not data.shaman.InRange()
		 and ni.spell.valid("target", 49238, true, true) then 
		 	ni.spell.cast(49238, "target")
			return true
			end	
		end
	end,
-----------------------------------
	["Lesser/Healing Wave (Self)"] = function()
		local value, enabled = GetSetting("waves");
		local _, enabledEv = GetSetting("wavesevery");
		if enabled
		 and ni.player.hp() < value
		 and ni.player.buffstacks(53817) == 5
		 and ((not data.youInInstance()
		 and not data.youInRaid())
		 or enabledEv ) then
		 if ni.spell.available(49273)
		  and ni.spell.isinstant(49273) then
				ni.spell.cast(49273, "player")
				return true
		 end
		 if not ni.spell.available(49273)
		  and ni.spell.isinstant(49276)
		  and ni.spell.available(49276) then
				ni.spell.cast(49276, "player")
				return true
			end
		end
	end,
-----------------------------------
	["Fire Nova"] = function()
		local totem_distance = ni.unit.distance("target", "totem1")
		local target_distance = ni.player.distance("target")
		local _, enabled = GetSetting("firenova")
		local _, enabledTotem = GetSetting("totempull")	
		if enabled
		 and enabledTotem
		 and ni.spell.available(61657)
		 and not ni.spell.available(49231)
		 and not ni.spell.available(17364)
		 and not ni.spell.available(60103) 
		 and fireTotem ~= ""
		 and target_distance < 7
		 and totem_distance < 7
		 and data.shaman.InRange() then
		 	ni.spell.cast(61657)
			return true
		end	
	end,
-----------------------------------
	["Flame Shock"] = function()
		if ni.unit.debuffremaining("target", 49233, "player") < 2
		 and ni.spell.available(49233)
		 and ni.spell.valid("target", 49233, true, true) then
			ni.spell.cast(49233, "target")
			return true
		end
	end,
-----------------------------------
	["Earth Shock"] = function()
		if ni.unit.debuffremaining("target", 49233, "player") > 4
		 and ni.spell.available(49231)
		 and ni.spell.valid("target", 49231, true, true) then
			ni.spell.cast(49231, "target")
			return true
		end
	end,
-----------------------------------
	["Stormstrike"] = function()
		if ni.player.buffstacks(53817) < 5
		 and ni.spell.available(17364)
		 and ni.spell.valid("target", 17364, true, true) then
			ni.spell.cast(17364, "target")
			return true
		end
	end,
-----------------------------------
	["Lava Lash"] = function()
		if ni.player.buffstacks(53817) < 5
		 and ni.spell.available(60103)
		 and ni.spell.valid("target", 60103, true, true) then
			ni.spell.cast(60103, "target")
			return true
		end
	end,
-----------------------------------
	["Cure Toxins (Self)"] = function()
		local _, enabled = GetSetting("toxins")
		if enabled
		  and ni.player.debufftype("Disease|Poison")
		  and ni.spell.available(526)
		  and ni.healing.candispel("player")
		  and GetTime() - data.LastDispel > 1.5
		  and ni.spell.valid("player", 526, false, true, true) then
			ni.spell.cast(526, "player")
			data.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Cure Toxins (Member)"] = function()
		local _, enabled = GetSetting("toxinsmemb")
		if enabled
		 and ni.spell.available(526) then
		  for i = 1, #ni.members do
		  if ni.unit.debufftype(ni.members[i].unit, "Disease|Poison")
		   and ni.healing.candispel(ni.members[i].unit)
		   and GetTime() - data.LastDispel > 1.5
		   and ni.spell.valid(ni.members[i].unit, 526, false, true, true) then
				ni.spell.cast(526, ni.members[i].unit)
				data.LastDispel = GetTime()
				return true
				end
			end
		end
	end,
-----------------------------------
	["Purge"] = function()
		local _, enabled = GetSetting("purge")
		if enabled
		 and data.shaman.canPurge("target")
		 and ni.spell.available(8012)
		 and ni.spell.valid("player", 8012, true, true)
		 and GetTime() - data.shaman.LastPurge > 2.5 then
			ni.spell.cast(8012, "target")
			data.shaman.LastPurge = GetTime()
			return true
		end
	end,
-----------------------------------
	["Control (Member)"] = function()
		local _, enabled = GetSetting("control")
		if enabled
		 and ni.spell.available(51514) then
		  for i = 1, #ni.members do
		   local ally = ni.members[i].unit
		    if data.ControlMember(ally)
			and not data.UnderControlMember(ally)
			and ni.spell.valid(ally, 51514, false, true, true) then
				ni.spell.cast(51514, ally)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Enhancement Shaman by DarhangeR for 3.3.5a", 
		 "Welcome to Enhancement Shaman Profile! Support and more in Discord > https://discord.gg/TEQEJYS.")	
		popup_shown = true;
		end 
	end,
}

	ni.bootstrap.profile("Enhancement_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
    ni.bootstrap.profile("Enhancement_DarhangeR", queue, abilities);
end
