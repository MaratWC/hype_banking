if GetResourceState('qb-core') ~= 'started' then
    return
end
local core = {}
local success, QB = pcall(function ()
    local obj = exports['qb-core']:GetCoreObject()
    return obj
end)

if not success then return end

local function createPlayerObject(player)
    local playerData = player.PlayerData
    return {
        identifier = playerData.citizenid,
        source = playerData.source,
        name = ('%s %s'):format(playerData.charinfo.firstname, playerData.charinfo.lastname),
        job = {
            name = playerData.job.name,
            grade = playerData.job.grade.level
        },
        removeMoney = function (type, amount, reason)
            return player.Functions.RemoveMoney(type, amount, reason)
        end,
        addMoney = function (type, amount, reason)
            return player.Functions.AddMoney(type, amount, reason)
        end,
        getMoney = function (type)
            return player.Functions.GetMoney(type)
        end,
    }
end

--- Get Framework Player Data By Source
---@param source number | string | integer
function core.GetPlayer(source)
    if source == '' then return end
    local player = QB.Functions.GetPlayer(source)
    if not player then return end
    return createPlayerObject(player)
end

--- Get Framework Player Data By Identifier
---@param identifier string
function core.GetPlayerById(identifier)
    if identifier == '' then return end
    local player = QB.Functions.GetPlayerByCitizenId(identifier)
    if not player then return end
    return createPlayerObject(player)
end

function core.GetJobs()
    local jobs = {}
    for jobName, job in pairs(QB.Shared.Jobs) do
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
    AddEventHandler('QBCore:Server:PlayerLoaded', function (Player)
        cb(Player?.PlayerData?.citizenid)
    end)
end

--- On Resource Start To Load Player Data
---@param cb function
function core.onResourceStart(cb)
    local players = QB.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player then
            cb(Player?.PlayerData?.citizenid)
        end
    end
end

return core