local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
local function ActiveEnemies()
	return data.GetActiveEnemies("target", 7, true, 0.15)
end
if build == 30300 and level == 80 and data then
	local items = {
		settingsfile = "DarhangeR_ProtoWarrior.xml",
		{ type = "title",    text = "Protection Warrior by |c0000CED1DarhangeR" },
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "entry",    text = "\124T" .. data.bossIcon() .. ":26:26\124t Boss Detect",                                                                            tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true,      key = "detect" },
		{ type = "entry",    text = "Auto Stence",                                                                                                                      tooltip = "Auto use proper stence",                                            enabled = true,      key = "stence" },
		{ type = "dropdown", text = "Shout Buff (Battle/Commanding)", key = "shoutmode", menu = {
				{ selected = false, value = "Battle" },
				{ selected = true, value = "Commanding" },
			}
		},
		{ type = "entry",    text = "\124T" .. data.warrior.inter2Icon() .. ":26:26\124t Auto Interrupt",                                                               tooltip = "Auto check and interrupt all interruptible spells",                 enabled = true,      key = "autointerrupt" },
		{ type = "entry",    text = "\124T" .. data.debugIcon() .. ":26:26\124t Debug Printing",                                                                        tooltip = "Enable for debug if you have problems",                             enabled = false,     key = "Debug" },
		{ type = "separator" },
		{ type = "page",     number = 1,                                                                                                                                text = "|cff00C957Defensive Settings" },
		{ type = "separator" },
		{ type = "entry",    text = "\124T" .. data.warrior.bersIcon() .. ":26:26\124t Berserker Rage (Anti-Contol)",                                                   enabled = true,                                                                key = "bersrage" },
		{ type = "entry",    text = "\124T" .. data.warrior.lastIcon() .. ":26:26\124t +  \124T" .. data.warrior.enraIcon() .. ":26:26\124t Last Stand + Enraged Regeneration", tooltip = "Use spell when player HP < %",                              enabled = true,      value = 27,           key = "regen" },
		{ type = "entry",    text = "\124T" .. data.warrior.wallIcon() .. ":26:26\124t Shield Wall",                                                                    tooltip = "Use spell when player HP < %",                                      enabled = true,      value = 37,           key = "wall" },
		{ type = "entry",    text = "\124T" .. data.stoneIcon() .. ":26:26\124t Healthstone",                                                                           tooltip = "Use Warlock Healthstone (if you have) when player HP < %",          enabled = true,      value = 35,           key = "healthstoneuse" },
		{ type = "entry",    text = "\124T" .. data.hpotionIcon() .. ":26:26\124t Heal Potion",                                                                         tooltip = "Use Heal Potions (if you have) when player HP < %",                 enabled = true,      value = 30,           key = "healpotionuse" },
		{ type = "separator" },
		{ type = "page",     number = 2,                                                                                                                                text = "|cffEE4000Rotation Settings" },
		{ type = "separator" },
		{ type = "entry",    text = "\124T" .. data.warrior.taunIcon() .. ":26:26\124t Taunt (Auto Agro)",                                                              tooltip = "Auto use spell to agro enemies in 30 yard radius",                  enabled = false,     key = "tau" },
		{ type = "entry",    text = "\124T" .. data.warrior.mokingIcon() .. ":26:26\124t Mocking Blow (Auto Agro)",                                                     tooltip = "Auto use spell to agro enemies in spell radius",                    enabled = false,     key = "mocking" },
		{ type = "entry",    text = "\124T" .. data.warrior.intervIcon() .. ":26:26\124t Intervene",                                                                    tooltip = "Auto use spell to protect ally in 25 yard radius",                  enabled = false,     key = "interv" },
		{ type = "entry",    text = "\124T" .. data.warrior.rendIcon() .. ":26:26\124t Rend",                                                                           tooltip = "Work only on bosses",                                               enabled = true,      key = "rend" },
		{ type = "entry",    text = "\124T" .. data.warrior.thundIcon() .. ":26:26\124t Thunder Clap (AoE)",                                                            enabled = true,                                                                key = "thunder" },
		{ type = "entry",    text = "\124T" .. data.warrior.heroIcon() .. ":26:26\124t  /  \124T" .. data.warrior.cleaveIcon() .. ":26:26\124t Heroic Strike/Cleave",   tooltip = "Minimal rage threshold for use spells",                             value = 35,          key = "heroiccleave" },
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
		ni.GUI.DestroyFrame("Protection_Warrior_DarhangeR");
		ni.GUI.AddFrame("Protection_Warrior_DarhangeR", items);
	end
	local function OnUnLoad()
		ni.GUI.DestroyFrame("Protection_Warrior_DarhangeR");
	end

	local queue = {

		"Universal pause",
		"AutoTarget",
		"Defensive Stance",
		"Commanding Shout",
		"Battle Shout",
		"Vigilance",
		"Berserker Rage",
		"Combat specific Pause",
		"Healthstone (Use)",
		"Heal Potions (Use)",
		"Trinkets (Config)",
		"Racial Stuff",
		"Trinkets",
		"Shield Bash (Interrupt)",
		"Last Stand",
		"Enraged Regeneration",
		"Shield Wall",
		"Shield Block",
		"Taunt",
		"Taunt (Ally)",
		"Revenge",
		"Thunder Clap (AoE)",
		"Mocking Blow",
		"Intervene",
		"Demoralizing Shout",
		"Heroic Strike + Cleave (Filler)",
		"Shield Slam",
		"Rend",
		"Devastate",
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
		["Defensive Stance"] = function()
			local _, enabled = GetSetting("stence")
			if enabled
					and not ni.player.aura(71)
					and ni.spell.available(71) then
				ni.spell.cast(71)
				return true
			end
		end,
		-----------------------------------
		["Battle Shout"] = function()
			local shoutMode = GetSetting("shoutmode")
			if shoutMode ~= "Battle" then
				return false
			end
			if ni.player.buffs("47436||48932||48934") then
				return false
			end
			if ni.spell.available(47436) then
				ni.spell.cast(47436)
				return true
			end
		end,
		-----------------------------------
		["Commanding Shout"] = function()
			local shoutMode = GetSetting("shoutmode")
			if shoutMode ~= "Commanding" then
				return false
			end
			if ni.player.buffs("47440||47440") then
				return false
			end
			if ni.spell.available(47440) then
				ni.spell.cast(47440)
				return true
			end
		end,
		-----------------------------------
		["Vigilance"] = function()
			if ni.unit.exists("focus")
					and UnitInRange("focus")
					and not UnitIsDeadOrGhost("focus")
					and not ni.unit.buff("focus", 50720)
					and ni.spell.valid("focus", 50720, false, true, true) then
				ni.spell.cast(50720, "focus")
				return true
			end
		end,
		-----------------------------------
		["Berserker Rage"] = function()
			local _, enabled = GetSetting("bersrage")
			if enabled
					and data.warrior.Berserk()
					and ni.spell.available(18499) then
				ni.spell.cast(18499)
				return true
			end
		end,
		-----------------------------------
		["Combat specific Pause"] = function()
			if data.tankStop("target")
					or data.PlayerDebuffs("player")
					or UnitCanAttack("player", "target") == nil
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
						and data.warrior.InRange() then
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
						and data.warrior.InRange() then
					ni.spell.cast(bloodelf[i])
					return true
				end
			end
			--- Ally race
			for i = 1, #alracial do
				if data.warrior.InRange()
						and ni.player.hp() < 20
						and IsSpellKnown(alracial[i])
						and ni.spell.available(alracial[i]) then
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
		-----------------------------------
		-----------------------------------
		["Trinkets (Config)"] = function()
			if data.UseConfiguredTrinkets(GetSetting, 47488, "target") then
				return true
			end
		end,
		-----------------------------------
		["Trinkets"] = function()
			local _, enabled = GetSetting("detect")
			if data.CDorBoss("target", 5, 35, 5, enabled)
				and ni.player.slotcastable(13)
				and ni.player.slotcd(13) == 0
				and data.warrior.InRange() then
				ni.player.useinventoryitem(13)
			else
				if data.CDorBoss("target", 5, 35, 5, enabled)
					and ni.player.slotcastable(14)
					and ni.player.slotcd(14) == 0
					and data.warrior.InRange() then
					ni.player.useinventoryitem(14)
					return true
				end
			end
		end,
		["Shield Bash (Interrupt)"] = function()
			local _, enabled = GetSetting("autointerrupt")
		if data.TryInterrupt("target", enabled, 72, 0.35) then
			return true
		end
		end,
		-----------------------------------
		["Last Stand"] = function()
			local value, enabled = GetSetting("regen");
			if enabled
					and ni.player.hp() < value
					and ni.spell.available(12975) then
				ni.spell.cast(12975)
				return true
			end
		end,
		-----------------------------------
		["Enraged Regeneration"] = function()
			local enrage = { 18499, 12292, 29131, 14204, 57522 }
			if ni.player.buff(12975)
					and ni.spell.available(55694) then
				for i = 1, #enrage do
					if ni.player.buff(enrage[i]) then
						ni.spell.cast(55694)
					else
						if not ni.player.buff(enrage[i])
								and ni.spell.cd(2687) == 0 then
							ni.spell.castspells("2687|55694")
							return true
						end
					end
				end
			end
		end,
		-----------------------------------
		["Shield Wall"] = function()
			local value, enabled = GetSetting("wall");
			if enabled
					and ni.player.hp() < value
					and ni.spell.available(871) then
				ni.spell.cast(871)
				return true
			end
		end,
		-----------------------------------
		["Taunt"] = function()
			local _, enabled = GetSetting("tau")
			if (data.youInInstance()
						or enabled)
					and ni.unit.exists("targettarget")
					and not UnitIsDeadOrGhost("targettarget")
					and UnitAffectingCombat("player")
					and (ni.unit.debuff("targettarget", 72410)
						or ni.unit.debuff("targettarget", 72411)
						or ni.unit.threat("player", "target") < 2)
					and ni.spell.available(355)
					and ni.spell.valid("target", 355, false, true, true) then
				ni.spell.cast(355)
				return true
			end
		end,
		-----------------------------------
		["Taunt (Ally)"] = function()
			local _, enabled = GetSetting("tau")
			if ni.spell.available(355)
					and (data.youInInstance()
						or enabled) then
				local enemies = ni.unit.enemiesinrange("player", 30)
				for i = 1, #enemies do
					local threatUnit = enemies[i].guid
					if ni.unit.threat("player", threatUnit) ~= nil
							and ni.unit.threat("player", threatUnit) <= 2
							and UnitAffectingCombat(threatUnit)
							and ni.spell.valid(threatUnit, 355, false, true, true) then
						ni.spell.cast(355, threatUnit)
						return true
					end
				end
			end
		end,
		-----------------------------------
		["Mocking Blow"] = function()
			local _, enabled = GetSetting("mocking")
			if (data.youInInstance()
						or enabled)
					and ni.unit.exists("targettarget")
					and not UnitIsDeadOrGhost("targettarget")
					and UnitAffectingCombat("player")
					and (ni.unit.debuff("targettarget", 72410)
						or ni.unit.debuff("targettarget", 72411)
						or ni.unit.threat("player", "target") < 2)
					and ni.spell.cd(355) ~= 0
					and ni.spell.available(694)
					and ni.spell.valid("target", 694, true, true) then
				ni.spell.cast(694, "target")
				return true
			end
		end,
		-----------------------------------
		["Intervene"] = function()
			local _, enabled = GetSetting("interv")
			if (data.youInInstance()
						or enabled)
					and ni.spell.available(3411) then
				for i = 1, #ni.members do
					if ni.members[i].range
							and not UnitIsDeadOrGhost(ni.members[i].unit) then
						local tarCount = #ni.unit.unitstargeting(ni.members[i].guid)
						if tarCount ~= nil
								and tarCount >= 1
								and not ni.members[i].istank
								and ni.unit.threat(ni.members[i].guid) >= 2
								and ni.spell.valid(ni.members[i].unit, 3411, false, true, true) then
							ni.spell.cast(3411, ni.members[i].unit)
							return true
						end
					end
				end
			end
		end,
		-----------------------------------
		["Revenge"] = function()
			if IsUsableSpell(GetSpellInfo(57823))
					and ni.spell.available(57823, true)
					and ni.spell.valid("target", 57823, true, true) then
				ni.spell.cast(57823, "target")
				return true
			end
		end,
		-----------------------------------
		["Rend"] = function()
			local _, enabled = GetSetting("rend")
			local rend = data.warrior.rend()
			if enabled
					and ni.unit.isboss("target")
					and (rend == nil or (rend <= 2))
					and ni.spell.available(47465, true)
					and ni.spell.valid("target", 47465, true, true) then
				ni.spell.cast(47465, "target")
				return true
			end
		end,
		-----------------------------------
		["Shield Block"] = function()
			if ni.player.hp() < 80
					and ni.spell.available(2565, true)
					and ni.spell.valid("target", 47498) then
				ni.spell.cast(2565)
				return true
			end
		end,
		-----------------------------------
		["Shield Slam"] = function()
			if ni.spell.available(47488, true)
					and ni.spell.valid("target", 47488, true, true) then
				ni.spell.cast(47488)
				return true
			end
		end,
		-----------------------------------
		["Thunder Clap (AoE)"] = function()
			local _, enabled = GetSetting("thunder")
			if enabled
					and ActiveEnemies() >= 1
					and ni.spell.available(47502, true)
					and ni.spell.valid("target", 47465, true, true) then
				ni.spell.cast(47502)
				return true
			end
		end,
		-----------------------------------
		["Demoralizing Shout"] = function()
			if ni.unit.exists("target")
					and data.warrior.InRange()
					and UnitCanAttack("player", "target") then
				local enemies = ni.unit.enemiesinrange("target", 8)
				for i = 1, # enemies do
					local tar = enemies[i].guid;
					if ni.unit.creaturetype(enemies[i].guid) ~= 8
							and not ni.unit.debuff(tar, 47437)
							and GetTime() - data.warrior.LastShout > 4
							and ni.spell.available(47437) then
						ni.spell.cast(47437, tar)
						data.warrior.LastShout = GetTime()
						return true
					end
				end
			end
		end,
		-----------------------------------
		["Devastate"] = function()
			if ni.spell.available(47498, true)
					and ni.spell.valid("target", 47498, true, true) then
				ni.spell.cast(47498)
				return true
			end
		end,
		-----------------------------------
		["Heroic Strike + Cleave (Filler)"] = function()
			local value = GetSetting("heroiccleave");
			if ni.spell.valid("target", 47475)
					and ni.player.power() > value then
				if ActiveEnemies() >= 1
						and ni.spell.available(47520, true)
						and not IsCurrentSpell(47520) then
					ni.spell.cast(47520, "target")
					return true
				else
					if ActiveEnemies() == 0
							and ni.spell.available(47450, true)
							and not IsCurrentSpell(47450) then
						ni.spell.cast(47450, "target")
						return true
					end
				end
			end
		end,
		-----------------------------------
		["Window"] = function()
			if not popup_shown then
				ni.debug.popup("Protection Warrior by DarhangeR for 3.3.5a",
					"Welcome to Protection Warrior Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-Focus ally target for use Vigilance on it")
				popup_shown = true;
			end
		end,
	}

	ni.bootstrap.profile("Protection_Warrior_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Protection_Warrior_DarhangeR", queue, abilities);
end
