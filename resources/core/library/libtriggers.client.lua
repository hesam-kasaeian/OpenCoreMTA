callServer = function(funcname, ...)
    local triggerKeys = getElementData(localPlayer, "triggerKeys")
    local triggerHash = getElementData(localPlayer, "triggerHash")

    if(triggerKeys == nil or triggerHash == nil) then return end

    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    
    triggerServerEvent(triggerKeys[math.random(1,10)], resourceRoot , encodeString("rsa", funcname, { key = triggerHash }), unpack(arg))
end