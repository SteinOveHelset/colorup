--
-- Import

local json = require("json")
local utilities = require("classes.utilities")

--
--

local env = system.getInfo("environment")
local gamecenter = {}
gamecenter.gpgs = nil

--
-- Google Play Games listener
gamecenter.gpgsInitListener = function(event)

    if not event.isError then
        if ( event.name == "login" ) then
            print( json.prettify(event) )
        end
    end
end

--
-- Submit score
function gamecenter:submitScore(score)

    if env ~= "simulator" then
        gamecenter.gpgs.leaderboards.submit({
            leaderboardId = utilities.leaderBoardId,
            score = score,
            listener = function() print("submittedScore") end
        })
    end
end

--
-- Open leaderboards
function gamecenter:openLeaderboard()

    if env ~= "simulator" then
        if gamecenter.gpgs then
            gamecenter.gpgs.leaderboards.show( {leaderboardId = utilities.leaderBoardId} )
        else
            gamecenter:init()
        end
    end
end

--
-- Init
function gamecenter:init()

    if env ~= "simulator" then
        gamecenter.gpgs = require("plugin.gpgs.v2")
        gamecenter.gpgs.login({ userInitiated = true, listener = gamecenter.gpgsInitListener })
    end
end

--
-- Return
return gamecenter