--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("classes.utilities")
local gc = require("classes.helper_gamecenter")


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain

-- Sounds
local _click = audio.loadStream("assets/sounds/click.wav")


--
-- Local functions

local function gotoGame()

    utilities:playSound(_click)

    composer.gotoScene( "scenes.game" )
end

local function gotoSettings()

    utilities:playSound(_click)

    composer.gotoScene( "scenes.settings" )
end


--
-- Scene events functions

function scene:create( event )

    print("scene:create - menu")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    --

    local background = display.newImageRect(_grpMain, "assets/images/background.png", _W, _H)
    background.x = _CX
    background.y = _CY

    local lblTitle = display.newText("ColorUp", _CX, 100, "assets/fonts/Galada.ttf", 76)
    lblTitle.fill = { 1, 1, 1 }
    _grpMain:insert(lblTitle)

    local btnPlay = display.newRoundedRect( _grpMain, _CX, _CY, 220, 80, 20)
    btnPlay.fill = { 1, 1, 1 }
    btnPlay.alpha = 0.4;

    local lblPlay = display.newText("Play", _CX, _CY + 4, "assets/fonts/Galada.ttf", 50)
    lblPlay.fill = { 0, 0, 0 } 
    _grpMain:insert(lblPlay)

    btnPlay:addEventListener("tap", gotoGame)

    local lblSettings = display.newText("Settings", _CX, _H - 40, "assets/fonts/Galada.ttf", 26)
    lblSettings.fill = { 1, 1, 1 }
    _grpMain:insert(lblSettings)

    lblSettings:addEventListener("tap", gotoSettings)

    local lblLeaderboards = display.newText("Leaderboards", _CX, _H - 100, "assets/fonts/Galada.ttf", 26)
    lblLeaderboards.fill = { 1, 1, 1 }
    _grpMain:insert(lblLeaderboards)

    lblLeaderboards:addEventListener("tap", function()
        gc:openLeaderboard()
    end)
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