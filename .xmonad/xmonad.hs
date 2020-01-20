import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.RunOrRaise
import XMonad.Util.EZConfig
import XMonad.Layout.MultiColumns
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders

main = xmonad $ ewmh def { terminal = "gnome-terminal" 
			 , normalBorderColor = "#333"
			 , focusedBorderColor = "#648"
			 , layoutHook = smartBorders myLayouts
			 , handleEventHook = def <+> fullscreenEventHook
			 } `additionalKeysP` myBindings

myLayouts = tall ||| Grid ||| multiCol [1] 0 0.0 (-0.5)
	where tall = Tall 1 (3/100) 0.5

myBindings = 
    [("M-<Space>", spawn "rofi -combi-modi window,drun,ssh -show combi -modi combi")]
