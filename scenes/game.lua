--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("classes.utilities")


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain
local _grpBackgrounds
local _grpWorld
local _grpHud

-- Misc
local _playing = false
local _score = 0
local _blockWidth = _W * 0.25
local _words = {"Awesome", "Nice", "Wow", "Great"}

-- Hud
local _lblScore = ""
local _lblTapToStart = ""

-- Object
local _hero
local _b1
local _b2
local _b3
local _b4
local _backgrounds = {}
local _blockIDS = {1, 2, 3, 4}
local _blocks = {}

-- Colors
local _clrRed = {209/255, 42/255, 95/255}
local _clrGreen = {122/255, 184/255, 79/255}
local _clrBlue = {77/255, 157/255, 191/255}
local _clrYellow = {201/255, 201/255, 85/255}

-- Sounds
local _sndJump = audio.loadStream("assets/sounds/jump.wav")
local _sndLose = audio.loadStream("assets/sounds/crash.wav")
local _click = audio.loadStream("assets/sounds/click.wav")

--
-- Functions

local touch = {}
local enterFrame = {}


--
-- Local functions

local function gotoGameover()

    composer.gotoScene("scenes.gameover")
end

local function gameOver()

    Runtime:removeEventListener("touch", touch)
    Runtime:removeEventListener("enterFrame", enterFrame)

    utilities:playSound(_sndLose)

    _playing = false

    utilities:setTmpScore(_score)

    for i=0, 15 do -- We want 15 parts
        local dot = display.newRect(_grpWorld, _hero.x + 10, _hero.y, 5, 5) 
        local x = dot.x + (math.random(-100, 100)) 
        local y = dot.y + (math.random(-100, 100))

        -- Set the same color to the dot as the hero

        if _hero.colorID == 1 then
            dot.fill = _clrRed
        elseif _hero.colorID == 2 then
            dot.fill = _clrGreen
        elseif _hero.colorID == 3 then
            dot.fill = _clrBlue
        else
            dot.fill = _clrYellow
        end

        -- Move the dot, set it to be transparent and rotate it

        transition.to(dot, {time=300, x=x, y=y, alpha=0, rotation=360})
    end

    transition.to(_hero, {time=550, xScale=0.01, yScale=0.01, onComplete=gotoGameover})
end

local function shuffle(tbl)
    local len = #tbl -- Get the length of the blocks table / list

    -- Randomize it and return
   
    for i = len, 2, -1 do
        local j = math.random( 1, i )

        tbl[i], tbl[j] = tbl[j], tbl[i]
    end

    return tbl;
end

local function randomizeBlocks()

    _hero.colorID = math.random(1, 4)

    if _hero.colorID == 1 then
        _hero.fill = _clrRed
    elseif _hero.colorID == 2 then
        _hero.fill = _clrGreen
    elseif _hero.colorID == 3 then
        _hero.fill = _clrBlue
    else
        _hero.fill = _clrYellow
    end

    --

    _blockIDS = shuffle(_blockIDS)

    for i=1, #_blocks do
        local block = _blocks[i]
        block.colorID = _blockIDS[i]

        if block.colorID == 1 then
            block.fill = _clrRed
        elseif block.colorID == 2 then
            block.fill = _clrGreen
        elseif block.colorID == 3 then
            block.fill = _clrBlue
        else
            block.fill = _clrYellow
        end
    end
end

local function checkCollision(block)

    local left  = (block.contentBounds.xMin) <= _hero.contentBounds.xMin and (block.contentBounds.xMax) >= _hero.contentBounds.xMin
    local right = (block.contentBounds.xMin) >= _hero.contentBounds.xMin and (block.contentBounds.xMin) <= _hero.contentBounds.xMax
    local up    = (block.contentBounds.yMin) <= _hero.contentBounds.yMin and (block.contentBounds.yMax) >= _hero.contentBounds.yMin
    local down  = (block.contentBounds.yMin) >= _hero.contentBounds.yMin and (block.contentBounds.yMin) <= _hero.contentBounds.yMax + 2

    return (left or right) and (up or down)
end

local function increaseLevel()

    if _hero.canIncreaseScore and _playing then
        _hero.canIncreaseScore = false

        utilities:playSound(_sndJump)

        _score = _score + 1

        _lblScore.text = _score

        transition.to(_lblScore, {time=150, xScale=1.5, yScale=1.5})
        transition.to(_lblScore, {time=150, xScale=1, yScale=1, delay=150})

        local rand = math.random(1, #_words)
        local lblRandom = display.newText(_words[rand], _CX, _CY, "assets/fonts/Galada.ttf", 46)
        lblRandom.fill = { 1, 1, 1 }
        _grpHud:insert(lblRandom)

        transition.to(lblRandom, {time=300, y=_CY - 60, alpha=0, delay=600, onComplete=function(obj)
            obj:removeSelf()
        end})

        if _hero.y > 400 then
            transition.to(_b1, {time=100, y=_b1.y-20})
            transition.to(_b2, {time=100, y=_b2.y-20})
            transition.to(_b3, {time=100, y=_b3.y-20})
            transition.to(_b4, {time=100, y=_b4.y-20})
            transition.to(_hero, {time=100, y=_hero.y-20})
        else
            transition.to(_backgrounds[1], {time=100, y=_backgrounds[1].y+20})
            transition.to(_backgrounds[2], {time=100, y=_backgrounds[2].y+20})
            transition.to(_backgrounds[3], {time=100, y=_backgrounds[3].y+20})

            if _backgrounds[1].y > _H then
                _backgrounds[1].y = _backgrounds[1].y - (_H * 2)
            end

            if _backgrounds[2].y > _H then
                _backgrounds[2].y = _backgrounds[2].y - (_H * 2)
            end

            if _backgrounds[3].y > _H then
                _backgrounds[3].y = _backgrounds[3].y - (_H * 2)
            end
        end
    end
end


function touch( event ) 

    if event.phase == 'began' then
        -- Start game
        if _playing == false then
            _playing = true

            utilities:playSound(_sndJump)

            transition.to(_lblTapToStart, {time=200, alpha=0})
            transition.to(_lblScore, {time=200, alpha=0.3, delay=400})
        else
            _hero.crashed = false

            if checkCollision(_b1) and _b1.colorID ~= _hero.colorID then
                _hero.crashed = true
            elseif checkCollision(_b2) and _b2.colorID ~= _hero.colorID then
                _hero.crashed = true
            elseif checkCollision(_b3) and _b3.colorID ~= _hero.colorID then
                _hero.crashed = true
            elseif checkCollision(_b4) and _b4.colorID ~= _hero.colorID then
                _hero.crashed = true
            end

            if _hero.crashed == false then
                increaseLevel()
            else
                gameOver()
            end
        end
    end
end

function enterFrame()

    if _playing then
        if _hero.direction == 'right' then
            _hero.x = _hero.x + _hero.speed
        else
            _hero.x = _hero.x - _hero.speed
        end

        if _hero.x > (_W - _hero.width / 2) then
            if not _hero.canIncreaseScore then
                _hero.direction = 'left'
                _hero.canIncreaseScore = true

                randomizeBlocks()
            else
                gameOver()
            end
        end

        if _hero.x < (0 + _hero.width / 2) then
            if not _hero.canIncreaseScore then
                _hero.direction = 'right'
                _hero.canIncreaseScore = true

                randomizeBlocks()
            else
                gameOver()
            end
        end

        -- Emitter
        
        _hero.showEmitterNum = _hero.showEmitterNum + 1

        if _hero.showEmitterNum >= 3 then
            local size = math.random(4, 6)
            local x = math.random(20, 40)
            local y = math.random(3, 10)
            local dot = display.newRect(_grpWorld, _hero.x - 14, _hero.y + 8, size, size)

            if _hero.direction == 'left' then
                x = -x
                dot.x = _hero.x + 14
            end        

            if _hero.colorID == 1 then
                dot.fill = _clrRed
            elseif _hero.colorID == 2 then
                dot.fill = _clrGreen
            elseif _hero.colorID == 3 then
                dot.fill = _clrBlue
            else
                dot.fill = _clrYellow
            end

            transition.to(dot, {time=300, x=dot.x - x, y=dot.y - y, alpha=0, rotation=-360, xScale=0.7, yScale=0.7, onComplete=function(obj)
                obj:removeSelf()
            end})

            _hero.showEmitterNum = 0
        end
    end
end


--
-- Scene events functions

function scene:create( event )

    print("scene:create - game")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    --

    _grpBackgrounds = display.newGroup()
    _grpMain:insert(_grpBackgrounds)

    _grpWorld = display.newGroup()
    _grpMain:insert(_grpWorld)

    _grpHud = display.newGroup()
    _grpMain:insert(_grpHud)

    --

    -- Backgrounds

    local back1 = display.newImageRect(_grpBackgrounds, "assets/images/background.png", _W, _H)
    back1.x = _CX
    back1.y = _CY
    back1.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back1

    local back2 = display.newImageRect(_grpBackgrounds, "assets/images/background.png", _W, _H)
    back2.x = _CX
    back2.y = _CY - _H
    back2.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back2

    local back3 = display.newImageRect(_grpBackgrounds, "assets/images/background.png", _W, _H)
    back3.x = _CX
    back3.y = _CY - (_H * 2)
    back3.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back3

    -- Score label

    _lblScore = display.newText("0", _CX, 150, "assets/fonts/Galada.ttf", 78) 
    _lblScore.fill = { 1, 1, 1 }
    _lblScore.alpha = 0 
    _grpHud:insert(_lblScore)

    -- Tap to start label

    _lblTapToStart = display.newText("Tap to start", _CX, _CY, "assets/fonts/Galada.ttf", 46)
    _lblTapToStart.fill = { 1, 1, 1 }
    _grpHud:insert(_lblTapToStart)

    transition.to(_lblTapToStart, {time=2000, y=_CY + 50})
    transition.to(_lblTapToStart, {time=2000, y=_CY - 50, delay=2000})
    transition.to(_lblTapToStart, {time=2000, y=_CY + 50, delay=4000})
    transition.to(_lblTapToStart, {time=2000, y=_CY - 50, delay=6000})

    -- Blocks

    _b1 = display.newRect( _grpMain, _blockWidth * 0.5, _H - 20, _blockWidth, 10)
    _b1.colorID = 1
    _b1.fill = _clrRed
    _b1.anchorY = 0

    _blocks[#_blocks+1] = _b1

    _b2 = display.newRect( _grpMain, _blockWidth + _blockWidth * 0.5, _H - 20, _blockWidth, 10)
    _b2.colorID = 2
    _b2.fill = _clrGreen
    _b2.anchorY = 0

    _blocks[#_blocks+1] = _b2

    _b3 = display.newRect( _grpMain, _blockWidth + _blockWidth * 1.5, _H - 20, _blockWidth, 10)
    _b3.colorID = 3
    _b3.fill = _clrBlue
    _b3.anchorY = 0

    _blocks[#_blocks+1] = _b3

    _b4 = display.newRect( _grpMain, _blockWidth + _blockWidth * 2.5, _H - 20, _blockWidth, 10)
    _b4.colorID = 4
    _b4.fill = _clrYellow
    _b4.anchorY = 0

    _blocks[#_blocks+1] = _b4

    -- Hero
    _hero = display.newRect( _grpMain, 20, _H - 26, 12, 12 )
    _hero.colorID = 3 
    _hero.speed = 3 
    _hero.direction = 'right'
    _hero.crashed = false
    _hero.canIncreaseScore = true 
    _hero.fill = _clrBlue
    _hero.showEmitterNum = 0

    --
    randomizeBlocks()

    --

    Runtime:addEventListener("touch", touch)
    Runtime:addEventListener("enterFrame", enterFrame)
end

function scene:show( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:hide( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:destroy( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end


--
-- Scene event listeners

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene