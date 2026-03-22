local data = ni.utils.require("DarhangeR");

local popup_shown = false;
local enemies = {};
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");

-- Icon helper
local function icon(spellID)
  return select(3, GetSpellInfo(spellID)) or ""
end

-- Contar enemigos alrededor del target
local function ActiveEnemiesOnTarget(range)
  range = range or 7
  table.wipe(enemies);
  enemies = ni.unit.enemiesinrange("target", range);
  for k, v in ipairs(enemies) do
    if ni.player.threat(v.guid) == -1 then
      table.remove(enemies, k);
    end
  end
  return #enemies;
end

-- Contar enemigos alrededor del jugador
local function ActiveEnemiesAroundPlayer(range)
  range = range or 10
  table.wipe(enemies);
  enemies = ni.unit.enemiesinrange("player", range);
  local count = 0
  for k, v in ipairs(enemies) do
    if UnitCanAttack("player", v.guid) then
      count = count + 1
    end
  end
  return count;
end

if build == 30300 and level == 80 and data then

  -- Seal por facción
  local factionseal = 53736 -- Seal of Corruption (Horde)
  if UnitFactionGroup("player") == "Alliance" then
    factionseal = 31801 -- Seal of Vengeance (Alliance)
  end

  local items = {
    settingsfile = "DarhangeR_Retri.xml",

    { type = "title", text = "Retribution Paladin by |c0000CED1DarhangeR" },
    { type = "separator" },

    -- =========================================================
    -- PAGE 1: MAIN SETTINGS
    -- =========================================================
    { type = "separator" },
    { type = "page", number = 1, text = "|cffEE4000Main Settings" },
    { type = "separator" },

    { type = "entry", text = "|T" .. icon(54428) .. ":26:26|t Divine Plea", tooltip = "Use Divine Plea when player mana < %", enabled = true, value = 50, key = "plea" },
    { type = "entry", text = "|T" .. icon(53601) .. ":26:26|t Sacred Shield", tooltip = "Cast Sacred Shield in combat when missing", enabled = true, value = 60, key = "sacred" },
    { type = "entry", text = "|T" .. icon(32223) .. ":26:26|t Crusader Aura", tooltip = "Auto keep Crusader Aura out of combat", enabled = true, key = "crusaderaura" },

    { type = "entry", text = "|T" .. icon(48785) .. ":26:26|t Flash of Light (Self)", tooltip = "Use spell when player HP < %. Work only with [Art of War] buff. And if [Exorcism] on cd.", enabled = true, value = 90, key = "flashoflight" },
    { type = "entry", text = "Ignore Exorcism CD", tooltip = "Allow Flash of Light with Art of War even if Exorcism is ready", enabled = false, key = "ignoreexocd" },
    { type = "dropdown", menu = {
      { selected = true,  value = "self",  text = "Cast on Self only" },
      { selected = false, value = "ally",  text = "Cast on Allies" },
    }, key = "flashtarget" },

    { type = "separator" },
    { type = "title", text = "Important settings" },
    { type = "separator" },

    { type = "entry", text = "Auto Target", tooltip = "Automatically target enemies in combat", enabled = true, key = "autotarget" },
    { type = "entry", text = "|T" .. icon(31884) .. ":26:26|t Boss Detect", tooltip = "Auto detect bosses for cooldown usage", enabled = true, key = "detect" },
    { type = "entry", text = "Profile Pause", tooltip = "Custom profile pause throttle in seconds", enabled = true, value = 1.5, key = "profilepause" },
    { type = "entry", text = "|T" .. icon(2382) .. ":26:26|t Debug Printing", tooltip = "Enable debug output", enabled = false, value = 1.5, key = "Debug" },

    -- =========================================================
    -- PAGE 2: ROTATION SETTINGS #1
    -- =========================================================
    { type = "separator" },
    { type = "page", number = 2, text = "|cffEE4000Rotation Settings #1" },
    { type = "separator" },

    { type = "title", text = "Blessings settings" },
    { type = "separator" },

    { type = "dropdown", menu = {
      { selected = true,  value = 25898, text = "|T" .. icon(25898) .. ":20:20|t Greater Blessing of Kings" },
      { selected = false, value = 48934, text = "|T" .. icon(48934) .. ":20:20|t Greater Blessing of Might" },
      { selected = false, value = 48938, text = "|T" .. icon(48938) .. ":20:20|t Greater Blessing of Wisdom" },
    }, key = "BlessingType" },
    { type = "entry", text = "Use blessings in combat", tooltip = "Allow casting blessings during combat", enabled = false, key = "blesscombat" },

    { type = "separator" },
    { type = "title", text = "Active seals" },
    { type = "separator" },

    { type = "dropdown", menu = {
      { selected = true,  value = factionseal, text = "|T" .. icon(factionseal) .. ":20:20|t Seal of Corruption/Vengeance" },
      { selected = false, value = 20375, text = "|T" .. icon(20375) .. ":20:20|t Seal of Command" },
      { selected = false, value = 21084, text = "|T" .. icon(21084) .. ":20:20|t Seal of Righteousness" },
      { selected = false, value = 20166, text = "|T" .. icon(20166) .. ":20:20|t Seal of Wisdom" },
      { selected = false, value = 20164, text = "|T" .. icon(20164) .. ":20:20|t Seal of Justice" },
    }, key = "CurentSeal" },

    { type = "separator" },
    { type = "title", text = "Active Judgement" },
    { type = "separator" },

    { type = "dropdown", menu = {
      { selected = false, value = 20271, text = "|T" .. icon(20271) .. ":20:20|t Judgement of Light" },
      { selected = true,  value = 53408, text = "|T" .. icon(53408) .. ":20:20|t Judgement of Wisdom" },
      { selected = false, value = 53407, text = "|T" .. icon(53407) .. ":20:20|t Judgement of Justice" },
    }, key = "JudgementType" },

    { type = "separator" },
    { type = "title", text = "Bursts" },
    { type = "separator" },

    { type = "entry", text = "Cancel Shadowmourne (Chaos Bane)", tooltip = "Cancel Chaos Bane buff (Shadowmourne) when enabled", enabled = false, key = "cancelshadow" },
    { type = "entry", text = "Use racial abilities", tooltip = "Use racial abilities on cooldown/boss", enabled = true, key = "racial" },
    { type = "entry", text = "Using Potions", tooltip = "Use burst potion in combat on cooldown/boss", enabled = false, value = 0, key = "usingpotions" },
    { type = "entry", text = "|T" .. icon(31884) .. ":26:26|t Avenging Wrath", tooltip = "Use Avenging Wrath on boss with seal stacks", enabled = true, key = "avengingwrath" },
    { type = "entry", text = "Engineering bombs", tooltip = "Use engineering bombs in combat", enabled = false, key = "engineeringbombs" },

    { type = "separator" },
    { type = "title", text = "AoE Settings" },
    { type = "separator" },

    { type = "entry", text = "AoE Seals", tooltip = "Enemies needed to switch to AoE seal rotation", enabled = true, value = 1, key = "AoE" },
    -- FIX: AoE seal ahora configurable via dropdown en lugar de hardcodeado
    { type = "dropdown", menu = {
      { selected = true,  value = 20375, text = "|T" .. icon(20375) .. ":20:20|t Seal of Command" },
      { selected = false, value = 0,     text = "No AoE seal switch" },
    }, key = "AoESeal" },
    { type = "entry", text = "|T" .. icon(53385) .. ":26:26|t Divine Storm", tooltip = "Use Divine Storm in rotation", enabled = true, key = "divinestorm" },
    { type = "entry", text = "Keep - Seal of Corruption/Vengeance", tooltip = "Keep faction seal during AoE (no seal switch)", enabled = false, key = "keepmainseal" },

    -- =========================================================
    -- PAGE 3: ROTATION SETTINGS #2
    -- =========================================================
    { type = "separator" },
    { type = "page", number = 3, text = "|cffEE4000Rotation Settings #2" },
    { type = "separator" },

    { type = "title", text = "Righteous Fury settings" },
    { type = "separator" },

    -- FIX: Cambiado de checkbox a dropdown (igual que screenshots)
    { type = "dropdown", menu = {
      { selected = true,  value = "cancel", text = "Cancel Buff" },
      { selected = false, value = "keep",   text = "Keep Buff" },
    }, key = "rfmode" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(48801) .. ":26:26|t Exorcism (Art of War only)", tooltip = "Use Exorcism when Art of War proc is active", enabled = true, key = "exorcism" },
    { type = "entry", text = "|T" .. icon(48819) .. ":26:26|t Consecration", tooltip = "Enable Consecration (smart usage)", enabled = true, value = 35, key = "concentrat" },
    { type = "entry", text = "|T" .. icon(48817) .. ":26:26|t Holy Wrath (Auto)", tooltip = "Use Holy Wrath vs Undead/Demon", enabled = false, value = 20, key = "holywrath" },
    { type = "entry", text = "|T" .. icon(48806) .. ":26:26|t Hammer of Wrath", tooltip = "Use Hammer of Wrath on targets below 20% HP", enabled = true, key = "hammerwrath" },
    { type = "entry", text = "|T" .. icon(10326) .. ":26:26|t Turn Evil (Auto)", tooltip = "Use Turn Evil vs Undead/Demon", enabled = false, key = "turn" },
    { type = "entry", text = "|T" .. icon(20066) .. ":26:26|t Auto Control (Allys)", tooltip = "Auto control mind-controlled allies", enabled = true, key = "control" },
    { type = "entry", text = "Auto Interrupt (Hammer of Justice)", tooltip = "Use Hammer of Justice as backup interrupt", enabled = false, key = "hojinterrupt" },

    { type = "separator" },
    { type = "title", text = "Dispel" },
    { type = "separator" },

    { type = "entry", text = "Delay for dispeling (seconds)", tooltip = "Delay between dispels in seconds", enabled = true, value = 1.5, key = "dispeldelay" },

    -- FIX: Cleanse consolidado en 1 entry + dropdown de modo (igual que screenshots)
    { type = "entry", text = "|T" .. icon(4987) .. ":26:26|t Cleanse", tooltip = "Auto cleanse Magic/Disease/Poison debuffs", enabled = true, key = "cleans" },
    { type = "dropdown", menu = {
      { selected = false, value = "auto_self",   text = "Auto (Self only)" },
      { selected = false, value = "auto_allies",  text = "Auto (Self + Allies)" },
      { selected = true,  value = "manual",       text = "Manual Mode" },
    }, key = "cleanse_mode" },
    { type = "entry", text = "Disable Cleanse", tooltip = "Completely disable cleansing", enabled = false, key = "disablecleans" },

    { type = "separator" },
    -- FIX: Hand of Freedom consolidado en 1 entry + dropdown de modo (igual que screenshots)
    { type = "entry", text = "|T" .. icon(1044) .. ":26:26|t Hand of Freedom", tooltip = "Use Hand of Freedom on rooted/snared units", enabled = true, key = "freedom" },
    { type = "dropdown", menu = {
      { selected = false, value = "auto_self",  text = "Auto (Self only)" },
      { selected = false, value = "auto_allies", text = "Auto (Self + Allies)" },
      { selected = true,  value = "manual",      text = "Manual Mode" },
    }, key = "freedom_mode" },
    { type = "entry", text = "Disable Hand of Freedom", tooltip = "Completely disable Hand of Freedom", enabled = false, key = "disablefreedom" },

    -- =========================================================
    -- PAGE 4: DEFENSIVE SETTINGS
    -- =========================================================
    { type = "separator" },
    { type = "page", number = 4, text = "|cff00C957Defensive Settings" },
    { type = "separator" },

    { type = "entry", text = "|T" .. icon(642)  .. ":26:26|t Divine Shield",     tooltip = "Use Divine Shield when HP < %",     enabled = true, value = 10, key = "divineshield" },
    { type = "entry", text = "|T" .. icon(498)  .. ":26:26|t Divine Protection", tooltip = "Use Divine Protection when HP < %", enabled = true, value = 30, key = "divineprot" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(36894) .. ":26:26|t Healthstone", tooltip = "Use Healthstone when HP < %", enabled = true, value = 35, key = "healthstoneuse" },
    -- NUEVO: Healthstone Pick-up (igual que screenshots)
    { type = "entry", text = "Healthstone (Pick-up)", tooltip = "Auto loot Healthstone from nearby Soulwell", enabled = true, key = "hstonepickup" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(43185) .. ":26:26|t Heal Potion",  tooltip = "Use Healing Potions when HP < %",   enabled = false, value = 30, key = "healpotionuse" },
    { type = "entry", text = "|T" .. icon(43186) .. ":26:26|t Mana Potion",  tooltip = "Use Mana Potions when mana < %",    enabled = false, value = 25, key = "manapotionuse" },

    -- =========================================================
    -- PAGE 5: SELF / PARTY / RAID
    -- =========================================================
    { type = "separator" },
    { type = "page", number = 5, text = "|cff00C957Self/Party/Raid" },
    { type = "separator" },

    { type = "entry", text = "|T" .. icon(48788) .. ":26:26|t Lay on Hands", tooltip = "Use Lay on Hands when HP < %", enabled = true, value = 20, key = "layon" },
    -- FIX: Dropdown en lugar de checkbox separado (igual que screenshots)
    { type = "dropdown", menu = {
      { selected = true,  value = "self",   text = "Cast on Self only" },
      { selected = false, value = "allies", text = "Cast on Self + Allies" },
    }, key = "layon_mode" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(1038) .. ":26:26|t Hand of Salvation", tooltip = "Auto check ally agro and use spell. Spell ignoring Tanks.", enabled = true, key = "salva" },
    -- NUEVO: Dropdown para Hand of Salvation (igual que screenshots)
    { type = "dropdown", menu = {
      { selected = true,  value = "self",   text = "Cast on Self only" },
      { selected = false, value = "allies", text = "Cast on Allies" },
    }, key = "salva_mode" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(6940)  .. ":26:26|t Hand of Sacrifice",  tooltip = "Use Hand of Sacrifice when ally HP < %",  enabled = true, value = 20, key = "sacrifice" },
    { type = "entry", text = "|T" .. icon(10278) .. ":26:26|t Hand of Protection", tooltip = "Use Hand of Protection when ally HP < %", enabled = true, value = 20, key = "handofprot" },

    { type = "separator" },
    { type = "entry", text = "|T" .. icon(31821) .. ":26:26|t Aura Mastery", tooltip = "Use Aura Mastery when allies HP < % (with throttle)", enabled = true, key = "auramastery" },
    { type = "entry", text = "Allys HP",    tooltip = "HP threshold for Aura Mastery",         enabled = true, value = 30, key = "auramasteryhp" },
    { type = "entry", text = "Allys Count", tooltip = "Allies below threshold required",        enabled = true, value = 4,  key = "auramasterycount" },

    -- =========================================================
    -- PAGE 6: TRINKETS (Config)
    -- =========================================================
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

  -- =========================================================
  -- GetSetting helper (soporta entry, dropdown, input)
  -- =========================================================
  local function GetSetting(name)
    for k, v in ipairs(items) do
      if v.type == "entry" and v.key ~= nil and v.key == name then
        return v.value, v.enabled
      end
      if v.type == "dropdown" and v.key ~= nil and v.key == name then
        for _, v2 in pairs(v.menu) do
          if v2.selected then
            return v2.value
          end
        end
      end
      if v.type == "input" and v.key ~= nil and v.key == name then
        return v.value
      end
    end
  end

  local function OnLoad()
    ni.GUI.AddFrame("Retri_DarhangeR", items);
  end

  local function OnUnLoad()
    ni.GUI.DestroyFrame("Retri_DarhangeR");
  end

  local LastAuraMastery = 0

  -- =========================================================
  -- QUEUE
  -- FIX #3: Exorcism movido ANTES que Consecration
  -- =========================================================
  local queue = {
    "Universal pause",
    "AutoTarget",
    "Blessings (Raid/Dungeon)",
    "Crusader Aura",
    "Main Seal",
    "Seal AoE (Switch)",
    "Cancel Righteous Fury",
    "Auto Track Undeads",
    "Combat specific Pause",
    "Healthstone (Pick-up)",
    "Healthstone (Use)",
    "Heal Potions (Use)",
    "Mana Potions (Use)",
    "Trinkets (Config)",
    "Racial Stuff",
    "Use engineer gloves",
    "Trinkets",
    "Lay on Hands (Self)",
    "Lay on Hands (Ally)",
    "Divine Shield",
    "Divine Protection",
    "Flash of Light (Self)",
    "Hand of Protection (Member)",
    "Hand of Salvation (Member)",
    "Hand of Sacrifice (Member)",
    "Hand of Freedom",
    "Divine Plea",
    "Sacred Shield (In Combat)",
    "Avenging Wrath",
    "Burst Potion",
    "Engineering Bombs",
    "Aura Mastery",
    "Turn Evil (Auto Use)",
    "Hammer of Justice (Interrupt)",
    "Control (Member)",
    "Hammer of Wrath",
    "Hammer of Wrath (Auto Target)",
    "Crusader Strike",
    "Judgement (Selected Type)",
    "Divine Storm",
    "Holy Wrath (Auto Use)",
    "Exorcism (Art of War)",      -- FIX: antes de Consecration (mayor DPS)
    "Consecration (Optimized)",
    "Cleanse",
    "Cancel Shadowmourne",
    "Window",
  }

  -- =========================================================
  -- ABILITIES
  -- =========================================================
  local abilities = {

    ["Universal pause"] = function()
      if data.UniPause() then
        return true
      end
      ni.vars.debug = select(2, GetSetting("Debug"));
    end,

    ["AutoTarget"] = function()
      local _, enabled = GetSetting("autotarget")
      if enabled
        and UnitAffectingCombat("player")
        and ((ni.unit.exists("target") and UnitIsDeadOrGhost("target") and not UnitCanAttack("player", "target"))
          or not ni.unit.exists("target")) then
        ni.player.runtext("/targetenemy")
      end
    end,

    ["Blessings (Raid/Dungeon)"] = function()
      local blessing = GetSetting("BlessingType");
      local _, combatEnabled = GetSetting("blesscombat")
      -- FIX: condición siempre-true eliminada; ahora comprueba grupo correctamente
      local inGroup = IsInRaid() or IsInGroup()
      if (not UnitAffectingCombat("player") or combatEnabled)
        and IsSpellKnown(blessing)
        and ni.spell.available(blessing) then

        if not ni.player.buff(blessing) then
          ni.spell.cast(blessing, "player")
          return true
        end

        if inGroup then
          for i = 1, #ni.members do
            local member = ni.members[i].unit
            if ni.spell.valid(member, blessing, false, true, true)
              and not ni.unit.buff(member, blessing) then
              ni.spell.cast(blessing, member)
              return true
            end
          end
        end
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

    -- FIX: Main Seal respeta keepmainseal para no ser sobreescrito en AoE
    ["Main Seal"] = function()
      local threshold, enabled = GetSetting("AoE")
      local _, keepmain = GetSetting("keepmainseal")
      local seal = GetSetting("CurentSeal");
      local enemiesCount = math.max(ActiveEnemiesOnTarget(7), ActiveEnemiesAroundPlayer(10))

      local shouldUseMainSeal = keepmain
        or ((ni.vars.combat.aoe == false and enemiesCount < threshold) or (enabled and enemiesCount < threshold))

      if shouldUseMainSeal
        and IsSpellKnown(seal)
        and ni.spell.available(seal)
        and not ni.player.buff(seal)
        and GetTime() - data.paladin.LastSeal > 3 then
        ni.spell.cast(seal)
        data.paladin.LastSeal = GetTime()
        return true
      end
    end,

    -- FIX: AoE Seal usa el dropdown AoESeal y respeta keepmainseal
    ["Seal AoE (Switch)"] = function()
      local threshold, enabled = GetSetting("AoE")
      local _, keepmain = GetSetting("keepmainseal")
      local aoeSeal = GetSetting("AoESeal")
      local enemiesCount = math.max(ActiveEnemiesOnTarget(7), ActiveEnemiesAroundPlayer(10))

      if keepmain then return end
      if not aoeSeal or aoeSeal == 0 then return end

      if ((ni.vars.combat.aoe) or (enabled and enemiesCount >= threshold))
        and IsSpellKnown(aoeSeal)
        and ni.spell.available(aoeSeal)
        and GetTime() - data.paladin.LastSeal > 3
        and not ni.player.buff(aoeSeal) then
        ni.spell.cast(aoeSeal)
        data.paladin.LastSeal = GetTime()
        return true
      end
    end,

    -- FIX: Ahora usa el dropdown rfmode en lugar de checkbox
    ["Cancel Righteous Fury"] = function()
      local rfMode = GetSetting("rfmode")
      if rfMode ~= "cancel" then return end
      local p = "player"
      for i = 1, 40 do
        local _, _, _, _, _, _, _, u, _, _, s = UnitBuff(p, i)
        if u == p and s == 25780 then
          CancelUnitBuff(p, i)
          break;
        end
      end
    end,

    ["Combat specific Pause"] = function()
      if data.meleeStop("target")
        or data.PlayerDebuffs("player")
        or UnitCanAttack("player", "target") == nil
        or (UnitAffectingCombat("target") == nil
          and ni.unit.isdummy("target") == nil
          and UnitIsPlayer("target") == nil) then
        return true
      end
    end,

    -- NUEVO: Healthstone Pick-up - auto loot desde Soulwell cercano
    ["Healthstone (Pick-up)"] = function()
      local _, enabled = GetSetting("hstonepickup")
      if not enabled then return end
      -- Si ya tenemos un healthstone, no es necesario
      local hstones = { 36892, 36893, 36894 }
      for i = 1, #hstones do
        if ni.player.hasitem(hstones[i]) then return end
      end
      -- Soulwell object ID en WotLK: 227900 aprox (varía por tier)
      local soulwells = { 227900, 187812, 205754, 232374 }
      for _, oid in ipairs(soulwells) do
        local obj = ni.object.id(oid)
        if obj and ni.unit.distance("player", obj) < 10 then
          InteractUnit(obj)
          return true
        end
      end
    end,

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

    ["Racial Stuff"] = function()
      local _, enabled = GetSetting("racial")
      if not enabled then return end

      local hracial = { 33697, 20572, 33702, 26297 }
      local bloodelf = { 25046, 28730, 50613 }
      local alracial = { 20594, 28880 }
      local _, bossDetect = GetSetting("detect")

      if data.forsaken("player") and IsSpellKnown(7744) and ni.spell.available(7744) then
        ni.spell.cast(7744)
        return true
      end

      for i = 1, #hracial do
        if data.CDorBoss("target", 5, 35, 5, bossDetect)
          and IsSpellKnown(hracial[i])
          and ni.spell.available(hracial[i])
          and data.paladin.RetriRange() then
          ni.spell.cast(hracial[i])
          return true
        end
      end

      for i = 1, #bloodelf do
        if data.CDorBoss("target", 5, 35, 5, bossDetect)
          and ni.player.power() < 60
          and IsSpellKnown(bloodelf[i])
          and ni.spell.available(bloodelf[i])
          and data.paladin.RetriRange() then
          ni.spell.cast(bloodelf[i])
          return true
        end
      end

      for i = 1, #alracial do
        if data.paladin.RetriRange()
          and ni.player.hp() < 20
          and IsSpellKnown(alracial[i])
          and ni.spell.available(alracial[i]) then
          ni.spell.cast(alracial[i])
          return true
        end
      end
    end,

    ["Use engineer gloves"] = function()
      local _, enabled = GetSetting("detect")
      if ni.player.slotcastable(10)
        and ni.player.slotcd(10) == 0
        and data.CDorBoss("target", 5, 35, 5, enabled)
        and data.paladin.RetriRange() then
        ni.player.useinventoryitem(10)
        return true
      end
    end,

    ["Trinkets (Config)"] = function()
      if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
        return true
      end
    end,

    -- FIX: stacksReady ahora tiene en cuenta cuando NO es faction seal (AoE con SoC)
    ["Trinkets"] = function()
      local _, enabled = GetSetting("detect")
      local seal = GetSetting("CurentSeal")
      local sealStacks = select(4, ni.unit.debuff("target", 53742)) or 0
      local stacksReady = (seal ~= factionseal) or sealStacks >= 5

      if data.CDorBoss("target", 5, 35, 5, enabled)
        and stacksReady
        and data.paladin.RetriRange() then
        -- FIX: slot 13 ahora también retorna true correctamente
        if ni.player.slotcastable(13) and ni.player.slotcd(13) == 0 then
          ni.player.useinventoryitem(13)
          return true
        end
        if ni.player.slotcastable(14) and ni.player.slotcd(14) == 0 then
          ni.player.useinventoryitem(14)
          return true
        end
      end
    end,

    ["Lay on Hands (Self)"] = function()
      local value, enabled = GetSetting("layon");
      local forb = data.paladin.forb()
      if enabled
        and ni.player.hp() < value
        and not forb
        and ni.spell.available(48788) then
        ni.spell.cast(48788)
        return true
      end
    end,

    -- FIX: usa layon_mode dropdown en lugar del antiguo checkbox layonally
    ["Lay on Hands (Ally)"] = function()
      local value, enabled = GetSetting("layon");
      local layonMode = GetSetting("layon_mode")
      local forb = data.paladin.forb()
      if enabled
        and layonMode == "allies"
        and #ni.members > 1
        and not forb
        and ni.spell.available(48788) then
        for i = 1, #ni.members do
          if ni.members[i].hp < value
            and ni.spell.valid(ni.members[i].unit, 48788, false, true, true) then
            ni.spell.cast(48788, ni.members[i].unit)
            return true
          end
        end
      end
    end,

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

    ["Divine Protection"] = function()
      local value, enabled = GetSetting("divineprot");
      local forb = data.paladin.forb()
      if enabled
        and ni.player.hp() < value
        and not forb
        and ni.spell.available(498)
        and not ni.player.buff(498) then
        ni.spell.cast(498)
        return true
      end
    end,

    -- FIX: override de emergencia si HP < 30% ignora el check de Exorcism
    ["Flash of Light (Self)"] = function()
      local value, enabled = GetSetting("flashoflight")
      local _, ignoreExoCD = GetSetting("ignoreexocd")
      local aow = data.paladin.aow()
      local emergency = ni.player.hp() < 30
      if enabled
        and ni.player.hp() < value
        and aow
        and ni.spell.isinstant(48785)
        and (ignoreExoCD or emergency or not ni.spell.available(48801))
        and ni.spell.available(48785) then
        ni.spell.cast(48785, "player")
        return true
      end
    end,

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

    -- FIX: Hand of Salvation respeta salva_mode dropdown
    ["Hand of Salvation (Member)"] = function()
      local _, enabled = GetSetting("salva")
      local salvaMode = GetSetting("salva_mode")
      if enabled
        and #ni.members > 1
        and ni.spell.available(1038)
        and data.CombatStart(10) then
        -- Modo "allies": proteger al miembro con más threat (no tank)
        if salvaMode == "allies" then
          if ni.members[1].threat >= 2
            and not ni.members[1].istank
            and not data.paladin.HandActive(ni.members[1].unit)
            and ni.spell.valid(ni.members[1].unit, 1038, false, true, true) then
            ni.spell.cast(1038, ni.members[1].unit)
            return true
          end
        else
          -- Modo "self": solo protegerse a uno mismo si tiene mucho threat
          if ni.player.threat("target") >= 2
            and ni.spell.valid("player", 1038, false, true, true) then
            ni.spell.cast(1038, "player")
            return true
          end
        end
      end
    end,

    ["Hand of Sacrifice (Member)"] = function()
      local value, enabled = GetSetting("sacrifice");
      if enabled
        and #ni.members > 1
        and ni.spell.available(6940) then
        for i = 1, #ni.members do
          if ni.members[i].hp < value
            and not data.paladin.HandActive(ni.members[i].unit)
            and ni.spell.valid(ni.members[i].unit, 6940, false, true, true) then
            ni.spell.cast(6940, ni.members[i].unit)
            return true
          end
        end
      end
    end,

    -- FIX: Hand of Freedom consolidado, controlado por freedom_mode dropdown
    ["Hand of Freedom"] = function()
      local _, enabled = GetSetting("freedom")
      local _, disabled = GetSetting("disablefreedom")
      local freedom_mode = GetSetting("freedom_mode")
      if disabled or not enabled or freedom_mode == "manual" then return end

      -- Self
      if ni.player.ismoving()
        and data.paladin.FreedomUse("player")
        and not data.paladin.HandActive("player")
        and ni.spell.available(1044) then
        ni.spell.cast(1044, "player")
        return true
      end

      -- Allies (solo si modo auto_allies)
      if freedom_mode == "auto_allies" and ni.spell.available(1044) then
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

    -- FIX: lógica de Sacred Shield simplificada (rama else redundante eliminada)
    ["Sacred Shield (In Combat)"] = function()
      local _, enabled = GetSetting("sacred")
      if enabled
        and UnitAffectingCombat("player")
        and not ni.player.buff(53601)
        and ni.spell.available(53601) then
        ni.spell.cast(53601, "player")
        return true
      end
    end,

    -- FIX: Avenging Wrath también respeta stacksReady (igual que Trinkets)
    ["Avenging Wrath"] = function()
      local _, enabled = GetSetting("avengingwrath")
      local _, bossDetect = GetSetting("detect")
      local seal = GetSetting("CurentSeal")
      local sealStacks = select(4, ni.unit.debuff("target", 53742)) or 0
      local stacksReady = (seal ~= factionseal) or sealStacks >= 5
      if enabled
        and data.CDorBoss("target", 5, 35, 5, bossDetect)
        and stacksReady
        and ni.spell.available(31884)
        and data.paladin.RetriRange() then
        ni.spell.cast(31884)
        data.paladin.LastAven = GetTime()
        return true
      end
    end,

    ["Burst Potion"] = function()
      local _, enabled = GetSetting("usingpotions")
      local _, bossDetect = GetSetting("detect")
      local burstPotions = { 40211, 22838 }
      if not enabled
        or not UnitAffectingCombat("player")
        or not data.CDorBoss("target", 5, 35, 5, bossDetect)
        or not data.paladin.RetriRange() then
        return
      end
      for i = 1, #burstPotions do
        local potion = burstPotions[i]
        if ni.player.hasitem(potion) and ni.player.itemcd(potion) == 0 then
          ni.player.useitem(potion)
          return true
        end
      end
    end,

    ["Engineering Bombs"] = function()
      local _, enabled = GetSetting("engineeringbombs")
      local _, bossDetect = GetSetting("detect")
      local bombs = { 42641, 41119 }
      if not enabled
        or not UnitAffectingCombat("player")
        or not data.CDorBoss("target", 5, 35, 5, bossDetect)
        or not data.paladin.RetriRange() then
        return
      end
      for i = 1, #bombs do
        local bomb = bombs[i]
        if ni.player.hasitem(bomb) and ni.player.itemcd(bomb) == 0 then
          ni.player.useitem(bomb)
          return true
        end
      end
    end,

    ["Aura Mastery"] = function()
      local _, enabled = GetSetting("auramastery")
      local hpThreshold = GetSetting("auramasteryhp")
      local countThreshold = GetSetting("auramasterycount")
      if enabled
        and UnitAffectingCombat("player")
        and not ni.player.buff(31821)
        and GetTime() - LastAuraMastery > 15
        and ni.spell.available(31821) then
        local lowHPCount = 0
        for i = 1, #ni.members do
          if ni.members[i].hp < hpThreshold then
            lowHPCount = lowHPCount + 1
          end
        end
        if lowHPCount >= countThreshold then
          ni.spell.cast(31821)
          LastAuraMastery = GetTime()
          return true
        end
      end
    end,

    -- FIX: Turn Evil corregido - evalúa cada unidad individualmente (no flag global)
    ["Turn Evil (Auto Use)"] = function()
      local _, enabled = GetSetting("turn")
      if enabled
        and ni.unit.exists("target")
        and ni.spell.available(10326)
        and UnitCanAttack("player", "target") then
        table.wipe(enemies);
        enemies = ni.unit.enemiesinrange("player", 25)
        for i = 1, #enemies do
          local tar = enemies[i].guid;
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

    ["Hammer of Justice (Interrupt)"] = function()
      local _, enabled = GetSetting("hojinterrupt")
      if data.TryInterrupt("target", enabled, 10308, 0.35) then
        return true
      end
    end,

    ["Control (Member)"] = function()
      local _, enabled = GetSetting("control")
      if enabled and ni.spell.available(20066) then
        for i = 1, #ni.members do
          local ally = ni.members[i].unit
          if data.ControlMember(ally)
            and not data.UnderControlMember(ally)
            and ni.spell.valid(ally, 20066, false, true, true) then
            ni.spell.cast(20066, ally)
            return true
          end
        end
      end
      if not ni.spell.available(20066) and ni.spell.available(10308) then
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

    ["Hammer of Wrath"] = function()
      local _, enabled = GetSetting("hammerwrath")
      if enabled
        and (ni.unit.hp("target") <= 20 or IsUsableSpell(GetSpellInfo(48806)))
        and ni.spell.available(48806)
        and ni.spell.valid("target", 48806, true, true) then
        ni.spell.cast(48806, "target")
        return true
      end
    end,

    ["Hammer of Wrath (Auto Target)"] = function()
      local _, enabled = GetSetting("hammerwrath")
      if enabled
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

    ["Crusader Strike"] = function()
      if ni.spell.available(35395)
        and ni.spell.valid("target", 35395, true, true) then
        ni.spell.cast(35395, "target")
        return true
      end
    end,

    ["Judgement (Selected Type)"] = function()
      local judgement = GetSetting("JudgementType");
      if ni.spell.available(judgement)
        and ni.spell.valid("target", judgement, false, true, true) then
        ni.spell.cast(judgement, "target")
        return true
      end
    end,

    ["Divine Storm"] = function()
      local _, enabled = GetSetting("divinestorm")
      if enabled
        and ni.spell.available(53385)
        and GetTime() - data.paladin.LastStorm > 1.6
        and data.paladin.RetriRange() then
        ni.spell.cast(53385, "target")
        data.paladin.LastStorm = GetTime()
        return true
      end
    end,

    ["Holy Wrath (Auto Use)"] = function()
      local _, enabled = GetSetting("holywrath")
      if enabled
        and ni.spell.available(48817)
        and (ni.unit.creaturetype("target") == 3 or ni.unit.creaturetype("target") == 6)
        and ni.player.distance("target") < 10 then
        ni.spell.cast(48817)
        return true
      end
    end,

    -- FIX: Exorcism está ANTES de Consecration en queue (mayor DPS)
    ["Exorcism (Art of War)"] = function()
      local _, enabled = GetSetting("exorcism")
      local aow = data.paladin.aow()
      if enabled
        and aow
        and ni.spell.isinstant(48801)
        and ni.spell.available(48801)
        and ni.spell.valid("target", 48801, true, true) then
        ni.spell.cast(48801, "target")
        return true
      end
    end,

    ["Consecration (Optimized)"] = function()
      local value, enabled = GetSetting("concentrat")
      local threshold = GetSetting("AoE")
      local enemiesCount = math.max(ActiveEnemiesOnTarget(7), ActiveEnemiesAroundPlayer(10))
      local useConsecration = false

      if enemiesCount >= threshold then
        useConsecration = true
      elseif ni.spell.cd(35395) > 1.2 and ni.spell.cd(53385) > 1.2 then
        useConsecration = true
      end

      if enabled
        and useConsecration
        and ni.player.power() > value
        and ni.spell.available(48819)
        and data.paladin.RetriRange() then
        ni.spell.cast(48819)
        return true
      end
    end,

    -- FIX: Cleanse consolidado, controlado por cleanse_mode dropdown
    ["Cleanse"] = function()
      local _, enabled = GetSetting("cleans")
      local _, disabled = GetSetting("disablecleans")
      local cleanse_mode = GetSetting("cleanse_mode")
      local delay = GetSetting("dispeldelay")

      if disabled or not enabled or cleanse_mode == "manual" then return end

      -- Self
      if ni.player.debufftype("Magic|Disease|Poison")
        and ni.spell.available(4987)
        and ni.healing.candispel("player")
        and GetTime() - data.LastDispel > delay
        and ni.spell.valid("player", 4987, false, true, true) then
        ni.spell.cast(4987, "player")
        data.LastDispel = GetTime()
        return true
      end

      -- Allies (solo si modo auto_allies)
      if cleanse_mode == "auto_allies" and ni.spell.available(4987) then
        for i = 1, #ni.members do
          if ni.unit.debufftype(ni.members[i].unit, "Magic|Disease|Poison")
            and ni.healing.candispel(ni.members[i].unit)
            and GetTime() - data.LastDispel > delay
            and ni.spell.valid(ni.members[i].unit, 4987, false, true, true) then
            ni.spell.cast(4987, ni.members[i].unit)
            data.LastDispel = GetTime()
            return true
          end
        end
      end
    end,

    ["Cancel Shadowmourne"] = function()
      local _, enabled = GetSetting("cancelshadow")
      if enabled then
        local p = "player"
        for i = 1, 40 do
          local _, _, _, _, _, _, _, u, _, _, s = UnitBuff(p, i)
          if u == p and s == 73422 then
            CancelUnitBuff(p, i)
            break
          end
        end
      end
    end,

    ["Window"] = function()
      if not popup_shown then
        ni.debug.popup("Retribution Paladin by DarhangeR for 3.3.5a",
          "Welcome to Retribution Paladin Profile!\n\nSupport: https://discord.gg/TEQEJYS\n\n--Profile Features--\n✓ 7 pages GUI (Main/Rot1/Rot2/Def/Party/Trinkets/Expert)\n✓ Smart seals (Single/AoE) con dropdown configurable\n✓ Art of War tracking con override de emergencia\n✓ Seal stack-based cooldowns (Trinkets + Avenging Wrath)\n✓ Cleanse y Hand of Freedom con modos Auto/Manual\n✓ Lay on Hands y Hand of Salvation con dropdown modo\n✓ Healthstone Pick-up automático desde Soulwell\n✓ AoE switching robusto (player+target scan)")
        popup_shown = true;
      end
    end,
  }

  ni.bootstrap.profile("Retri_DarhangeR", queue, abilities, OnLoad, OnUnLoad);

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
  ni.bootstrap.profile("Retri_DarhangeR", queue, abilities);
end
