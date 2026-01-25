StrokersConsortium = {
    name = "StrokersConsortium",
    version = "1.2",

    defaults = {
        status = true,
    },
}

local function onAddOnLoaded(event, addonName)
    if addonName ~= StrokersConsortium.name then return end

    StrokersConsortium.vars = ZO_SavedVars:NewAccountWide("StrokersConsortiumSavedVariables", 1, nil,
        StrokersConsortium.defaults)

    SLASH_COMMANDS["/stroker"] = StrokersConsortium.PortToHouse
    SLASH_COMMANDS["/encountertoggle"] = StrokersConsortium.SlashCommandHandler

    EVENT_MANAGER:UnregisterForEvent(StrokersConsortium.name, EVENT_ADD_ON_LOADED)
    EVENT_MANAGER:RegisterForEvent(StrokersConsortium.name, EVENT_PLAYER_ACTIVATED, StrokersConsortium.OnPlayerActivated)

    ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_ENCOUNTER_LOG", "Toggle Encounter Log")
end

function StrokersConsortium.PortToHouse()
    local houseId = 90

    if GetDisplayName() == ("@Longstriker") then
        d("Porting to your house!")
        RequestJumpToHouse(houseId, false)
    else
        d("Porting to @Longstriker's house!")
        JumpToSpecificHouse("@Longstriker", houseId, false)
    end
end

function StrokersConsortium.SlashCommandHandler(command)
    command = string.lower(command)

    if (command == "status") then
        StrokersConsortium.vars.status = not StrokersConsortium.vars.status
        CHAT_ROUTER:AddSystemMessage(string.format(
            "[%s] Status Message: %s", StrokersConsortium.name,
            GetString(StrokersConsortium.vars.status and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
        ))
    else
        CHAT_ROUTER:AddSystemMessage(string.format("[%s]", StrokersConsortium.name))
        CHAT_ROUTER:AddSystemMessage(
            "/encountertoggle status - Prints a status message upon loading into a raid/arena/dungeon")
    end
end

function StrokersConsortium.ToggleLogging(value)
    local toggle = (value == nil) and not IsEncounterLogEnabled() or value
    SetEncounterLogEnabled(toggle)
    StrokersConsortium.LogPrint()
end

function StrokersConsortium.LogPrint()
    if IsEncounterLogEnabled() then
        CHAT_ROUTER:AddSystemMessage("Encounter log enabled.")
    else
        CHAT_ROUTER:AddSystemMessage("Encounter log disabled.")
    end
end

function StrokersConsortium.LogStatus()
    if IsEncounterLogEnabled() then
        CHAT_ROUTER:AddSystemMessage("Encounter log is active.")
    else
        CHAT_ROUTER:AddSystemMessage("Encounter log is inactive.")
    end
end

function StrokersConsortium.OnPlayerActivated(event)
    if (StrokersConsortium.vars.status == false) then
        return
    end

    local current_instance = GetCurrentZoneDungeonDifficulty()

    if current_instance ~= DUNGEON_DIFFICULTY_NONE then
        if current_instance == DUNGEON_DIFFICULTY_VETERAN or current_instance == DUNGEON_DIFFICULTY_NORMAL then
            StrokersConsortium.LogStatus()
        end
    end
end

EVENT_MANAGER:RegisterForEvent(StrokersConsortium.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
