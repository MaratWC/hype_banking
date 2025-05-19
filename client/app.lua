while GetResourceState("lb-phone") ~= "started" do
    Wait(500)
end

Wait(1000) -- wait for the AddCustomApp export to exist
local app = require 'shared.config'.App
local url = GetResourceMetadata(cache.resource, "ui_page", 0)

local function AddApp()
    local added, errorMessage = exports["lb-phone"]:AddCustomApp({
        identifier = app.identifier, -- unique app identifier

        name = app.name,
        description = app.description,
        developer = app.developer,

        defaultApp = app.defaultApp, -- should the app be installed by default? this also means that you can't uninstall it
        size = 59812, -- the app size in kb
        -- price = 0, -- OPTIONAL: require players to pay for the app with in-game money to download it

        images = { -- OPTIONAL array of screenshots of the app, used for showcasing the app
            "https://cfx-nui-" .. cache.resource .. "/web/build/image/screenshot-light.png",
            "https://cfx-nui-" .. cache.resource .. "/web/build/image/screenshot-dark.png"
        },

        ui = url:find("http") and url or cache.resource .. "/" .. url,
        icon = url:find("http") and url .. "/web/build/image/icon.svg" or "https://cfx-nui-" .. cache.resource .. "/web/build/image/icon.png",

        fixBlur = true,
        onUse = function() -- OPTIONAL function to be called when the app is opened
        end,
        onClose = function()
            exports["lb-phone"]:DisableWalkableCam()
        end
    })

    if not added then
        print("Could not add app:", errorMessage)
    end
end

AddApp()

AddEventHandler("onResourceStart", function(resource)
    if resource == "lb-phone" then
        AddApp()
    end
end)