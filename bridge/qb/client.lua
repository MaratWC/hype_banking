if GetResourceState('qb-core') ~= 'started' then
    return
end

PlayerData = {}
local success, QB = pcall(function ()
    local obj = exports['qb-core']:GetCoreObject()
    local playerData = obj.Functions.GetPlayerData()
    if playerData then
        PlayerData.job = {
            name = playerData.job.name,
            grade = playerData.job.grade.level,
        }
    end
    return obj
end)

if not success then return end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function (job)
    if source == '' then return end
    PlayerData.job = {
        name = job.name,
        grade = job.grade.level,
    }
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function ()
    if source == '' then return end
    local playerData = QB.Functions.GetPlayerData()
    PlayerData.job = {
        name = playerData.job.name,
        grade = playerData.job.grade.level,
    }
end)
