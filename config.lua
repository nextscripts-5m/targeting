Config = {}

-- Max Distance for getting player
Config.MaxDistance      = 3.5

-- For selecting the player (left mouse)
Config.SelectControl    = 24

-- Controls Disabled during the raycast
Config.DisabledControls = {25, 263, 140, 141, 142, 143, 200}

-- Controls for leaving the raycast
Config.ExitControl      = {200, 202}

-- .ytd file in stream folder
Config.StreamFile       = "targeting_marker"

-- Marker options
Config.Marker           = {
    textureDict     = Config.StreamFile,
    textureName     = "logo",
    rgb             = {r = 255, g = 255, b = 255},
    scale           = {x = .5, y = .5, z = .5},
    rotation        = {x = 90.0, y = 0.0, z = 0.0},
    direction       = {x = 0.0, y = 0.0, z = 0.0},
    alpha           = 100,
    bobUpAndDown    = false,
    faceCamera      = true,
    rotate          = false,
    type            = 9,
    zOffset         = .5
}
