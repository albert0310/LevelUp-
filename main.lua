display.setStatusBar(display.HiddenStatusBar)
native.setProperty("preferredScreenEdgesDeferringSystemGestures", true)

local composer = require('composer')
composer.recycleOnSceneChange = true

if ( system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 ) then
	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end




system.activate("multitouch")

audio.reserveChannels( 1 )
audio.setVolume( 0.2, { channel=1 } )

composer.gotoScene( "scenes.menu" )
