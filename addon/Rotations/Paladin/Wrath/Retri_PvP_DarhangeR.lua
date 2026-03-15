local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");

if build == 30300 and level == 80 and data then
    local factionseal = 53736
    if select(2, UnitFactionGroup("player")) == "Alliance" then
        factionseal = 31801
    end

    local items = {
        settingsfile = "DarhangeR_Retri_PvP.xml",
        { type = "title", text = "Retribution Paladin PvP Ascension v1.0.0" },
        { type = "separator" },
        { type = "entry", text = "Pause", tooltip = "Profile pause/debug", enabled = false, value = 1.5, key = "Debug" },
        { type = "entry", text = "Racial Abilities (PvP)", enabled = true, key = "racialpvp" },
        { type = "dropdown", menu = {
            { selected = true, value = 1, text = "Auto" },
            { selected = false, value = 2, text = "Offensive" },
            { selected = false, value = 3, text = "Defensive" },
        }, key = "racialmode" },
        { type = "separator" },

        { type = "page", number = 1, text = "|cff00C957Protective spells" },
        { type = "separator" },
        { type = "entry", text = "Turn Evil (with Glyph of Turn Evil)", enabled = true, key = "turnevil" },
        { type = "entry", text = "Sacred Shield, when you has %MP or more", enabled = true, value = 35, key = "sacredmp" },
        { type = "entry", text = "Divine Shield, when you have %HP or less", enabled = true, value = 35, key = "bubble" },
        { type = "entry", text = "Hand of Protection, when ally have %HP or less", enabled = true, value = 45, key = "hopally" },
        { type = "entry", text = "Divine Protection, when you has %HP or less", enabled = true, value = 40, key = "divineprot" },
        { type = "entry", text = "Lay on Hands, when you have %HP or less", enabled = true, value = 25, key = "layon" },
        { type = "entry", text = "Hand of Salvation (with glyph), when you have %HP or less", enabled = true, value = 50, key = "handsalvself" },
        { type = "entry", text = "Divine Sacrifice, when arena ally or focus has %HP or less", enabled = true, value = 65, key = "divinesac" },
        { type = "entry", text = "Hand of Sacrifice, when arena ally or focus has %HP or less", enabled = true, value = 50, key = "handsac" },
        { type = "entry", text = "Divine Plea", enabled = true, key = "plea" },

        { type = "separator" },
        { type = "page", number = 2, text = "|cff00C957Supporting spells" },
        { type = "separator" },
        { type = "entry", text = "Hand of Freedom, delay(seconds)", enabled = true, value = 0.2, key = "hofdelay" },
        { type = "entry", text = "Hand of Freedom (Self)", enabled = true, key = "hofself" },
        { type = "entry", text = "Hand of Freedom (Allies)", enabled = true, key = "hofally" },
        { type = "entry", text = "Cleanse, delay(seconds)", enabled = true, value = 0.5, key = "cleansedelay" },
        { type = "entry", text = "Cleanse (Self)", enabled = true, key = "cleanseself" },
        { type = "entry", text = "Cleanse (Allies)", enabled = true, key = "cleanseally" },
        { type = "entry", text = "Other debuffs, Mana Limit", enabled = true, value = 25, key = "cleansemanalimit" },
        { type = "entry", text = "Purify/Cleanse, when you has %MP or more", enabled = true, value = 35, key = "purifymp" },

        { type = "separator" },
        { type = "page", number = 3, text = "|cff00C957Heal spells" },
        { type = "separator" },
        { type = "entry", text = "Flash of Light, when you have buff: The Art of War", enabled = true, key = "folaow" },
        { type = "entry", text = "Heal, when you has %MP or more", enabled = true, value = 20, key = "healmp" },
        { type = "entry", text = "Flash of Light without The Art of War buff", enabled = false, key = "folhard" },
        { type = "entry", text = "Delay, when you are not moving(seconds)", enabled = true, value = 0.2, key = "healdelay" },
        { type = "entry", text = "Word of Glory, when you/ally has %HP or less", enabled = true, value = 60, key = "woghp" },

        { type = "separator" },
        { type = "page", number = 4, text = "|cff00C957Buffs" },
        { type = "separator" },
        { type = "entry", text = "Auto Righteous Fury", enabled = true, key = "rfury" },
        { type = "dropdown", menu = {
            { selected = true, value = 20217, text = "Blessing of Kings" },
            { selected = false, value = 48934, text = "Blessing of Might" },
            { selected = false, value = 0, text = "None" },
        }, key = "selfbuff" },
        { type = "dropdown", menu = {
            { selected = true, value = 20217, text = "Blessing of Kings (Arena Target)" },
            { selected = false, value = 48934, text = "Blessing of Might (Arena Target)" },
            { selected = false, value = 0, text = "None" },
        }, key = "targetbuff" },

        { type = "separator" },
        { type = "page", number = 5, text = "|cffEE4000Weapons and other things" },
        { type = "separator" },
        { type = "entry", text = "Autotarget", enabled = true, key = "autotarget" },
        { type = "entry", text = "Arena Assist (Smart Target)", tooltip = "Auto target arena healer/lowest HP when target is invalid", enabled = true, key = "arenaassist" },
        { type = "entry", text = "PvP Trinket/Break CC", tooltip = "Use racial/trinket to break hard control", enabled = true, value = 2.0, key = "trinketcc" },
        { type = "entry", text = "Arena Focus Interrupt", tooltip = "Try focus interrupt if spell ID is configured", enabled = false, key = "arenafocusinterrupt" },
        { type = "input", value = "", width = 80, height = 15, key = "focusinterruptspell" },
        { type = "entry", text = "Healthstone, use when you have %HP or less", enabled = true, value = 20, key = "healthstoneuse" },
        { type = "entry", text = "Healing Potion, use when you have %HP or less", enabled = true, value = 25, key = "healpotionuse" },
        { type = "entry", text = "Mana Potion, use when you have %MP or less", enabled = true, value = 25, key = "manapotionuse" },
        { type = "input", value = "15993", width = 80, height = 15, key = "bombitem" },
        { type = "entry", text = "Defensive trinket, when you have %HP or less", enabled = true, value = 40, key = "deftrinkethp" },
        { type = "entry", text = "Auto-trinket, when control duration is longer(seconds)", enabled = true, value = 3.5, key = "autotrinketcc" },

        { type = "separator" },
        { type = "page", number = 6, text = "|cffEE4000Offensive spells" },
        { type = "separator" },
        { type = "entry", text = "Auto Seal", enabled = true, key = "autoseal" },
        { type = "dropdown", menu = {
            { selected = true, value = 21084, text = "Seal of Righteousness" },
            { selected = false, value = factionseal, text = "Seal of Corruption/Vengeance" },
            { selected = false, value = 20375, text = "Seal of Command" },
        }, key = "offseal" },
        { type = "entry", text = "Judgement of Wisdom, when you has %MP or less", enabled = true, value = 35, key = "jowmp" },
        { type = "entry", text = "Templar's Verdict", enabled = true, key = "tv" },
        { type = "entry", text = "Holy Wrath, when you have %MP or more", enabled = true, value = 40, key = "holywrathmp" },
        { type = "entry", text = "Shield of Righteousness", enabled = true, key = "sor" },
        { type = "entry", text = "Divine Storm", enabled = true, key = "divinestorm" },
        { type = "entry", text = "Crusader Strike", enabled = true, key = "crusaderstrike" },
        { type = "entry", text = "Exorcism", enabled = true, key = "exorcism" },
        { type = "entry", text = "Hammer of Wrath", enabled = true, key = "how" },
        { type = "entry", text = "Consecration on melee DD, when you has %MP or more", enabled = true, value = 50, key = "consecrationmp" },
        { type = "entry", text = "Hammer of Justice", enabled = true, key = "hoj" },
        { type = "entry", text = "Hammer of Justice, when enemy cast a spell", enabled = true, key = "hojinterrupt" },
        { type = "entry", text = "Hammer of Justice on focus, when your target have %HP or less", enabled = true, value = 70, key = "hojfocushp" },
        { type = "entry", text = "Repentance", enabled = true, key = "repentance" },
        { type = "entry", text = "Repentance, when enemy cast a spell", enabled = true, key = "repentinterrupt" },
        { type = "entry", text = "Repentance on focus, when your target have %HP or less", enabled = true, value = 70, key = "repentfocushp" },
        { type = "entry", text = "Hand of Reckoning (only arena)", enabled = true, key = "handreck" },

        { type = "separator" },
        { type = "page", number = 7, text = "|cff00BFFFTrinkets (Config)" },
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
        ni.GUI.AddFrame("Retri_PvP_DarhangeR", items);
    end

    local function OnUnLoad()
        ni.GUI.DestroyFrame("Retri_PvP_DarhangeR");
    end

    local queue = {
        "Universal pause",
        "AutoTarget",
        "Arena Cache",
        "Arena Assist",
        "Main Seal",
        "Combat specific Pause",
        "PvP Trinket Break",
        "Healthstone (Use)",
        "Heal Potions (Use)",
        "Mana Potions (Use)",
        "Racial PvP",
        "Hand of Freedom (Self)",
        "Hand of Freedom (Ally)",
        "Cleanse (Self)",
        "Cleanse (Ally)",
        "Turn Evil",
        "Divine Shield",
        "Divine Protection",
        "Lay on Hands",
        "Hand of Protection (Ally)",
        "Hand of Sacrifice (Ally)",
        "Divine Sacrifice",
        "Divine Plea",
        "Flash of Light (Self)",
        "Flash of Light (Ally)",
        "Trinkets (Config)",
        "Trinkets",
        "Hammer of Justice",
        "Repentance",
        "Judgement",
        "Crusader Strike",
        "Divine Storm",
        "Shield of Righteousness",
        "Exorcism",
        "Hammer of Wrath",
        "Holy Wrath",
        "Consecration",
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
        ["Main Seal"] = function()
            local _, enabled = GetSetting("autoseal")
            local seal = GetSetting("offseal")
            if enabled and seal and IsSpellKnown(seal) and ni.spell.available(seal) and not ni.player.buff(seal) then
                ni.spell.cast(seal)
                return true
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

            if defensive and IsSpellKnown(7744) and ni.spell.available(7744)
                    and (ni.player.isfleeing() or ni.player.isconfused() or ni.player.issilenced()) then
                ni.spell.cast(7744)
                return true
            end
            if defensive and IsSpellKnown(59752) and ni.spell.available(59752)
                    and (ni.player.isstunned() or ni.player.isfleeing() or ni.player.isconfused()) then
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
        ["Hand of Freedom (Self)"] = function()
            local _, enabled = GetSetting("hofself")
            local delay = GetSetting("hofdelay") or 0.2
            if enabled and ni.spell.available(1044)
                    and (ni.player.isrooted() or ni.player.isfleeing() or ni.player.isconfused())
                    and ni.spell.valid("player", 1044, false, true, true)
                    and GetTime() - (data.paladin.LastFreedomSelf or 0) > delay then
                ni.spell.cast(1044, "player")
                data.paladin.LastFreedomSelf = GetTime()
                return true
            end
        end,
        -----------------------------------
        ["Hand of Freedom (Ally)"] = function()
            local _, enabled = GetSetting("hofally")
            local delay = GetSetting("hofdelay") or 0.2
            if enabled and ni.spell.available(1044) and GetTime() - (data.paladin.LastFreedomAlly or 0) > delay then
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player" and (ni.unit.debufftype(ally, "Root") or ni.unit.debufftype(ally, "Snare"))
                            and ni.spell.valid(ally, 1044, false, true, true) then
                        ni.spell.cast(1044, ally)
                        data.paladin.LastFreedomAlly = GetTime()
                        return true
                    end
                end
            end
        end,
        -----------------------------------
        ["Cleanse (Self)"] = function()
            local _, enabled = GetSetting("cleanseself")
            local mana = GetSetting("purifymp") or 35
            if enabled and ni.player.power() >= mana and ni.spell.available(4987)
                    and ni.unit.debufftype("player", "Poison|Disease|Magic")
                    and ni.spell.valid("player", 4987, false, true, true) then
                ni.spell.cast(4987, "player")
                return true
            end
        end,
        -----------------------------------
        ["Cleanse (Ally)"] = function()
            local _, enabled = GetSetting("cleanseally")
            local mana = GetSetting("cleansemanalimit") or 25
            if enabled and ni.player.power() >= mana and ni.spell.available(4987) then
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player"
                            and ni.unit.debufftype(ally, "Poison|Disease|Magic")
                            and ni.spell.valid(ally, 4987, false, true, true) then
                        ni.spell.cast(4987, ally)
                        return true
                    end
                end
            end
        end,
        -----------------------------------
        ["Turn Evil"] = function()
            local _, enabled = GetSetting("turnevil")
            if enabled and ni.spell.available(10326)
                    and ni.unit.exists("target")
                    and (ni.unit.creaturetype("target") == 3 or ni.unit.creaturetype("target") == 6)
                    and ni.spell.valid("target", 10326, false, true, true) then
                ni.spell.cast(10326, "target")
                return true
            end
        end,
        -----------------------------------
        ["Divine Shield"] = function()
            local value, enabled = GetSetting("bubble")
            if enabled and ni.player.hp() < value and ni.spell.available(642) then
                ni.spell.cast(642)
                return true
            end
        end,
        -----------------------------------
        ["Divine Protection"] = function()
            local value, enabled = GetSetting("divineprot")
            if enabled and ni.player.hp() < value and ni.spell.available(498) and not ni.player.buff(642) then
                ni.spell.cast(498)
                return true
            end
        end,
        -----------------------------------
        ["Lay on Hands"] = function()
            local value, enabled = GetSetting("layon")
            if enabled and ni.player.hp() < value and ni.spell.available(48788)
                    and ni.spell.valid("player", 48788, false, true, true) then
                ni.spell.cast(48788, "player")
                return true
            end
        end,
        -----------------------------------
        ["Hand of Protection (Ally)"] = function()
            local value, enabled = GetSetting("hopally")
            if enabled and ni.spell.available(1022) then
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player" and ni.unit.hp(ally) < value
                            and not ni.unit.debuff(ally, 25771)
                            and ni.spell.valid(ally, 1022, false, true, true) then
                        ni.spell.cast(1022, ally)
                        return true
                    end
                end
            end
        end,
        -----------------------------------
        ["Hand of Sacrifice (Ally)"] = function()
            local value, enabled = GetSetting("handsac")
            if enabled and ni.spell.available(6940) then
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player" and ni.unit.hp(ally) < value
                            and ni.spell.valid(ally, 6940, false, true, true) then
                        ni.spell.cast(6940, ally)
                        return true
                    end
                end
            end
        end,
        -----------------------------------
        ["Divine Sacrifice"] = function()
            local value, enabled = GetSetting("divinesac")
            if enabled and ni.spell.available(64205) then
                local low = 0
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player" and ni.unit.hp(ally) < value then
                        low = low + 1
                    end
                end
                if low >= 1 then
                    ni.spell.cast(64205)
                    return true
                end
            end
        end,
        -----------------------------------
        ["Divine Plea"] = function()
            local _, enabled = GetSetting("plea")
            if enabled and not ni.player.buff(54428) and ni.spell.available(54428) then
                ni.spell.cast(54428)
                return true
            end
        end,
        -----------------------------------
        ["Flash of Light (Self)"] = function()
            local _, enabled = GetSetting("folaow")
            local mana = GetSetting("healmp") or 20
            if enabled and ni.player.power() >= mana and ni.player.hp() < 75 and ni.spell.available(48785)
                    and ni.player.buff(59578) and ni.spell.valid("player", 48785, false, true, true) then
                ni.spell.cast(48785, "player")
                return true
            end
        end,
        -----------------------------------
        ["Flash of Light (Ally)"] = function()
            local value, enabled = GetSetting("woghp")
            local mana = GetSetting("healmp") or 20
            if enabled and ni.player.power() >= mana and ni.spell.available(48785) and ni.player.buff(59578) then
                for i = 1, #ni.members do
                    local ally = ni.members[i].unit
                    if ally ~= "player" and ni.unit.hp(ally) < value and ni.spell.valid(ally, 48785, false, true, true) then
                        ni.spell.cast(48785, ally)
                        return true
                    end
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
        ["Trinkets"] = function()
            if ni.player.slotcastable(13) and ni.player.slotcd(13) == 0 then
                ni.player.useinventoryitem(13)
            elseif ni.player.slotcastable(14) and ni.player.slotcd(14) == 0 then
                ni.player.useinventoryitem(14)
                return true
            end
        end,
        -----------------------------------
        ["Hammer of Justice"] = function()
            local _, enabled = GetSetting("hoj")
            local _, interrupt = GetSetting("hojinterrupt")
            local hp, onfocus = GetSetting("hojfocushp")
            if enabled and ni.spell.available(10308) then
                if interrupt and ni.unit.exists("target") and ni.spell.interrupt("target") and ni.spell.valid("target", 10308, false, true, true) then
                    ni.spell.cast(10308, "target")
                    return true
                end
                if onfocus and ni.unit.exists("focus") and ni.unit.hp("target") <= hp and ni.spell.valid("focus", 10308, false, true, true) then
                    ni.spell.cast(10308, "focus")
                    return true
                end
            end
        end,
        -----------------------------------
        ["Repentance"] = function()
            local _, enabled = GetSetting("repentance")
            local _, interrupt = GetSetting("repentinterrupt")
            local hp, onfocus = GetSetting("repentfocushp")
            if enabled and ni.spell.available(20066) then
                if interrupt and ni.unit.exists("target") and ni.spell.interrupt("target") and ni.spell.valid("target", 20066, false, true, true) then
                    ni.spell.cast(20066, "target")
                    return true
                end
                if onfocus and ni.unit.exists("focus") and ni.unit.hp("target") <= hp and ni.spell.valid("focus", 20066, false, true, true) then
                    ni.spell.cast(20066, "focus")
                    return true
                end
            end
        end,
        -----------------------------------
        ["Judgement"] = function()
            local jmp, jen = GetSetting("jowmp")
            if ni.spell.available(20271) and ni.spell.valid("target", 20271, false, true, true) then
                if jen and ni.player.power() <= jmp and IsSpellKnown(53408) and ni.spell.available(53408) then
                    ni.spell.cast(53408, "target")
                else
                    ni.spell.cast(20271, "target")
                end
                return true
            end
        end,
        -----------------------------------
        ["Crusader Strike"] = function()
            local _, enabled = GetSetting("crusaderstrike")
            if enabled and ni.spell.available(35395) and ni.spell.valid("target", 35395, false, true, true) then
                ni.spell.cast(35395, "target")
                return true
            end
        end,
        -----------------------------------
        ["Divine Storm"] = function()
            local _, enabled = GetSetting("divinestorm")
            if enabled and ni.spell.available(53385) and ni.spell.valid("target", 53385, false, true, true) then
                ni.spell.cast(53385, "target")
                return true
            end
        end,
        -----------------------------------
        ["Shield of Righteousness"] = function()
            local _, enabled = GetSetting("sor")
            if enabled and ni.spell.available(61411) and ni.spell.valid("target", 61411, false, true, true) then
                ni.spell.cast(61411, "target")
                return true
            end
            local _, tv = GetSetting("tv")
            if tv and IsSpellKnown(85256) and ni.spell.available(85256) and ni.spell.valid("target", 85256, false, true, true) then
                ni.spell.cast(85256, "target")
                return true
            end
        end,
        -----------------------------------
        ["Exorcism"] = function()
            local _, enabled = GetSetting("exorcism")
            if enabled and ni.spell.available(48801) and ni.spell.valid("target", 48801, false, true, true) then
                ni.spell.cast(48801, "target")
                return true
            end
        end,
        -----------------------------------
        ["Hammer of Wrath"] = function()
            local _, enabled = GetSetting("how")
            if enabled and ni.spell.available(48806) and ni.spell.valid("target", 48806, false, true, true) and ni.unit.hp("target") < 20 then
                ni.spell.cast(48806, "target")
                return true
            end
        end,
        -----------------------------------
        ["Holy Wrath"] = function()
            local value, enabled = GetSetting("holywrathmp")
            if enabled and ni.player.power() >= value and ni.spell.available(48817) and ni.spell.valid("target", 48817, false, true, true) then
                ni.spell.cast(48817)
                return true
            end
        end,
        -----------------------------------
        ["Consecration"] = function()
            local value, enabled = GetSetting("consecrationmp")
            if enabled and ni.player.power() >= value and ni.spell.available(48819) and ni.spell.valid("target", 48819, false, true, true) then
                ni.spell.cast(48819)
                return true
            end
        end,
        -----------------------------------
        ["Window"] = function()
            if not popup_shown then
                ni.debug.popup("Retribution Paladin PvP Ascension v1.0.0", "Loaded Retri PvP profile for WotLK 3.3.5a")
                popup_shown = true;
            end
        end,
    }

    ni.bootstrap.profile("Retri_PvP_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
    ni.bootstrap.profile("Retri_PvP_DarhangeR", queue, abilities);
end
