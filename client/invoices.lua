repeat Wait(500) until lib
local utils = require 'shared.utils'
local config = require 'shared.config'
local core = require (('bridge.%s.client'):format(config.framework))

local function invoiceMenu(playerId)
    local input = lib.inputDialog('Create Invoice', {
        { type = 'input', label = 'Item', required = true, placeholder = 'cth: Jasa Perbaikan Kendaraan' },
        { type = 'number', label = 'Amount', required = true, min = 1 },
        { type = 'textarea', label = 'Note (Optional)'},
        { type = 'checkbox', label = 'Auto Pay', default = false},
    })
    
    if not input then return end
    TriggerServerEvent('hype_banking:server:createInvoice', {
        target = playerId,
        item = input[1],
        amount = input[2],
        note = input[3],
        autoPay = input[4],
    })
end

-- RegisterCommand('createinvoice', function ()
--     invoiceMenu(cache.serverId)
-- end)

if config.interactionType == 'ox_target' then
    exports.ox_target.addGlobalPlayer({
        {
            name = "createInvoice",
            label = "Send Invoice",
            icon = "fa-money-bill-wave",
            onSelect = function (data)
                local entity = data.entity
                local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                invoiceMenu(serverId)
            end,
            canInteract = function ()
                return utils.getManagementAccess(PlayerData.job.name, PlayerData.job.grade, 'createInvoice')
            end
        },
    })
elseif config.interactionType == 'interact' then
    exports.interact:addGlobalPlayerInteraction({
        distance = 5.0,
        interactDst = 1.5,
        offset = vec3(0.0, 0.0, 0.0),
        id = 'createInvoice',
        options = {
            name = 'createInvoice',
            label = 'Send Invoice',
            action = function(entity, _, _, serverId)
                invoiceMenu(serverId)
            end,
            canInteract = function ()
                return utils.getManagementAccess(PlayerData.job.name, PlayerData.job.grade, 'createInvoice')
            end
        }
    })
end

RegisterNetEvent('hype_banking:client:openInvoiceMenu', function (invoices)
    if source == '' then return end
    SendNUIMessage({action = 'setLoading', data = {status = true}})
    SetTimeout(1000, function()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'setVisible',
            data = {
                status = true,
                page = 'invoices',
                loading = false,
            }
        })
        SendNUIMessage({
            action ='setInvoices',
            data = invoices
        })
    end)
end)

RegisterNUICallback('hype_banking:client:getInvoices', function (_, cb)
    local resp = lib.callback.await('hype_banking:server:getInvoices', false)
    cb(resp)
end)

RegisterNUICallback('hype_banking:client:getAllInvoices', function (_, cb)
    local resp = lib.callback.await('hype_banking:server:getAllInvoices', false)
    cb(resp)
end)

RegisterNUICallback('hype_banking:client:payInvoice', function (invoice, cb)
    local resp = lib.callback.await('hype_banking:server:payInvoice', false, invoice)
    cb(resp)
end)

RegisterNUICallback('hype_banking:client:cancelInvoice', function (invoice, cb)
    local resp = lib.callback.await('hype_banking:server:cancelInvoice', false, invoice)
    cb(resp)
end)

RegisterNUICallback('hype_banking:client:payAllPendingInvoices', function (_, cb)
    local resp = lib.callback.await('hype_banking:server:payAllPendingInvoices', false)
    cb(resp)
end)