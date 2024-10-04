Logs = class()

function Logs:__init()
    local logFiles = {
        ["server"]    = "- IR:VC Server Logs:",
        ["mysql"]     = "- IR:VC MySQL Logs:",
        ["socket"]    = "- IR:VC Socket Logs:",
        ["anticheat"] = "- IR:VC Anticheat Logs:"
    }

    for i,v in pairs(logFiles) do
        if(not fileExists((":%s/%s"):format("core","logs/" .. i .. ".log"))) then
            local createdFile = fileCreate((":%s/%s"):format("core","logs/" .. i .. ".log"))
            if(createdFile) then
                fileWrite(createdFile,  v .. "\n")
            end
    
            destroyElement(createdFile)
        end
    end
end

function Logs:log(type,message,onlyConsole)
    if(not onlyConsole) then
        onlyConsole = false
    end

    if(onlyConsole) then
        local time       = getRealTime()
        local hours      = time.hour
        local minutes    = time.minute
        local seconds    = time.second
        print(type .. " -> [" .. string.format("%02d:%02d:%02d",  hours, minutes, seconds) .. "] IRVC-Logs: " .. message)

        return true
    end

    if(fileExists((":%s/%s"):format("core","logs/" .. type .. ".log"))) then
        local file = fileOpen((":%s/%s"):format("core","logs/" .. type .. ".log"))
        
        if(file) then
            fileSetPos( file, fileGetSize( file ) )
            local time       = getRealTime()
            local hours      = time.hour
            local minutes    = time.minute
            local seconds    = time.second

            print(type .. " -> [" .. string.format("%02d:%02d:%02d",  hours, minutes, seconds) .. "] IRVC-Logs: " .. message)
            fileWrite(file, "[" .. string.format("%02d:%02d:%02d",  hours, minutes, seconds) .. "] IRVC-Logs: " .. message .. "\n")
            fileFlush(file)
            fileClose(file)

            return true
        else
            return false
        end
    else
        return false
    end
end

logs_class = Logs()