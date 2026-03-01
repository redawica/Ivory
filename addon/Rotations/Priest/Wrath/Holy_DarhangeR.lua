local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local enemies = { };
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_HolyPriest.xml",
	{ type = "title", text = "Holy Priest by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.priest.fearIcon()..":26:26\124t Fear Ward (Self)", tooltip = "Use spell on player", enabled = false, key = "fearward" },
	{ type = "entry", text = "\124T"..data.priest.fearIcon()..":26:26\124t Fear Ward (Focus)", tooltip = "Use spell on focus target", enabled = false, key = "fearwardmemb" },
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },	
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.priest.despPlaIcon()..":26:26\124t Desperate Prayer", tooltip = "Use spell when player HP < %", enabled = true, value = 25, key = "despplayer" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %",  enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "\124T"..data.mpotionIcon()..":26:26\124t Mana Potion", tooltip = "Use Mana Potions (if you have) when player mana < %", enabled = true, value = 25, key = "manapotionuse" },
	{ type = "separator" },
	{ type = "page", number = 2, text = "|cff95f900CD's and important spells" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.priest.painIcon()..":26:26\124t Exorcism", tooltip = "Use spell when player mana > 75%", enabled = false, key = "pain" },
	{ type = "entry", text = "\124T"..data.priest.shackIcon()..":26:26\124t Shackle Undead (Auto Use)", tooltip = "Auto check and use spell on proper enemies", enabled = false, key = "shackundead" },
	{ type = "entry", text = "\124T"..data.priest.guardIcon()..":26:26\124t Guardian Spirit", tooltip = "Use spell when member HP < %", enabled = true, value = 20, key = "guard" },
	{ type = "entry", text = "\124T"..data.priest.innerIcon()..":26:26\124t +  \124T"..data.priest.hymnIcon()..":26:26\124t Inner Focus + Divine Hymn", tooltip = "Enable spell", enabled = true, key = "innerhymn" },
	{ type = "entry", text = "Inner Focus + Divine Hymn (Members HP)", tooltip = "Use spell when member HP < %", value = 35, key = "innerhymnhp" },
	{ type = "entry", text = "Inner Focus + Divine Hymn (Members Count)", tooltip = "Use spell when member count in Party/Raid have low hp", value = 9, key = "innerhymncount" },
	{ type = "separator" },
	{ type = "title", text = "Dispel" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.priest.dispIcon()..":26:26\124t Dispel Magic (Member)", tooltip = "Auto dispel debuffs from members", enabled = true, key = "dispelmagmemb" },
	{ type = "entry", text = "\124T"..data.priest.abolIcon()..":26:26\124t Abolish Disease (Member)", tooltip = "Auto dispel debuffs from members", enabled = true, key = "abolishmb" },
	{ type = "separator" },
	{ type = "page", number = 3, text = "|cff95f900Healing spells settings" },
	{ type = "separator" },
	{ type = "entry", text = "Non Combat Healing", tooltip = "Heal members after fight when HP < %", enabled = true, value = 95, key = "noncombatheal" },
	{ type = "entry", text = "\124T"..data.tankIcon()..":26:26\124t Priority Tank", tooltip = "Priority Tank healing first", enabled = true, key = "healtank" },	
	{ type = "entry", text = "\124T"..data.priest.mendIcon()..":26:26\124t Prayer of Mending", tooltip = "Enabled only if Tank Priority off!", value = 95, key = "mend" },		
	{ type = "entry", text = "\124T"..data.priest.flashIcon()..":26:26\124t Flash Heal", tooltip = "Use spell when member HP < %", enabled = true, value = 79, key = "flash" },		
	{ type = "entry", text = "\124T"..data.priest.prayIcon()..":26:26\124t Prayer of Healing", tooltip = "Use spell when member HP < %", enabled = true, value = 73, key = "prayer" },	
	{ type = "entry", text = "\124T"..data.priest.circIcon()..":26:26\124t Circle of Healing", tooltip = "Use spell when members HP < %", enabled = true, value = 87, key = "circle" },	
	{ type = "separator" },
	{ type = "title", text = "Build Settings" },
    { type = "dropdown", menu = {
        { selected = true, value = 1, text = "Renew Build" },
        { selected = false, value = 2, text = "Serendipity Build" },
    }, key = "builds" },	
	{ type = "separator" },	
	{ type = "title", text = "|cff00C957Renew Build Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.priest.renewIcon()..":26:26\124t Renew (All Members)", tooltip = "Use spell when member HP < %", enabled = true, value = 99, key = "renewall" },	
	{ type = "separator" },	
	{ type = "title", text = "|cff00C957Serendipity Build Settings" },
	{ type = "separator" },	
	{ type = "entry", text = "\124T"..data.priest.renewIcon()..":26:26\124t Renew", tooltip = "Use spell when member HP < %. And you move or your mana < 55%", enabled = true, value = 89, key = "renew" },	
	{ type = "entry", text = "\124T"..data.priest.greatIcon()..":26:26\124t Greater Heal", tooltip = "Use spell when member HP < %", enabled = true, value = 58, key = "great" },
	{ type = "separator" },
	{ type = "page", number = 6, text = "|cff00BFFFTrinkets (Config)" },
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
	ni.GUI.AddFrame("Holy_DarhangeR", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Holy_DarhangeR");
end

local RenewBuildActive = {
	
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",
	"Non Combat Healing",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Trinkets (Config)",
	"Racial Stuff",
	"Shadowfiend",
	"Fade",
	"Desperate Prayer",
	"Shackle Undead (Auto Use)",
	"Inner Focus",
	"Divine Hymn",
	"Tank Heal",
	"Valithria Heal",
	"Guardian Spirit",
	"Shadow Word: Pain",
	"Prayer of Healing (Renew Build)",
	"Circle of Healing",
	"Abolish Disease (Member)",
	"Dispel Magic (Member)",		
	"Prayer of Mending",
	"Flash Heal",
	"Renew (All Members)",
}
local SerenBuildACtive = {
		
	"Universal pause",
	"Inner Fire",
	"Prayer of Fortitude",
	"Prayer of Spirit",
	"Prayer of Shadow Protection",
	"Fear Ward",
	"Non Combat Healing",	
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Trinkets (Config)",
	"Racial Stuff",
	"Shadowfiend",
	"Fade",
	"Desperate Prayer",
	"Shackle Undead (Auto Use)",
	"Inner Focus",
	"Divine Hymn",
	"Tank Heal",
	"Valithria Heal",
 	"Guardian Spirit",
	"Shadow Word: Pain",
	"Prayer of Healing (Serendipity)",	
	"Circle of Healing",
	"Greater Heal (Serendipity)",
	"Abolish Disease (Member)",
	"Dispel Magic (Member)",		
	"Prayer of Mending",
	"Flash Heal",
	"Renew",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if (data.UniPause() 
		 or data.PlayerDebuffs("player")) then
			return true
		end
		ni.vars.debug = select(2, GetSetting("Debug"));
	end,
-----------------------------------
	["Inner Fire"] = function()
		if not ni.player.buff(48168)
		 and ni.spell.available(48168) then
			ni.spell.cast(48168)
			return true
		end
	end,
-----------------------------------
	["Prayer of Fortitude"] = function()
		if ni.player.buff(48162)
		 or not IsUsableSpell(GetSpellInfo(48162)) then 
		 return false
	end
		if ni.spell.available(48162) then
			ni.spell.cast(48162)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Spirit"] = function()
		if ni.player.buffs("48074||57567")
		 or not IsUsableSpell(GetSpellInfo(48074)) then 
		 return false
	end
		if ni.spell.available(48074) then
			ni.spell.cast(48074)	
			return true
		end
	end,
-----------------------------------
	["Prayer of Shadow Protection"] = function()
		if ni.player.buff(48170)
		 or not IsUsableSpell(GetSpellInfo(48170)) then 
		 return false
	end
		if ni.spell.available(48170) then
			ni.spell.cast(48170)	
			return true
		end
	end,
-----------------------------------
	["Fear Ward"] = function()
		local _, enabled = GetSetting("fearward")
		local _, enabledM = GetSetting("fearwardmemb")
        if enabled
		 and not ni.player.buff(6346)
		 and ni.spell.available(6346) then
			ni.spell.cast(6346, "player")
			return true
		end
		if enabledM
		 and ni.unit.exists("focus")
		 and not ni.unit.buff("focus", 6346)
		 and ni.spell.available(6346)
		 and ni.spell.valid("focus", 6346, false, true, true) then
			ni.spell.cast(6346, "focus")
			return true
		end
	end,
-----------------------------------
	["Non Combat Healing"] = function()
		local value, enabled = GetSetting("noncombatheal");
		if enabled
		 and not UnitAffectingCombat("player")
		 and ni.spell.available(48068)		 
		 and ni.spell.available(48071) then
		   if ni.members[1].hp < value
		    and not ni.unit.buff(ni.members[1].unit, 48068, "player")
		    and ni.spell.valid(ni.members[1].unit, 48068, false, true, true) then
				ni.spell.cast(48068, ni.members[1].unit)
				return true
			end
		   if ni.members[1].hp < value
		    and not ni.player.ismoving()
		    and ni.spell.valid(ni.members[1].unit, 48071, false, true, true) then
				ni.spell.cast(48071, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if UnitAffectingCombat("player") then
			return false
		end
		for i = 1, #ni.members do
		if UnitAffectingCombat(ni.members[i].unit) then
				return false
			end
		end
			return true
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
	["Trinkets (Config)"] = function()
		if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
			return true
		end
	end,
-----------------------------------
	["Racial Stuff"] = function()
		local hracial = { 33697, 20572, 33702, 26297 }
		local bloodelf = { 25046, 28730, 50613 }
		local alracial = { 20594, 28880 }
		--- Undead
		if data.forsaken("player")
		 and IsSpellKnown(7744)
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if ni.members.averageof(7) < 40
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and ni.spell.valid("target", 48125) then 
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Blood Elf
		for i = 1, #bloodelf do
		if ni.player.power() < 70 
		 and IsSpellKnown(bloodelf[i])
		 and ni.spell.available(bloodelf[i])
		 and ni.spell.valid("target", 48125) then 
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 48125)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then 
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Fade"] = function()
		if #ni.members > 1 
		 and ni.unit.threat("player") >= 2
		 and not ni.player.buff(586)
		 and ni.spell.available(586) then
			ni.spell.cast(586)
			return true
		end
	end,
-----------------------------------
	["Desperate Prayer"] = function()
		local value, enabled = GetSetting("despplayer");
		if enabled
		 and ni.player.hp() < value
		 and IsSpellKnown(48173) 
		 and ni.spell.available(48173) then
			ni.spell.cast(48173)
			return true
		end
	end,
-----------------------------------
	["Shadowfiend"] = function()
		if ni.player.power() < 37
		 and ni.spell.available(34433) then
			ni.spell.cast(34433, "target")
			return true
		end
	end,
-----------------------------------
	["Shackle Undead (Auto Use)"] = function()        
		local _, enabled = GetSetting("shackundead")
		if enabled 
		 and ni.unit.exists("target")
		 and ni.spell.available(10955)
		 and UnitCanAttack("player", "target") then
		 table.wipe(enemies);
		  enemies = ni.unit.enemiesinrange("player", 25)
		  local dontShackle = false
		  for i = 1, #enemies do
		   local tar = enemies[i].guid; 
		   if (ni.unit.creaturetype(enemies[i].guid) == 6
		    or ni.unit.aura(enemies[i].guid, 49039))
		    and ni.unit.debuff(tar, 10955, "player") then
			dontShackle = true
				break
			end
		end
		if not dontShackle then
		 for i = 1, #enemies do
		 local tar = enemies[i].guid; 
		  if (ni.unit.creaturetype(enemies[i].guid) == 6
		   or ni.unit.aura(enemies[i].guid, 49039))
		   and not ni.unit.isboss(tar)
		   and not ni.unit.debuffs(tar, "23920||35399||69056", "EXACT")
		   and not ni.unit.debuff(tar, 10955, "player")
		   and ni.spell.valid(enemies[i].guid, 10955, false, true, true)
		   and GetTime() - data.priest.LastShackle > 1.5 then
				ni.spell.cast(10955, tar)
				data.priest.LastShackle = GetTime()
                        return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Inner Focus"] = function()
		local _, enabled = GetSetting("innerhymn");
		local valueHp = GetSetting("innerhymnhp");
		local valueCount = GetSetting("innerhymncount");		
		if enabled
		 and ni.members.averageof(valueCount) < valueHp
		 and ni.spell.available(14751)
		 and ni.spell.available(48066)
		 and ni.spell.available(64843)
		 and not ni.unit.debuff("player", 6788)
		 and not ni.unit.buff("player", 48066, "player") then
			ni.spell.cast(48066, "player")
			ni.spell.cast(14751)
			return true
		end
	end,
-----------------------------------
	["Divine Hymn"] = function()
		local _, enabled = GetSetting("innerhymn");
		if enabled
		 and ni.player.buff(14751)
		 and not ni.player.ismoving()
		 and ni.spell.available(64843)
		 and UnitChannelInfo("player") == nil then
			ni.spell.cast(64843)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		local _, enabled = GetSetting("healtank");
		local tank, offTank = ni.tanks()
		-- Main Tank Heal
		if enabled
		 and ni.unit.exists(tank) then
		 local rnewtank, _, _, _, _, _, rnewtank_time = ni.unit.buff(tank, 48068, "player")
		 local pmendtank = ni.unit.buff(tank, 48113, "player")
		 local ws = ni.unit.debuff(tank, 6788)
		-- Heal MT with Renew 
		if ni.spell.available(48068)
		 and (not rnewtank
		 or (rnewtank and rnewtank_time - GetTime() < 2))
		 and ni.spell.valid(tank, 48068, false, true, true) then
			ni.spell.cast(48068, tank)
			return true
		end
		-- Put PoF Mending on MT
		if  ni.spell.available(48113) then
		  local friends = ni.members.inrangewithoutbuff(tank, 19, 48113)
		   if not ni.unit.buff(tank, 48113)
		    and #friends >= 1
		    and ni.spell.valid(tank, 48113, false, true, true) then
				ni.spell.cast(48113, tank)
				return true
			end
		end
		-- Greater Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 50
		 and ni.player.buffstacks(63734) >= 2
		 and not ni.player.ismoving()
		 and ni.spell.available(48063)
		 and ni.spell.valid(tank, 48063, false, true, true) then		 
			ni.spell.cast(48063, tank)
			return true
		end
		-- Binding Heal on MT
		if tank ~= nil
		 and ni.unit.hp(tank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(48120)
		 and ni.spell.valid(tank, 48120, false, true, true) then
			ni.spell.cast(48120, tank)
			return
			end			
		end
		-- Off Tank heal
		if enabled
		 and offTank ~= nil
		 and ni.unit.exists(offTank) then
		 local rnewotank, _, _, _, _, _, rnewotank_time = ni.unit.buff(offTank, 48068, "player")
		 local ws = ni.unit.debuff(offTank, 6788)
		-- Heal Off with Renew 
		if ni.spell.available(48068)
		 and (not rnewotank
		 or (rnewotank and rnewotank_time - GetTime() < 2))
		 and ni.spell.valid(offTank, 48068, false, true, true) then
			ni.spell.cast(48068, offTank)
			return true
		 end
		-- Greater Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 50
		 and ni.player.buffstacks(63734) >= 2
		 and not ni.player.ismoving()
		 and ni.spell.available(48063)
		 and ni.spell.valid(offTank, 48063, false, true, true) then		 
			ni.spell.cast(48063, offTank)
			return true
		end
		-- Binding Heal on Off
		if offTank ~= nil
		 and ni.unit.hp(offTank) < 75
		 and ni.player.hp() < 75	
		 and not ni.player.ismoving()
		 and ni.spell.available(48120)
		 and ni.spell.valid(offTank, 48120, false, true, true) then
			ni.spell.cast(48120, offTank)
			return
			end		
		end
	end,
-----------------------------------
	["Valithria Heal"] = function()
		local tank = ni.tanks()
		if ni.unit.exists("boss1") then
		 if ni.unit.id("boss1") == 36789 
		  and ni.unit.hp("boss1") < 100 then
		 local rnewBoss, _, _, _, _, _, rnewBoss_time = ni.unit.buff("boss1", 48068, "player")     
		-- Heal Boss with Renew 
		if ni.spell.available(48068)
		 and (not rnewBoss
		 or (rnewBoss and rnewBoss_time - GetTime() < 2))
		 and ni.spell.valid("boss1", 48068, false, true, true) then
			ni.spell.cast(48068, "boss1")
			return true
		end       
		-- Heal Boss with Greater Heal --
		if not ni.player.ismoving()
		 and ni.members[1].hp > 80        
		 and ni.spell.available(48063)
		 and not ni.player.ismoving()
		 and GetTime() - data.priest.LastGreater > 3
		 and ni.spell.valid("boss1", 48063, false, true, true) then
			ni.spell.cast(48063, "boss1")
			data.priest.LastHoly = GetTime()        
			return true
		end
			end
		end
	end,
-----------------------------------
	["Guardian Spirit"] = function()
		local value, enabled = GetSetting("guard");
		if enabled
		 and ni.spell.available(47788)
		 and ni.spell.available(48063)
		 and ni.members[1].hp < value
		 and ni.spell.valid(ni.members[1].unit, 47788, false, true, true)
		 and ni.spell.valid(ni.members[1].unit, 48063, false, true, true) then
			ni.spell.cast(47788, ni.members[1].unit)
			ni.spell.cast(48063, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Circle of Healing"] = function()
		local value, enabled = GetSetting("circle");	
		local friends = ni.members.inrange(ni.members[1].unit, 17)
		if enabled
		 and ni.spell.available(48089) then 
		 -- Heal party with Circle
		if ni.members.averageof(3) < value
		 and #friends > 2		 
		 and ni.members[1].hp < value
		 and ni.spell.valid(ni.members[1].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[1].unit)
			return true
		end
		 -- Heal raid with Circle
		if not ni.player.hasglyph(55675)
		 and #ni.members > 5 
		 and ni.members.averageof(4) < value
		 and #friends > 3 
		 and ni.members[1].hp < value
		 and ni.spell.valid(ni.members[1].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[1].unit)
			return true
		end
		-- Heal raid with Circle + Glyph
		if ni.player.hasglyph(55675)
		 and #ni.members > 5
		 and ni.members.averageof(5) < value
		 and #friends > 4  
		 and ni.members[1].hp < value
		 and ni.spell.valid(ni.members[1].unit, 48089, false, true, true) then
			ni.spell.cast(48089, ni.members[1].unit)
			return true
			end
		end
	end,
-----------------------------------
	["Renew"] = function()
		local value, enabled = GetSetting("renew");
		 if enabled
		 and (ni.player.power() < 55
		 or ni.player.ismoving())
		 and ni.spell.available(48068) then
		  for i = 1, #ni.members do
		   if ni.members[i].hp < value
		    and not ni.unit.buff(ni.members[i].unit, 48068, "player")
		    and ni.spell.valid(ni.members[i].unit, 48068, false, true, true) then
				ni.spell.cast(48068, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Renew (All Members)"] = function()
		local value, enabled = GetSetting("renewall");
		 if enabled
		 and ni.spell.available(48068) then
		  for i = 1, #ni.members do
		   if ni.members[i].hp < value
		    and not ni.unit.buff(ni.members[i].unit, 48068, "player")
		    and ni.spell.valid(ni.members[i].unit, 48068, false, true, true) then
				ni.spell.cast(48068, ni.members[i].unit)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Prayer of Healing (Renew Build)"] = function()
		local value, enabled = GetSetting("prayer");		
		if enabled
		 and ni.spell.available(48072)
		 and not ni.player.ismoving() then
		 -- Heal party with Prayer
		if ni.members[1].hp < value
		 and data.GetLowPartyMemberCount(ni.members[1].unit, value) >= 2
		 and ni.spell.valid(ni.members[1].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[1].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.members[1].hp < value
		 and #ni.members > 5
		 and data.GetLowPartyMemberCount(ni.members[1].unit, value) >= 3
		 and ni.spell.valid(ni.members[1].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Prayer of Healing (Serendipity)"] = function()
		local value, enabled = GetSetting("prayer");	
		if enabled
		 and ni.spell.available(48072)
		 and ni.player.buffstacks(63734) >= 2
		 and not ni.player.ismoving() then 
		 -- Heal party with Prayer
		if ni.members[1].hp < value
		 and data.GetLowPartyMemberCount(ni.members[1].unit, value) >= 3
		 and ni.spell.valid(ni.members[1].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[1].unit)
			return true
		end
		 -- Heal raid with Prayer
		if ni.members[1].hp < value
		 and #ni.members > 5
		 and data.GetLowPartyMemberCount(ni.members[1].unit, value) >= 4
		 and ni.spell.valid(ni.members[1].unit, 48072, false, true, true) then
			ni.spell.cast(48072, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Greater Heal (Serendipity)"] = function()
		local value, enabled = GetSetting("great");
		if enabled
		 and ni.player.buffstacks(63734) >= 2
		 and ni.spell.available(48063)
		 and not ni.player.ismoving()
		 and ni.members[1].hp < value
		 and ni.spell.valid(ni.members[1].unit, 48063, false, true, true) then
			ni.spell.cast(48063, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Abolish Disease (Member)"] = function() 
		local _, enabled = GetSetting("abolishmb")
		if enabled
		and ni.spell.available(552) then
		 for i = 1, #ni.members do
		  if ni.unit.debufftype(ni.members[i].unit, "Disease")
		  and ni.healing.candispel(ni.members[i].unit)
		  and GetTime() - data.LastDispel > 1.2
		  and not ni.unit.buff(ni.members[i].unit, 552)
		  and ni.spell.valid(ni.members[i].unit, 552, false, true, true) then
				ni.spell.cast(552, ni.members[i].unit)
				data.LastDispel = GetTime()
				return true
				end
			end
		end
	end,
-----------------------------------
	["Dispel Magic (Member)"] = function()
		local _, enabled = GetSetting("dispelmagmemb")
		if enabled
		 and ni.spell.available(988) then
		  for i = 1, #ni.members do
		   if ni.unit.debufftype(ni.members[i].unit, "Magic")
		   and ni.healing.candispel(ni.members[i].unit)
		   and GetTime() - data.LastDispel > 1.2
		   and ni.spell.valid(ni.members[i].unit, 988, false, true, true) then
				ni.spell.cast(988, ni.members[i].unit)
				data.LastDispel = GetTime()
				return true
				end
			end
		end
	end,
-----------------------------------
	["Flash Heal"] = function()
		local value, enabled = GetSetting("flash");
		if enabled
		 and ni.spell.available(48071)
		 and ni.members[1].hp < value
		 and not ni.player.ismoving()
		 and ni.spell.valid(ni.members[1].unit, 48071, false, true, true) then
				ni.spell.cast(48071, ni.members[1].unit)
			return true
		end
	end,
-----------------------------------
	["Prayer of Mending"] = function()
		local _, enabled = GetSetting("healtank");
		local value = GetSetting("mend");
		if not enabled
		 and ni.spell.available(48113) then
		  local friends = ni.members.inrangewithoutbuff(ni.members[1].unit, 19, 48113)
		   if ni.members[1].hp < value
		    and #friends >= 1
		    and not ni.unit.buff(ni.members[1].unit, 48113)
		    and ni.spell.valid(ni.members[1].unit, 48113, false, true, true) then
				ni.spell.cast(48113, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Shadow Word: Pain"] = function()
		local SWP = data.priest.SWP()
		local _, enabled = GetSetting("pain");
		if enabled
		 and not SWP
		 and ni.members[1].hp > 75
		 and ni.player.power() > 75
		 and ni.spell.available(48125)
		 and ni.spell.valid("target", 48125, false, true) then
			ni.spell.cast(48125, "target")
			return true
		end
	end,	
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		  ni.debug.popup("Holy Priest by DarhangeR for 3.3.5a", 
		 "Welcome to Holy Priest Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For enable priority healing Main Tank & Off Tank put tank name to Tank Overrides and press Enable Main/Off\n-For chose build select it in GUI menu.")
		popup_shown = true;
		end 
	end,
}

local function queue()
	local build = GetSetting("builds")
	 if build == 1 then
	  return RenewBuildActive;
	elseif build == 2 then
	  return SerenBuildACtive;
	end
end

	ni.bootstrap.profile("Holy_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
    ni.bootstrap.profile("Holy_DarhangeR", queue, abilities);
end