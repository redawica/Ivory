local queue = {
    "pause",
    "fish",
}

local Fishing = GetSpellInfo(7620)
local offset
if ni.vars.build == 40300 then
    offset = 0xD4
elseif ni.vars.build > 40300 then
    offset = 0xCC
else
    offset = 0xBC
end

local functionSent = 0
local failedBobberReads = 0
local lastCast = 0
local recastAfter = 1.2
local maxFailedReads = 4

local localeBobbers = {
    ["Fishing Bobber"] = true,
    ["Поплавок"] = true,
    ["Corcho de pesca"] = true,
}

local function IsBobberName(name)
    return name and localeBobbers[name] == true
end

local function FindMyBobber()
    local playerguid = UnitGUID("player")
    for _, v in pairs(ni.objects) do
        if type(v) == "table" and IsBobberName(v.name) then
            local creator = v:creator()
            if creator == playerguid then
                return v.guid
            end
        end
    end
    return nil
end

local abilities = {
    ["pause"] = function()
        if IsMounted()
            or UnitInVehicle("player")
            or UnitIsDeadOrGhost("player")
            or UnitCastingInfo("player")
            or UnitAffectingCombat("player")
            or ni.player.ismoving() then
            return true
        end
    end,

    ["fish"] = function()
        if ni.player.islooting() then
            return
        end

        if UnitChannelInfo("player") then
            if GetTime() - functionSent > 0.2 then
                local guid = FindMyBobber()
                if guid then
                    local ptr = ni.memory.objectpointer(guid)
                    if ptr then
                        local result = ni.memory.read("byte", ptr, offset)
                        if result == 1 then
                            failedBobberReads = 0
                            ni.player.interact(guid)
                            functionSent = GetTime()
                            return true
                        end
                    end
                    failedBobberReads = failedBobberReads + 1
                else
                    failedBobberReads = failedBobberReads + 1
                end

                if failedBobberReads >= maxFailedReads and GetTime() - lastCast > recastAfter then
                    failedBobberReads = 0
                    ni.spell.stopchanneling()
                    lastCast = GetTime()
                    return true
                end
            end
            return
        end

        if FindMyBobber() then
            return
        end

        if GetTime() - lastCast < recastAfter then
            return
        end

        lastCast = GetTime()
        ni.spell.delaycast(Fishing, nil, 1.5)
        ni.utils.resetlasthardwareaction()
    end,
}

ni.bootstrap.profile("Fisher", queue, abilities)
