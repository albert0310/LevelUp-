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


composer.gotoScene( "scenes.menu" )
