# [Standalone] 👆🏻 Raycast Targeting
An useful system to obtain the player's id by clicking on them.

### 🔧 Configuration
You can easily customize the marker on the player head, or remove it.
You can change:
* Change the max distance for interacting with the player
* Select Control for selecting the player
* Disabled Controls during the raycasting
* Exit Controls for leaving the raycasting

### 👁️ Plus
In addition to the players you can select the peds to obtain their entity

### Disclaimer
I didn't find many resources on the forum or on GitHub that would allow you to do this, to be honest I didn't search in depth, the idea obviously didn't come from me but I think this script could be useful to many people.

🎬 [Preview](https://youtu.be/P2ZvoAznGIM)
---
📃 [Documentation](https://next-script-tm.gitbook.io/next-scripts/free-resources/targeting)
---


# Installation
After you have downloaded the [latest release](https://github.com/nextscripts-5m/targeting/releases) of the resource:

* Put the `targeting` folder into your resource foleder
* Add `ensure targeting`  to your `server.cfg` or put the folder into a `[collection]` already started in the `server.cfg`
---

# Usage

```lua
exports.targeting:StartTargeting(data)
```
data: `table`
* npc: `boolean` enable raycasting on npc's

---

> An example with npc raycasting disabled
```lua
RegisterCommand("getId", function (source, args, raw)
    local id = exports.targeting:StartTargeting({
        npc = false
    })
    print(id)
end)
```

> This is equivalent to:
```lua
RegisterCommand("getId", function (source, args, raw)
    local id = exports.targeting:StartTargeting({})
    print(id)
end)
```

## Ox Inventory Give Item Feature
> At this [line](https://github.com/overextended/ox_inventory/blob/52d99285eef1dc7df31c084679db3fdf6b1c0150/client.lua#L1628) of @ox_inventory/client.lua you can replace all the code of the callback with this
```lua
RegisterNUICallback('giveItem', function(data, cb)
    cb(1)
    TriggerEvent('ox_inventory:closeInventory')
    local id = exports.targeting:StartTargeting({})
    giveItemToTarget(id, data.slot, data.count)
end)
```
