-- Copyright (C) 2026 Dahus
-- SPDX-License-Identifier: MIT

-- Compatible with MySQL 8+

-- hive.lua

handlers = {}

-- state for 302
local _objQueue = {}
local _initKey = nil
-- state for 303/309
local _serverId = nil

-- Utility: extract fields respecting nested brackets
local function extractFields(str)
    local fields = {}
    local depth = 0
    local current = ""
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == "[" then depth = depth + 1; current = current .. c
        elseif c == "]" then depth = depth - 1; current = current .. c
        elseif c == ":" and depth == 0 then
            table.insert(fields, current)
            current = ""
        else
            current = current .. c
        end
    end
    return fields
end


-- 101: loadPlayer
handlers[101] = function(params)
    -- Parse: 76561198103578797:1:Kronus:
    local fields = {}
    for field in (params .. ":"):gmatch("([^:]*):") do
        table.insert(fields, field)
    end
    local playerId   = fields[1]
    local serverId   = fields[2]
    local playerName = fields[3]

    -- Check if player exists
    local playerRes = db.query(string.format(
        'SELECT `PlayerName` FROM `Player_DATA` WHERE `PlayerUID` = \'%s\'', playerId))

    if #playerRes == 0 then
        -- New player
        db.execute(string.format(
            'INSERT INTO `Player_DATA` (`PlayerUID`, `PlayerName`) VALUES (\'%s\', \'%s\')',
            playerId, playerName))
        log.info("Created new player " .. playerId .. " name: " .. playerName)
    else
        -- Update name if changed
        if playerRes[1]["PlayerName"] ~= playerName then
            db.execute(string.format(
                'UPDATE `Player_DATA` SET `PlayerName` = \'%s\' WHERE `PlayerUID` = \'%s\'',
                playerName, playerId))
            log.info("Updated name for " .. playerId .. " to " .. playerName)
        end
    end

    -- Get alive character
    local charRes = db.query(string.format([[
            SELECT `CharacterID`, `Worldspace`, `Inventory`, `Backpack`,
            TIMESTAMPDIFF(MINUTE, `Datestamp`, `LastLogin`) AS `survTime`,
            TIMESTAMPDIFF(MINUTE, `LastAte`, NOW()) AS `lastAte`,
            TIMESTAMPDIFF(MINUTE, `LastDrank`, NOW()) AS `lastDrank`,
            `Model`
            FROM `Character_DATA`
            WHERE `PlayerUID` = '%s' AND `Alive` = 1
            ORDER BY `CharacterID` DESC LIMIT 1]], playerId))

    if #charRes > 0 then
        local row = charRes[1]
        local charId     = row["CharacterID"]
        local worldspace = row["Worldspace"] or "[]"
        local inventory  = row["Inventory"] or "[]"
        local backpack   = row["Backpack"] or "[]"
        local survTime   = math.floor(tonumber(row["survTime"]) or 0)
        local lastAte    = math.floor(tonumber(row["lastAte"]) or 0)
        local lastDrank  = math.floor(tonumber(row["lastDrank"]) or 0)
        local model      = row["Model"] or ""
        model = model:gsub('"', '')

        -- Update last login
        db.execute(string.format(
            'UPDATE `Character_DATA` SET `LastLogin` = CURRENT_TIMESTAMP WHERE `CharacterID` = %s', charId))

        return string.format('["PASS",false,"%s",%s,%s,%s,[%d,%d,%d],"%s",0.96]',
            charId, worldspace, inventory, backpack, survTime, lastAte, lastDrank, model)
    else
        -- Get previous char for generation/humanity
        local prevRes = db.query(string.format([[
            SELECT `Generation`, `Humanity`, `Model`
            FROM `Character_DATA`
            WHERE `PlayerUID` = '%s' AND `Alive` = 0
            ORDER BY `CharacterID` DESC LIMIT 1]], playerId))

        local generation = 1
        local humanity   = 2500
        local model      = ""
        if #prevRes > 0 then
            generation = (tonumber(prevRes[1]["Generation"]) or 1) + 1
            humanity   = tonumber(prevRes[1]["Humanity"]) or 2500
            model      = prevRes[1]["Model"] or ""
            model = model:gsub('"', '')
        end

        -- Insert new character
        db.execute(string.format([[
            INSERT INTO `Character_DATA`
            (`PlayerUID`, `InstanceID`, `Worldspace`, `Inventory`, `Backpack`, `Medical`, `Generation`, `Datestamp`, `LastLogin`, `LastAte`, `LastDrank`, `Humanity`)
            VALUES ('%s', %s, '[]', '[]', '[]', '[]', %d, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, %d)]],
            playerId, serverId, generation, humanity))

        -- Get new char id
        local newCharRes = db.query(string.format([[
            SELECT `CharacterID` FROM `Character_DATA`
            WHERE `PlayerUID` = '%s' AND `Alive` = 1
            ORDER BY `CharacterID` DESC LIMIT 1]], playerId))

        if #newCharRes == 0 then
            return '["ERROR"]'
        end

        local charId = newCharRes[1]["CharacterID"]
        log.info("Created new character " .. charId .. " for " .. playerName)

        return string.format('["PASS",true,"%s","[]","[]","[]",[0,0,0],"%s",0.96]',
            charId, model)
    end
end

-- 102: loadCharacterDetails
handlers[102] = function(params)
    local charId = params:match("^([^:]+)")

    local res = db.query(string.format([[
        SELECT `Worldspace`, `Medical`, `Generation`, `KillsZ`, `HeadshotsZ`, `KillsH`, `KillsB`, `CurrentState`, `Humanity`
        FROM `Character_DATA`
        WHERE `CharacterID` = %s]], charId))

    if #res == 0 then
        return '["ERROR"]'
    end

    local row = res[1]
    local worldspace   = row["Worldspace"] or "[]"
    local medical      = row["Medical"] or "[]"
    local killsZ       = row["KillsZ"] or 0
    local headshotsZ   = row["HeadshotsZ"] or 0
    local killsH       = row["KillsH"] or 0
    local killsB       = row["KillsB"] or 0
    local currentState = row["CurrentState"] or "[]"
    local humanity     = row["Humanity"] or 2500

    return string.format('["PASS",%s,[%s,%s,%s,%s],%s,%s,%s]',
        medical, killsZ, headshotsZ, killsH, killsB, currentState, worldspace, humanity)
end

-- 103: recordCharacterLogin
handlers[103] = function(params)
    local fields = {}
    for field in params:gmatch("([^:]*):") do
        table.insert(fields, field)
    end
    local playerId   = fields[1]
    local charId     = fields[2]
    local action     = fields[3]

    db.execute(string.format([[
        INSERT INTO `Player_LOGIN` (`PlayerUID`, `CharacterID`, `Datestamp`, `Action`)
        VALUES ('%s', %s, CURRENT_TIMESTAMP, %s))]], playerId, charId, action))

    return '["PASS"]'
end

-- 201: playerUpdate
handlers[201] = function(params)
    local charId = params:match("^([^:]+):")
    local rest = params:sub(#charId + 2)

    local sets = {}

    local f = extractFields(rest)

    -- worldspace
    if f[1] and f[1] ~= "" and f[1] ~= "[]" then
        table.insert(sets, string.format('"Worldspace" = \'%s\'', f[1]))
    end
    -- inventory
    if f[2] and f[2] ~= "" and f[2] ~= "[]" then
        table.insert(sets, string.format('"Inventory" = \'%s\'', f[2]))
    end
    -- backpack
    if f[3] and f[3] ~= "" and f[3] ~= "[]" then
        table.insert(sets, string.format('"Backpack" = \'%s\'', f[3]))
    end
    -- medical
    if f[4] and f[4] ~= "" and f[4] ~= "[]" then
        table.insert(sets, string.format('"Medical" = \'%s\'', f[4]))
    end
    -- justAte
    if f[5] == "true" then
        table.insert(sets, '"LastAte" = CURRENT_TIMESTAMP')
    end
    -- justDrank
    if f[6] == "true" then
        table.insert(sets, '"LastDrank" = CURRENT_TIMESTAMP')
    end
    -- killsZ
    if f[7] and tonumber(f[7]) and tonumber(f[7]) > 0 then
        table.insert(sets, string.format('"KillsZ" = ("KillsZ" + %d)', tonumber(f[7])))
    end
    -- headshotsZ
    if f[8] and tonumber(f[8]) and tonumber(f[8]) > 0 then
        table.insert(sets, string.format('"HeadshotsZ" = ("HeadshotsZ" + %d)', tonumber(f[8])))
    end
    -- distanceFoot
    if f[9] and tonumber(f[9]) and tonumber(f[9]) > 0 then
        table.insert(sets, string.format('"DistanceFoot" = ("DistanceFoot" + %d)', tonumber(f[9])))
    end
    -- duration
    if f[10] and tonumber(f[10]) and tonumber(f[10]) > 0 then
        table.insert(sets, string.format('"Duration" = ("Duration" + %d)', tonumber(f[10])))
    end
    -- currentState
    if f[11] and f[11] ~= "" and f[11] ~= "[]" then
        table.insert(sets, string.format('"CurrentState" = \'%s\'', f[11]))
    end
    -- killsH
    if f[12] and tonumber(f[12]) and tonumber(f[12]) > 0 then
        table.insert(sets, string.format('"KillsH" = ("KillsH" + %d)', tonumber(f[12])))
    end
    -- killsB
    if f[13] and tonumber(f[13]) and tonumber(f[13]) > 0 then
        table.insert(sets, string.format('"KillsB" = ("KillsB" + %d)', tonumber(f[13])))
    end
    -- model
    if f[14] and f[14] ~= "" then
        table.insert(sets, string.format('"Model" = \'%s\'', f[14]))
    end
    -- humanity
    if f[15] and tonumber(f[15]) and tonumber(f[15]) ~= 0 then
        local h = tonumber(f[15])
        if h > 0 then
            table.insert(sets, string.format('"Humanity" = ("Humanity" + %d)', h))
        else
            table.insert(sets, string.format('"Humanity" = ("Humanity" - %d)', math.abs(h)))
        end
    end

    if #sets > 0 then
        db.execute(string.format('UPDATE `Character_DATA` SET %s WHERE `CharacterID` = %s',
            table.concat(sets, " , "), charId))
    end

    return '["PASS"]'
end

-- 202: playerDeath
handlers[202] = function(params)
    local fields = {}
    for field in params:gmatch("([^:]*):") do
        table.insert(fields, field)
    end
    local charId   = fields[1]
    local duration = fields[2] or 0

    db.execute(string.format([[
        UPDATE `Character_DATA`
        SET `Alive` = 0, `LastLogin` = DATE_SUB(CURRENT_TIMESTAMP, INTERVAL %s MINUTE)
        WHERE `CharacterID` = %s AND `Alive` = 1]], duration, charId))

    return '["PASS"]'
end

-- 203: playerInit
handlers[203] = function(params)
    local f = extractFields(params)
    local charId    = f[1]
    local inventory = f[2] or "[]"
    local backpack  = f[3] or "[]"

    db.execute(string.format([[
        UPDATE `Character_DATA`
        SET `Inventory` = '%s', `Backpack` = '%s'
        WHERE `CharacterID` = %s]], inventory, backpack, charId))

    return '["PASS"]'
end

-- 302: streamObjects
handlers[302] = function(params)
    local fields = {}
    for field in (params):gmatch("([^:]*):") do
        table.insert(fields, field)
    end
    local serverId = fields[1]
    _serverId = serverId

    if #_objQueue == 0 then
        if _initKey == nil then
            -- загружаем объекты
            local objRes = db.query(string.format([[
                SELECT `ObjectID`, `Classname`, `CharacterID`, `Worldspace`, `Inventory`, `Hitpoints`, `Fuel`, `Damage`
                FROM `Object_DATA`
                WHERE `Instance` = %s AND `Classname` IS NOT NULL]], serverId))

            for _, row in ipairs(objRes) do
                local obj = string.format('["OBJ","%s","%s","%s",%s,%s,%s,%s,%s]',
                    row["ObjectID"], row["Classname"], row["CharacterID"], row["Worldspace"],
                    row["Inventory"] or "[]", row["Hitpoints"] or "[]",
                    row["Fuel"] or 0, row["Damage"] or 0)
                table.insert(_objQueue, obj)
            end

            -- генерируем ключ
            _initKey = tostring(os.time()) .. tostring(math.random(100000, 999999))

            return string.format('["ObjectStreamStart",%d,"%s"]', #_objQueue, _initKey)
        else
            return '["ERROR","Instance already initialized"]'
        end
    else
        local obj = table.remove(_objQueue, 1)
        return obj
    end
end

-- 303: objectInventory (by ObjectID)
handlers[303] = function(params)
    local f = extractFields(params)
    local objectId  = f[1] or 0
    local inventory = f[2] or "[]"

    if tonumber(objectId) ~= 0 then
        db.execute(string.format([[
            UPDATE `Object_DATA`
            SET `Inventory` = '%s'
            WHERE `ObjectID` = %s AND `Instance` = %s]],
            inventory, objectId, _serverId))
    end

    return '["PASS"]'
end

-- 304: objectDelete (by ObjectID)
handlers[304] = function(params)
    local f = extractFields(params)
    local objectId = f[1] or 0

    if tonumber(objectId) ~= 0 then
        db.execute(string.format([[
            DELETE FROM `Object_DATA`
            WHERE `ObjectID` = %s AND `Instance` = %s]],
            objectId, _serverId))
    end

    return '["PASS"]'
end

-- 305: vehicleMoved
handlers[305] = function(params)
    local f = extractFields(params)
    local objectId   = f[1] or 0
    local worldspace = f[2] or "[]"
    local fuel       = f[3] or 0

    if tonumber(objectId) > 0 then
        db.execute(string.format([[
            UPDATE `Object_DATA`
            SET `Worldspace` = '%s', `Fuel` = %s
            WHERE `ObjectID` = %s AND `Instance` = %s]],
            worldspace, fuel, objectId, _serverId))
    end

    return '["PASS"]'
end

-- 306: vehicleDamaged
handlers[306] = function(params)
    local f = extractFields(params)
    local objectId  = f[1] or 0
    local hitpoints = f[2] or "[]"
    local damage    = f[3] or 0

    if tonumber(objectId) > 0 then
        db.execute(string.format([[
            UPDATE `Object_DATA`
            SET `Hitpoints` = '%s', `Damage` = %s
            WHERE `ObjectID` = %s AND `Instance` = %s]],
            hitpoints, damage, objectId, _serverId))
    end

    return '["PASS"]'
end

-- 307: getDateTime
handlers[307] = function(params)
    local t = os.date("*t")
    return string.format('["PASS",[%d,%d,%d,%d,%d]]',
        t.year, t.month, t.day, t.hour, t.min)
end

-- 308: objectPublish
handlers[308] = function(params)
    local f = extractFields(params)
    local serverId    = f[1]
    local className   = f[2]
    local damage      = f[3] or 0
    local charId      = f[4] or 0
    local worldspace  = f[5] or "[]"
    local inventory   = f[6] or "[]"
    local hitpoints   = f[7] or "[]"
    local fuel        = f[8] or 0
    local uniqueId    = f[9] or 0

    db.execute(string.format([[
        INSERT INTO `Object_DATA`
        (`ObjectUID`, `Instance`, `Classname`, `Damage`, `CharacterID`, `Worldspace`, `Inventory`, `Hitpoints`, `Fuel`, `Datestamp`)
        VALUES (%s, %s, '%s', %s, %s, '%s', '%s', '%s', %s, CURRENT_TIMESTAMP)]],
        uniqueId, serverId, className, damage, charId, worldspace, inventory, hitpoints, fuel))

    return '["PASS"]'
end

-- 309: objectInventory (by ObjectUID)
handlers[309] = function(params)
    local f = extractFields(params)
    local objectUID = f[1] or 0
    local inventory = f[2] or "[]"

    if tonumber(objectUID) ~= 0 then
        db.execute(string.format([[
            UPDATE `Object_DATA`
            SET `Inventory` = '%s'
            WHERE `ObjectUID` = %s AND `Instance` = %s]],
            inventory, objectUID, _serverId))
    end

    return '["PASS"]'
end


-- 310: objectDelete (by ObjectUID)
handlers[310] = function(params)
    local f = extractFields(params)
    local objectUID = f[1] or 0

    if tonumber(objectUID) ~= 0 then
        db.execute(string.format([[
            DELETE FROM `Object_DATA`
            WHERE `ObjectUID` = %s AND `Instance` = %s]],
            objectUID, _serverId))
    end

    return '["PASS"]'
end

-- 399: serverShutdown
handlers[399] = function(params)
    local f = extractFields(params)
    local theirKey = f[1] or ""

    if _initKey and _initKey ~= "" and theirKey == _initKey then
        log.info("Shutting down HiveExt instance")
        return "__SHUTDOWN__"
    end

    return '["ERROR"]'
end

-- 500: db.query(sql) -> rows
handlers[500] = function(params)
    local rows = db.query(params)
    if not rows then
        return '["ERROR"]'
    end
    -- Serialize rows as SQF array of arrays
    local result = {}
    for _, row in ipairs(rows) do
        local cells = {}
        for k, v in pairs(row) do
            table.insert(cells, string.format('"%s"', tostring(v):gsub('"', '\\"')))
        end
        table.insert(result, "[" .. table.concat(cells, ",") .. "]")
    end
    return '["PASS",[' .. table.concat(result, ",") .. ']]'
end

-- 501: db.execute(sql) -> bool
handlers[501] = function(params)
    local ok = db.execute(params)
    if ok then
        return '["PASS"]'
    else
        return '["ERROR"]'
    end
end

-- 502: db.queryAsync(sql) -> token
handlers[502] = function(params)
    local token = db.queryAsync(params)
    return string.format('["PASS",%d]', token)
end

-- 503: db.queryStatus(token) -> 0/1/-1
handlers[503] = function(params)
    local token = tonumber(params)
    if not token then return '["ERROR"]' end
    local status = db.queryStatus(token)
    return string.format('["PASS",%d]', status)
end

-- 504: db.queryFetch(token) -> next row or nil
handlers[504] = function(params)
    local token = tonumber(params)
    if not token then return '["ERROR"]' end
    local row = db.queryFetch(token)
    if not row then
        return '["DONE"]'
    end
    local cells = {}
    for k, v in pairs(row) do
        table.insert(cells, string.format('"%s"', tostring(v):gsub('"', '\\"')))
    end
    return '["PASS",[' .. table.concat(cells, ",") .. ']]'
end

-- 505: db.queryClose(token) -> bool
handlers[505] = function(params)
    local token = tonumber(params)
    if not token then return '["ERROR"]' end
    local ok = db.queryClose(token)
    if ok then
        return '["PASS"]'
    else
        return '["ERROR"]'
    end
end