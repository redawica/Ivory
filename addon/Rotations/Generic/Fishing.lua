local queue = {
	"action check",
	"combat check",
	"lure check",
	"pause",
	"fish",
}

local enables = {
	lure = true,
	weapon_swap = false,
	pole_check = false,
}

local values = {
	lure = 6532, -- Bright Baubles
	failed_attempts = 10,
	cast_delay = 1.5,
	recast_after = 2.0,
}

local inputs = {
	pole = "6256",
	main = "",
	off = "",
	bobber = "Fishing Bobber",
	pool = "School"
}

local menus = {
	full_bags = "AFK",
}

local function GUICallback(key, item_type, value)
	if item_type == "enabled" then
		enables[key] = value
	elseif item_type == "value" then
		values[key] = value
	elseif item_type == "input" then
		inputs[key] = value
	elseif item_type == "menu" then
		menus[key] = value
	end
end

local items = {
	settingsfile = "ni_fishing.xml",
	callback = GUICallback,
	{ type = "title", text = "Fish Bot (Automated)" },
	{ type = "separator" },
	{
		type = "entry",
		text = "Auto Lure (Bright Baubles by default)",
		enabled = enables["lure"],
		tooltip = "Automatically apply lure before fishing",
		value = values["lure"],
		width = 50,
		key = "lure",
	},
	{
		type = "entry",
		text = "Auto Swap Weapons for Combat",
		enabled = enables["weapon_swap"],
		tooltip = "Swap to combat weapons in combat and back to pole out of combat",
		key = "weapon_swap"
	},
	{ type = "title", text = "Fishing Pool/School Name" },
	{ type = "input", value = inputs["pool"], width = 140, height = 15, key = "pool" },
	{ type = "title", text = "Fishing Bobber Name" },
	{ type = "input", value = inputs["bobber"], width = 140, height = 15, key = "bobber" },
	{
		type = "entry",
		text = "Failed bobber reads before recast",
		enabled = true,
		value = values["failed_attempts"],
		width = 50,
		key = "failed_attempts",
	},
	{
		type = "entry",
		text = "Delay between casts",
		enabled = true,
		value = values["cast_delay"],
		width = 50,
		key = "cast_delay",
	},
	{
		type = "entry",
		text = "Minimum recast delay",
		enabled = true,
		value = values["recast_after"],
		width = 50,
		key = "recast_after",
	},
	{
		type = "entry",
		text = "Check if pole equipped",
		enabled = enables["pole_check"],
		key = "pole_check"
	},
	{ type = "title", text = "Fishing Pole ID" },
	{ type = "input", value = inputs["pole"], width = 100, height = 15, key = "pole" },
	{ type = "title", text = "Main Hand ID" },
	{ type = "input", value = inputs["main"], width = 100, height = 15, key = "main" },
	{ type = "title", text = "Off Hand ID" },
	{ type = "input", value = inputs["off"], width = 100, height = 15, key = "off" },
	{ type = "title", text = "What to do on full bags?" },
	{
		type = "dropdown",
		menu = {
			{ selected = (menus["full_bags"] == "AFK"), value = "AFK" },
			{ selected = (menus["full_bags"] == "Hearthstone"), value = "Hearthstone" },
			{ selected = (menus["full_bags"] == "Logout"), value = "Logout" },
		},
		key = "full_bags",
	},
}

local function FullBags()
	local fullbags = 0
	for i = 0, 4 do
		if GetContainerNumFreeSlots(i) == 0 then
			fullbags = fullbags + 1
		end
	end
	return fullbags == 5
end

local localeDefaults = {
	enUS = { bobber = "Fishing Bobber", pool = "School" },
	ruRU = { bobber = "Поплавок", pool = "Косяк" },
	esES = { bobber = "Corcho de pesca", pool = "Banco" },
	esMX = { bobber = "Corcho de pesca", pool = "Banco" },
}

local function IsKnownLocaleValue(value, field)
	for _, defaults in pairs(localeDefaults) do
		if defaults[field] == value then
			return true
		end
	end
	return false
end

local function ResolveLocaleInputs()
	local locale = GetLocale()
	local defaults = localeDefaults[locale] or localeDefaults.enUS
	if not inputs["bobber"] or inputs["bobber"] == "" or IsKnownLocaleValue(inputs["bobber"], "bobber") then
		inputs["bobber"] = defaults.bobber
	end
	if not inputs["pool"] or inputs["pool"] == "" or IsKnownLocaleValue(inputs["pool"], "pool") then
		inputs["pool"] = defaults.pool
	end
end

local function IsBobberName(name)
	if not name then return false end
	if name == inputs["bobber"] then return true end
	for _, defaults in pairs(localeDefaults) do
		if name == defaults.bobber then
			return true
		end
	end
	return false
end

local function OnLoad()
	ResolveLocaleInputs()
	ni.GUI.AddFrame("Fishing", items)
end

local function OnUnload()
	ni.GUI.DestroyFrame("Fishing")
end

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
local lureApplied = 0
local failedBobberReads = 0
local lastCast = 0
local castStart = 0

local function FindMyBobber()
	local playerguid = UnitGUID("player")
	for k, v in pairs(ni.objects) do
		if type(k) == "string" and type(v) == "table" and IsBobberName(v.name) then
			local creator = v:creator()
			if creator == playerguid then
				return v.guid
			end
		end
	end
	return nil
end

local abilities = {
	["action check"] = function()
		if FullBags() then
			local action = menus["full_bags"]
			if action == "AFK" then
				ni.frames.floatingtext:message("Bags are full, time to AFK!")
				ni.vars.profiles.enabled = false
			elseif action == "Hearthstone" then
				if not UnitAffectingCombat("player") and not UnitCastingInfo("player") and not UnitChannelInfo("player") then
					ni.player.useitem(6948)
					ni.frames.floatingtext:message("Bags are full, time to go home!")
					ni.vars.profiles.enabled = false
				end
			elseif action == "Logout" then
				if not UnitAffectingCombat("player") then
					ni.player.runtext("/logout")
					ni.frames.floatingtext:message("Bags are full, time to logout!")
					ni.vars.profiles.enabled = false
				end
			end
		end
	end,

	["combat check"] = function()
		if enables["weapon_swap"] and not UnitIsDeadOrGhost("player") then
			local pole = tonumber(inputs["pole"])
			local mh = tonumber(inputs["main"])
			local oh = tonumber(inputs["off"])
			if pole and mh then
				if UnitAffectingCombat("player") then
					if IsEquippedItem(pole) then
						EquipItemByName(mh)
						if oh then EquipItemByName(oh) end
						return true
					end
				else
					if not IsEquippedItem(pole) and not IsEquippedItem(mh) and not ni.player.ismoving() then
						EquipItemByName(pole)
						return true
					end
				end
			end
		end
	end,

	["lure check"] = function()
		if not enables["lure"] then return end
		if GetTime() - lureApplied <= 2 then return end

		local pole = tonumber(inputs["pole"])
		if pole and IsEquippedItem(pole) and not UnitAffectingCombat("player") then
			local hasEnchant = GetWeaponEnchantInfo()
			local lureId = tonumber(values["lure"]) or 6532
			if not hasEnchant and ni.player.hasitem(lureId) and ni.player.itemcd(lureId) == 0 then
				lureApplied = GetTime()
				ni.spell.stopcasting()
				ni.spell.stopchanneling()
				ni.player.useitem(lureId)
				ni.player.useinventoryitem(16)
				ni.player.runtext("/click StaticPopup1Button1")
				return true
			end
		end
	end,

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
		if enables["pole_check"] then
			local pole = tonumber(inputs["pole"])
			if pole and not IsEquippedItem(pole) then
				return
			end
		end
		if ni.player.islooting() then return end

		local castDelay = tonumber(values["cast_delay"]) or 1.5
		local recastAfter = tonumber(values["recast_after"]) or 1.2
		if castDelay < 0 then castDelay = 0 end
		if recastAfter < 0.4 then recastAfter = 0.4 end

		if UnitChannelInfo("player") then
			if castStart == 0 then
				castStart = GetTime()
			end
			if GetTime() - functionSent > 0.35 then
				local guid = FindMyBobber()
				if guid then
					local ptr = ni.memory.objectpointer(guid)
					if ptr then
						local result = ni.memory.read("byte", ptr, offset)
						if result == 1 then
							failedBobberReads = 0
							ni.player.interact(guid)
							functionSent = GetTime()
							castStart = 0
							return true
						end
					end
					if GetTime() - castStart >= 4 then
						failedBobberReads = failedBobberReads + 1
					end
				else
					if GetTime() - castStart >= 4 then
						failedBobberReads = failedBobberReads + 1
					end
				end
				local maxReads = tonumber(values["failed_attempts"]) or 4
				if maxReads < 1 then maxReads = 1 end
				if failedBobberReads >= maxReads and GetTime() - castStart > 6 and GetTime() - lastCast > recastAfter then
					failedBobberReads = 0
					ni.spell.stopchanneling()
					lastCast = GetTime()
					castStart = 0
					return true
				end
			end
			return
		end
		castStart = 0

		local activeBobber = FindMyBobber()
		if activeBobber then
			return
		end

		for k, v in pairs(ni.objects) do
			if type(v) == "table" and v.name ~= nil and string.match(v.name, inputs["pool"]) then
				local dist = ni.player.distance(k)
				if dist and dist < 20 then
					ni.player.lookat(k)
					break
				end
			end
		end

		if GetTime() - lastCast < recastAfter then
			return
		end
		lastCast = GetTime()
		castStart = 0
		failedBobberReads = 0
		ni.spell.delaycast(Fishing, nil, castDelay)
		ni.utils.resetlasthardwareaction()
	end,
}

ni.bootstrap.profile("Fishing", queue, abilities, OnLoad, OnUnload)
