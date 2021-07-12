local tetromino = require("tetromino")
local colors = require("colors")
local audio = require("audio")

local arena = {}

arena.width = 10
arena.height = 24
arena.score = 0
arena.next_kind = tetromino.random_kind()

local render_frame = function()
    love.graphics.setColor(colors.white)
    love.graphics.rectangle("line", 0, 0,
        arena.width * tetromino.square_width,
        arena.height * tetromino.square_width)
end

local render_field = function()
    for x, row in pairs(arena.field) do
        for y, kind in pairs(row) do
            tetromino.set_color_of_kind(kind)
            tetromino.render_square(x, y)
        end
    end
end

local render_score = function()
    love.graphics.setColor(colors.white)
    love.graphics.print("Score: " .. tostring(arena.score), 250, 50, 0)
end

local render_next = function()
    tetromino.render({
            kind = arena.next_kind,
            x = 15, y = 6, rotation = 0
        })
end

arena.render = function()
    render_frame()
    render_field()
    render_score()
    render_next()
end

arena.field = {}

arena.clear = function() arena.field = {} end

local get_field = function(x, y)
    if arena.field[x] then
        return arena.field[x][y]
    else
        return nil
    end
end
local set_field = function(x, y, val)
    if not arena.field[x] then
        arena.field[x] = {}
    end
    arena.field[x][y] = val
end

arena.place_piece = function(piece)
    for _, c in ipairs(tetromino.get_absolute_coords(piece)) do
        set_field(c[1], c[2], piece.kind)
    end
end

arena.valid_placement = function(piece)
    for _, c in ipairs(tetromino.get_absolute_coords(piece)) do
        if c[1] < 0 or c[2] < 0 or c[1] >= arena.width or c[2] >= arena.height then
            return false
        end
        if get_field(c[1], c[2]) then
            return false
        end
    end
    return true
end

local detect_lines = function()
    local lines = {}
    for y = 0, arena.height - 1 do
        local full = true
        for x = 0, arena.width - 1 do
            if not get_field(x, y) then
                full = false
            end
        end
        if full then table.insert(lines, y) end
    end
    return lines
end

local delete_and_shift = function(row)
    for y = row - 1, 0, -1 do
        for x = 0, arena.width - 1 do
            set_field(x, y + 1, get_field(x, y))
        end
    end
end

local score_increase = function(lines)
    local score_map = {
        [0] = 0,
        [1] = 40,
        [2] = 100,
        [3] = 300,
        [4] = 1200
    }
    return score_map[lines] * 1 -- level
end

arena.delete_lines = function()
    local lines = detect_lines()
    arena.score = arena.score + score_increase(#lines)
    for _, row in ipairs(lines) do
        audio.play("delete")
        delete_and_shift(row)
    end
end

return arena
