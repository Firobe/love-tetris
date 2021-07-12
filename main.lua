local arena = require("arena")
local tetromino = require("tetromino")
local audio = require("audio")
local colors = require("colors")

local current_piece = nil
local since_last_tick = 0
local tick_duration = 0.5

local generate_piece = function()
    local res = {kind = arena.next_kind, x = 0, y = 0, rotation = 0}
    arena.next_kind = tetromino.random_kind()
    return res
end

local try_move_piece = function(piece, dx, dy, no_audio)
    if piece then
        piece.x = piece.x + dx
        piece.y = piece.y + dy
        if not arena.valid_placement(piece) then
            piece.x = piece.x - dx
            piece.y = piece.y - dy
            return false
        else
            if not no_audio then
                audio.play("move")
            end
            return true
        end
    end
end

local try_rotate_piece = function(piece)
    if piece then
        local old_rotation = piece.rotation
        piece.rotation = (piece.rotation + 1) % 4
        if not arena.valid_placement(piece) then
            piece.rotation = old_rotation
            return false
        else
            audio.play("rotate")
            return true
        end
    end
end

local defeat = false
local defeat_fun = function()
    defeat = true
    audio.play("defeat")
end

local tick = function()
    if not defeat then
        if current_piece == nil then
            current_piece = generate_piece()
            if not arena.valid_placement(current_piece) then
                defeat_fun()
            end
        else
            if not try_move_piece(current_piece, 0, 1, true) then
                audio.play("hit")
                arena.place_piece(current_piece)
                current_piece = nil
                arena.delete_lines()
            end
        end
    end
end

local turbo_down = function(piece)
    if piece and not defeat then
        local continue = true
        while continue do
            continue = try_move_piece(piece, 0, 1, true)
        end
        audio.play("turbo")
        tick()
    end
end

function love.load()
    math.randomseed(os.time())
    love.window.setMode(500, 480)
    love.window.setTitle("Totally Not Tetris")
    love.keyboard.setKeyRepeat(true)
    love.graphics.setNewFont(40)
end

function love.draw()
    arena.render()
    if current_piece then
        tetromino.render(current_piece)
        local x1, y1, x2, y2 = tetromino.bounds(current_piece)
        local sw = tetromino.square_width
        love.graphics.setColor(colors.dGrey)
        love.graphics.line(x1 * sw, y1 * sw, x1 * sw, arena.height * sw)
        love.graphics.line(x2 * sw, y2 * sw, x2 * sw, arena.height * sw)
    end
    if defeat then
        love.graphics.setColor(colors.dRed)
        local scale = 1 + (math.sin(since_last_tick) + 1) / 4
        love.graphics.print("DEFEAT", 250, 200, 0, scale, scale)
    end
end

function love.update(dt)
    since_last_tick = since_last_tick + dt
    if not defeat and since_last_tick > tick_duration then
        since_last_tick = 0
        tick()
    end
end

function love.keypressed(key)
    local key_map = {
        escape = function() love.event.quit() end,
        right = function() try_move_piece(current_piece, 1, 0) end,
        left = function() try_move_piece(current_piece,-1, 0) end,
        down = function() try_move_piece(current_piece, 0, 1) end,
        space = function() try_rotate_piece(current_piece) end,
        ["return"] = function() turbo_down(current_piece) end
    }
    local action = key_map[key]
    if action then action() end
end
