local PortToStrokersHouse = {}
PortToStrokersHouse.name = "PortToStrokersHouse"

function PortToStrokersHouse.PortToHouse()
    local houseId = 90

    if zo_strlower(GetDisplayName()) == zo_strlower("@Longstriker") then
        d("Porting to your house!")
        RequestJumpToHouse(houseId, false)
    else
        d("Porting to @Longstriker's house!")
        JumpToSpecificHouse("@Longstriker", houseId, false)
    end
end

function PortToStrokersHouse.OnAddOnLoaded(event, addonName)
    if addonName ~= PortToStrokersHouse.name then return end

    SLASH_COMMANDS["/stroker"] = PortToStrokersHouse.PortToHouse
    EVENT_MANAGER:UnregisterForEvent(PortToStrokersHouse.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(PortToStrokersHouse.name, EVENT_ADD_ON_LOADED, PortToStrokersHouse.OnAddOnLoaded)
