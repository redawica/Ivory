local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
local function ActiveEnemies()
	return data.GetActiveEnemies("target", 7, true, 0.15)
end
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_BeastMaster.xml",
	{ type = "title", text = "Beastmaster Hunter by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },	
	{ type = "entry", text = "\124T"..data.hunter.dragonIcon()..":26:26\124t Aspect of the Dragonhawk (Mana cup)", tooltip = "Use spell when player mana > %", value = 85, key = "dragon" },
	{ type = "entry", text = "\124T"..data.hunter.viperIcon()..":26:26\124t Aspect of the Viper (Mana threshold)", tooltip = "Use spell when player mana < %", value = 15, key = "viper" },
	{ type = "entry", text = "\124T"..data.hunter.mendIcon()..":26:26\124t Mend Pet", tooltip = "Use spell when pet HP < %", enabled = true, value = 80, key = "mendpet" },	
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },		
	{ type = "separator" },
	{ type = "title", text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.hunter.feignIcon()..":26:26\124t Feign Death", tooltip = "Use spell for reset agro", enabled = true, key = "feign" },	
	{ type = "entry", text = "\124T"..data.hunter.deterIcon()..":26:26\124t Deterrence", tooltip = "Use spell when player HP < %", enabled = true, value = 25, key = "deterrence" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %",  enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "\124T"..data.mpotionIcon()..":26:26\124t Mana Potion", tooltip = "Use Mana Potions (if you have) when player mana < %", enabled = true, value = 25, key = "manapotionuse" },
	{ type = "separator" },
	{ type = "title", text = "|cffEE4000Rotation Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.hunter.scareIcon()..":26:26\124t Scare Beast (Auto Use)", tooltip = "Auto check and use spell on proper enemies", enabled = false, key = "scare" },	
	{ type = "entry", text = "\124T"..data.hunter.killIcon()..":26:26\124t Kill Shot (Auto Check)", tooltip = "Auto check ''execute'' target in this spell range and use it.", enabled = true, key = "masskill" },		
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
	ni.GUI.AddFrame("BeastMaster_DarhangeR", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("BeastMaster_DarhangeR");
end

local queue = {
	
	"Cancel Deterrence",
	"Universal pause",
	"AutoTarget",
	"Aspect of the Dragonhawk",
	"Aspect of the Viper",
	"Pet:Heart of the Phoenix",
	"Mend Pet",
	"Hunter's Mark",
	"Auto Track Targets",	
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets (Config)",
	"Trinkets",
	"Deterrence",
	"Wing Clip",
	"Volley",
	"Freezing Arrow",
	"Rapid Fire",
	"Bestial Wrath",
	"Pet:Call of the Wild",
	"Kill Command",
	"Misdirection",
	"Feign Death",
	"Mongoose Bite",
	"Raptor Strike",
	"Tranquilizing Shot",
	"Scare Beast (Auto Use)",
	"Kill Shot",
	"Multi-Shot (AoE)",
	"Serpent Sting",
	"Arcane Shot",
	"Aimed Shot",
	"Steady Shot",
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
	["Auto Track Targets"] = function()
		if select(5, GetTalentInfo(3,1)) > 3 then
		 if not UnitAffectingCombat("player") 
		  and GetTime() - data.hunter.LastTrack > 3 then
				SetTracking(nil);	
		 end
		 if UnitAffectingCombat("player")
		  and ni.unit.exists("target") then	  
				data.hunter.setTracking();
			end	
		end
	end,
-----------------------------------
	["Aspect of the Dragonhawk"] = function()
		local value = GetSetting("dragon");
		if not ni.player.buff(61847)
		 and ni.spell.available(61847)
		 and ni.player.power() > value then
			ni.spell.cast(61847)
			return true
		end
	end,
-----------------------------------
	["Aspect of the Viper"] = function()
		local value = GetSetting("viper");
		if not ni.player.buff(34074)
		 and ni.spell.available(34074)
		 and ni.player.power() < value then
			ni.spell.cast(34074)
			return true
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and ni.unit.exists("playerpet")
		 and ni.unit.exists("target")
		 and UnitIsUnit("target", "pettarget")
		 and ni.unit.buff("pet", 48990)
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
	["Mend Pet"] = function()
		local value, enabled = GetSetting("mendpet");
		if enabled
		 and ni.unit.hp("playerpet") < value
		 and not ni.unit.buff("pet", 48990)
		 and ni.unit.exists("playerpet")
		 and UnitInRange("playerpet")
		 and ni.spell.available(48990)
		 and not UnitIsDeadOrGhost("playerpet") then
			ni.spell.cast(48990)
			return true
		end
	end,
-----------------------------------
	["Hunter's Mark"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled) 
		 and not ni.unit.debuff("target", 53338)
		 and ni.spell.available(53338)		 
		 and ni.spell.valid("target", 53338, true, true) then
			ni.spell.cast(53338)
			return true
		end
	end,
-----------------------------------
	["Cancel Deterrence"] = function()
		local p = "player" for i = 1,40 
		do local _,_,_,_,_,_,_,u,_,_,s = UnitBuff(p,i)
		 if ni.player.hp() > 45
		 and u == p and s == 19263 then
				CancelUnitBuff(p, i)
				break 
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
		 and data.hunter.InRange() then 
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
		 and data.hunter.InRange() then 
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if data.hunter.InRange()
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
		 and data.hunter.InRange() then
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
		 and data.hunter.InRange() then
			ni.player.useinventoryitem(13)
		else
		 if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and data.hunter.InRange() then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Deterrence"] = function()
		local value, enabled = GetSetting("deterrence");
		if enabled
		 and ni.player.hp() < value
		 and ni.spell.available(19263)
		 and not ni.player.buff(19263) then
			ni.spell.cast(19263)
			return true
		end
	end,
-----------------------------------
	["Wing Clip"] = function()
		if ni.player.distance("target") < 2
		 and not ni.unit.debuff("target", 2974)
		 and ni.spell.available(2974)
		 and ni.spell.valid("target", 53339, true, true) then
			ni.spell.cast(2974, "target")
			return true
		end
	end,
-----------------------------------
	["Volley"] = function()
		if ni.vars.combat.aoe
		 and not ni.player.ismoving()
		 and ni.spell.available(58434) then
			ni.spell.castat(58434, "target")
			return true
		end
	end,
-----------------------------------
	["Freezing Arrow"] = function()
		if ni.rotation.custommod()
		 and ni.spell.available(60192) then
			ni.spell.castat(60192, "target")
			return true
		end
	end,
-----------------------------------
	["Rapid Fire"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and not ni.player.buff(3045)
		 and ni.player.buff(61847)
		 and ni.spell.available(3045)
		 and data.hunter.InRange() then
			ni.spell.cast(3045)
			return true
		end
	end,
-----------------------------------
	["Bestial Wrath"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.unit.exists("playerpet")
		 and UnitInRange("playerpet")
		 and ni.spell.available(19574)
		 and data.hunter.InRange() then
			ni.spell.cast(19574)
			return true
		end
	end,		
-----------------------------------
	["Pet:Call of the Wild"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and IsSpellKnown(53434, true)
		 and GetSpellCooldown(53434) == 0 then
			ni.spell.cast(53434)
			return true
		end
	end,
-----------------------------------
	["Pet:Heart of the Phoenix"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and IsSpellKnown(55709, true)
		 and GetSpellCooldown(55709) == 0 then
			ni.spell.cast(55709)
			return true
		end
	end,
-----------------------------------
	["Kill Command"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.unit.exists("playerpet")
		 and ni.spell.available(34026)
		 and data.hunter.InRange() then
			ni.spell.cast(34026)
			return true
		end
	end,
-----------------------------------
	["Misdirection"] = function()
		local tank = ni.tanks()
		local _, enabled = GetSetting("detect")
		if ( ni.unit.threat("player") >= 2
		 or data.CDorBoss("target", 5, 35, 5, enabled))
		 and ni.spell.available(34477) then
		if ni.unit.exists("focus")		 
		 and not UnitIsDeadOrGhost("focus")
		 and ni.spell.valid("focus", 34477, false, true, true) then
			ni.spell.cast(34477, "focus")
			data.hunter.LastMD = GetTime()
			return true
		else 
		if not ni.unit.exists("focus")
		 and not ni.unit.exists(tank)
		 and ni.unit.exists("playerpet")
		 and not UnitIsDeadOrGhost("playerpet")
		 and ni.spell.valid("playerpet", 34477, false, true, true) then
			ni.spell.cast(34477, "playerpet")
			data.hunter.LastMD = GetTime()
			return true
		else
		if ni.unit.exists(tank)
		 and data.youInInstance() 
		 and ni.spell.valid(tank, 34477, false, true, true) then
			ni.spell.cast(34477, tank)
			data.hunter.LastMD = GetTime()
			return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Feign Death"] = function()
		local _, enabled = GetSetting("feign");
		if enabled
		 and ni.unit.threat("player", "target") >= 2
		 and ni.unit.exists("focus")
		 and ni.spell.available(5384)
		 and not ni.spell.available(34477)
		 and GetTime() - data.hunter.LastMD > 3
		 and ni.spell.available(5384) then
			ni.spell.cast(5384)
			return true
		end
	end,
-----------------------------------
	["Mongoose Bite"] = function()
		if ni.spell.available(53339)
		 and ni.spell.available(53339)
		 and ni.spell.valid("target", 53339, true, true) then
			ni.spell.cast(53339, "target")
			return true
		end
	end,
-----------------------------------
	["Raptor Strike"] = function()
		if ni.spell.available(48996, true)
		 and ni.spell.valid("target", 53339, true, true) then
			ni.spell.cast(48996, "target")
			return true
		end
	end,
-----------------------------------
	["Kill Shot"] = function()
		if (ni.unit.hp("target") <= 20
		 or IsUsableSpell(GetSpellInfo(61006)))
		 and ni.player.buff(61847)
		 and ni.spell.available(61006)
		 and ni.spell.valid("target", 61006, true, true) then
			ni.spell.cast(61006, "target")
			return true
		end
	end,
-----------------------------------
	["Kill Shot (Auto Target)"] = function()
		local _, enabled = GetSetting("masskill")
		if enabled
		 and ni.spell.available(61006)
		 and UnitCanAttack("player", "target") then
		 table.wipe(enemies);
		  enemies = ni.unit.enemiesinrange("player", 29)
		  for i = 1, #enemies do
		   local executetar = enemies[i].guid;
		    if ni.unit.hp(executetar) < 20
			and ni.spell.valid(executetar, 61006, true, true) then
					ni.spell.cast(61006, executetar)
					return true
				end
			end					
		end
	end,
-----------------------------------
	["Multi-Shot (AoE)"] = function()
		if ActiveEnemies() >= 2
		 and ni.spell.available(49048)
		 and ni.spell.valid("target", 49048, true, true) then
			ni.spell.cast(49048, "target")
			return true
		end
	end,
-----------------------------------
	["Serpent Sting"] = function()
		local serpstring = data.hunter.serpstring()
		if (not serpstring or (serpstring <= 2))	 
		 and ni.spell.available(49001)
		 and ni.spell.valid("target", 49001, true, true) then
			ni.spell.cast(49001, "target")
			return true
		end
	end,
-----------------------------------
	["Arcane Shot"] = function()
		if ni.spell.available(49045)
		 and ni.spell.valid("target", 49045, true, true) then
			ni.spell.cast(49045, "target")
			return true
		end
	end,	
-----------------------------------
	["Aimed Shot"] = function()
		if ni.spell.available(49050)	
		 and ni.spell.valid("target", 49050, true, true) then
			ni.spell.cast(49050, "target")
			return true
		end
	end,
-----------------------------------
	["Steady Shot"] = function()
		if not ni.player.ismoving()
		 and ni.spell.cd(49045)
		 and ni.spell.available(49052)
		 and ni.spell.valid("target", 49052, true, true) then
			ni.spell.cast(49052, "target")
			return true
		end
	end,
-----------------------------------
	["Tranquilizing Shot"] = function()
		if ni.unit.bufftype("target", "Enrage|Magic")
		 and ni.spell.available(19801)
		 and ni.spell.valid("target", 19801, true, true) then
			ni.spell.cast(19801, "target")
			return true
		end
	end,
-----------------------------------
	["Scare Beast (Auto Use)"] = function()        
		local _, enabled = GetSetting("scare")
		if enabled 
		 and ni.unit.exists("target")
		 and ni.spell.available(14327)
		 and UnitCanAttack("player", "target") then
		 table.wipe(enemies);
		  enemies = ni.unit.enemiesinrange("player", 25)
		  local dontScare = false
		  for i = 1, #enemies do
		   local tar = enemies[i].guid; 
		   if (ni.unit.creaturetype(enemies[i].guid) == 1 
		    or ni.unit.aura(enemies[i].guid, 2645)
			or ni.unit.aura(enemies[i].guid, 768)
			or ni.unit.aura(enemies[i].guid, 5487)
			or ni.unit.aura(enemies[i].guid, 9634))
		    and ni.unit.debuff(tar, 14327, "player") then
			dontScare = true
			break
		end
        end
		if not dontScare then
		 for i = 1, #enemies do
		 local tar = enemies[i].guid; 
		  if (ni.unit.creaturetype(enemies[i].guid) == 1 
		   or ni.unit.aura(enemies[i].guid, 2645)
		   or ni.unit.aura(enemies[i].guid, 768)
		   or ni.unit.aura(enemies[i].guid, 5487)
		   or ni.unit.aura(enemies[i].guid, 9634))
		   and not ni.unit.isboss(tar)
		   and not ni.unit.debuffs(tar, "23920||35399||69056", "EXACT")
		   and not ni.unit.debuff(tar, 14327, "player")
		   and ni.spell.valid(enemies[i].guid, 14327, false, true)
		   and GetTime() - data.hunter.LastScare > 1.5 then
				ni.spell.cast(14327, tar)
				data.hunter.LastScare = GetTime()
                        return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		ni.debug.popup("Beast Mastery Hunter by DarhangeR for 3.3.5a", 
		"Welcome to Beast Mastery Hunter Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For use Volley configure AoE Toggle key.\n-Focus target for use Misdirection & Feign Death.\n-For use Freezing Arrow configure Custom Key Modifier and hold it for use it.\n-For better experience make Pet passive.")	
		popup_shown = true;
		end 
	end,
}

	ni.bootstrap.profile("BeastMaster_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
    ni.bootstrap.profile("BeastMaster_DarhangeR", queue, abilities);
end