local utilities = require("classes.utilities")
local admob = require("plugin.admob")

local ads = {}
ads.flagInterstitialLoaded = false
ads.flagInterstitialShowing = false
ads.admob_id = ""
ads.admob_interstitial_id = ""

ads.adListener = function(event)

    if ( event.phase == "init" ) then
        admob.load( "interstitial", { adUnitId=ads.admob_interstitial_id } )
    elseif ( event.phase == "loaded" ) then
        if ( event.type == "interstitial" ) then
            ads.flagInterstitialLoaded = true
        end
    end
end

function ads:init()

    ads.admob_id = utilities.admob_id
    ads.admob_interstitial_id = utilities.admob_interstitial_id

    admob.init( ads.adListener, { appId=ads.admob_id } )
end

function ads:clear()

    self.onComplete = nil
end

function ads:checkIfInterstitial()

    return admob.isLoaded( "interstitial" )
end

function ads:loadInterstitial()

    admob.load( "interstitial", { adUnitId=ads.admob_interstitial_id } )
end

function ads:showInterstitial()

    admob.show("interstitial")
end

return ads