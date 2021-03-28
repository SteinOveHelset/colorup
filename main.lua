-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
native.setProperty("preferredScreenEdgesDeferringSystemGestures", true)

-- Play games
local gamecenter = require("classes.helper_gamecenter")
gamecenter:init()

-- Ads
local ads = require("classes.helper_ads")
ads:init()

-- Music
local utilities = require("classes.utilities")
local music = audio.loadStream("assets/sounds/loop1.mp3")
utilities:playMusic(music)

-- Create composer
local composer = require('composer')
composer.recycleOnSceneChange = true
composer.gotoScene( "scenes.menu" )