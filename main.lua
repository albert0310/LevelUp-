display.setStatusBar(display.HiddenStatusBar)
native.setProperty("preferredScreenEdgesDeferringSystemGestures", true)

local composer = require('composer')
composer.recycleOnSceneChange = true


native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 

system.activate("multitouch")

audio.reserveChannels( 1 )
audio.setVolume( 0.2, { channel=1 } )

timer.performWithDelay( 1000, function()
    composer.gotoScene( "scenes.menu" )
end )