--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("classes.utilities")
local transition2 = require("transition2")

local ads = require("classes.helper_ads")
local gc = require("classes.helper_gamecenter")


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain
local _grpConfetti
local _grpContent

-- Sounds
local _click = audio.loadStream("assets/sounds/click.wav")


--
-- Local functions

local function gotoMenu()

    utilities:playSound(_click)
    composer.gotoScene("scenes.menu")
end

local function gotoGame()

    utilities:playSound(_click)
    composer.gotoScene("scenes.game")
end


--
-- Scene events functions

function scene:create( event )

    print("scene:create - game over")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    --

    local background = display.newImageRect(_grpMain, "assets/images/background.png", _W, _H)
    background.x = _CX
    background.y = _CY

    -- Groups

    _grpConfetti = display.newGroup()
    _grpMain:insert(_grpConfetti)

    _grpContent = display.newGroup()
    _grpMain:insert(_grpContent)

    -- Title

    local title = display.newText("Game over", _CX, 100, "assets/fonts/Galada.ttf", 80)
    title.fill = { 1, 1, 1 }
    _grpContent:insert(title)   

    --

    local isHighscore = utilities:setHighscore(utilities:getTmpScore())

    local lblScore = display.newText("Score: " .. utilities:getTmpScore(), _CX, _CY - 30, "assets/fonts/Galada.ttf", 26)
    lblScore.fill = { 1, 1, 1 }
    _grpContent:insert(lblScore)

    local lblCurrentHighscore = display.newText("Highscore: " .. utilities:getHighscore(), _CX, _CY - 5, "assets/fonts/Galada.ttf", 16)
    lblCurrentHighscore.fill = { 1, 1, 1 }
    _grpContent:insert(lblCurrentHighscore)

    --

    if isHighscore then
        local lblHighscore = display.newText("HIGHSCORE!", _CX, _CY - 80, "assets/fonts/Galada.ttf", 30)
        lblHighscore.fill = { 1, 1, 1 }
        _grpContent:insert(lblHighscore)

        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=200})
        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5, delay=400})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=600})
        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5, delay=800})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=1000})


        for i = 1, 200 do
            local leaf = display.newRoundedRect(_CX, _CY, 10, 10, 2)
            leaf.alpha = 0
            leaf.rotation = math.random(0, 360)
            _grpConfetti:insert(leaf)
           
            local colors = {
                { 209/255, 42/255, 95/255 },
                { 122/255, 184/255, 79/255 },
                { 77/255, 157/255, 191/255 },
                { 201/255, 201/255, 85/255 }
            }
            leaf:setFillColor(unpack(colors[math.random(1,#colors)]))
    
            transition.to(leaf, {math.random(300, 1860), y=leaf.y - math.random(100, 200), x=math.random(_CX - 150, _CX + 150), alpha=1, transition=easing.inOutQuad, onComplete=function()
                transition2.fallingLeaf(leaf, {
                    delay = 0,
                    speed = 0.25,
                    verticalIntensity = 0.7,
                    horizontalIntensity = 0.5,
                    rotationIntensity = 0.25,
                    horizontalDirection = "random",
                    randomness = 0.75,
                    zRotateParams = {
                        shadingDarknessIntensity = 0.5,
                        shadingBrightnessIntensity = 0.25,
                    },
                    cancelWhen = function()
                        return (not leaf.y) or (leaf.y > display.contentHeight + 100)
                    end,
                    onComplete = function(target)
                        target:removeSelf()
                    end,
                })
            end})
        end
    end

    --

    -- Send score to game center
    gc:submitScore(utilities:getTmpScore())

    -- Restart button
    local btnPlay = display.newRoundedRect( _grpContent, _CX, _CY + 80, 220, 80, 20)
    btnPlay.fill = { 1, 1, 1 }
    btnPlay.alpha = 0.4;

    btnPlay:addEventListener("tap", gotoGame)

    local lblPlay = display.newText("Restart", _CX, _CY + 84, "assets/fonts/Galada.ttf", 50)
    lblPlay.fill = { 0, 0, 0 }
    _grpContent:insert(lblPlay)

    -- Menu button
    local btnMenu = display.newText("Menu", _CX, _H - 100, "assets/fonts/Galada.ttf", 26)
    btnMenu.fill = { 1, 1, 1 }
    _grpContent:insert(btnMenu)

    btnMenu:addEventListener("tap", gotoMenu)

    -- Leaderboards

    local lblLeaderboards = display.newText("Leaderboards", _CX, _H - 40, "assets/fonts/Galada.ttf", 26)
    lblLeaderboards.fill = { 1, 1, 1 }
    _grpContent:insert(lblLeaderboards)

    lblLeaderboards:addEventListener("tap", function()
        gc:openLeaderboard()
    end)

    -- Show ads
    if utilities:canShowAd() == true then
        ads:showInterstitial()
    end
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