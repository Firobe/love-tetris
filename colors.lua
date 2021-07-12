local colors255 = {
    black     = {0, 0, 0},
    white     = {255, 255, 255},
    dGrey     = {50, 50, 50},
    grey      = {125, 125, 125},
    lGrey     = {200, 200, 200},
    dRed      = {200, 0, 0},
    red       = {255, 0, 0},
    lRed      = {255, 80, 80},
    dOrange   = {200, 80, 0},
    orange    = {255, 120, 0},
    lOrange   = {255, 160, 0},
    dYellow   = {200,200,0},
    yellow    = {255,255,0},
    lYellow   = {255,255,100},
    dGreen    = {0,180,0},
    green     = {0,255,0},
    lGreen    = {60,255,60},
    dBlue     = {0,0,255},
    blue      = {0,80,255},
    lBlue     = {0,150,255},
    dPurple   = {120,50,120},
    purple    = {160,50,160},
    lPurple   = {200,50,200}
}

function colorConvert(c)
    return {c[1] / 255, c[2] / 255, c[3] / 255}
end

function convertAll(t)
    converted = {}
    for i, v in pairs(t) do
        converted[i] = colorConvert(v)
    end
    return converted
end

return convertAll(colors255)
