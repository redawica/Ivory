local queue = {
    "pause",
    "disenchant",
}

local enables = {
    auto = true,
}

local values = {
    max_item_level = 200,
    min_quality = 2,
    max_quality = 4,
}

local function GUICallback(key, item_type, value)
    if item_type == "enabled" then
        enables[key] = value
    elseif item_type == "value" then
        values[key] = value
    end
end

local items = {
    settingsfile = "ni_disenchant.xml",
    callback = GUICallback,
    { type = "title", text = "Disenchant (Automated)" },
    { type = "separator" },
    { type = "entry", text = "Enable Auto Disenchant", enabled = enables.auto, key = "auto" },
    { type = "entry", text = "Max item level", enabled = true, value = values.max_item_level, min = 1, max = 300, step = 1, key = "max_item_level" },
    { type = "entry", text = "Min quality (2=green)", enabled = true, value = values.min_quality, min = 2, max = 4, step = 1, key = "min_quality" },
    { type = "entry", text = "Max quality (4=epic)", enabled = true, value = values.max_quality, min = 2, max = 4, step = 1, key = "max_quality" },
}

local function OnLoad()
    ni.GUI.AddFrame("Disenchant", items)
end

local function OnUnload()
    ni.GUI.DestroyFrame("Disenchant")
end

local lastAction = 0
local disenchantSpell = GetSpellInfo(13262)

local function IsDisenchantable(link)
    if not link then return false end
    local _, _, quality, itemLevel, _, _, _, _, equipLoc = GetItemInfo(link)
    if not quality or not itemLevel then return false end

    local minQ = tonumber(values.min_quality) or 2
    local maxQ = tonumber(values.max_quality) or 4
    local maxIlvl = tonumber(values.max_item_level) or 200

    if quality < minQ or quality > maxQ then return false end
    if itemLevel > maxIlvl then return false end

    if equipLoc and equipLoc ~= "" then
        return true
    end

    return false
end

local abilities = {
    ["pause"] = function()
        if IsMounted()
            or UnitInVehicle("player")
            or UnitIsDeadOrGhost("player")
            or UnitAffectingCombat("player")
            or ni.player.ismoving()
            or UnitCastingInfo("player")
            or UnitChannelInfo("player") then
            return true
        end
    end,

    ["disenchant"] = function()
        if not enables.auto then return false end
        if GetTime() - lastAction < 1.0 then return false end
        if not ni.spell.available(13262) then return false end

        for bag = 0, 4 do
            local slots = GetContainerNumSlots(bag) or 0
            for slot = 1, slots do
                local link = GetContainerItemLink(bag, slot)
                if IsDisenchantable(link) then
                    local target = string.format("%d %d", bag, slot)
                    if ni.spell.cast(disenchantSpell) then
                        ni.player.runtext("/use " .. target)
                        lastAction = GetTime()
                        return true
                    end
                end
            end
        end
        return false
    end,
}

ni.bootstrap.profile("Disenchant", queue, abilities, OnLoad, OnUnload)
