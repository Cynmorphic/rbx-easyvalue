

# EasyValue

## Installation

1. Download the EasyValue module
2. Place it in ReplicatedStorage or ServerScriptService
3. Require it in your scripts:

        local EasyValue = require(path.to.EasyValue)

## Creating Value Objects

### EasyValue.Create()

Syntax:

    EasyValue.Create(type, name, value, parent, returnObject)

Arguments:

- type (string, required) - The type of value to create. Use EasyValue.Type enums (e.g., EasyValue.Type.NumberValue)
- name (string, required) - The name of the value object
- value (any, required) - The initial value
- parent (Instance, required) - The parent instance
- returnObject (boolean, optional) - If false, returns the raw Roblox value object instead of an EasyValue wrapper. Defaults to wrapping in EasyValue.

Example:

    local health = EasyValue.Create(EasyValue.Type.NumberValue, "Health", 100, player)

### Wrapping Existing Values

    local existingValue = workspace.SomeValue
    local wrapped = EasyValue(existingValue)

## Methods

### :Set()

Syntax:

    easyValue:Set(value, dontCallOnUpdate)

Arguments:

- value (any, required) - The new value to set
- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    health:Set(50)

### :Get()

Syntax:

    easyValue:Get()

Example:

    local currentHealth = health:Get()

### :OnUpdate()

Syntax:

    easyValue:OnUpdate(callback)

Arguments:

- callback (function, required) - Function that receives (newValue, oldValue) as parameters

Example:

    health:OnUpdate(function(newValue, oldValue)
        print("Health changed from", oldValue, "to", newValue)
    end)

### :Disconnect()

Syntax:

    easyValue:Disconnect(func)

Arguments:

- func (function, required) - The callback function to remove

Example:

    health:Disconnect(healthChanged)

### :Toggle()

Only works with BoolValues.

Syntax:

    easyValue:Toggle(dontCallOnUpdate)

Arguments:

- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    isActive:Toggle()

### :Increment()

Only works with NumberValue and IntValue.

Syntax:

    easyValue:Increment(amount, dontCallOnUpdate)

Arguments:

- amount (number, required) - The amount to add
- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    coins:Increment(10)

### :Take()

Only works with NumberValue and IntValue.

Syntax:

    easyValue:Take(amount, dontCallOnUpdate)

Arguments:

- amount (number, required) - The amount to subtract (automatically converted to positive)
- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    health:Take(25)

### :Multiply()

Only works with NumberValue and IntValue.

Syntax:

    easyValue:Multiply(factor, dontCallOnUpdate)

Arguments:

- factor (number, required) - The multiplication factor
- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    damage:Multiply(2)

### :Divide()

Only works with NumberValue and IntValue.

Syntax:

    easyValue:Divide(factor, dontCallOnUpdate)

Arguments:

- factor (number, required) - The division factor
- dontCallOnUpdate (boolean, optional) - If true, prevents OnUpdate callbacks from firing

Example:

    speed:Divide(2)

### :Equals()

Syntax:

    easyValue:Equals(value)

Arguments:

- value (any, required) - The value to compare against

Returns:

- boolean - true if values match, false otherwise

Example:

    if health:Equals(0) then
        print("Player is dead")
    end

### :GetType()

Syntax:

    easyValue:GetType()

Returns:

- string - The type ("number", "string", "boolean", etc.)

Example:

    print(health:GetType())

### :Destroy()

Syntax:

    easyValue:Destroy()

Example:

    health:Destroy()

## Example Usage

    local EasyValue = require(game.ReplicatedStorage.EasyValue)

    local health = EasyValue.Create(EasyValue.Type.NumberValue, "Health", 100, player)

    health:OnUpdate(function(newValue, oldValue)
        print("Changed from", oldValue, "to", newValue)
    end)

    health:Take(25)
    health:Increment(10)

