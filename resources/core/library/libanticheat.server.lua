Anticheat = class()

function Anticheat:__init()
    self.triggers = { }

    logs_class:log("server", "libAntiCheat Loaded Successfully.")
end

function Anticheat:createTriggerStrings(resourceName)
    for i,v in pairs(anticheat_class.triggers) do
        if(tostring(resourceName) == tostring(i)) then
            return
        end
    end

    anticheat_class.triggers[resourceName] = { }

    local status = true

    while(#anticheat_class.triggers[resourceName] <= 9) do
        local randomString = core_class:generateRandomString(24)

        if(core_class:getTableCount(anticheat_class.triggers) == 1 and core_class:getTableCount(anticheat_class.triggers[resourceName]) == 0) then
            table.insert(anticheat_class.triggers[resourceName], randomString)
        else
            for i_triggers, v_triggers in pairs(anticheat_class.triggers) do
                for i_strings = 1, #v_triggers do
                    if(core_class:getTableCount(anticheat_class.triggers[resourceName]) >= 10 and v_triggers[i_strings] == randomString) then
                        local status = false
                    end
                end
            end

            if(status) then
                table.insert(anticheat_class.triggers[resourceName], randomString)
            end
        end
    end
    
    return anticheat_class.triggers[resourceName]
end

anticheat_class = Anticheat