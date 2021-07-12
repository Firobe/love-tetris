local audio = {}

local kinds = {"delete", "move", "rotate", "defeat", "turbo", "hit"}

local loadSmall = function(name)
    local filename = "sounds/" .. name .. ".wav"
    return love.audio.newSource(filename, "static")
end

local load_all = function()
    local sources = {}
    for _, name in ipairs(kinds) do
        sources[name] = loadSmall(name)
    end
    return sources
end

audio.sources = load_all()

audio.play = function(name)
    audio.sources[name]:play()
end

return audio
