local cachedAccounts = {}

---@class AccountProps
---@field id string
---@field name string
---@field type string
---@field frozen boolean
---@field amount number
---@field transactions table
---@field auth table
---@field creator? string

---@class Account : OxClass
---@field data AccountProps
local account = lib.class('Account')

--- Constructor
---@param data AccountProps
function account:constructor(data)
    assert(type(data) == 'table', 'Invalid data type')
    self.amount = data.amount
    self.frozen = data.frozen
    self.id = data.id
    self.name = data.name
    self.type = data.type
    self.transactions = data.transactions
    self.auth = data.auth
    self.creator = data.creator
    return self
end

function account:addMoney(amount)
    assert(type(amount) == 'number', 'Invalid amount type')
    assert(amount > 0, 'Invalid amount')
    self.amount = self.amount + amount
    return self.amount
end

function account:removeMoney(amount)
    assert(type(amount) == 'number', 'Invalid amount type')
    assert(amount > 0, 'Invalid amount')
    self.amount = self.amount - amount
    return self.amount
end

function account:setMoney(amount)
    assert(type(amount) == 'number', 'Invalid amount type')
    assert(amount > 0, 'Invalid amount')
    self.amount = amount
    return self.amount
end

local accounts = {}

--- Get All Accounts
---@return table<string, AccountProps>
function accounts.getAllAccounts()
    return cachedAccounts
end

--- Create Account
---@param data AccountProps
---@return Account | nil
function accounts.new(data)
    if cachedAccounts[data.id] then
        lib.print.info(('Account with id %s already exists'):format(data.id))
        return end
    local acc = account:new(data)
    cachedAccounts[acc.id] = acc
    return acc
end

--- Get Account
---@param id string
---@return AccountProps
function accounts.getAccount(id)
    return cachedAccounts[id]
end exports('GetAccount', accounts.getAccount)

return accounts