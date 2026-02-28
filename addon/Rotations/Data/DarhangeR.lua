-- Blacklist table for healers --
local dontdispel = { 31803, 60814, 69674, 68786, 34916, 34917, 34919, 48159, 48160, 30404, 30405, 31117, 34438, 35183, 43522, 47841, 47843, 65812, 68154, 68155, 68156, 44461, 55359, 55360, 55361, 55362, 61429, 30108, 34914, 74562, 74792, 70867, 70338, 70405 };
for k, v in pairs(dontdispel) do
    ni.healing.debufftoblacklist(v);
end
-- Shared Stuff for all --
local cbuff = { 30940, 60158, 59301, 642, 31224, 23920, 33786, 19263, 21892, 40733, 45438, 69051, 69056, 20223 };
local mbuff = { 30940, 59301, 45438, 33786, 21892, 40733, 69051 };
local tbuff = { 30940, 59301, 45438, 33786, 21892, 40733, 19263, 1022, 69051 };
local targetdebuff = { 33786, 18647, 10955, 10326, 14327 };
local forsdebuff = { 6215, 8122, 5484, 2637, 5246, 6358, 605, 22686, 74384, 49106, 35280, 36866 };
local pbuff = { 430, 433, 25990, 58984, 11392, 32612, 47585 };
local pdebuff = { 34661, 71289, 33684, 52509, 51750, 35856, 70157, 33173, 33652, 69645 };
local _, class = UnitClass("player");
local control = { 71289, 605 };
local undercontrol = { 33786, 64044, 10890, 12826, 28271, 61025, 61305, 61721, 61780, 20066, 10308, 14311, 47860, 6215, 17928, 51514 };
-- DK Anti-Magic Shell --
local ams = { };
-- Druid Stuff -- 
local flyform = { 33357, 1066, 33943, 40120 };
-- Hunter Stuff --
local creaturetypes = {
  [1] = 1494,
  [2] = 19879,
  [3] = 19878,
  [4] = 19880,
  [5] = 19882,
  [6] = 19884,
  [7] = 19883   
}
-- Mage Fire / Frost Protection -- 
local firedots = { 49233, 42833, 42891, 55360, 22959 };
local frostdots = { 49236, 12494 };
-- Spellsteal 
local stealable = { 57761, 57531, 12043, 44401, 54428, 43242, 31884, 2825, 32182, 1719, 17, 33763, 6940, 67106, 67107, 67108, 66228, 67009, 48068 };
-- Paladin Freedom --
local freedomdebuff = { 60814, 42842, 45524, 1715, 3408, 59638, 20164, 25809, 31589, 51585, 50040, 50041, 31124, 122, 44614, 1604, 339, 45334, 58179, 61391, 19306, 19185, 35101, 5116, 2974, 61394, 54644, 50245, 50271, 54706, 4167, 33395, 55080, 11113, 6136, 120, 116, 44614, 31589, 20170, 31125, 3409, 26679, 64695, 63685, 8056, 8034, 18118, 18223, 63311, 23694, 1715, 12323, 39965, 55536, 13099, 29703, 32859, 32065 };
-- Shaman Purge -- 
local purgebuff = { 38210, 48068, 48066, 61301, 43039, 43020, 48441, 11841, 43046, 18100 };
-- Warlock Shadow Ward --
local shadowdots = { 48125, 48160, 48300, 47864, 47813, 47857, 47855 };
-- Warrior Berserker --
local bersrage = { 6215, 8122, 5484, 2637, 5246, 6358 };
-- Stuff for data.ishealer(t)
local checkheal = { 33891, 20216, 31842, 31834, 55166, 53390, 59891, 63725, 63734, 33151, 64911, 70806, 70757 };
-- Shared stuff for Druid/Warrior --
local bleedUp = { 48564, 48566, 46856 };

local data = { };
data.LastDispel = 0
data.LastInterrupt = 0
				
-- Check Start Fight with TTD --
data.CDsaverTTD = function(unit, valueTime, valueTTD, hp)
	valueTime = valueTime or 0
	valueTTD = valueTTD or 0
	hp = hp or 0
	if ni.vars.combat.time ~= 0 
	 and GetTime() - ni.vars.combat.time > valueTime 
	 and ni.unit.ttd(unit) > valueTTD
	 and ni.unit.hp(unit) >= hp then
		return true
	end
		return false
end

data.CombatStart = function(value)
	if ni.vars.combat.time ~= 0
	 and GetTime() - ni.vars.combat.time > value then
		return true
	end
		return false
end

data.CDorBoss = function(unit, valueTime, valueTTD, hp, enabled)
	if ni.vars.combat.cd then
		return true;
	end
	local isboss = false;
	if enabled then
	isboss = ni.unit.isboss(unit);
	 if not isboss then
		return false;
		end
	end
	if data.CDsaverTTD(unit, valueTime, valueTTD, hp) then
	 if enabled then
	  if isboss then
		return true;
      end
	return true;
		end
	end
		return false;
end

data.ControlMember = function(t)
	for _, v in ipairs(control) do
		if ni.unit.debuff(t, v) then 
			return true
		end
	end
	return false
end

data.UnderControlMember = function(t)
for _, v in ipairs(undercontrol) do
	if ni.unit.debuff(t, v) then 
		 return true
	end
end
		 return false
end

-- Part of for data.ishealer(t)
data.ishealer = function(t)
for _, v in ipairs(checkheal) do
	if ni.unit.buff(t, v) then 
		 return true
	end
end
		 return false
end
-- Vars for Universal Pause --
data.PlayerBuffs = function(t)
for _, v in ipairs(pbuff) do
	if ni.unit.buff(t, v) then 
		 return true
	end
end
		 return false
end
-- Universal Pause --
data.UniPause = function()
if IsMounted()
 or UnitInVehicle("player")
 or UnitIsDeadOrGhost("target") 
 or UnitIsDeadOrGhost("player")
 or UnitChannelInfo("player") ~= nil
 or UnitCastingInfo("player") ~= nil
 or ni.vars.combat.casting == true
 or ni.player.islooting()
 or data.PlayerBuffs("player")
 or (not UnitAffectingCombat("player")
 and ni.vars.followEnabled) then
		 return true
	end
		 return false
end
-- Vars for Combat Pause --
data.targetDebuffs = function(t)
for _, v in ipairs(targetdebuff) do
	if ni.unit.debuff(t, v) then 
		 return true
	end
end
		 return false
end
data.casterStop = function(t)
for _, v in ipairs(cbuff) do
	if (ni.unit.buff(t, v) 
	or data.targetDebuffs(t)) then 
		 return true
	end
end
		 return false
end
data.meleeStop = function(t)
for _, v in ipairs(mbuff) do
	if (ni.unit.buff(t, v) 
	or data.targetDebuffs(t)) then 
		 return true
	end
end
		 return false
end
data.tankStop = function(t)
for _, v in ipairs(tbuff) do
	if (ni.unit.buff(t, v) 
	or data.targetDebuffs(t)) then 
		 return true
	end
end
		 return false
end
data.PlayerDebuffs = function(t)
for _, v in ipairs(pdebuff) do
		if (ni.unit.debuff(t, v) 
		or ni.player.debuffstacks(69766) == 5
		or (ni.unit.debuff("player", 305131, "EXACT") 
		and ni.unit.debuffremaining("player", 305131, "EXACT") <= 3)) then 
		 return true
	end
end
		 return false
end

-- Will of the Forsaken --
data.forsaken = function(t)
for _, v in ipairs(forsdebuff) do
		if ni.unit.debuff(t, v) then 
		 return true
	end
end
	return false
end

-- Check Instance / Raid --
data.youInInstance = function()
if IsInInstance()
		and select(2, GetInstanceInfo()) == "party" then
		 return true
	end
		 return false
end
data.youInRaid = function(t)
if IsInInstance()
		and select(2, GetInstanceInfo()) == "raid" then
		 return true
	end
		return false
end
		
-- Pet Follow / Attack Function -- 
data.petFollow = function()
	local pet = ni.objects["pet"]
	if not pet:exists() then
		return
	end
	local oldPetDistance = petDistance;
	petDistance = pet:distance("player")
	local distanceThreshold = 1
	if not oldPetDistance 
	 or petDistance - oldPetDistance > distanceThreshold then
		ni.player.runtext("/petfollow");
	end
end

data.petAttack = function()
	local pet = ni.objects["pet"]
	if not pet:exists() then
		return
	end
	if not pet:combat() then
		ni.player.runtext("/petattack")
		petDistance = nil
	end

	if pet:combat() then
		ni.player.runtext("/petattack")
		petDistance = nil
	end
end
-- Check Item Set --
data.checkforSet = function(t, pieces)
	local count = 0
	for _, v in ipairs(t) do
		if IsEquippedItem(v) then
			count = count + 1
		end
	end
	if count >= pieces then
		return true
	else
		return false
	end
end
-- Sirus Stuff --
data.SirusCheck = function()
	if (GetRealmName() == "Frostmourne x1 - 3.3.5a+"
	 or GetRealmName() == "Scourge x2 - 3.3.5a+"
	 or GetRealmName() == "Neltharion x3 - 3.3.5a+"
	 or GetRealmName() == "Sirus x10 - 3.3.5a+") then
		return true
	end
		return false
end
local classlower = string.lower(class);
if classlower == "deathknight" then
	classlower = "dk";
end
data[classlower] = { };
if classlower == "dk" then
	--- GUI Stuff
	data[classlower].deathIcon = function()
		return select(3, GetSpellInfo(49924))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(47528))
	end;
	data[classlower].iceboundIcon = function()
		return select(3, GetSpellInfo(48792))
	end;
	data[classlower].raiseIcon = function()
		return select(3, GetSpellInfo(46584))
	end;
	data[classlower].nothIcon = function()
		return select(3, GetSpellInfo(53910))
	end;
	data[classlower].runeIcon = function()
		return select(3, GetSpellInfo(48982))
	end;
	data[classlower].vampIcon = function()
		return select(3, GetSpellInfo(55233))
	end;
	data[classlower].markIcon = function()
		return select(3, GetSpellInfo(49005))
	end;
	data[classlower].bboilIcon = function()
		return select(3, GetSpellInfo(49941))
	end;
	data[classlower].gripIcon = function()
		return select(3, GetSpellInfo(49576))
	end;
	data[classlower].commandIcon = function()
		return select(3, GetSpellInfo(56222))
	end;
	-----------------------------------
	data[classlower].LastIcy = 0;
	data[classlower].icy = function()
		return ni.unit.debuffremaining("target", 55095, "player")
	end;
	data[classlower].plague = function() 
		return ni.unit.debuffremaining("target", 55078, "player")
	end;
	data[classlower].InRange = function()
	 if IsSpellInRange(GetSpellInfo(49930), "target") == 1 then
			return true
		end
	end
		-- Sirus Custom T5 --
	data[classlower].itemsetT5DPS = { 
	81241, 80867, 80861, 80927, 82812, 103491, 103492, 103493, 103494, 103495 
	};
	data[classlower].itemsetT4tank = { 
	63462, 55792, 56291, 56323, 56435, 100494, 100488, 100491, 100492, 100493 
	}
	data[classlower].itemsetT4DPS = { 
	55848, 55207, 55254, 55784, 56104, 100489, 100485, 100486, 100487, 100490
	}
elseif classlower == "druid" then
	--- GUI Stuff
	data[classlower].formIcon = function()
		return select(3, GetSpellInfo(768))
	end;
	data[classlower].intervateIcon = function()
		return select(3, GetSpellInfo(29166))
	end;
	data[classlower].barsIcon = function()
		return select(3, GetSpellInfo(22812))
	end;
	data[classlower].survIcon = function()
		return select(3, GetSpellInfo(61336))
	end;
	data[classlower].growlIcon = function()
		return select(3, GetSpellInfo(6795))
	end;
	data[classlower].swiftIcon = function()
		return select(3, GetSpellInfo(18562))
	end;
	data[classlower].natureIcon = function()
		return select(3, GetSpellInfo(17116))
	end;
	data[classlower].tranqIcon = function()
		return select(3, GetSpellInfo(48447))
	end;
	data[classlower].curseIcon = function()
		return select(3, GetSpellInfo(2782))
	end;
	data[classlower].poisonIcon = function()
		return select(3, GetSpellInfo(2893))
	end;
	data[classlower].nouIcon = function()
		return select(3, GetSpellInfo(50464))
	end;
	data[classlower].touchIcon = function()
		return select(3, GetSpellInfo(48378))
	end;
	data[classlower].rejuIcon = function()
		return select(3, GetSpellInfo(48441))
	end;
	data[classlower].regroIcon = function()
		return select(3, GetSpellInfo(48443))
	end;
	-----------------------------------	
	data[classlower].LastShout = 0;
	data[classlower].LastRegrowth = 0;
	data[classlower].LastNourish = 0;	
	data[classlower].mFaerieFire = function() 
		return ni.unit.debuff("target", 770) 
	end;
	data[classlower].fFaerieFire = function() 
		return ni.unit.debuff("target", 16857) 
	end
	data[classlower].iSwarm = function()
		return select(7, ni.unit.debuff("target", 48468, "player")) 
	end
	data[classlower].mFire = function() 
		return select(7, ni.unit.debuff("target", 48463, "player"))
	end
	data[classlower].lunar = function() 
		return select(7, ni.unit.buff("player", 48517)) 
	end
	data[classlower].solar = function() 
		return select(7, ni.unit.buff("player", 48518)) 
	end
	data[classlower].berserk = function() 
		return ni.unit.buff("player", 50334)
	end
	data[classlower].lacerate = function() 
		return ni.unit.debuffremaining("target", 48568, "player")
	end
	data[classlower].rip = function() 
		return ni.unit.debuffremaining("target", 49800, "player")
	end
	data[classlower].rake = function() 
		return ni.unit.debuffremaining("target", 48574, "player")
	end
	data[classlower].tiger = function() 
		return ni.unit.buff("player", 50213) 
	end
	data[classlower].savage = function() 
		return ni.unit.buffremaining("player", 52610) 
	end
	-- Bleed  Buff --
	data[classlower].BleedBuff = function(t)
		for _, v in ipairs(bleedUp) do
		 if ni.unit.debuff(t, v) then 
		     return true
			end
		end
		     return false
	end
	data[classlower].DruidStuff = function(t)
	for _, v in ipairs(flyform) do
		if ni.unit.buff(t, v) then 
		     return true
		end
	end
		     return false
	end
	data[classlower].InBearRange = function()
	 if IsSpellInRange(GetSpellInfo(48568), "target") == 1 then
			return true
		end
	end
	data[classlower].InCatRange = function()
	 if IsSpellInRange(GetSpellInfo(49800), "target") == 1 then
			return true
		end
	end
elseif classlower == "hunter" then
	--- GUI Stuff
	data[classlower].dragonIcon = function()
		return select(3, GetSpellInfo(61847))
	end;
	data[classlower].viperIcon = function()
		return select(3, GetSpellInfo(34074))
	end;
	data[classlower].mendIcon = function()
		return select(3, GetSpellInfo(48990))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(34490))
	end;
	data[classlower].feignIcon = function()
		return select(3, GetSpellInfo(5384))
	end;
	data[classlower].deterIcon = function()
		return select(3, GetSpellInfo(19263))
	end;
	data[classlower].scareIcon = function()
		return select(3, GetSpellInfo(14327))
	end;
	data[classlower].killIcon = function()
		return select(3, GetSpellInfo(61006))
	end;
	-----------------------------------	
	data[classlower].LastMD = 0;
	data[classlower].LastScat = 0;
	data[classlower].LastTrack = 0;
	data[classlower].LastScare = 0;
	data[classlower].serpstring = function() 
		return ni.unit.debuffremaining("target", 49001, "player")
	end
	data[classlower].viperstring = function() 
		return ni.unit.debuffremaining("target", 3034, "player")
	end
	data[classlower].scorpstring = function() 
		return ni.unit.debuffremaining("target", 3043, "player")
	end
	data[classlower].exploshot = function() 
		return ni.unit.debuff("target", 60053, "player")
	end
	data[classlower].setTracking = function() 
	local creaturetype = ni.unit.creaturetype("target")
	local spellid = creaturetypes[creaturetype]
    if spellid ~= nil 
	 and UnitAffectingCombat("player") 
	 and ni.unit.exists("target") 
	 and ni.spell.isinstant(spellid) 
	 and ni.spell.available(spellid) 
	 and GetTime() - data.hunter.LastTrack > 3 then
			data.hunter.LastTrack = GetTime()
			ni.spell.cast(spellid)
		end
	end
	data[classlower].InRange = function()
	 if IsSpellInRange(GetSpellInfo(49052), "target") == 1 then
			return true
		end
	end
elseif classlower == "mage" then
	--- GUI Stuff	
	data[classlower].evoIcon = function()
		return select(3, GetSpellInfo(12051))
	end;
	data[classlower].gemIcon = function()
		return select(3, GetSpellInfo(42985))
	end;
	data[classlower].iceIcon = function()
		return select(3, GetSpellInfo(45438))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(2139))
	end;
	data[classlower].coneIcon = function()
		return select(3, GetSpellInfo(42931))
	end;
	data[classlower].breathIcon = function()
		return select(3, GetSpellInfo(42950))
	end;
	data[classlower].stealIcon = function()
		return select(3, GetSpellInfo(30449))
	end;
	data[classlower].fwardIcon = function()
		return select(3, GetSpellInfo(43010))
	end;
	data[classlower].frwardIcon = function()
		return select(3, GetSpellInfo(43012))
	end;
	data[classlower].curseIcon = function()
		return select(3, GetSpellInfo(475))
	end;
	data[classlower].livingIcon = function()
		return select(3, GetSpellInfo(55360))
	end;
	-----------------------------------		
	data[classlower].LastScorch = 0;
	data[classlower].LBomb = function() 
		return ni.unit.debuff("target", 55360, "player") 
	end
	data[classlower].fnova = function() 
		return ni.unit.debuff("target", 42917, "player") 
	end
	data[classlower].fbite = function() 
		return ni.unit.debuff("target", 12494, "player") 
	end
	data[classlower].freeze = function() 
		return ni.unit.debuff("target", 33395, "player") 
	end
	data[classlower].FoF = function() 
		return ni.player.buff(44545) 
	end
	-- Sirus Custom T4 --
	data[classlower].itemsetT4 = {
		29076, 29077, 29078, 29079, 29080, 100460, 100461, 100462, 100463, 100464 
	};	
	-- Mages Wards --
	data[classlower].FireWard = function()
		for _, v in ipairs(firedots) do
		 if ni.player.debuff(v) then 
		     return true
			end
		end
		     return false
	end	
	data[classlower].FrostWard = function()
		for _, v in ipairs(frostdots) do
		 if ni.player.debuff(v) then 
		     return true
			end
		end
		     return false
	end
	data[classlower].isStealable = function(t)
	for i, v in ipairs(stealable) do
		local _,_,_,_,_,_,_,_,StealableSpell = ni.unit.buff(t, v)
		 if StealableSpell then
		     return true
		end
	end
		     return false
	end
elseif classlower == "paladin" then
	--- GUI Stuff	
	data[classlower].pleaIcon = function()
		return select(3, GetSpellInfo(54428))
	end;
	data[classlower].sacredIcon = function()
		return select(3, GetSpellInfo(53601))
	end;
	data[classlower].flashIcon = function()
		return select(3, GetSpellInfo(48785))
	end;
	data[classlower].layIcon = function()
		return select(3, GetSpellInfo(48788))
	end;
	data[classlower].divineShIcon = function()
		return select(3, GetSpellInfo(642))
	end;
	data[classlower].divinePrIcon = function()
		return select(3, GetSpellInfo(498))
	end;
	data[classlower].handProIcon = function()
		return select(3, GetSpellInfo(10278))
	end;
	data[classlower].handSalIcon = function()
		return select(3, GetSpellInfo(1038))
	end;
	data[classlower].handSacrIcon = function()
		return select(3, GetSpellInfo(6940))
	end;
	data[classlower].hamWraIcon = function()
		return select(3, GetSpellInfo(48806))
	end;
	data[classlower].consIcon = function()
		return select(3, GetSpellInfo(48819))
	end;
	data[classlower].hwrathIcon = function()
		return select(3, GetSpellInfo(48817))
	end;
	data[classlower].turnIcon = function()
		return select(3, GetSpellInfo(10326))
	end;
	data[classlower].cleanIcon = function()
		return select(3, GetSpellInfo(4987))
	end;
	data[classlower].handFreeIcon = function()
		return select(3, GetSpellInfo(1044))
	end;
	data[classlower].illumIcon = function()
		return select(3, GetSpellInfo(31842))
	end;
	data[classlower].aveWrathIcon = function()
		return select(3, GetSpellInfo(31884))
	end;
	data[classlower].exorIcon = function()
		return select(3, GetSpellInfo(48801))
	end;
	data[classlower].masteryIcon = function()
		return select(3, GetSpellInfo(31821))
	end;
	data[classlower].hsockIcon = function()
		return select(3, GetSpellInfo(48825))
	end;
	data[classlower].lightIcon = function()
		return select(3, GetSpellInfo(48782))
	end;
	data[classlower].BoKIcon = function()
		return select(3, GetSpellInfo(25898))
	end;
	data[classlower].divSacrIcon = function()
		return select(3, GetSpellInfo(64205))
	end;
	data[classlower].HandRecIcon = function()
		return select(3, GetSpellInfo(62124))
	end;
	data[classlower].RigDefIcon = function()
		return select(3, GetSpellInfo(31789))
	end;
	data[classlower].SoCRIcon = function()
		return select(3, GetSpellInfo(53736))
	end;
	data[classlower].SoCIcon = function()
		return select(3, GetSpellInfo(20375))
	end;
	data[classlower].SoRIcon = function()
		return select(3, GetSpellInfo(21084))
	end;
	data[classlower].SoLIcon = function()
		return select(3, GetSpellInfo(20165))
	end;
	data[classlower].SoWIcon = function()
		return select(3, GetSpellInfo(20166))
	end;
	data[classlower].SoJIcon = function()
		return select(3, GetSpellInfo(20164))
	end;
	-----------------------------------		
	data[classlower].LastSeal = 0;
	data[classlower].LastTrack = 0;
	data[classlower].LastTurn = 0;
	data[classlower].LastHoly = 0;
	data[classlower].LastStorm = 0;
	data[classlower].LastAven = 0;	
	data[classlower].forb = function() 
		return ni.player.debuff(25771) 
	end
	data[classlower].aow = function() 
		return ni.player.buff(59578) 
	end
	data[classlower].itemsetT10 = { 
		51270, 51271, 51272, 51273, 51274, 51165, 51166, 51167, 51168, 51169, 50865, 50866, 50867, 50868, 50869
	};
	-- Sirus Custom T5 (Healer)--
	data[classlower].itemsetT5Heal = { 
		30134, 30135, 30136, 30137, 30138, 103426, 103427, 103428, 103429, 103430
	};
	data[classlower].itemsetT5Retri = { 
		30129, 30130, 30131, 30132, 30133, 103423, 103425, 103421, 103422, 103424
	};	
	data[classlower].HandActive = function(t)
		if ni.unit.buff(t, 1044)
		 or ni.unit.buff(t, 1022)
		 or ni.unit.buff(t, 6940)
		 or ni.unit.buff(t, 1038) then
		     return true
		end
		     return false
	end
	data[classlower].FreedomUse = function(t)
	for _, v in ipairs(freedomdebuff) do
		if ni.unit.debuff(t, v) then 
		     return true
		end
	end
		     return false
	end
	data[classlower].ProtoRange = function()
	 if IsSpellInRange(GetSpellInfo(53595), "target") == 1 then
			return true
		end
	end
	data[classlower].RetriRange = function()
	 if IsSpellInRange(GetSpellInfo(35395), "target") == 1 then
			return true
		end
	end
elseif classlower == "priest" then
	--- GUI Stuff	
	data[classlower].shadowFIcon = function()
		return select(3, GetSpellInfo(15473))
	end;
	data[classlower].fearIcon = function()
		return select(3, GetSpellInfo(6346))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(15487))
	end;
	data[classlower].disperIcon = function()
		return select(3, GetSpellInfo(47585))
	end;
	data[classlower].shackIcon = function()
		return select(3, GetSpellInfo(10955))
	end;
	data[classlower].dispIcon = function()
		return select(3, GetSpellInfo(988))
	end;
	data[classlower].abolIcon = function()
		return select(3, GetSpellInfo(552))
	end;
	data[classlower].despPlaIcon = function()
		return select(3, GetSpellInfo(48173))
	end;
	data[classlower].painIcon = function()
		return select(3, GetSpellInfo(33206))
	end;
	data[classlower].powerIcon = function()
		return select(3, GetSpellInfo(10060))
	end;
	data[classlower].innerIcon = function()
		return select(3, GetSpellInfo(14751))
	end;
	data[classlower].hymnIcon = function()
		return select(3, GetSpellInfo(64843))
	end;
	data[classlower].pwsIcon = function()
		return select(3, GetSpellInfo(48066))
	end;
	data[classlower].renewIcon = function()
		return select(3, GetSpellInfo(48068))
	end;
	data[classlower].penIcon = function()
		return select(3, GetSpellInfo(53007))
	end;
	data[classlower].flashIcon = function()
		return select(3, GetSpellInfo(48071))
	end;
	data[classlower].bindIcon = function()
		return select(3, GetSpellInfo(48120))
	end;
	data[classlower].prayIcon = function()
		return select(3, GetSpellInfo(48072))
	end;
	data[classlower].guardIcon = function()
		return select(3, GetSpellInfo(47788))
	end;
	data[classlower].mendIcon = function()
		return select(3, GetSpellInfo(48113))
	end;
	data[classlower].circIcon = function()
		return select(3, GetSpellInfo(48089))
	end;
	data[classlower].greatIcon = function()
		return select(3, GetSpellInfo(48063))
	end;
	data[classlower].painIcon = function()
		return select(3, GetSpellInfo(48125))
	end;
	-----------------------------------		
	data[classlower].LastVamp = 0;
	data[classlower].LastSWP = 0;
	data[classlower].LastPlague = 0;
	data[classlower].LastShackle = 0;
	data[classlower].LastGreater = 0;	
	data[classlower].vamp = function()
		return ni.unit.debuff("target", 48160, "player") 
	end
	data[classlower].SWP = function() 
		return ni.unit.debuff("target", 48125, "player") 
	end
	data[classlower].dplague = function() 
		return ni.unit.debuff("target", 48300, "player")
	end
	-- Sirus Custom T4 --
	data[classlower].itemsetT4DPS = {
		29056, 29057, 29058, 29059, 29060, 100440, 100441, 100442, 100443, 100444 
	};		
		-- Crimson Acolyte's Regalia --
	data[classlower].itemsetT10 = {
		51255, 51256, 51257, 51258, 51259, 51180, 51181, 51182, 51183, 51184, 50391, 50392, 50393, 50394, 50396
	};
elseif classlower == "rogue" then
	--- GUI Stuff	
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(1766))
	end;
	-----------------------------------	
	data[classlower].SnD = function() 
		return ni.unit.buffremaining("player", 6774)
	end
	data[classlower].Hunger = function() 
		return ni.unit.buffremaining("player", 63848)
	end
	data[classlower].envenom = function() 
		return ni.unit.buff("player", 57993) 
	end
	data[classlower].Rup = function() 
		return ni.unit.debuffremaining("target", 48672, "player") 
	end
	data[classlower].OGar = function() 
		return ni.unit.debuff("target", 48676) 
	end
	data[classlower].InRange = function()
	 if IsSpellInRange(GetSpellInfo(48638), "target") == 1 then
			return true
		end
	end
elseif classlower == "shaman" then
	--- GUI Stuff
	data[classlower].lightIcon = function()
		return select(3, GetSpellInfo(49281))
	end;
	data[classlower].waterIcon = function()
		return select(3, GetSpellInfo(57960))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(57994))
	end;
	data[classlower].thundIcon = function()
		return select(3, GetSpellInfo(59159))
	end;
	data[classlower].hwaveIcon = function()
		return select(3, GetSpellInfo(49273))
	end;
	data[classlower].lhwaveIcon = function()
		return select(3, GetSpellInfo(49276))
	end;
	data[classlower].chainIcon = function()
		return select(3, GetSpellInfo(70809))
	end;
	data[classlower].purgeIcon = function()
		return select(3, GetSpellInfo(8012))
	end;
	data[classlower].totemIcon = function()
		return select(3, GetSpellInfo(66842))
	end;
	data[classlower].cureIcon = function()
		return select(3, GetSpellInfo(526))
	end;
	data[classlower].cleanIcon = function()
		return select(3, GetSpellInfo(51886))
	end;
	data[classlower].rageIcon = function()
		return select(3, GetSpellInfo(30823))
	end;
	data[classlower].novaIcon = function()
		return select(3, GetSpellInfo(61657))
	end;
	data[classlower].riptIcon = function()
		return select(3, GetSpellInfo(61301))
	end;
	data[classlower].flshockIcon = function()
		return select(3, GetSpellInfo(49233))
	end;
	data[classlower].switIcon = function()
		return select(3, GetSpellInfo(16188))
	end;
	data[classlower].tidalIcon = function()
		return select(3, GetSpellInfo(55198))
	end;
	-----------------------------------		
	data[classlower].LastPurge = 0;
	data[classlower].LastWave = 0;	
	data[classlower].flameshock = function() 
		return ni.unit.debuff("target", 49233, "player") 
	end
	-- Shaman Enchancment T10 --
	data[classlower].itemsetT10Enc = {
		50830, 50831, 50832, 50833, 50834, 51195, 51196, 51197, 51198, 51199, 51240, 51241, 51242, 51243, 51244
	};
	data[classlower].canPurge = function(t)
	for i, v in ipairs(purgebuff) do
		local name, icon, _, _, _, _, _, PurgebleSpell = ni.unit.buff(t, v)
		 if PurgebleSpell then
		     return true
		end
	end
		     return false
	end
	data[classlower].InRange = function()
	 if IsSpellInRange(GetSpellInfo(17364), "target") == 1 then
			return true
		end
	end
elseif classlower == "warlock" then
	--- GUI Stuff
	data[classlower].impIcon = function()
		return select(3, GetSpellInfo(688))
	end;
	data[classlower].voidIcon = function()
		return select(3, GetSpellInfo(697))
	end;
	data[classlower].sucIcon = function()
		return select(3, GetSpellInfo(712))
	end;
	data[classlower].felhunIcon = function()
		return select(3, GetSpellInfo(691))
	end;
	data[classlower].felguardIcon = function()
		return select(3, GetSpellInfo(30146))
	end;	
	data[classlower].felIcon = function()
		return select(3, GetSpellInfo(47893))
	end;
	data[classlower].demIcon = function()
		return select(3, GetSpellInfo(47889))
	end;
	data[classlower].ssIcon = function()
		return select(3, GetSpellInfo(47884))
	end;
	data[classlower].interIcon = function()
		return select(3, GetSpellInfo(19647))
	end;
	data[classlower].stoneIcon = function()
		return select(3, GetSpellInfo(71905))
	end;
	data[classlower].coilIcon = function()
		return select(3, GetSpellInfo(47860))
	end;
	data[classlower].sflameIcon = function()
		return select(3, GetSpellInfo(61290))
	end;
	data[classlower].banIcon = function()
		return select(3, GetSpellInfo(18647))
	end;
	data[classlower].sfuryIcon = function()
		return select(3, GetSpellInfo(47847))
	end;
	data[classlower].sburnIcon = function()
		return select(3, GetSpellInfo(47827))
	end;
	data[classlower].chargeIcon = function()
		return select(3, GetSpellInfo(54785))
	end;
	data[classlower].cleaveIcon = function()
		return select(3, GetSpellInfo(50581))
	end;
	data[classlower].immolAuraIcon = function()
		return select(3, GetSpellInfo(50589))
	end;
	-----------------------------------		
	data[classlower].LastSummon = 0;
	data[classlower].LastCorrupt = 0;
	data[classlower].LastCurse = 0;
	data[classlower].LastShadowbolt = 0;
	data[classlower].Lastimmolate = 0;
	data[classlower].LastUA = 0;
	data[classlower].LastHaunt = 0;
	data[classlower].LastSeed = 0;
	data[classlower].LastBanish = 0;	
	data[classlower].lastAgonyT5 = 0;		
	data[classlower].CotE = function()
		return ni.unit.debuff("target", 47865)
	end
	data[classlower].elem = function()
		return ni.unit.debuff("target", 47865, "player")
	end
	data[classlower].doom = function()
		return ni.unit.debuff("target", 47867, "player")
	end
	data[classlower].agony = function()
		return ni.unit.debuff("target", 47864, "player")
	end
	data[classlower].corruption = function()
		return ni.unit.debuff("target", 47813, "player")
	end
	data[classlower].seed = function()
		return ni.unit.debuff("target", 47836, "player")
	end
	data[classlower].haunt = function()
		return ni.unit.debuff("target", 59164, "player")
	end
	data[classlower].ua = function()
		return ni.unit.debuff("target", 47843, "player")
	end
	data[classlower].immolate = function()
		return ni.unit.debuff("target", 47811, "player")
	end
	data[classlower].eplag = function() 
		return ni.unit.debuff("target", 51735) 
	end
	data[classlower].earmoon = function()
		return ni.unit.debuff("target", 60433) 
	end
	-- Sirus Custom T4 --
	data[classlower].itemsetT4 = {
		28963, 28964, 28966, 28967, 28968, 100400, 100401, 100402, 100403, 100404
	};
	data[classlower].itemsetT5 = {
		30211, 30212, 30213, 30214, 30215, 103472, 103475, 103474, 103471, 103473
	};
	-- Shadow Ward --
	data[classlower].ShadowWard = function()
		for _, v in ipairs(shadowdots) do
		 if ni.player.debuff(v) then 
		     return true
			end
		end
		     return false
	end
elseif classlower == "warrior" then
	--- GUI Stuff
	data[classlower].batIcon = function()
		return select(3, GetSpellInfo(47436))
	end;	
	data[classlower].comIcon = function()
		return select(3, GetSpellInfo(47440))
	end;
	data[classlower].enraIcon = function()
		return select(3, GetSpellInfo(55694))
	end;
	data[classlower].bersIcon = function()
		return select(3, GetSpellInfo(18499))
	end;
	data[classlower].shatIcon = function()
		return select(3, GetSpellInfo(64382))
	end;
	data[classlower].sweepIcon = function()
		return select(3, GetSpellInfo(12328))
	end;
	data[classlower].thundIcon = function()
		return select(3, GetSpellInfo(47502))
	end;
	data[classlower].hamIcon = function()
		return select(3, GetSpellInfo(1715))
	end;
	data[classlower].heroIcon = function()
		return select(3, GetSpellInfo(47450))
	end;
	data[classlower].cleaveIcon = function()
		return select(3, GetSpellInfo(47520))
	end;
	data[classlower].inter1Icon = function()
		return select(3, GetSpellInfo(6552))
	end;
	data[classlower].inter2Icon = function()
		return select(3, GetSpellInfo(6552))
	end;
	data[classlower].sundIcon = function()
		return select(3, GetSpellInfo(7386))
	end;
	data[classlower].rendIcon = function()
		return select(3, GetSpellInfo(47465))
	end;
	data[classlower].taunIcon = function()
		return select(3, GetSpellInfo(355))
	end;
	data[classlower].mokingIcon = function()
		return select(3, GetSpellInfo(694))
	end;
	data[classlower].wallIcon = function()
		return select(3, GetSpellInfo(871))
	end;
	data[classlower].lastIcon = function()
		return select(3, GetSpellInfo(12975))
	end;
	data[classlower].intervIcon = function()
		return select(3, GetSpellInfo(3411))
	end;
	-----------------------------------
	data[classlower].LastShout = 0;
	data[classlower].rend = function() 
		return ni.unit.debuffremaining("target", 47465, "player")
	end
	data[classlower].hams = function() 
		return ni.unit.debuffremaining("target", 1715, "player")
	end
	data[classlower].Berserk = function()
	for _, v in ipairs(bersrage) do
            if ni.player.debuff(v) then 
		     return true
		end
	end
		     return false
	end
	data[classlower].InRange = function()
	 if IsSpellInRange(GetSpellInfo(47465), "target") == 1 then
			return true
		end
	end
end

	--- GUI Stuff
data.debugIcon = function()
	return select(3, GetSpellInfo(2382))
end
data.stoneIcon = function()
	return select(3, GetSpellInfo(47878))
end
data.hpotionIcon = function()
	return select(3, GetSpellInfo(53760))
end
data.mpotionIcon = function()
	return select(3, GetSpellInfo(53755))
end
data.controlIcon = function()
	return select(3, GetSpellInfo(59752))
end
data.tankIcon = function()
	return select(3, GetSpellInfo(2565))
end
data.bossIcon = function()
	return select(3, GetSpellInfo(22888))
end
	
	--- Multitool
data.lookIcon = function()
	return select(3, GetSpellInfo(1002))
end
data.LootIcon = function()
	return select(3, GetSpellInfo(58856))
end
data.ProspectingIcon = function()
	return select(3, GetSpellInfo(31252))
end
data.MillingIcon = function()
	return select(3, GetSpellInfo(51005))
end
data.SkinningIcon = function()
	return select(3, GetSpellInfo(8613))
end
data.FishingIcon = function()
	return select(3, GetSpellInfo(7620))
end
data.LureIcon = function()
	return select(3, GetSpellInfo(51067))
end


	--- Stuff for Healing (Originaly maded by Scott#1180)
local temptable = { };
local customtable = { };

data.SortByUnits = function(x, y)
    return x.unitsclose > y.unitsclose;
end

data.SortByHP = function(x, y)
    return x.hp < y.hp
end

data.GetTableForBestUnit = function(health, distance, unitsclose, buff)
    table.wipe(customtable);
    for i = 1, #ni.members do
        if ni.members[i].hp <= health
         and ni.members[i].range
         and (buff ~= nil 
         and not ni.unit.buff(ni.members[i].unit, buff, "player")) then
            table.wipe(temptable);
            if buff ~= nil then
                temptable = ni.members.inrangewithoutbuff(ni.members[i].unit, distance, buff, "player");
                for k, v in ipairs(temptable) do
                    if v and v.hp > health then
                        tremove(temptable, k);
                    end
                end
            else
                temptable = ni.members.inrangebelow(ni.members[i].unit, distannce, health);                
            end
            if #temptable >= unitsclose then
                tinsert(customtable, { unit = ni.members[i].unit, hp = ni.members[i].hp, unitsclose = #temptable });
            end
        end
    end
    if #customtable > 0 then
        table.sort(customtable, data.SortByHP)
    end
end

data.GroupCount = function(gtype, starting, ending, threshold)
  local count = 0;
  for i = starting, ending do
    if UnitExists(gtype..i)
     and ni.unit.hp(gtype..i) < threshold then
      count = count + 1
    end
  end
  return count;
end

data.GroupTotal = function(grouping, index, threshold)
  local count = 0;
  if index > 0 and index <= 5 then
    count = data.GroupCount(grouping, 1, 5, threshold)
  elseif index > 5 and index <= 10 then
    count = data.GroupCount(grouping, 6, 10, threshold)
  elseif index > 10 and index <= 15 then
    count = data.GroupCount(grouping, 11, 15, threshold)
  elseif index > 15 and index <= 20 then
    count = data.GroupCount(grouping, 16, 20, threshold)  
  elseif index > 20 and index <= 25 then
    count = data.GroupCount(grouping, 21, 25, threshold)  
  elseif index > 25 and index <= 30 then
    count = data.GroupCount(grouping, 26, 30, threshold)  
  elseif index > 30 and index <= 35 then
    count = data.GroupCount(grouping, 31, 35, threshold)  
  elseif index > 35 and index <= 40 then
    count = data.GroupCount(grouping, 36, 40, threshold)  
  end
  return count;
end

data.GetLowPartyMemberCount = function(unit, threshold)
  local count = 0;
  if unit == "player" then
    count = data.GroupCount("party", 1, 4, threshold)
  else
    local index = string.sub(unit, -1);
    local grouping = string.sub(unit, 0, 4);
    if grouping == "part" then grouping = "party"
    elseif grouping == "raid" then grouping = "raid" end
    if tonumber(index) ~= nil then
      count = data.GroupTotal(grouping, tonumber(index), threshold)
    else
      for i = 1, #ni.members do
        if ni.members[i].unit == unit then
          index = string.sub(ni.members[i].unit, -1)
          grouping = string.sub(unit, 0, 4);
          if grouping == "part" then grouping = "party"
          elseif grouping == "raid" then grouping = "raid" end
          break
        end
      end
      count = data.GroupTotal(grouping, tonumber(index), threshold)
    end
  end
  if grouping == "party" or grouping == "player" then
    if ni.player.hp() < threshold then
      count = count + 1
    end
  end
  return count;
end
	
return data;