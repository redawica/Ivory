local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local enemies = { };
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_HolyPaladin.xml",
	{ type = "title", text = "Holy Paladin PvE" },
	{ type = "title", text = "Core Files |cff00D700v2.0.7" },
	{ type = "title", text = "|cffFF69B4Profile version 2.0.4" },
	{ type = "separator" },

	-- 11) Main Settings
	{ type = "page", number = 0, text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 0, text = "|T"..(select(3, GetSpellInfo(19746)) or "")..":20:20|t Active Aura: Auto mode" },
		{ selected = false, value = 465, text = "|T"..(select(3, GetSpellInfo(465)) or "")..":20:20|t Devotion Aura" },
		{ selected = false, value = 19746, text = "|T"..(select(3, GetSpellInfo(19746)) or "")..":20:20|t Concentration Aura" },
		{ selected = false, value = 19876, text = "|T"..(select(3, GetSpellInfo(19876)) or "")..":20:20|t Shadow Resistance Aura" },
		{ selected = false, value = 19888, text = "|T"..(select(3, GetSpellInfo(19888)) or "")..":20:20|t Frost Resistance Aura" },
		{ selected = false, value = 19891, text = "|T"..(select(3, GetSpellInfo(19891)) or "")..":20:20|t Fire Resistance Aura" },
		{ selected = false, value = 7294, text = "|T"..(select(3, GetSpellInfo(7294)) or "")..":20:20|t Retribution Aura" },
		{ selected = false, value = 32223, text = "|T"..(select(3, GetSpellInfo(32223)) or "")..":20:20|t Crusader Aura" },
	}, key = "AuraType" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 20166, text = "Active Seals: Wisdom" },
		{ selected = false, value = 0, text = "Active Seals: Auto mode" },
		{ selected = false, value = 20166, text = "|T"..(select(3, GetSpellInfo(20166)) or "")..":20:20|t Seal of Wisdom" },
		{ selected = false, value = 20165, text = "|T"..(select(3, GetSpellInfo(20165)) or "")..":20:20|t Seal of Light" },
	}, key = "sealtype" },
	{ type = "entry", text = "|T"..(select(3, GetSpellInfo(32223)) or "")..":26:26|t Crusader Aura", tooltip = "Auto use auras.", enabled = true, key = "crusaderaura" },
	{ type = "entry", text = "|T"..(select(3, GetSpellInfo(5019)) or "")..":26:26|t Profile Pause", tooltip = "Custom profile pause throttle in seconds", enabled = true, value = 1.5, key = "profilepause" },
	{ type = "entry", text = "|T"..data.debugIcon()..":26:26|t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },

	-- 1) Rotation / Basic
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cffEE4000Rotation Settings" },
	{ type = "separator" },
	{ type = "title", text = "Blessings Settings" },
	{ type = "dropdown", menu = {
		{ selected = false, value = 25898, text = "|T"..(select(3, GetSpellInfo(25898)) or "")..":20:20|t Greater Blessing of Kings" },
		{ selected = false, value = 48934, text = "|T"..(select(3, GetSpellInfo(48934)) or "")..":20:20|t Greater Blessing of Might" },
		{ selected = true, value = 48938, text = "|T"..(select(3, GetSpellInfo(48938)) or "")..":20:20|t Greater Blessing of Wisdom" },
		{ selected = false, value = 25899, text = "|T"..(select(3, GetSpellInfo(25899)) or "")..":20:20|t Greater Blessing of Sanctuary" },
	}, key = "BlessingType" },
	{ type = "entry", text = "Use in combat", tooltip = "Allow blessing in combat", enabled = false, key = "blesscombat" },
	{ type = "separator" },
	{ type = "title", text = "Righteous Fury Settings" },
	{ type = "entry", text = "Cancel Buff", tooltip = "Cancel Righteous Fury buff.", enabled = true, key = "cancelrf" },
	{ type = "separator" },
	{ type = "title", text = "Active Judgement" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 20271, text = "|T"..(select(3, GetSpellInfo(20271)) or "")..":20:20|t Judgement of Light" },
		{ selected = false, value = 53408, text = "|T"..(select(3, GetSpellInfo(53408)) or "")..":20:20|t Judgement of Wisdom" },
		{ selected = false, value = 53407, text = "|T"..(select(3, GetSpellInfo(53407)) or "")..":20:20|t Judgement of Justice" },
	}, key = "JudgementType" },
	{ type = "entry", text = "|T"..data.paladin.exorIcon()..":26:26|t Exorcism (75)", tooltip = "Use spell when player mana is above 75%", enabled = false, value = 75, key = "exorc" },
	{ type = "entry", text = "|T"..data.paladin.hamWraIcon()..":26:26|t Hammer of Wrath", tooltip = "Auto check execute target and use it.", enabled = false, key = "masswrath" },
	{ type = "entry", text = "|T"..data.paladin.turnIcon()..":26:26|t Turn Evil (Auto Use)", tooltip = "Auto check and use spell on proper enemies", enabled = false, key = "turn" },
	{ type = "entry", text = "|T"..data.controlIcon()..":26:26|t Auto Control (Allys)", tooltip = "Checking for a buff and using a spell in combat.", enabled = true, key = "control" },

	-- 2) Trinkets Settings
	{ type = "separator" },
	{ type = "page", number = 2, text = "|cff00BFFFTrinkets Settings" },
	{ type = "separator" },
	{ type = "title", text = "Using Trinkets increasing player stats" },
	{ type = "entry", text = "Trinkets", tooltip = "Use stat trinkets.", enabled = true, key = "trinkets" },
	{ type = "entry", text = "Allys HP", tooltip = "Allies HP threshold for trinket usage", enabled = true, value = 55, key = "trinketsallyhp" },
	{ type = "entry", text = "Allys Count", tooltip = "Allies count threshold for trinket usage", enabled = true, value = 3, key = "trinketsallycount" },
	{ type = "separator" },
	{ type = "title", text = "Using Other Trinkets" },
	{ type = "entry", text = "Mana Regeneration", tooltip = "Use mana trinkets when MP is below %", enabled = true, value = 60, key = "manaregtrinket" },
	{ type = "entry", text = "Health Regeneration", tooltip = "Use health trinkets when HP is below %", enabled = true, value = 50, key = "healthregtrinket" },
	{ type = "separator" },
	{ type = "title", text = "Mass Healing" },
	{ type = "entry", text = "Allys HP", tooltip = "Mass healing trinket HP threshold", enabled = true, value = 55, key = "masshealtrinkethp" },
	{ type = "entry", text = "Allys Count", tooltip = "Mass healing trinket allies count", enabled = true, value = 3, key = "masshealtrinketcount" },
	{ type = "separator" },
	{ type = "title", text = "Using Engineering items" },
	{ type = "entry", text = "Hands", tooltip = "Use engineering gloves", enabled = true, key = "enghands" },
	{ type = "entry", text = "Allys HP", tooltip = "Engineering gloves HP threshold", enabled = true, value = 37, key = "enghandshp" },
	{ type = "entry", text = "Allys Count", tooltip = "Engineering gloves allies count", enabled = true, value = 3, key = "enghandscount" },
	{ type = "title", text = "Using the following Trinkets (if equipped) when MP is below %:" },
	{ type = "title", text = "• Sliver of Pure Ice • Meteorite Crystal • Spirit-World Glass • Figurine - Sapphire Owl" },
	{ type = "separator" },
	{ type = "title", text = "Custom Trinkets (ID/Spell/Unit)" },
	{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = false, key = "trinketenabled" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
	{ type = "input", value = "player", width = 80, height = 15, key = "trinket13unit" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
	{ type = "input", value = "player", width = 80, height = 15, key = "trinket14unit" },

	-- 3) CD's and important spells #1
	{ type = "separator" },
	{ type = "page", number = 3, text = "|cff95f900CD's and important spells #1" },
	{ type = "separator" },
	{ type = "title", text = "Racial Abilities" },
	{ type = "entry", text = "Use racial abilities", tooltip = "Enable racial spells/items", enabled = true, key = "racial" },
	{ type = "entry", text = "|T"..data.paladin.pleaIcon()..":26:26|t Divine Plea (60 seconds)", tooltip = "Use spell when player mana is below %", enabled = true, value = 60, key = "plea" },
	{ type = "separator" },
	{ type = "title", text = "Bursts" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "Modifiers with checking" },
		{ selected = false, value = 2, text = "Modifiers without checking allies" },
	}, key = "burstmode" },
	{ type = "entry", text = "|T"..data.paladin.favorIcon()..":26:26|t Divine Favor (40 seconds)", tooltip = "Use spell with burst conditions.", enabled = true, value = 40, key = "divinefavor" },
	{ type = "entry", text = "|T"..(select(3, GetSpellInfo(633)) or "")..":26:26|t Lay on Hands (20 seconds)", tooltip = "Cast on Ally + Self", enabled = true, value = 20, key = "layon" },
	{ type = "entry", text = "Lay on Hands (Ally + Self)", tooltip = "Allow using Lay on Hands on allies", enabled = true, key = "layonally" },
	{ type = "entry", text = "|T"..data.paladin.aveWrathIcon()..":26:26|t Avenging Wrath", tooltip = "Use when ally HP is below 30% and ally count is at least 4", enabled = true, key = "aven" },
	{ type = "entry", text = "|T"..data.paladin.illumIcon()..":26:26|t Divine Illumination", tooltip = "Use when ally HP is below 30% and ally count is at least 4", enabled = true, value = 35, key = "illumination" },
	{ type = "entry", text = "During Divine Plea use Avenging Wrath", tooltip = "Sync Avenging Wrath during Divine Plea", enabled = true, key = "pleaburstaw" },
	{ type = "entry", text = "During Divine Plea use Divine Illumination (2T10)", tooltip = "Sync Divine Illumination during Divine Plea when using 2T10", enabled = true, key = "pleaburstillum" },

	-- 4) CD's and important spells #2
	{ type = "separator" },
	{ type = "page", number = 4, text = "|cff95f900CD's and important spells #2" },
	{ type = "separator" },
	{ type = "entry", text = "|T"..data.paladin.handSalIcon()..":26:26|t Hand of Salvation (Allys)", tooltip = "Auto check ally agro and use spell.", enabled = true, key = "salva" },
	{ type = "entry", text = "|T"..data.paladin.handSacrIcon()..":26:26|t Hand of Sacrifice (Allys)", tooltip = "Use spell when ally HP is below %", enabled = true, value = 25, key = "handsacrifice" },
	{ type = "entry", text = "|T"..data.paladin.handProIcon()..":26:26|t Hand of Protection (Allys)", tooltip = "Spell ignoring Tanks.", enabled = true, value = 25, key = "handofprot" },
	{ type = "entry", text = "|T"..data.paladin.masteryIcon()..":26:26|t Aura Mastery", tooltip = "Enable spell", enabled = true, key = "auramastery" },
	{ type = "entry", text = "Allys HP", tooltip = "Use spell when member HP is below %", enabled = true, value = 30, key = "auramasteryhp" },
	{ type = "entry", text = "Allys Count", tooltip = "Use spell when ally count have low hp", enabled = true, value = 4, key = "auramasterycount" },
	{ type = "separator" },
	{ type = "title", text = "Dispel Section" },
	{ type = "entry", text = "Delay for dispeling", tooltip = "Delay between dispels", enabled = true, value = 1.5, key = "dispeldelay" },
	{ type = "entry", text = "|T"..data.paladin.cleanIcon()..":26:26|t Cleanse (Allys)", tooltip = "Auto dispel debuffs from allies", enabled = true, key = "cleans" },
	{ type = "entry", text = "|T"..data.paladin.handFreeIcon()..":26:26|t Hand of Freedom (Allys)", tooltip = "Auto cast on ally with roots/slows", enabled = true, key = "freedom" },
	{ type = "input", value = "", width = 120, height = 15, key = "salvatarget" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "Settings: Automatic" },
		{ selected = false, value = 2, text = "Settings: By Ally name" },
		{ selected = false, value = 3, text = "Settings: Manual mode" },
	}, key = "supportmode" },

	-- 5) Healing Engine Settings
	{ type = "separator" },
	{ type = "page", number = 5, text = "|cff95f900Healing Engine Settings" },
	{ type = "separator" },
	{ type = "title", text = "Ignore Ally" },
	{ type = "input", value = "", width = 120, height = 15, key = "ignoreally1" },
	{ type = "title", text = "Ignore Ally #2" },
	{ type = "input", value = "", width = 120, height = 15, key = "ignoreally2" },
	{ type = "title", text = "Ignore Ally #3" },
	{ type = "input", value = "", width = 120, height = 15, key = "ignoreally3" },
	{ type = "entry", text = "Burst-Healing: Flash of Light", tooltip = "Prefer Flash of Light in burst windows.", enabled = true, key = "burstflash" },
	{ type = "entry", text = "Pets Healing", tooltip = "Allow healing pets.", enabled = true, key = "pethealing" },
	{ type = "entry", text = "Overhealing", tooltip = "Enable this function to overheal bad effects on allies or disperse HPS under certain items.", enabled = true, key = "overhealing" },
	{ type = "title", text = "Examples: Frost Blast, Incinerate Flesh, Penetrating Cold, Mark of the Fallen Champion, Volatile Ooze Adhesive, Gaseous Bloat, Frost Beacon, Infest, Harvest Soul, Soul Reaper." },
	{ type = "title", text = "Items: Scarab Brooch, Glowing Twilight Scale, Val'anyr, Hammer of Ancient Kings" },

	-- 6) Party/Raid Healing Settings
	{ type = "separator" },
	{ type = "page", number = 6, text = "|cff95f900Party/Raid Healing Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Non Combat Healing", tooltip = "Heal ally if you or them are not in combat and ally HP is below %. If not moving use Flash of Light.", enabled = true, value = 95, key = "noncombatheal" },
	{ type = "entry", text = "|T"..data.paladin.hsockIcon()..":26:26|t Holy Shock", tooltip = "Use spell when member HP is below %", enabled = true, value = 86, key = "shock" },
	{ type = "entry", text = "|T"..data.paladin.flashIcon()..":26:26|t Flash of Light", tooltip = "Use spell when member HP is below %", enabled = true, value = 84, key = "flash" },
	{ type = "entry", text = "|T"..data.paladin.lightIcon()..":26:26|t Holy Light", tooltip = "Use spell when member HP is below %", enabled = true, value = 60, key = "light" },
	{ type = "entry", text = "|T"..data.paladin.lightIcon()..":26:26|t Holy Light (Glyph)", tooltip = "Use spell when you have glyph and member HP is below %", enabled = true, value = 68, key = "lightglyph" },
	{ type = "entry", text = "Allys HP", tooltip = "Mass healing hp threshold", enabled = true, value = 85, key = "healallyhp" },
	{ type = "entry", text = "Allys Count", tooltip = "Mass healing ally count", enabled = true, value = 2, key = "healallycount" },

	-- 7) Tank Settings
	{ type = "separator" },
	{ type = "page", number = 7, text = "|cff95f900Tank Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Auto Track Tank", tooltip = "Auto Track Tank and mainly heal him. Paladin support only ONE MAIN TANK.", enabled = true, key = "healtank" },
	{ type = "entry", text = "Beacon of Light", tooltip = "Maintain Beacon of Light on tank", enabled = true, key = "beacon" },
	{ type = "entry", text = "Sacred Shield", tooltip = "Maintain Sacred Shield on tank", enabled = true, key = "sacred" },
	{ type = "entry", text = "Beacon of Light (Focus)", tooltip = "Allow beacon on focus target", enabled = false, key = "beaconfocus" },
	{ type = "entry", text = "Sacred Shield (Focus)", tooltip = "Allow sacred shield on focus target", enabled = false, key = "sacredfocus" },
	{ type = "entry", text = "Flash of Light (HoT)", tooltip = "Keep Flash of Light HoT on beacon/focus", enabled = true, key = "flashhot" },
	{ type = "entry", text = "Patchwerk Mode", tooltip = "High throughput single-tank healing mode", enabled = false, key = "patchwerk" },

	-- 8) Valithria Healing Settings
	{ type = "separator" },
	{ type = "page", number = 8, text = "|cff95f900Valithria Healing Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Enable Healing", tooltip = "Enable Valithria healing in ICC.", enabled = false, key = "valithria" },
	{ type = "entry", text = "Allys HP %", tooltip = "Valithria or raid HP threshold", enabled = true, value = 80, key = "valithriahp" },
	{ type = "title", text = "Healing Mode Settings" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "Heal Boss Only" },
		{ selected = false, value = 2, text = "Heal Boss and Raid" },
	}, key = "valithriamode" },

	-- 9) Defensive Settings
	{ type = "separator" },
	{ type = "page", number = 9, text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "|T"..data.paladin.divineShIcon()..":26:26|t Divine Shield [22]", tooltip = "Use spell when player HP is below %", enabled = true, value = 22, key = "divineshield" },
	{ type = "entry", text = "|T"..data.stoneIcon()..":26:26|t Healthstone [35]", tooltip = "Use Warlock Healthstone when player HP is below %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "Healthstone (Pick-up)", tooltip = "Auto pick-up Healthstones when possible", enabled = true, key = "healthstonepickup" },
	{ type = "entry", text = "|T"..data.hpotionIcon()..":26:26|t Heal Potion [30]", tooltip = "Use Heal Potions when player HP is below %", enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "|T"..data.mpotionIcon()..":26:26|t Mana Potion [25]", tooltip = "Use Mana Potions when player mana is below %", enabled = true, value = 25, key = "manapotionuse" },

	-- 10) Expert Settings
	{ type = "separator" },
	{ type = "page", number = 10, text = "|cffFFD700Expert Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Change macro #1 rebuff [Confirm]", tooltip = "Change macro /rebuff on your own.", enabled = false, key = "expertmacro1" },
	{ type = "entry", text = "Change macro #2 burst [Confirm]", tooltip = "Change burst macro on your own.", enabled = false, key = "expertmacro2" },
	{ type = "entry", text = "Change macro #3 cleanse [Confirm]", tooltip = "Change cleanse macro on your own.", enabled = false, key = "expertmacro3" },
	{ type = "entry", text = "Import/Export Settings", tooltip = "Import or export profile settings.", enabled = false, key = "importexport" },
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
local function IsIgnoredUnit(unit)
	if not unit or not UnitExists(unit) then
		return false
	end
	local name = UnitName(unit)
	if not name then
		return false
	end
	for _, key in ipairs({ "ignoreally1", "ignoreally2", "ignoreally3" }) do
		local value = GetSetting(key)
		if value and value ~= "" and string.lower(value) == string.lower(name) then
			return true
		end
	end
	return false
end
local function AllowPetHealing(unit)
	local _, enabled = GetSetting("pethealing")
	if enabled then
		return true
	end
	return not tostring(unit):find("pet")
end
local function GetHealCandidate(index)
	local found = 0
	for i = 1, #ni.members do
		local member = ni.members[i]
		if member
		 and member.unit
		 and not IsIgnoredUnit(member.unit)
		 and AllowPetHealing(member.unit) then
			found = found + 1
			if found == index then
				return member
			end
		end
	end
	return ni.members[index]
end
local function GetSelectedAura()
	local aura = GetSetting("AuraType")
	if aura and aura ~= 0 then
		return aura
	end
	if UnitAffectingCombat("player") then
		return 19746
	end
	if IsMounted() then
		return 32223
	end
	return 465
end
local function IsValithriaBossOnly()
	local mode = GetSetting("valithriamode")
	local _, enabled = GetSetting("valithria")
	return enabled and mode == 1 and ni.unit.exists("boss1") and ni.unit.id("boss1") == 36789
end
local function OnLoad()
	ni.GUI.AddFrame("Holy_DarhangeR", items);
end
local function OnUnLoad()
	ni.GUI.DestroyFrame("Holy_DarhangeR");
end

local queue = {

	"Universal pause",
	"Selected Aura",
	"Seal of Wisdom/Light",
	"Crusader Aura",
	"Blessings (Raid/Dungeon)",
	"Cancel Righteous Fury",
	"Divine Plea",
	"Non Combat Healing",
	"Auto Track Undeads",
	"Combat specific Pause",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",
	"Trinkets (Config)",
	"Use enginer gloves",
	"Racial Stuff",
	"Divine Shield",
	"Cleanse (Member)",
	"Judgement (Selected Type)",
	"Exorcism",
	"Aura Mastery",
	"Hand of Sacrifice (Member)",
	"Hand of Salvation (Member)",
	"Hand of Protection (Member)",
	"Divine Favor",
	"Avenging Wrath",
	"Divine Illumination T10",
	"Divine Illumination",
	"Tank Heal",
	"Valithria Heal",
	"Hammer of Wrath (Auto Target)",
	"Turn Evil (Auto Use)",
	"Control (Member)",
	"Holy Light (Glyph)",
	"Holy Light",
	"Holy Shock",
	"Flash of Light",
	"Hand of Freedom (Member)",
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
	["Selected Aura"] = function()
		local aura = GetSelectedAura()
		if aura
		 and IsSpellKnown(aura)
		 and ni.spell.available(aura)
		 and not ni.player.buff(aura) then
			ni.spell.cast(aura)
			return true
		end
	end,
-----------------------------------
	["Auto Track Undeads"] = function()
		if ni.player.hasglyph(57947) then
		 if not UnitAffectingCombat("player")
		  and GetTime() - data.paladin.LastTrack > 8 then
				SetTracking(nil);
		 end
			-- Undead --
		 if UnitAffectingCombat("player")
		  and ni.unit.exists("target")
		  and ni.unit.creaturetype("target") == 6
		  and ni.spell.available(5502)
		  and GetTime() - data.paladin.LastTrack > 8 then
				data.paladin.LastTrack = GetTime()
				ni.spell.cast(5502)
			end
		end
	end,
-----------------------------------
	["Seal of Wisdom/Light"] = function()
		local seal = GetSetting("sealtype")
		if seal and seal ~= 0
		 and IsSpellKnown(seal)
		 and ni.spell.available(seal)
		 and not ni.player.buff(seal) then
			ni.spell.cast(seal)
			return true
		end
		if ni.spell.available(20166)
		 and ni.player.hasglyph(54940)
		 and not ni.player.buff(20166) then
			ni.spell.cast(20166)
			return true
		end
		if ni.spell.available(20165)
		 and ni.player.hasglyph(54943)
		 and not ni.player.buff(20165) then
			ni.spell.cast(20165)
			return true
		end
		if not ni.player.hasglyph(54943)
		 and not ni.player.hasglyph(54940)
		 and ni.spell.available(20166)
		 and not ni.player.buff(20166) then
			ni.spell.cast(20166)
			return true
		end
	end,
-----------------------------------
	["Crusader Aura"] = function()
		local _, enabled = GetSetting("crusaderaura")
		if enabled
		 and not UnitAffectingCombat("player")
		 and IsSpellKnown(32223)
		 and ni.spell.available(32223)
		 and not ni.player.buff(32223) then
			ni.spell.cast(32223)
			return true
		end
	end,
-----------------------------------
	["Blessings (Raid/Dungeon)"] = function()
		local blessing = GetSetting("BlessingType")
		local _, combatEnabled = GetSetting("blesscombat")
		if not blessing then return end
		if (not UnitAffectingCombat("player") or combatEnabled)
		 and IsSpellKnown(blessing)
		 and ni.spell.available(blessing)
		 and not ni.player.buff(blessing) then
			ni.spell.cast(blessing, "player")
			return true
		end
	end,
-----------------------------------
	["Cancel Righteous Fury"] = function()
		local _, enabled = GetSetting("cancelrf")
		if not enabled then return end
		local p = "player"
		for i = 1, 40 do
			local _, _, _, _, _, _, _, u, _, _, s = UnitBuff(p, i)
			if u == p and s == 25780 then
				CancelUnitBuff(p, i)
				break
			end
		end
	end,
-----------------------------------
	["Divine Plea"] = function()
		local value, enabled = GetSetting("plea");
		if enabled
		 and ni.player.power() < value
		 and not ni.player.buff(54428)
		 and ni.spell.available(54428) then
			ni.spell.cast(54428)
			return true
		end
	end,
-----------------------------------
	["Non Combat Healing"] = function()
		local member = GetHealCandidate(1)
		local value, enabled = GetSetting("noncombatheal");
		if enabled
		 and not UnitAffectingCombat("player")
		 and member
		 and ni.spell.available(48785) then
		   if member.hp < value
		    and not ni.player.ismoving()
		    and ni.spell.valid(member.unit, 48785, false, true, true) then
				ni.spell.cast(48785, member.unit)
				return true
			end
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		local pauseDelay, enabled = GetSetting("profilepause")
		if enabled and pauseDelay and pauseDelay > 0 and not data.CombatStart(pauseDelay) then
			return true
		end
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
		if data.UseConfiguredTrinkets(GetSetting, nil, "player") then
			return true
		end
	end,
-----------------------------------
	["Use enginer gloves"] = function()
		if ni.player.slotcastable(10)
		 and ni.player.slotcd(10) == 0
		 and UnitAffectingCombat("player") then
			ni.player.useinventoryitem(10)
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
		 and ni.spell.valid("target", 20271) then
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Blood Elf
		for i = 1, #bloodelf do
		if ni.player.power() < 70
		 and IsSpellKnown(bloodelf[i])
		 and ni.spell.available(bloodelf[i])
		 and ni.spell.valid("target", 20271) then
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 20271)
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then
					ni.spell.cast(alracial[i])
					return true
				end
			end
		end,
-----------------------------------
	["Divine Shield"] = function()
		local value, enabled = GetSetting("divineshield");
		local forb = data.paladin.forb()
		if enabled
		 and ni.player.hp() < value
		 and not forb
		 and ni.spell.available(642) then
			ni.spell.cast(642)
			return true
		end
	end,
-----------------------------------
	["Judgement (Selected Type)"] = function()
		local judgement = GetSetting("JudgementType")
		if judgement
		 and ni.members[1].hp > 75
		 and ni.spell.available(judgement)
		 and ni.spell.valid("target", judgement, false, true, true) then
			ni.spell.cast(judgement, "target")
			return true
		end
	end,
-----------------------------------
	["Exorcism"] = function()
		local _, enabled = GetSetting("exorc");
		if enabled
		 and ni.members[1].hp > 75
		 and ni.player.power() > 75
		 and ni.spell.available(48801)
		 and not ni.player.ismoving()
		 and ni.spell.valid("target", 48801, true, true) then
			ni.spell.cast(48801, "target")
			return true
		end
	end,
-----------------------------------
	["Aura Mastery"] = function()
		local _, enabled = GetSetting("auramastery");
		local valueHp = GetSetting("auramasteryhp");
		local valueCount = GetSetting("auramasterycount");
		if enabled
		 and ni.members.averageof(valueCount) < valueHp
		 and ni.spell.available(31821) then
			ni.spell.cast(31821)
			return true
		end
	end,
-----------------------------------
	["Hand of Sacrifice (Member)"] = function()
		local value, enabled = GetSetting("handsacrifice");
		if enabled
		 and #ni.members > 1
		 and ni.spell.available(6940) then
		   if ni.members[1].range
		   and ni.members[1].hp < value
		   and ni.player.hp() >= 65
		   and not ni.members[1].istank
		   and not data.paladin.HandActive(ni.members[1].unit)
		   and ni.spell.valid(ni.members[1].unit, 6940, false, true, true) then
				ni.spell.cast(6940, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Hand of Salvation (Member)"] = function()
		local _, enabled = GetSetting("salva")
		local mode = GetSetting("supportmode")
		local namedTarget = GetSetting("salvatarget")
		if enabled
		 and #ni.members > 1
		 and ni.spell.available(1038)
		 and data.CombatStart(10) then
		  if mode == 2 and namedTarget and namedTarget ~= "" then
			for i = 1, #ni.members do
				local ally = ni.members[i]
				if UnitName(ally.unit) == namedTarget
				 and ally.threat >= 2
				 and not ally.istank
				 and not data.paladin.HandActive(ally.unit)
				 and ni.spell.valid(ally.unit, 1038, false, true, true) then
					ni.spell.cast(1038, ally.unit)
					return true
				end
			end
		  elseif mode == 3 then
			if ni.unit.exists("focus")
			 and not UnitIsDeadOrGhost("focus")
			 and not UnitIsUnit("focus", "player")
			 and not data.paladin.HandActive("focus")
			 and ni.spell.valid("focus", 1038, false, true, true) then
				ni.spell.cast(1038, "focus")
				return true
			end
		  elseif ni.members[1].threat >= 2
		   and not ni.members[1].istank
		   and not data.paladin.HandActive(ni.members[1].unit)
		   and ni.spell.valid(ni.members[1].unit, 1038, false, true, true) then
				ni.spell.cast(1038, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Hand of Protection (Member)"] = function()
		local value, enabled = GetSetting("handofprot");
		if enabled
		 and #ni.members > 1
		 and ni.spell.available(10278) then
		  if ni.members[1].range
		  and ni.members[1].hp < value
		  and not ni.members[1].istank
		  and ni.members[1].threat >= 2
		  and ni.members[1].class ~= "DEATHKNIGHT"
		  and not (ni.members[1].class == "DRUID"
		  and ni.unit.buff(ni.members[1].unit, 768))
		  and ni.members[1].class ~= "HUNTER"
		  and ni.members[1].class ~= "PALADIN"
		  and ni.members[1].class ~= "ROGUE"
		  and ni.members[1].class ~= "WARRIOR"
		  and not data.paladin.HandActive(ni.members[1].unit)
		  and not ni.unit.debuff(ni.members[1].unit, 25771)
		  and ni.spell.valid(ni.members[1].unit, 10278, false, true, true) then
				ni.spell.cast(10278, ni.members[1].unit)
				return true
			end
		end
	end,
-----------------------------------
	["Divine Favor"] = function()
		local member = GetHealCandidate(1)
		local value, enabled = GetSetting("divinefavor")
		local mode = GetSetting("burstmode")
		if not enabled
		 or not member
		 or not ni.spell.available(20216)
		 or ni.player.buff(20216) then
			return
		end
		if mode == 2 then
			if member.hp < value then
				ni.spell.cast(20216)
				return true
			end
		elseif ni.members.averageof(4) < 75
		 and member.hp < value then
			ni.spell.cast(20216)
			return true
		end
	end,
-----------------------------------
	["Avenging Wrath"] = function()
		local _, enabled = GetSetting("aven");
		local mode = GetSetting("burstmode")
		local _, syncPlea = GetSetting("pleaburstaw")
		if enabled
		 and ni.spell.available(31884) then
			if syncPlea and ni.player.buff(54428) then
				ni.spell.cast(31884)
				return true
			end
			if mode == 2 and ni.members[1].hp < 30 then
				ni.spell.cast(31884)
				return true
			end
			if data.youInInstance()
			 and ni.members.averageof(4) < 30 then
				ni.spell.cast(31884)
				return true
			end
			if data.youInRaid()
			 and ni.members.averageof(7) < 30 then
				ni.spell.cast(31884)
				return true
			end
		end
	end,
-----------------------------------
	["Divine Illumination T10"] = function()
		local _, syncPlea = GetSetting("pleaburstillum")
		if data.checkforSet(data.paladin.itemsetT10, 2) then
		 if syncPlea
		  and ni.player.buff(54428)
		  and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
		 end
		 if data.youInInstance()
		 and ni.members.averageof(4) < 45
		 and not ni.player.buff(54428)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
			end
		else
		if data.youInRaid()
		 and ni.members.averageof(9) < 45
		 and not ni.player.buff(54428)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
			end
		end
	end,
-----------------------------------
	["Divine Illumination"] = function()
		local value, enabled = GetSetting("illumination");
		local mode = GetSetting("burstmode")
		if enabled
		 and (ni.player.power() < value or (mode ~= 2 and ni.members.averageof(4) < 30))
		 and not ni.player.buff(31842)
		 and ni.spell.available(31842) then
			ni.spell.cast(31842)
			return true
		end
	end,
-----------------------------------
	["Tank Heal"] = function()
		if IsValithriaBossOnly() then
			return
		end
		local tank = ni.tanks()
		local _, enabled = GetSetting("healtank");
		-- Main Tank Heal
		if enabled
		 and ni.unit.exists(tank) then
		 local BofLtank, _, _, _, _, _, BofLtank_time = ni.unit.buff(tank, 53563, "player")
		 local SCtank, _, _, _, _, _, SCtank_time = ni.unit.buff(tank, 53601, "player")
		 local SelfSCtank = ni.unit.buff(tank, 53601)
		 local forbtank = ni.unit.debuff(tank, 25771)
			-- Put Beacon on MT --
		if not ni.unit.exists("boss1") then
		 if (not BofLtank
		 or (BofLtank and BofLtank_time - GetTime() < 2))
		 and ni.spell.available(53563)
		 and ni.spell.valid(tank, 53563, false, true, true) then
			 ni.spell.cast(53563, tank)
			 return true
			end
		end
			-- Put Sacred on MT --
		 if not ni.unit.exists("boss1") then
		  if not SelfSCtank
		  and (not SCtank
		  or (SCtank and SCtank_time - GetTime() < 2))
		  and ni.spell.available(53601)
		  and ni.spell.valid(tank, 53601, false, true, true) then
			 ni.spell.cast(53601, tank)
			 return true
			end
		end
			-- Heal MT with Lay on Hands --
		 if tank ~= nil
		 and ni.unit.hp(tank) < 12
		 and not forbtank
		 and ni.spell.available(48788)
		 and ni.spell.valid(tank, 48788, false, true, true) then
			ni.spell.cast(48788, tank)
			return true
		end
			-- Heal MT with Holy Light --
		 if tank ~= nil
		 and ni.unit.hp(tank) < 25
		 and ni.spell.available(20216)
		 and ni.spell.available(48825)
		 and ni.spell.valid(tank, 48825, false, true, true) then
			ni.spell.castspells("20216|48825", tank)
			return true
			end
		end
	end,
-----------------------------------
	["Valithria Heal"] = function()
		local tank = ni.tanks()
		local _, enabled = GetSetting("valithria")
		local mode = GetSetting("valithriamode")
		if not enabled then
			return
		end
		if ni.unit.exists("boss1") then
		 if ni.unit.id("boss1") == 36789
		  and ni.unit.hp("boss1") < 100 then
		 local BofLBoss, _, _, _, _, _, BofLBoss_time = ni.unit.buff("boss1", 53563, "player")
		 local SCBoss, _, _, _, _, _, SCBoss_time = ni.unit.buff("boss1", 53601, "player")
		 local SCtank, _, _, _, _, _, SCtank_time = ni.unit.buff(tank, 53601, "player")
		 local SelfSCtank = ni.unit.buff(tank, 53601)
		 local SelfSCBoss = ni.unit.buff("boss1", 53601)
		-- Put Beacon on Boss --
		if (not BofLBoss
		 or (BofLBoss and BofLBoss_time - GetTime() < 2))
		 and ni.spell.available(53563)
		 and ni.spell.valid("boss1", 53563, false, true, true) then
			ni.spell.cast(53563, "boss1")
			return true
		end
		-- Put Sacred on Boss --
		if (not SelfSCBoss
		 or (SCBoss and SCBoss_time - GetTime() < 2))
		 and ni.spell.available(53601)
		 and ni.spell.valid("boss1", 53601, false, true, true) then
			ni.spell.cast(53601, "boss1")
			return true
		end
		if SelfSCBoss
		 and ni.unit.exists(tank)
		 and (not SelfSCtank
		 or (SCtank and SCtank_time - GetTime() < 2))
		 and ni.spell.available(53601)
		 and ni.spell.valid(tank, 53601, false, true, true) then
			ni.spell.cast(53601, tank)
			return true
		end
		-- Heal Boss with Holy Light --
		if not ni.player.ismoving()
		 and (mode == 1 or ni.members[1].hp > GetSetting("valithriahp"))
		 and ni.spell.available(48782)
		 and not ni.player.ismoving()
		 and GetTime() - data.paladin.LastHoly > 6
		 and ni.spell.valid("boss1", 48782, false, true, true) then
			ni.spell.cast(48782, "boss1")
			data.paladin.LastHoly = GetTime()
			return true
		end
		-- Heal Boss with Flash of Light --
		if not ni.player.ismoving()
		 and (mode == 1 or ni.members[1].hp > GetSetting("valithriahp"))
		 and ni.spell.available(48785)
		 and not ni.player.ismoving()
		 and ni.unit.buffremaining("boss1", 66922, "player") < ni.spell.casttime(48785)
		 and ni.spell.valid("boss1", 48785, false, true, true) then
			ni.spell.cast(48785, "boss1")
			return true
		end
			end
		end
	end,
-----------------------------------
	["Holy Light"] = function()
		local member = GetHealCandidate(1)
		local value, enabled = GetSetting("light");
		if enabled
		 and not IsValithriaBossOnly()
		 and member
		 and ni.spell.available(48782)
		 and not ni.player.ismoving() then
		  if member.hp < value
		   and ni.spell.valid(member.unit, 48782, false, true, true) then
				ni.spell.cast(48782, member.unit)
				return true
			end
		end
	end,
-----------------------------------
	["Holy Light (Glyph)"] = function()
		local member = GetHealCandidate(1)
		local value, enabled = GetSetting("lightglyph");
		local friends = member and ni.members.inrangebelow(member.unit, 7, 85) or {}
		if enabled
		 and not IsValithriaBossOnly()
		 and member
		 and ni.player.hasglyph(54937)
		 and ni.spell.available(48782)
		 and ni.members.averageof(3) < 85
		 and not ni.player.ismoving() then
		  if member.hp < value
		   and #friends > 3
		   and ni.spell.valid(member.unit, 48782, false, true, true) then
				ni.spell.cast(48782, member.unit)
				return true
			end
		end
	end,
-----------------------------------
	["Holy Shock"] = function()
		local memberOne = GetHealCandidate(1)
		local memberTwo = GetHealCandidate(2)
		local value, enabled = GetSetting("shock");
		if enabled
		 and not IsValithriaBossOnly()
		 and memberOne
		 and ni.spell.available(48825) then
		-- Lowest member Tank but one member more need heal
		 if memberTwo
		  and memberOne.hp < value
		  and ni.unit.buff(memberOne.unit, 53563, "player")
		  and memberTwo.hp + 12.5 < value
		  and ni.spell.valid(memberTwo.unit, 48825, false, true, true) then
			ni.spell.cast(48825, memberTwo.unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		 if memberTwo
		  and memberOne.hp < value
		  and ni.unit.buff(memberOne.unit, 53563, "player")
		  and memberTwo.hp + 12.5 >= value
		  and ni.spell.valid(memberOne.unit, 48825, false, true, true) then
			ni.spell.cast(48825, memberOne.unit)
			return true
		end
		 -- Lowest member isn't Tank
		 if memberOne.hp < value
		  and not ni.unit.buff(memberOne.unit, 53563, "player")
		  and ni.spell.valid(memberOne.unit, 48825, false, true, true) then
			ni.spell.cast(48825, memberOne.unit)
			return true
			end
		end
	end,
-----------------------------------
	["Flash of Light"] = function()
		local memberOne = GetHealCandidate(1)
		local memberTwo = GetHealCandidate(2)
		local value, enabled = GetSetting("flash");
		if (enabled
		 and not IsValithriaBossOnly()
		 and memberOne
		 and ni.spell.available(48785)
		 and not ni.player.ismoving())
		 or (enabled
		 and memberOne
		 and not IsValithriaBossOnly()
		 and ni.unit.buff("player", 54149)) then
		-- Lowest member Tank but one member more need heal
		 if memberTwo
		  and memberOne.hp < value
		  and ni.unit.buff(memberOne.unit, 53563, "player")
		  and memberTwo.hp + 5 < value
		  and ni.spell.valid(memberTwo.unit, 48785, false, true, true) then
			ni.spell.cast(48785, memberTwo.unit)
			return true
		end
		 -- Lowest member Tank and nobody else
		if memberTwo
		  and memberOne.hp < value
		  and ni.unit.buff(memberOne.unit, 53563, "player")
		  and memberTwo.hp + 5 >= value
		  and ni.spell.valid(memberOne.unit, 48785, false, true, true) then
			ni.spell.cast(48785, memberOne.unit)
			return true
		end
		 -- Lowest member isn't Tank
		if memberOne.hp < value
		  and ni.spell.valid(memberOne.unit, 48785, false, true, true) then
			ni.spell.cast(48785, memberOne.unit)
			return true
			end
		end
	end,
-----------------------------------
	["Cleanse (Member)"] = function()
		local _, enabled = GetSetting("cleans")
		if enabled
		 and ni.spell.available(4987) then
		  for i = 1, #ni.members do
		  if not IsIgnoredUnit(ni.members[i].unit)
		  and AllowPetHealing(ni.members[i].unit)
		  and ni.unit.debufftype(ni.members[i].unit, "Magic|Disease|Poison")
		  and ni.healing.candispel(ni.members[i].unit)
		  and GetTime() - data.LastDispel > GetSetting("dispeldelay")
		  and ni.spell.valid(ni.members[i].unit, 4987, false, true, true) then
				ni.spell.cast(4987, ni.members[i].unit)
				data.LastDispel = GetTime()
				return true
				end
			end
		end
	end,
-----------------------------------
	["Hand of Freedom (Member)"] = function()
		local _, enabled = GetSetting("freedom")
		if enabled
		 and ni.spell.available(1044) then
		  for i = 1, #ni.members do
		   local ally = ni.members[i].unit
		    if not IsIgnoredUnit(ally)
		     and AllowPetHealing(ally)
		     and ni.unit.ismoving(ally)
		     and data.paladin.FreedomUse(ally)
		     and not data.paladin.HandActive(ally)
		     and ni.spell.valid(ally, 1044, false, true, true) then
					ni.spell.cast(1044, ally)
					return true
				end
                   end
		end
	end,
-----------------------------------
	["Turn Evil (Auto Use)"] = function()
		local _, enabled = GetSetting("turn")
		if enabled
		 and ni.unit.exists("target")
		 and ni.spell.available(10326)
		 and UnitCanAttack("player", "target") then
		 table.wipe(enemies);
		  enemies = ni.unit.enemiesinrange("player", 25)
		  local dontTurn = false
		  for i = 1, #enemies do
		   local tar = enemies[i].guid;
		   if (ni.unit.creaturetype(enemies[i].guid) == 3
		    or ni.unit.creaturetype(enemies[i].guid) == 6
		    or ni.unit.aura(enemies[i].guid, 49039))
		    and ni.unit.debuff(tar, 10326, "player") then
			dontTurn = true
			break
		end
        end
		if not dontTurn then
		 for i = 1, #enemies do
		 local tar = enemies[i].guid;
		  if (ni.unit.creaturetype(enemies[i].guid) == 3
		   or ni.unit.creaturetype(enemies[i].guid) == 6
		   or ni.unit.aura(enemies[i].guid, 49039))
		   and not ni.unit.isboss(tar)
		   and not ni.unit.debuffs(tar, "23920||35399||69056", "EXACT")
		   and not ni.unit.debuff(tar, 10326, "player")
		   and ni.spell.valid(enemies[i].guid, 10326, false, true, true)
		   and GetTime() - data.paladin.LastTurn > 1.5 then
				ni.spell.cast(10326, tar)
				data.paladin.LastTurn = GetTime()
                        return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Hammer of Wrath (Auto Target)"] = function()
		local _, enabled = GetSetting("masswrath")
		if enabled
		 and ni.player.power() > 60
		 and ni.spell.available(48806)
		 and UnitCanAttack("player", "target") then
		 table.wipe(enemies);
		  enemies = ni.unit.enemiesinrange("player", 29)
		  for i = 1, #enemies do
		   local executetar = enemies[i].guid;
		    if ni.unit.hp(executetar) < 20
			and ni.spell.valid(executetar, 48806, true, true) then
					ni.spell.cast(48806, executetar)
					return true
				end
			end
		end
	end,
-----------------------------------
	["Control (Member)"] = function()
		local _, enabled = GetSetting("control")
		if enabled
		 and ni.spell.available(10308) then
		  for i = 1, #ni.members do
		   local ally = ni.members[i].unit
		    if data.ControlMember(ally)
			and not data.UnderControlMember(ally)
			and ni.spell.valid(ally, 10308, false, true, true) then
				ni.spell.cast(10308, ally)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Holy Paladin by DarhangeR for 3.3.5a",
		 "Welcome to Holy Paladin Profile! Support and more in Discord: https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For enable priority healing Main Tank put tank name to Tank Overrides and press Enable Main")
		popup_shown = true;
		end
	end,
}

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
