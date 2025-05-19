if GetResourceState('hype_core') ~= 'started' then
    return
end
local core = {}
local success, hype = pcall(function ()
    local obj = exports.hype_core:getSharedObject()
    return obj
end)

if not success then return end

local function createPlayerObject(player)
    return {
        identifier = player.citizenid,
        source = player.source,
        name = player.name,
        job = {
            name = player.job.name,
            grade = player.job.grade
        },
        removeMoney = function (type, amount, reason)
            type = type == 'cash' and 'money' or type
            player.removeAccountMoney(type, amount, reason)
            return true
        end,
        addMoney = function (type, amount, reason)
            type = type == 'cash' and 'money' or type
            player.addAccountMoney(type, amount, reason)
            return true
        end,
        getMoney = function (type)
            type = type == 'cash' and 'money' or type
            return player.getAccount(type).money
        end,
    }
end

--- Get Framework Player Data By Source
---@param source number | string | integer
function core.GetPlayer(source)
    if source == '' then return end
    local player = hype.GetPlayerFromId(source)
    if not player then return end
    return createPlayerObject(player)
end

--- Get Framework Player Data By Identifier
---@param identifier string
function core.GetPlayerById(identifier)
    if identifier == '' then return end
    local player = hype.GetPlayerFromIdentifier(identifier)
    if not player then return end
    return createPlayerObject(player)
end

function core.GetJobs()
    local jobs = {}
    hype.RefreshJobs()
    local frameworkJobs = hype.GetJobs()
    for jobName, job in pairs(frameworkJobs) do
        jobs[jobName] = {
            label = job.label,
            name = jobName
        }
    end

    return jobs
end

function core.GetGangs()
    return {}
end

--- On Framework Player Loaded
---@param cb function
function core.onPlayerLoad(cb)
    AddEventHandler('esx:playerLoaded', function (playerId, xPlayer, isNew)
        cb(xPlayer.citizenid)
    end)
end

--- On Resource Start To Load Player Data
---@param cb function
function core.onResourceStart(cb)
    local players = ESX.GetExtendedPlayers()
    for _, Player in pairs(players) do
        cb(Player.citizenid)
    end
end

return core