import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Actions.Navigation2D
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.RunOrRaise
import XMonad.Util.EZConfig
import XMonad.Layout.MultiColumns

main = do
    xmonad =<< statusBar "xmobar" xmobarPP toggleStrutsKey myConfig

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

navigationConfig = navigation2D def (xK_Up, xK_Left, xK_Down, xK_Right)
				    [(mod1Mask, windowGo),
				     (mod1Mask .|. shiftMask, windowSwap)]
                                    False

myConfig = navigationConfig $ desktopConfig
        { terminal = "termite" 
	, logHook = dynamicLogString def >>= xmonadPropLog
	, normalBorderColor = "#333"
	, focusedBorderColor = "#345"
	, layoutHook = Tall 1 (3/100) 0.5 ||| Full ||| multiCol [1] 1 0.0 (-0.5)
	} `additionalKeysP` [ ("M-p", runOrRaisePrompt xpConfig) ]

xpConfig = def { position = Top
               , alwaysHighlight = True
               , promptBorderWidth = 0
	       , font = "xft:monospace:size=9"
               }

myLayouts = tall ||| Mirror tall ||| multiCol [1] 0 0.0 (-0.5)
	where tall = Tall 1 (3/100) 0.5
