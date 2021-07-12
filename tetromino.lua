local tetromino = {}

local colors = require("colors")

local pieces = {
    I = {
        color = colors.lBlue,
        coords = {{0, 0}, {1, 0}, {2, 0}, {3, 0}}
    },
    O = {
        color = colors.yellow,
        coords = {{0, 0}, {1, 0}, {1, 1}, {0, 1}}
    },
    T = {
        color = colors.purple,
        coords = {{0, 0}, {1, 0}, {2, 0}, {1, 1}}
    },
    L = {
        color = colors.orange,
        coords = {{0, 0}, {1, 0}, {2, 0}, {0, 1}}
    },
    J = {
        color = colors.dBlue,
        coords = {{0, 0}, {1, 0}, {2, 0}, {2, 1}}
    },
    Z = {
        color = colors.red,
        coords = {{0, 0}, {1, 0}, {1, 1}, {2, 1}}
    },
    S = {
        color = colors.green,
        coords = {{0, 1}, {1, 1}, {1, 0}, {2, 0}}
    }
}
local kinds = {"I", "O", "T", "L", "J", "Z", "S"}

tetromino.random_kind = function ()
    return kinds[math.random(#kinds)]
end
    
tetromino.square_width = 20

tetromino.render_square = function(x, y)
    local sw = tetromino.square_width
    love.graphics.rectangle("fill", x * sw, y * sw, sw, sw)
end

local rotate_vector
rotate_vector = function(vector, rotation)
    if rotation == 0 then return vector
    else
        local rotated = {-vector[2], vector[1]}
        return rotate_vector(rotated, rotation - 1)
    end
end

tetromino.get_absolute_coords = function(p)
    local t = pieces[p.kind]
    local res = {}
    for i, square in ipairs(t.coords) do
        local r = rotate_vector(square, p.rotation)
        res[i] = {r[1] + p.x, r[2] + p.y}
    end
    return res
end

tetromino.set_color_of_kind = function(k)
    local color = pieces[k].color
    love.graphics.setColor(color)
end

tetromino.render = function(p)
    local t = pieces[p.kind]
    tetromino.set_color_of_kind(p.kind)
    for _, square in ipairs(tetromino.get_absolute_coords(p)) do
        tetromino.render_square(square[1], square[2])
    end
end

tetromino.bounds = function(p)
    local min_x = {math.huge, math.huge}
    local max_x = {-math.huge, math.huge}
    for _, square in ipairs(tetromino.get_absolute_coords(p)) do
        if square[1] < min_x[1] then
            min_x = square
        elseif square[1] == min_x[1] then
            min_x[2] = math.min(min_x[2], square[2])
        end
        if square[1] > max_x[1] then
            max_x = square
        elseif square[1] == max_x[1] then
            max_x[2] = math.min(max_x[2], square[2])
        end
    end
    return min_x[1], min_x[2], max_x[1] + 1, max_x[2]
end

return tetromino
