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

-- Sounds
local _click = audio.loadStream("assets/sounds/click.wav")

-- Buttons
local _lblSoundsButton
local _lblMusicButton


--
-- Local functions

local function gotoMenu()

    utilities:playSound(_sndClick)

    composer.gotoScene("scenes.menu")
end

local function toggleSounds()

    utilities:toggleSounds()

    _lblSoundsButton.text = utilities:checkSounds()
end

local function toggleMusic()

    utilities:toggleMusic()

    _lblMusicButton.text = utilities:checkMusic()

    if utilities:checkMusic() == "On" then
        local music = audio.loadStream("assets/sounds/loop1.mp3")
        utilities:playMusic(music)
    else
        audio.stop()
    end
end


--
-- Scene events functions

function scene:create( event )

    print("scene:create - settings")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    --

    -- Background
    local background = display.newImageRect(_grpMain, "assets/images/background.png", _W, _H)
    background.x = _CX
    background.y = _CY

    -- Title
    local title = display.newText("Settings", _CX, 100, "assets/fonts/Galada.ttf", 80)
    title.fill = { 1, 1, 1 }
    _grpMain:insert(title)

    -- Sound title and button
    local lblSoundsTitle = display.newText("Sounds", _CX - 80, _CY - 50, "assets/fonts/Galada.ttf", 22)
    lblSoundsTitle.fill = { 1, 1, 1 }
    _grpMain:insert(lblSoundsTitle)

    _lblSoundsButton = display.newText(utilities:checkSounds(), _CX - 80, _CY, "assets/fonts/Galada.ttf", 38)
    _lblSoundsButton.fill = {1, 1, 1}
    _grpMain:insert(_lblSoundsButton)

    _lblSoundsButton:addEventListener("tap", toggleSounds)

    -- Music title and button
    local lblMusicTitle = display.newText("Music", _CX + 80, _CY - 50, "assets/fonts/Galada.ttf", 22)
    lblMusicTitle.fill = { 1, 1, 1 }
    _grpMain:insert(lblMusicTitle)

    _lblMusicButton = display.newText(utilities:checkMusic(), _CX + 80, _CY, "assets/fonts/Galada.ttf", 38)
    _lblMusicButton.fill = {1, 1, 1}
    _grpMain:insert(_lblMusicButton)

    _lblMusicButton:addEventListener("tap", toggleMusic)

    -- Created by
    local lblCreatedby = display.newText("Created by Code With Stein", _CX, _H - 100, "assets/fonts/Galada.ttf", 22)
    lblCreatedby.fill = {1, 1, 1}
    _grpMain:insert(lblCreatedby)

    lblCreatedby:addEventListener("tap", function()
        system.openURL( "https://www.youtube.com/channel/UCfVoYvY8BfTDeF63JQmQJvg" )
    end)

    -- Credits
    local lblCredit = display.newText("Music by Eric Matyas, www.soundimage.org", _CX, _H - 30, "assets/fonts/Galada.ttf", 12)
    lblCredit.fill = {1, 1, 1}
    _grpMain:insert(lblCredit)

    -- Close button
    local btnMenu = display.newRect(_grpMain, _W - 30, 30, 50, 50)
    btnMenu.alpha = 0.01

    btnMenu:addEventListener("tap", gotoMenu)

    local cross1 = display.newLine( _grpMain, _W - 40, 40, _W - 20, 20 )
    cross1.y = cross1.y - 50
    cross1:setStrokeColor( 1, 1, 1, 1 )
    cross1.strokeWidth = 2

    local cross2 = display.newLine( _grpMain, _W - 40, 20, _W - 20, 40 )
    cross2.y = cross2.y - 50
    cross2:setStrokeColor( 1, 1, 1, 1 )
    cross2.strokeWidth = 2

    transition.to(cross1, {time=300, delay=300, y=cross1.y+50})
    transition.to(cross2, {time=300, delay=300, y=cross2.y+50})
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