local private_hash_key, public_hash_key = generateKeyPair("rsa", { size = 2048 })

allowedFunctions = { }

function callServerFunction(funcname, ...)
    local funcname = decodeString("rsa", funcname, { key = private_hash_key })

    if not allowedFunctions[funcname] then
        logs_class:log("anticheat", "Security: " .. tostring(getPlayerName(client)) .. " tried to use function " .. tostring(funcname))
        return
    end

    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end

    loadstring([[
        function call_class( ... )

            local arg = { ... }
            if (arg[1]) then
                for key, value in next, arg do arg[key] = tonumber(value) or value end
            end

            return ]] .. tostring(funcname) .. [[(unpack(arg))
        end
    ]])()

    loadstring("return call_class")()(unpack(arg))
end

add_allowed_function = function(funcname)
    allowedFunctions[funcname] = true
end

setup_triggers = function()
    local triggerKeys = anticheat_class:createTriggerStrings("core")
    local triggerHash = public_hash_key

    addEventHandler("onPlayerJoin", root, function() 
        setElementData(source, "triggerKeys", triggerKeys)
        setElementData(source, "triggerHash", triggerHash)
    end)

    for i,v in pairs(triggerKeys) do
        addEvent(v, true)
        addEventHandler(v, resourceRoot , callServerFunction)
    end

    addEventHandler( "onResourceStop", getResourceRootElement(getThisResource()),
        function( resource )
            for i,v in pairs(triggerKeys) do
                removeEventHandler(v, resourceRoot , callServerFunction)
            end
        end
    )

    setTimer(function() 
        
    end,15000,0)
end

callClient = function(thePlayer, funcname, ...)
    local triggerKeys = getElementData(thePlayer, "triggerKeys")
    local triggerHash = getElementData(thePlayer, "triggerHash")

    if(triggerKeys == nil or triggerHash == nil) then return end

    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    
    triggerClientEvent(triggerKeys[math.random(1,10)], resourceRoot , encodeString("rsa", funcname, { key = triggerHash }), unpack(arg))
end