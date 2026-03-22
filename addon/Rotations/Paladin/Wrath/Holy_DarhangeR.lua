local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local enemies = {};
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");

-- Icon helper: usa GetSpellInfo directamente para evitar dependencias de data.*Icon()
local function icon(spellID)
  return select(3, GetSpellInfo(spellID)) or ""
end

if build == 30300 and level == 80 and data then

local items = {
  settingsfile = "DarhangeR_HolyPaladin.xml",
  { type = "title", text = "Holy Paladin PvE" },
  { type = "title", text = "Core Files |cff00D700v2.0.7" },
  { type = "title", text = "|cffFF69B4Profile version 2.0.4" },
  { type = "separator" },

  -- =========================================================
  -- PAGE 0: MAIN SETTINGS
  -- =========================================================
  { type = "page", number = 0, text = "|cffFFFF00Main Settings" },
  { type = "separator" },
  { type = "title", text = "DPS Mode" },
  { type = "dropdown", menu = {
    { selected = true,  value = 0, text = "|T"..(select(3,GetSpellInfo(20473)) or "")..":20:20|t Auto" },
    { selected = false, value = 1, text = "|T"..(select(3,GetSpellInfo(48825)) or "")..":20:20|t Holy Shock" },
    { selected = false, value = 2, text = "|T"..(select(3,GetSpellInfo(48806)) or "")..":20:20|t Hammer of Wrath" },
  }, key = "dpsmode" },
  { type = "separator" },
  { type = "title", text = "Active Seals" },
  { type = "dropdown", menu = {
    { selected = true,  value = 0,     text = "Auto mode" },
    { selected = false, value = 20166, text = "|T"..(select(3,GetSpellInfo(20166)) or "")..":20:20|t Seal of Wisdom" },
    { selected = false, value = 20165, text = "|T"..(select(3,GetSpellInfo(20165)) or "")..":20:20|t Seal of Light" },
  }, key = "sealtype" },
  { type = "separator" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(32223)) or "")..":26:26|t Crusader Aura", tooltip = "Auto use auras.", enabled = true, key = "crusaderaura" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(5019)) or "")..":26:26|t Profile Pause", tooltip = "Custom profile pause throttle in seconds", enabled = true, value = 1.5, key = "profilepause" },
  { type = "entry", text = "|T"..""..":26:26|t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },

  -- =========================================================
  -- PAGE 1: ROTATION SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 1, text = "|cffEE4000Rotation Settings" },
  { type = "separator" },
  { type = "title", text = "Blessings Settings" },
  { type = "dropdown", menu = {
    { selected = false, value = 25898, text = "|T"..(select(3,GetSpellInfo(25898)) or "")..":20:20|t Greater Blessing of Kings" },
    { selected = false, value = 48934, text = "|T"..(select(3,GetSpellInfo(48934)) or "")..":20:20|t Greater Blessing of Might" },
    { selected = true,  value = 48938, text = "|T"..(select(3,GetSpellInfo(48938)) or "")..":20:20|t Greater Blessing of Wisdom" },
  }, key = "BlessingType" },
  { type = "entry", text = "Use in combat", tooltip = "Checking for a buff and using a spell in combat.", enabled = false, key = "blesscombat" },
  { type = "separator" },
  { type = "title", text = "Righteous Fury Settings" },
  -- FIX: cambiado de entry/checkbox a dropdown (igual que screenshots)
  { type = "dropdown", menu = {
    { selected = true,  value = "cancel", text = "Cancel Buff" },
    { selected = false, value = "keep",   text = "Keep Buff" },
  }, key = "rfmode" },
  { type = "separator" },
  { type = "title", text = "Active Judgement" },
  { type = "dropdown", menu = {
    { selected = true,  value = 20271, text = "|T"..(select(3,GetSpellInfo(20271)) or "")..":20:20|t Judgement of Light" },
    { selected = false, value = 53408, text = "|T"..(select(3,GetSpellInfo(53408)) or "")..":20:20|t Judgement of Wisdom" },
    { selected = false, value = 53407, text = "|T"..(select(3,GetSpellInfo(53407)) or "")..":20:20|t Judgement of Justice" },
  }, key = "JudgementType" },
  { type = "entry", text = "|T"..icon(48801)..":26:26|t Exorcism", tooltip = "Use spell when player mana > %", enabled = false, value = 75, key = "exorc" },
  { type = "entry", text = "|T"..icon(48806)..":26:26|t Hammer of Wrath", tooltip = "Auto check execute target and use it.", enabled = false, key = "masswrath" },
  { type = "entry", text = "|T"..icon(10326)..":26:26|t Turn Evil (Auto Use)", tooltip = "Auto check and use spell on proper enemies", enabled = false, key = "turn" },
  { type = "entry", text = "|T"..icon(20066)..":26:26|t Auto Control (Allys)", tooltip = "Checking for a buff and using a spell in combat.", enabled = true, key = "control" },

  -- =========================================================
  -- PAGE 2: TRINKETS SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 2, text = "|cff00BFFFTrinkets Settings" },
  { type = "separator" },
  { type = "title", text = "Using Trinkets increasing player stats" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48825)) or "")..":20:20|t |T"..(select(3,GetSpellInfo(48782)) or "")..":20:20|t Trinkets", tooltip = "Use stat trinkets on healing burst.", enabled = true, key = "trinkets" },
  { type = "entry", text = "Allys HP", tooltip = "Allies HP threshold for trinket usage", enabled = true, value = 55, key = "trinketsallyhp" },
  { type = "entry", text = "Allys Count", tooltip = "Allies count threshold for trinket usage", enabled = true, value = 3, key = "trinketsallycount" },
  { type = "separator" },
  { type = "title", text = "Using Other Trinkets" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(29166)) or "")..":26:26|t Mana Regeneration", tooltip = "Use mana trinkets when MP < %", enabled = true, value = 60, key = "manaregtrinket" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48788)) or "")..":26:26|t Health Regeneration", tooltip = "Use health trinkets when HP < %", enabled = true, value = 50, key = "healthregtrinket" },
  { type = "separator" },
  { type = "title", text = "Mass Healing" },
  { type = "entry", text = "Allys HP", tooltip = "Mass healing trinket HP threshold", enabled = true, value = 55, key = "masshealtrinkethp" },
  { type = "entry", text = "Allys Count", tooltip = "Mass healing trinket allies count", enabled = true, value = 3, key = "masshealtrinketcount" },
  { type = "separator" },
  { type = "title", text = "Using Engineering items" },
  { type = "entry", text = "Hands", tooltip = "Use engineering gloves on healing burst.", enabled = true, key = "enghands" },
  { type = "entry", text = "Allys HP", tooltip = "Engineering gloves HP threshold", enabled = true, value = 37, key = "enghandshp" },
  { type = "entry", text = "Allys Count", tooltip = "Engineering gloves allies count", enabled = true, value = 3, key = "enghandscount" },
  { type = "separator" },
  { type = "title", text = "Using the following Trinkets (if equipped) when MP < % character:" },
  { type = "title", text = "• Sliver of Pure Ice  • Meteorite Crystal  • Spirit-World Glass  • Figurine - Sapphire Owl" },
  { type = "separator" },
  { type = "title", text = "Custom Trinkets (ID/Spell/Unit)" },
  { type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = false, key = "trinketenabled" },
  { type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
  { type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
  { type = "input", value = "player", width = 80, height = 15, key = "trinket13unit" },
  { type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
  { type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
  { type = "input", value = "player", width = 80, height = 15, key = "trinket14unit" },

  -- =========================================================
  -- PAGE 3: CD'S AND IMPORTANT SPELLS #1
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 3, text = "|cff95f900CD's and important spells" },
  { type = "separator" },
  { type = "title", text = "Racial Abilities" },
  { type = "entry", text = "Use racial abilities", tooltip = "Enable racial spells/items", enabled = true, key = "racial" },
  { type = "entry", text = "|T"..icon(54428)..":26:26|t Divine Plea", tooltip = "Use spell when player mana < %", enabled = true, value = 60, key = "plea" },
  { type = "separator" },
  { type = "title", text = "Bursts" },
  -- FIX: dropdown de modo burst (igual que screenshots)
  { type = "dropdown", menu = {
    { selected = true,  value = 1, text = "Modifiers with checking" },
    { selected = false, value = 2, text = "Modifiers without checking allies" },
  }, key = "burstmode" },
  { type = "entry", text = "|T"..icon(20216)..":26:26|t Divine Favor", tooltip = "Use spell with burst conditions. During Divine Plea use to reduce healing penalty.", enabled = true, value = 40, key = "divinefavor" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(633)) or "")..":26:26|t Lay on Hands", tooltip = "Use spell when HP < %", enabled = true, value = 20, key = "layon" },
  -- FIX: dropdown en lugar de checkbox separado (igual que screenshots)
  { type = "dropdown", menu = {
    { selected = false, value = "self",   text = "Cast on Self only" },
    { selected = true,  value = "allies", text = "Cast on Ally + Self" },
  }, key = "layon_mode" },
  { type = "entry", text = "|T"..icon(31884)..":26:26|t Avenging Wrath", tooltip = "Use when Ally HP < %, Ally Count >= configured. During Divine Plea use to reduce healing penalty.", enabled = true, key = "aven" },
  -- FIX: Avenging Wrath ahora tiene HP y Count configurables (igual que screenshots)
  { type = "entry", text = "Allys HP",    tooltip = "Ally HP threshold for Avenging Wrath", enabled = true, value = 30, key = "avenhp" },
  { type = "entry", text = "Allys Count", tooltip = "Number of allies below threshold", enabled = true, value = 4,  key = "avencount" },
  { type = "entry", text = "|T"..icon(31842)..":26:26|t Divine Illumination", tooltip = "Use when Ally HP < %, Ally Count >= configured. During Divine Plea (2T10) use to reduce healing penalty.", enabled = true, value = 35, key = "illumination" },
  -- FIX: Divine Illumination también tiene HP y Count configurables (igual que screenshots)
  { type = "entry", text = "Allys HP",    tooltip = "Ally HP threshold for Divine Illumination", enabled = true, value = 30, key = "illumhp" },
  { type = "entry", text = "Allys Count", tooltip = "Number of allies below threshold", enabled = true, value = 4,  key = "illumcount" },

  -- =========================================================
  -- PAGE 4: CD'S AND IMPORTANT SPELLS #2
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 4, text = "|cff95f900CD's and important spells #2" },
  { type = "separator" },
  { type = "entry", text = "|T"..icon(1038)..":26:26|t Hand of Salvation (Allys)", tooltip = "Auto check ally agro and use spell. Spell ignoring Tanks.", enabled = true, key = "salva" },
  -- FIX: input de nombre + dropdown de modo (igual que screenshots)
  { type = "input", value = "", width = 120, height = 15, key = "salvaname" },
  { type = "dropdown", menu = {
    { selected = true,  value = 1, text = "Automatic" },
    { selected = false, value = 2, text = "By Ally name" },
    { selected = false, value = 3, text = "Manual mode" },
  }, key = "salvamode" },
  { type = "entry", text = "|T"..icon(6940)..":26:26|t Hand of Sacrifice (Allys)", tooltip = "Use spell when ally HP < %", enabled = true, value = 25, key = "handsacrifice" },
  { type = "entry", text = "|T"..icon(10278)..":26:26|t Hand of Protection (Allys)", tooltip = "Spell ignoring Tanks.", enabled = true, value = 25, key = "handofprot" },
  { type = "entry", text = "|T"..icon(31821)..":26:26|t Aura Mastery", tooltip = "Enable spell", enabled = true, key = "auramastery" },
  { type = "entry", text = "Allys HP",    tooltip = "Use spell when member HP < %", enabled = true, value = 30, key = "auramasteryhp" },
  { type = "entry", text = "Allys Count", tooltip = "Use spell when ally count have low HP", enabled = true, value = 4,  key = "auramasterycount" },
  { type = "separator" },
  { type = "title", text = "Dispel" },
  { type = "entry", text = "Delay for dispeling", tooltip = "Delay between dispels", enabled = true, value = 1.5, key = "dispeldelay" },
  { type = "entry", text = "|T"..icon(4987)..":26:26|t Cleanse (Allys)", tooltip = "Auto dispel debuffs from allies", enabled = true, key = "cleans" },
  { type = "entry", text = "|T"..icon(1044)..":26:26|t Hand of Freedom (Allys)", tooltip = "Auto cast on ally with roots/slows", enabled = true, key = "freedom" },
  { type = "dropdown", menu = {
    { selected = true,  value = 1, text = "Settings: Automatic" },
    { selected = false, value = 2, text = "Settings: By Ally name" },
    { selected = false, value = 3, text = "Settings: Manual mode" },
  }, key = "supportmode" },

  -- =========================================================
  -- PAGE 5: HEALING ENGINE SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 5, text = "|cff95f900Healing Engine Settings" },
  { type = "separator" },
  { type = "title", text = "Ignore Ally" },
  { type = "input", value = "", width = 120, height = 15, key = "ignoreally1" },
  { type = "title", text = "Ignore Ally #2" },
  { type = "input", value = "", width = 120, height = 15, key = "ignoreally2" },
  { type = "title", text = "Ignore Ally #3" },
  { type = "input", value = "", width = 120, height = 15, key = "ignoreally3" },
  { type = "separator" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48819)) or "")..":26:26|t Burst-Healing", tooltip = "Prefer faster spell in burst windows.", enabled = false, key = "burstflash" },
  -- FIX: dropdown de spell para Burst-Healing (igual que screenshots)
  { type = "dropdown", menu = {
    { selected = true,  value = 48785, text = "|T"..(select(3,GetSpellInfo(48785)) or "")..":20:20|t Flash of Light" },
    { selected = false, value = 48782, text = "|T"..(select(3,GetSpellInfo(48782)) or "")..":20:20|t Holy Light" },
  }, key = "burstspell" },
  { type = "separator" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(1) or "") or "")..":26:26|t Pets Healing", tooltip = "Allow healing pets.", enabled = false, key = "pethealing" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48819)) or "")..":26:26|t Overhealing", tooltip = "Enable to overheal bad effects on allies or disperse HPS under certain items.\nExamples: Frost Blast, Incinerate Flesh, Penetrating Cold, Mark of the Fallen Champion, Volatile Ooze Adhesive, Gaseous Bloat, Frost Beacon, Infest, Harvest Soul, Soul Reaper.\nItems: Scarab Brooch, Glowing Twilight Scale, Val'anyr.", enabled = true, key = "overhealing" },

  -- =========================================================
  -- PAGE 6: PARTY/RAID HEALING SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 6, text = "|cff95f900Party/Raid Healing Settings" },
  { type = "separator" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48782)) or "")..":26:26|t Non Combat Healing", tooltip = "Heal ally if you or them not in combat, ally HP < %. If not moving use Flash of Light.", enabled = true, value = 95, key = "noncombatheal" },
  { type = "entry", text = "|T"..icon(48825)..":26:26|t Holy Shock", tooltip = "Use spell when member HP < %", enabled = true, value = 86, key = "shock" },
  { type = "entry", text = "|T"..icon(48785)..":26:26|t Flash of Light", tooltip = "Use spell when member HP < %", enabled = true, value = 84, key = "flash" },
  { type = "entry", text = "|T"..icon(48782)..":26:26|t Holy Light", tooltip = "Use spell when member HP < %", enabled = true, value = 60, key = "light" },
  { type = "entry", text = "|T"..icon(48782)..":26:26|t Holy Light (Glyph)", tooltip = "Use spell when you have glyph and member HP < %", enabled = true, value = 68, key = "lightglyph" },
  { type = "entry", text = "Allys HP",    tooltip = "Mass healing HP threshold", enabled = true, value = 85, key = "healallyhp" },
  { type = "entry", text = "Allys Count", tooltip = "Mass healing ally count",   enabled = true, value = 2,  key = "healallycount" },

  -- =========================================================
  -- PAGE 7: TANK SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 7, text = "|cff95f900Tank Settings" },
  { type = "separator" },
  { type = "entry", text = "Auto Track Tank", tooltip = "Auto Track Tank and mainly heal him. Paladin support only ONE MAIN TANK. If you wanna heal OTHER TANK, use software settings.", enabled = true, key = "healtank" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(53563)) or "")..":26:26|t Beacon of Light", tooltip = "Maintain Beacon of Light on main tank", enabled = true, key = "beacon" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(53601)) or "")..":26:26|t Sacred Shield", tooltip = "Maintain Sacred Shield on all tanks (skips Paladin tanks — they self-buff)", enabled = true, key = "sacred" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(53563)) or "")..":26:26|t Beacon of Light (Focus)", tooltip = "Allow beacon on focus target", enabled = false, key = "beaconfocus" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(53601)) or "")..":26:26|t Sacred Shield (Focus)", tooltip = "Allow sacred shield on focus target", enabled = false, key = "sacredfocus" },
  { type = "entry", text = "|T"..icon(48785)..":26:26|t Flash of Light (HoT)", tooltip = "Keep Flash of Light HoT on beacon/focus", enabled = true, key = "flashhot" },
  { type = "entry", text = "Patchwerk Mode", tooltip = "High throughput single-tank healing mode", enabled = false, key = "patchwerk" },

  -- =========================================================
  -- PAGE 8: VALITHRIA HEALING SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 8, text = "|cff95f900Valithria Healing Settings" },
  { type = "separator" },
  { type = "entry", text = "Enable Healing", tooltip = "Enable Valithria healing in ICC.", enabled = false, key = "valithria" },
  { type = "entry", text = "|T"..(select(3,GetSpellInfo(48825)) or "")..":26:26|t Allys HP %", tooltip = "Valithria/Raid HP threshold", enabled = true, value = 80, key = "valithriahp" },
  { type = "title", text = "Healing Mode Settings" },
  { type = "dropdown", menu = {
    { selected = true,  value = 1, text = "Heal Boss Only" },
    { selected = false, value = 2, text = "Heal Boss and Raid" },
  }, key = "valithriamode" },

  -- =========================================================
  -- PAGE 9: DEFENSIVE SETTINGS
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 9, text = "|cff00C957Defensive Settings" },
  { type = "separator" },
  { type = "entry", text = "|T"..icon(642)..":26:26|t Divine Shield", tooltip = "Use spell when player HP < %", enabled = true, value = 22, key = "divineshield" },
  { type = "entry", text = "|T"..icon(36894)..":26:26|t Healthstone", tooltip = "Use Warlock Healthstone when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
  { type = "entry", text = "Healthstone (Pick-up)", tooltip = "Auto pick-up Healthstones when possible", enabled = false, key = "healthstonepickup" },
  { type = "entry", text = "|T"..icon(43185)..":26:26|t Heal Potion", tooltip = "Use Heal Potions when player HP < %", enabled = false, value = 30, key = "healpotionuse" },
  { type = "entry", text = "|T"..icon(43186)..":26:26|t Mana Potion", tooltip = "Use Mana Potions when player mana < %", enabled = false, value = 25, key = "manapotionuse" },

  -- =========================================================
  -- PAGE 10: EXPERT SETTINGS
  -- FIX: input fields con confirm buttons (igual que screenshots)
  -- =========================================================
  { type = "separator" },
  { type = "page", number = 10, text = "|cffFFD700Expert Settings" },
  { type = "separator" },
  { type = "title", text = "Change macro #1" },
  { type = "input", value = "rebuff",  width = 120, height = 15, key = "macro1" },
  { type = "title", text = "Change macro #2" },
  { type = "input", value = "burst",   width = 120, height = 15, key = "macro2" },
  { type = "title", text = "Change macro #3" },
  { type = "input", value = "cleanse", width = 120, height = 15, key = "macro3" },
};

-- =========================================================
-- GetSetting helper
-- =========================================================
local function GetSetting(name)
  for k, v in ipairs(items) do
    if v.type == "entry" and v.key ~= nil and v.key == name then
      return v.value, v.enabled
    end
    if v.type == "dropdown" and v.key ~= nil and v.key == name then
      for _, v2 in pairs(v.menu) do
        if v2.selected then return v2.value end
      end
    end
    if v.type == "input" and v.key ~= nil and v.key == name then
      return v.value
    end
  end
end

local function OnLoad()
  ni.GUI.AddFrame("Holy_DarhangeR", items);
end
local function OnUnLoad()
  ni.GUI.DestroyFrame("Holy_DarhangeR");
end

-- =========================================================
-- QUEUE
-- =========================================================
local queue = {
  "Universal pause",
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
  "Use engineer gloves",
  "Racial Stuff",
  "Divine Shield",
  "Cleanse (Member)",
  "Judgement (Selected Type)",
  "Exorcism",
  "Aura Mastery",
  "Hand of Sacrifice (Member)",
  "Hand of Salvation (Member)",
  "Hand of Protection (Member)",
  "Avenging Wrath",
  "Divine Illumination T10",
  "Divine Illumination",
  "Lay on Hands",
  "Sacred Shield (Tanks)",   -- FIX: nueva ability para todos los tanks
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

-- =========================================================
-- ABILITIES
-- =========================================================
local abilities = {

  ["Universal pause"] = function()
    if (data.UniPause() or data.PlayerDebuffs("player")) then
      return true
    end
    ni.vars.debug = select(2, GetSetting("Debug"));
  end,

  ["Auto Track Undeads"] = function()
    if ni.player.hasglyph(57947) then
      if not UnitAffectingCombat("player") and GetTime() - data.paladin.LastTrack > 8 then
        SetTracking(nil);
      end
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

  ["Seal of Wisdom/Light"] = function()
    local sealChoice = GetSetting("sealtype")
    -- Si el usuario eligió un seal específico, usarlo
    if sealChoice and sealChoice ~= 0 then
      if ni.spell.available(sealChoice) and not ni.player.buff(sealChoice) then
        ni.spell.cast(sealChoice)
        return true
      end
      return
    end
    -- Auto mode: priorizar por glyph, fallback a Wisdom
    if ni.spell.available(20166) and ni.player.hasglyph(54940) and not ni.player.buff(20166) then
      ni.spell.cast(20166)
      return true
    end
    if ni.spell.available(20165) and ni.player.hasglyph(54943) and not ni.player.buff(20165) then
      ni.spell.cast(20165)
      return true
    end
    if not ni.player.hasglyph(54943) and not ni.player.hasglyph(54940) and not ni.player.buff(20166) then
      ni.spell.cast(20166)
      return true
    end
  end,

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

  -- FIX: Blessings ahora buffea a todos los miembros del grupo, no solo a sí mismo
  ["Blessings (Raid/Dungeon)"] = function()
    local blessing = GetSetting("BlessingType")
    local _, combatEnabled = GetSetting("blesscombat")
    if not blessing then return end
    if (not UnitAffectingCombat("player") or combatEnabled)
      and IsSpellKnown(blessing)
      and ni.spell.available(blessing) then
      -- Self
      if not ni.player.buff(blessing) then
        ni.spell.cast(blessing, "player")
        return true
      end
      -- Group members
      for i = 1, #ni.members do
        local member = ni.members[i].unit
        if ni.spell.valid(member, blessing, false, true, true)
          and not ni.unit.buff(member, blessing) then
          ni.spell.cast(blessing, member)
          return true
        end
      end
    end
  end,

  -- FIX: usa rfmode dropdown en lugar del antiguo checkbox
  ["Cancel Righteous Fury"] = function()
    local rfMode = GetSetting("rfmode")
    if rfMode ~= "cancel" then return end
    local p = "player"
    for i = 1, 40 do
      local _, _, _, _, _, _, _, u, _, _, s = UnitBuff(p, i)
      if u == p and s == 25780 then
        CancelUnitBuff(p, i)
        break
      end
    end
  end,

  ["Divine Plea"] = function()
    local value, enabled = GetSetting("plea")
    if enabled
      and ni.player.power() < value
      and not ni.player.buff(54428)
      and ni.spell.available(54428) then
      ni.spell.cast(54428)
      return true
    end
  end,

  ["Non Combat Healing"] = function()
    local value, enabled = GetSetting("noncombatheal")
    if enabled
      and not UnitAffectingCombat("player")
      and ni.spell.available(48785) then
      if ni.members[1].hp < value
        and not ni.player.ismoving()
        and ni.spell.valid(ni.members[1].unit, 48785, false, true, true) then
        ni.spell.cast(48785, ni.members[1].unit)
        return true
      end
    end
  end,

  ["Combat specific Pause"] = function()
    local pauseDelay, enabled = GetSetting("profilepause")
    if enabled and pauseDelay and pauseDelay > 0 and not data.CombatStart(pauseDelay) then
      return true
    end
    if UnitAffectingCombat("player") then return false end
    for i = 1, #ni.members do
      if UnitAffectingCombat(ni.members[i].unit) then return false end
    end
    return true
  end,

  ["Healthstone (Use)"] = function()
    local value, enabled = GetSetting("healthstoneuse")
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

  ["Heal Potions (Use)"] = function()
    local value, enabled = GetSetting("healpotionuse")
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

  ["Mana Potions (Use)"] = function()
    local value, enabled = GetSetting("manapotionuse")
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

  ["Trinkets (Config)"] = function()
    if data.UseConfiguredTrinkets(GetSetting, nil, "player") then
      return true
    end
  end,

  ["Use engineer gloves"] = function()
    local _, enabled = GetSetting("enghands")
    local hpThreshold = GetSetting("enghandshp")
    local countThreshold = GetSetting("enghandscount")
    if enabled
      and ni.player.slotcastable(10)
      and ni.player.slotcd(10) == 0
      and UnitAffectingCombat("player")
      and ni.members.averageof(countThreshold) < hpThreshold then
      ni.player.useinventoryitem(10)
      return true
    end
  end,

  ["Racial Stuff"] = function()
    local _, enabled = GetSetting("racial")
    if not enabled then return end
    local hracial = { 33697, 20572, 33702, 26297 }
    local bloodelf = { 25046, 28730, 50613 }
    local alracial = { 20594, 28880 }
    if data.forsaken("player") and IsSpellKnown(7744) and ni.spell.available(7744) then
      ni.spell.cast(7744)
      return true
    end
    for i = 1, #hracial do
      if ni.members.averageof(7) < 40
        and IsSpellKnown(hracial[i])
        and ni.spell.available(hracial[i])
        and ni.spell.valid("target", 20271) then
        ni.spell.cast(hracial[i])
        return true
      end
    end
    for i = 1, #bloodelf do
      if ni.player.power() < 70
        and IsSpellKnown(bloodelf[i])
        and ni.spell.available(bloodelf[i])
        and ni.spell.valid("target", 20271) then
        ni.spell.cast(bloodelf[i])
        return true
      end
    end
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

  ["Divine Shield"] = function()
    local value, enabled = GetSetting("divineshield")
    local forb = data.paladin.forb()
    if enabled
      and ni.player.hp() < value
      and not forb
      and ni.spell.available(642) then
      ni.spell.cast(642)
      return true
    end
  end,

  ["Cleanse (Member)"] = function()
    local _, enabled = GetSetting("cleans")
    local supportMode = GetSetting("supportmode")
    if not enabled or supportMode == 3 then return end
    if ni.spell.available(4987) then
      for i = 1, #ni.members do
        if ni.unit.debufftype(ni.members[i].unit, "Magic|Disease|Poison")
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

  ["Exorcism"] = function()
    local value, enabled = GetSetting("exorc")
    if enabled
      and ni.members[1].hp > 75
      and ni.player.power() > value
      and ni.spell.available(48801)
      and not ni.player.ismoving()
      and ni.spell.valid("target", 48801, true, true) then
      ni.spell.cast(48801, "target")
      return true
    end
  end,

  ["Aura Mastery"] = function()
    local _, enabled = GetSetting("auramastery")
    local valueHp = GetSetting("auramasteryhp")
    local valueCount = GetSetting("auramasterycount")
    if enabled
      and ni.members.averageof(valueCount) < valueHp
      and ni.spell.available(31821) then
      ni.spell.cast(31821)
      return true
    end
  end,

  ["Hand of Sacrifice (Member)"] = function()
    local value, enabled = GetSetting("handsacrifice")
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

  -- FIX: Hand of Salvation respeta salvamode y salvaname
  ["Hand of Salvation (Member)"] = function()
    local _, enabled = GetSetting("salva")
    local salvaMode = GetSetting("salvamode")
    local salvaName = GetSetting("salvaname")
    if not enabled or not ni.spell.available(1038) or not data.CombatStart(10) then return end
    if salvaMode == 3 then return end -- Manual mode

    -- Modo "By Ally name": castear en el aliado específico si tiene mucho threat
    if salvaMode == 2 and salvaName and salvaName ~= "" then
      if not data.paladin.HandActive(salvaName)
        and ni.unit.threat(salvaName) >= 2
        and not ni.unit.istank(salvaName)
        and ni.spell.valid(salvaName, 1038, false, true, true) then
        ni.spell.cast(1038, salvaName)
        return true
      end
      return
    end

    -- Modo automático: miembro con más threat que no sea tank
    if #ni.members > 1
      and ni.members[1].threat >= 2
      and not ni.members[1].istank
      and not data.paladin.HandActive(ni.members[1].unit)
      and ni.spell.valid(ni.members[1].unit, 1038, false, true, true) then
      ni.spell.cast(1038, ni.members[1].unit)
      return true
    end
  end,

  ["Hand of Protection (Member)"] = function()
    local value, enabled = GetSetting("handofprot")
    if enabled
      and #ni.members > 1
      and ni.spell.available(10278) then
      if ni.members[1].range
        and ni.members[1].hp < value
        and not ni.members[1].istank
        and ni.members[1].threat >= 2
        and ni.members[1].class ~= "DEATHKNIGHT"
        and not (ni.members[1].class == "DRUID" and ni.unit.buff(ni.members[1].unit, 768))
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

  -- FIX: Avenging Wrath ahora usa avenhp y avencount configurables
  ["Avenging Wrath"] = function()
    local _, enabled = GetSetting("aven")
    local avenhp    = GetSetting("avenhp")
    local avencount = GetSetting("avencount")
    local burstMode = GetSetting("burstmode")
    if not enabled or not ni.spell.available(31884) then return end

    -- Durante Divine Plea: usar para reducir penalización de healing
    local _, awduringplea = GetSetting("pleaburstaw")
    if awduringplea and ni.player.buff(54428) then
      ni.spell.cast(31884)
      return true
    end

    -- Modo "with checking": verificar HP de aliados
    if burstMode == 1 then
      if ni.members.averageof(avencount) < avenhp then
        ni.spell.cast(31884)
        return true
      end
    else
      -- Sin verificación: usar en cooldown en combate
      if UnitAffectingCombat("player") then
        ni.spell.cast(31884)
        return true
      end
    end
  end,

  -- Divine Illumination T10 (2 piezas del set T10)
  ["Divine Illumination T10"] = function()
    local _, pleaburst = GetSetting("pleaburstillum")
    if not pleaburst then return end
    if data.checkforSet(data.paladin.itemsetT10, 2) then
      if ni.player.buff(54428)
        and not ni.player.buff(31842)
        and ni.spell.available(31842) then
        ni.spell.cast(31842)
        return true
      end
    end
  end,

  -- FIX: Divine Illumination ahora usa illumhp/illumcount configurables
  ["Divine Illumination"] = function()
    local value, enabled = GetSetting("illumination")
    local illumhp    = GetSetting("illumhp")
    local illumcount = GetSetting("illumcount")
    local burstMode  = GetSetting("burstmode")
    if not enabled or not ni.spell.available(31842) or ni.player.buff(31842) then return end

    -- Durante Divine Plea: usar para reducir penalización de healing (2T10)
    if ni.player.buff(54428) then
      -- Ya manejado en Divine Illumination T10
      return
    end

    -- Verificar mana bajo (uso normal)
    if ni.player.power() < value and not ni.player.buff(54428) and not ni.spell.available(54428) then
      ni.spell.cast(31842)
      return true
    end

    -- Modo burst con chequeo de aliados
    if burstMode == 1 then
      if ni.members.averageof(illumcount) < illumhp then
        ni.spell.cast(31842)
        return true
      end
    elseif burstMode == 2 and UnitAffectingCombat("player") then
      ni.spell.cast(31842)
      return true
    end
  end,

  -- FIX: Lay on Hands usa layon_mode dropdown
  ["Lay on Hands"] = function()
    local value, enabled = GetSetting("layon")
    local layonMode = GetSetting("layon_mode")
    local forb = data.paladin.forb()
    if not enabled or forb or not ni.spell.available(48788) then return end

    -- Self
    if ni.player.hp() < value then
      ni.spell.cast(48788, "player")
      return true
    end

    -- Allies
    if layonMode == "allies" and #ni.members > 1 then
      for i = 1, #ni.members do
        if ni.members[i].hp < value
          and ni.spell.valid(ni.members[i].unit, 48788, false, true, true) then
          ni.spell.cast(48788, ni.members[i].unit)
          return true
        end
      end
    end
  end,

  -- =========================================================
  -- NUEVO: Sacred Shield (Tanks)
  -- Pone Sacred Shield en TODOS los tanks del grupo/raid
  -- EXCEPTO Paladines (ellos se lo ponen a sí mismos)
  -- También respeta Focus y el main tank
  -- =========================================================
  ["Sacred Shield (Tanks)"] = function()
    local _, enabled = GetSetting("sacred")
    if not enabled or not ni.spell.available(53601) then return end

    -- Focus target
    local _, focusEnabled = GetSetting("sacredfocus")
    if focusEnabled and UnitExists("focus") and UnitIsPlayer("focus") then
      local scFocus = ni.unit.buff("focus", 53601, "player")
      if not scFocus and ni.spell.valid("focus", 53601, false, true, true) then
        ni.spell.cast(53601, "focus")
        return true
      end
    end

    -- Iterar todos los miembros del grupo buscando tanks
    for i = 1, #ni.members do
      local member = ni.members[i]
      if member.istank
        and member.class ~= "PALADIN"          -- FIX: Paladines se buffean a sí mismos
        and not ni.unit.buff(member.unit, 53601)  -- Sin Sacred Shield activo
        and ni.spell.valid(member.unit, 53601, false, true, true) then
        ni.spell.cast(53601, member.unit)
        return true
      end
    end
  end,

  -- Tank Heal: Beacon + Holy Light combo en main tank, Sacred Shield manejado en ability separada
  ["Tank Heal"] = function()
    local tank = ni.tanks()
    local _, enabled = GetSetting("healtank")
    if not enabled or not ni.unit.exists(tank) then return end

    local BofLtank, _, _, _, _, _, BofLtank_time = ni.unit.buff(tank, 53563, "player")
    local forbtank = ni.unit.debuff(tank, 25771)
    local _, beaconEnabled = GetSetting("beacon")

    -- Beacon of Light en main tank (no durante boss activo para evitar movimiento)
    if beaconEnabled and not ni.unit.exists("boss1") then
      if (not BofLtank or (BofLtank and BofLtank_time - GetTime() < 2))
        and ni.spell.available(53563)
        and ni.spell.valid(tank, 53563, false, true, true) then
        ni.spell.cast(53563, tank)
        return true
      end
    end

    -- Focus: Beacon en focus target
    local _, beaconFocus = GetSetting("beaconfocus")
    if beaconFocus and UnitExists("focus") and UnitIsPlayer("focus") then
      local BofLFocus, _, _, _, _, _, BofLFocus_time = ni.unit.buff("focus", 53563, "player")
      if (not BofLFocus or (BofLFocus and BofLFocus_time - GetTime() < 2))
        and ni.spell.available(53563)
        and ni.spell.valid("focus", 53563, false, true, true) then
        ni.spell.cast(53563, "focus")
        return true
      end
    end

    -- Lay on Hands de emergencia en main tank
    if tank ~= nil
      and ni.unit.hp(tank) < 12
      and not forbtank
      and ni.spell.available(48788)
      and ni.spell.valid(tank, 48788, false, true, true) then
      ni.spell.cast(48788, tank)
      return true
    end

    -- Holy Light + Holy Shock combo en main tank crítico
    if tank ~= nil
      and ni.unit.hp(tank) < 25
      and ni.spell.available(20216)
      and ni.spell.available(48825)
      and ni.spell.valid(tank, 48825, false, true, true) then
      ni.spell.castspells("20216|48825", tank)
      return true
    end
  end,

  -- FIX: Valithria ahora verifica GetSetting("valithria") enabled
  ["Valithria Heal"] = function()
    local _, enabled = GetSetting("valithria")
    if not enabled then return end

    if ni.unit.exists("boss1")
      and ni.unit.id("boss1") == 36789
      and ni.unit.hp("boss1") < 100 then

      local tank = ni.tanks()
      local valMode = GetSetting("valithriamode")
      local valHP   = GetSetting("valithriahp")

      local BofLBoss, _, _, _, _, _, BofLBoss_time = ni.unit.buff("boss1", 53563, "player")
      local SCBoss_buf, _, _, _, _, _, SCBoss_time  = ni.unit.buff("boss1", 53601, "player")
      local SelfSCBoss = ni.unit.buff("boss1", 53601)

      -- Beacon en Valithria
      if (not BofLBoss or (BofLBoss and BofLBoss_time - GetTime() < 2))
        and ni.spell.available(53563)
        and ni.spell.valid("boss1", 53563, false, true, true) then
        ni.spell.cast(53563, "boss1")
        return true
      end

      -- Sacred Shield en Valithria
      if not SelfSCBoss
        and ni.spell.available(53601)
        and ni.spell.valid("boss1", 53601, false, true, true) then
        ni.spell.cast(53601, "boss1")
        return true
      end

      -- Si ya tiene SC y el tank no lo tiene, ponerlo en el tank (Modo "Heal Boss and Raid")
      if valMode == 2 and SelfSCBoss and ni.unit.exists(tank) then
        local SelfSCtank = ni.unit.buff(tank, 53601)
        local SCtank, _, _, _, _, _, SCtank_time = ni.unit.buff(tank, 53601, "player")
        if not SelfSCtank
          and ni.spell.available(53601)
          and ni.spell.valid(tank, 53601, false, true, true) then
          ni.spell.cast(53601, tank)
          return true
        end
      end

      -- Curar Valithria con Holy Light
      if not ni.player.ismoving()
        and ni.members[1].hp > valHP
        and ni.spell.available(48782)
        and GetTime() - data.paladin.LastHoly > 6
        and ni.spell.valid("boss1", 48782, false, true, true) then
        ni.spell.cast(48782, "boss1")
        data.paladin.LastHoly = GetTime()
        return true
      end

      -- Curar Valithria con Flash of Light (para mantener HoT activo)
      if not ni.player.ismoving()
        and ni.members[1].hp > valHP
        and ni.spell.available(48785)
        and ni.unit.buffremaining("boss1", 66922, "player") < ni.spell.casttime(48785)
        and ni.spell.valid("boss1", 48785, false, true, true) then
        ni.spell.cast(48785, "boss1")
        return true
      end
    end
  end,

  ["Holy Light"] = function()
    local value, enabled = GetSetting("light")
    if enabled
      and ni.spell.available(48782)
      and not ni.player.ismoving() then
      if ni.members[1].hp < value
        and ni.spell.valid(ni.members[1].unit, 48782, false, true, true) then
        ni.spell.cast(48782, ni.members[1].unit)
        return true
      end
    end
  end,

  ["Holy Light (Glyph)"] = function()
    local value, enabled = GetSetting("lightglyph")
    local friends = ni.members.inrangebelow(ni.members[1].unit, 7, 85)
    if enabled
      and ni.player.hasglyph(54937)
      and ni.spell.available(48782)
      and ni.members.averageof(3) < 85
      and not ni.player.ismoving() then
      if ni.members[1].hp < value
        and #friends > 3
        and ni.spell.valid(ni.members[1].unit, 48782, false, true, true) then
        ni.spell.cast(48782, ni.members[1].unit)
        return true
      end
    end
  end,

  ["Holy Shock"] = function()
    local value, enabled = GetSetting("shock")
    if enabled and ni.spell.available(48825) then
      if ni.members[1].hp < value
        and ni.unit.buff(ni.members[1].unit, 53563, "player")
        and ni.members[2].hp + 12.5 < value
        and ni.spell.valid(ni.members[2].unit, 48825, false, true, true) then
        ni.spell.cast(48825, ni.members[2].unit)
        return true
      end
      if ni.members[1].hp < value
        and ni.unit.buff(ni.members[1].unit, 53563, "player")
        and ni.members[2].hp + 12.5 >= value
        and ni.spell.valid(ni.members[1].unit, 48825, false, true, true) then
        ni.spell.cast(48825, ni.members[1].unit)
        return true
      end
      if ni.members[1].hp < value
        and not ni.unit.buff(ni.members[1].unit, 53563, "player")
        and ni.spell.valid(ni.members[1].unit, 48825, false, true, true) then
        ni.spell.cast(48825, ni.members[1].unit)
        return true
      end
    end
  end,

  -- FIX: operador de precedencia corregido — el `or` para Infusion of Light ahora está
  -- dentro del check de condición en lugar de cortocircuitar todo el bloque
  ["Flash of Light"] = function()
    local value, enabled = GetSetting("flash")
    local infusion = ni.unit.buff("player", 54149)  -- Infusion of Light proc (instant cast)
    if enabled
      and ni.spell.available(48785)
      and (not ni.player.ismoving() or infusion) then  -- FIX: paréntesis correctos
      -- Lowest member es tank pero hay otro que también necesita cura
      if ni.members[1].hp < value
        and ni.unit.buff(ni.members[1].unit, 53563, "player")
        and ni.members[2].hp + 5 < value
        and ni.spell.valid(ni.members[2].unit, 48785, false, true, true) then
        ni.spell.cast(48785, ni.members[2].unit)
        return true
      end
      -- Lowest member es tank y nadie más necesita cura
      if ni.members[1].hp < value
        and ni.unit.buff(ni.members[1].unit, 53563, "player")
        and ni.members[2].hp + 5 >= value
        and ni.spell.valid(ni.members[1].unit, 48785, false, true, true) then
        ni.spell.cast(48785, ni.members[1].unit)
        return true
      end
      -- Lowest member no es tank
      if ni.members[1].hp < value
        and ni.spell.valid(ni.members[1].unit, 48785, false, true, true) then
        ni.spell.cast(48785, ni.members[1].unit)
        return true
      end
    end
  end,

  ["Hand of Freedom (Member)"] = function()
    local _, enabled = GetSetting("freedom")
    local supportMode = GetSetting("supportmode")
    if not enabled or supportMode == 3 then return end
    if ni.spell.available(1044) then
      for i = 1, #ni.members do
        local ally = ni.members[i].unit
        if ni.unit.ismoving(ally)
          and data.paladin.FreedomUse(ally)
          and not data.paladin.HandActive(ally)
          and ni.spell.valid(ally, 1044, false, true, true) then
          ni.spell.cast(1044, ally)
          return true
        end
      end
    end
  end,

  -- FIX: Turn Evil - evaluación por unidad individual, sin flag global
  ["Turn Evil (Auto Use)"] = function()
    local _, enabled = GetSetting("turn")
    if enabled
      and ni.unit.exists("target")
      and ni.spell.available(10326)
      and UnitCanAttack("player", "target") then
      table.wipe(enemies)
      enemies = ni.unit.enemiesinrange("player", 25)
      for i = 1, #enemies do
        local tar = enemies[i].guid
        local isUndead = ni.unit.creaturetype(tar) == 3
        local isDemon  = ni.unit.creaturetype(tar) == 6
        if (isUndead or isDemon or ni.unit.aura(tar, 49039))
          and not ni.unit.isboss(tar)
          and not ni.unit.debuffs(tar, "23920||35399||69056", "EXACT")
          and not ni.unit.debuff(tar, 10326, "player")
          and ni.spell.valid(tar, 10326, false, true, true)
          and GetTime() - data.paladin.LastTurn > 1.5 then
          ni.spell.cast(10326, tar)
          data.paladin.LastTurn = GetTime()
          return true
        end
      end
    end
  end,

  ["Hammer of Wrath (Auto Target)"] = function()
    local _, enabled = GetSetting("masswrath")
    if enabled
      and ni.player.power() > 60
      and ni.spell.available(48806)
      and UnitCanAttack("player", "target") then
      table.wipe(enemies)
      enemies = ni.unit.enemiesinrange("player", 29)
      for i = 1, #enemies do
        local executetar = enemies[i].guid
        if ni.unit.hp(executetar) < 20
          and ni.spell.valid(executetar, 48806, true, true) then
          ni.spell.cast(48806, executetar)
          return true
        end
      end
    end
  end,

  ["Control (Member)"] = function()
    local _, enabled = GetSetting("control")
    if enabled and ni.spell.available(10308) then
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

  ["Window"] = function()
    if not popup_shown then
      ni.debug.popup("Holy Paladin by DarhangeR for 3.3.5a",
        "Welcome to Holy Paladin Profile! Support: https://discord.gg/TEQEJYS\n\n--Profile Features--\n✓ 10 pages GUI\n✓ Sacred Shield automático en TODOS los tanks (excluye Paladines)\n✓ Beacon of Light en main tank\n✓ Flash of Light proc Infusion of Light corregido\n✓ Avenging Wrath y Divine Illumination con HP/Count configurables\n✓ Valithria ICC con check de setting\n✓ Turn Evil por unidad individual\n✓ Blessings para todo el grupo/raid\n✓ Expert Settings con macros configurables")
      popup_shown = true
    end
  end,
}

  ni.bootstrap.profile("Holy_DarhangeR", queue, abilities, OnLoad, OnUnLoad);

else
  local queue = { "Error" }
  local abilities = {
    ["Error"] = function()
      ni.vars.profiles.enabled = false
      if build > 30300 then
        ni.frames.floatingtext:message("This profile is meant for WotLK 3.3.5a! Sorry!")
      elseif level < 80 then
        ni.frames.floatingtext:message("This profile is meant for level 80! Sorry!")
      elseif data == nil then
        ni.frames.floatingtext:message("Data file is missing or corrupted!")
      end
    end,
  }
  ni.bootstrap.profile("Holy_DarhangeR", queue, abilities)
end
