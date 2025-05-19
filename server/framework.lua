local ESX, Jobs, Gangs = nil, nil, nil
local deadPlayers = {}

-- Define ExportHandler function at the top of the file
local function ExportHandler(resource, name, cb)
    AddEventHandler(('__cfx_export_%s_%s'):format(resource, name), function(setCB)
        setCB(cb)
    end)
end

ESX = exports['es_extended']:getSharedObject()
repeat Wait(200) until next(ESX) or ESX
ESX.RefreshJobs()
Jobs = ESX.GetJobs()
Gangs = {} -- ESX doesn't have gangs

-- Backwards Compatability
ExportHandler("esx_society", "GetSociety", GetAccountMoney)
RegisterServerEvent('esx_society:getSociety', GetAccountMoney)
RegisterServerEvent('esx_society:depositMoney', AddAccountMoney)
RegisterServerEvent('esx_society:withdrawMoney', RemoveAccountMoney)

function GetSocietyLabel(society)
    return Jobs[society] and Jobs[society].label or society
end

function GetFunds(Player)
    local funds = {
        cash = Player.getAccount('money').money,
        bank = Player.getAccount('bank').money
    }
    return funds
end

function AddMoney(Player, Amount, Type, comment)
    if Type == 'cash' then
        Player.addAccountMoney('money', Amount, comment)
    elseif Type == 'bank' then
        Player.addAccountMoney('bank', Amount, comment)
    end
end

function RemoveMoney(Player, Amount, Type, comment)
    if Type == 'cash' then
        local currentAmount = Player.getAccount('money').money
        if currentAmount >= Amount then
            Player.removeAccountMoney('money', Amount, comment)
            return true
        end
    elseif Type == 'bank' then
        local currentAmount = Player.getAccount('bank').money
        if currentAmount >= Amount then
            Player.removeAccountMoney('bank', Amount, comment)
            return true
        end
    end
end

function GetJobs(Player)
    return {
        name = Player.job.name,
        grade = tostring(Player.job.grade)
    }
end

function GetGang(Player)
    return false
end

function IsJobAuth(job, grade)
    local numGrade = tonumber(grade)
    return Jobs[job].grades[grade] and Jobs[job].grades[grade].name == 'boss' or Jobs[job].grades[numGrade] and Jobs[job].grades[numGrade].name == 'boss'
end

function IsGangAuth(Player, gang)
    return false
end

function IsDead(Player)
    return deadPlayers[Player.source]
end

function GetFrameworkGroups()
    return Jobs, Gangs
end

--Misc Framework Events

RegisterNetEvent('esx:onPlayerDeath', function()
	deadPlayers[source] = true
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
    local Player = ESX.GetPlayerFromId(source)
    local cid = Player.citizenid
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
    -- We'll handle this in main.lua
    -- UpdatePlayerAccount(cid)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)

-- We'll move this to main.lua since it depends on UpdatePlayerAccount
-- AddEventHandler('onResourceStart', function(resourceName)
--     Wait(250)
--     if resourceName == GetCurrentResourceName() then
--         for _, v in ipairs(GetPlayers()) do
--             local Player = GetPlayerObject(v)
--             if Player then
--                 local cid = GetIdentifier(Player)
--                 UpdatePlayerAccount(cid)
--             end
--         end
--     end
-- end)
