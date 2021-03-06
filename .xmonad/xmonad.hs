-- {{{
--        Initially from not4aw3some at deviantart.com
--- }}}

-- {{{ Imports
-- stuff
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import System.IO
import IO (Handle, hPutStrLn) 
 
-- utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.NoBorders
 
-- hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.XPropManage
-- Dialog and menu hooks
import Graphics.X11.Xlib.Extras
import Foreign.C.Types (CLong)
 
-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.SimplestFloat
import Data.Ratio((%))
-- }}}
-------------------------------------------------------------------------------
-- {{{ Main
main = do
       h <- spawnPipe "xmobar"
       xmonad $ defaultConfig 
              { workspaces = ["main", "www", "code", "im", "vid", "doc", "misc"]
              , modMask = mod4Mask
              , borderWidth = 1
              , normalBorderColor = "#5a5a5a"
              , focusedBorderColor = "#daff30"
              , terminal = "xterm"
              , keys = keys'
              , logHook = logHook' h 
              , layoutHook = layoutHook'
              , manageHook = manageHook'
              }
-- }}}
-------------------------------------------------------------------------------
-- {{{ Log Hooks
logHook' :: Handle ->  X ()
logHook' h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

customPP :: PP
customPP = defaultPP { ppCurrent = xmobarColor "#daff30" "#000000" . wrap "[" "]"
                     , ppTitle =  shorten 80
                     , ppSep =  "<fc=#daff30> | </fc>"
                     , ppHiddenNoWindows = xmobarColor "#777777" ""
                     , ppUrgent = xmobarColor "#AFAFAF" "#333333" . wrap "*" "*"
                     }
-- }}}
-------------------------------------------------------------------------------
-- {{{ Layout hooks
layoutHook' = customLayout
customLayout =  avoidStruts $ onWorkspace "im" im $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| im ||| noBorders Full ||| smartBorders simplestFloat

-- [[old (made gap for bottom)
-- customLayout = gaps [(D,16)] $ avoidStruts $ onWorkspace "im" im $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| im ||| noBorders Full
-- ]]end

  where
    tiled = named "[]=" $ ResizableTall 1 (2/100) (1/2) [] --"Tiled"
    im = named "InstantMessenger" $ withIM (12/50) (Role "buddy_list") Grid
-- }}}
-------------------------------------------------------------------------------
-- {{{ Dialog and menu hooks
getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w

checkAtom name value = ask >>= \w -> liftX $ do
                a <- getAtom name
                val <- getAtom value
                mbr <- getProp a w
                case mbr of
                  Just [r] -> return $ elem (fromIntegral r) [val]
                  _ -> return False 

checkDialog = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"
checkMenu = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"

manageMenus = checkMenu --> doFloat
manageDialogs = checkDialog --> doFloat
-- }}}
-------------------------------------------------------------------------------
-- {{{ Manage Hooks
myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [ className       =? c                 --> doFloat | c <- myFloats ]
    , [ title           =? t                 --> doFloat | t <- myOtherFloats ]
    , [ resource        =? r                 --> doIgnore | r <- myIgnores ]
  --  , [ (className =? "URxvt" <&&> title =? "urxvt") --> doF (W.shift "1:main")]
    , [ className       =? "Vimperator"       --> doF (W.shift "www") ]
    , [ className       =? "Firefox"         --> doF (W.shift "www") ]
--    , [ className       =? "Gimp"            --> doF (W.shift "etc") ]
--    , [ className       =? "Gvim"            --> doF (W.shift "code") ]
    , [ className       =? "OpenOffice.org 3.0" --> doF (W.shift "doc") ]
    , [ className       =? "Abiword"                     --> doF (W.shift "doc") ]
    , [ className       =? "Pidgin"          --> doF (W.shift "im") ]
    ]
    where
        myIgnores       = ["trayer", "stalonetray"]
        myFloats        = ["Gmlive", "Thunar", "Sonata", "File-roller"]
        myOtherFloats   = ["alsamixer", "Firefox", "Clear Prevate Data", "Download; Firefox", "addons", "Dialog", "Downloads", "Firefox Preferences", "Save As...", "Send file", "Open", "File Transfers"]

manageHook' :: ManageHook
manageHook' = manageHook defaultConfig <+> manageDocks <+> manageMenus <+> manageDialogs <+> myManageHook
-- }}}
-------------------------------------------------------------------------------
-- {{{ Keys/Button bindings
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask,               xK_Return     ), spawn $ XMonad.terminal conf)
    , ((modMask,               xK_F2     ), spawn "dmenu_run -fn \"-*-terminus-medium-r-normal-*-12-*-*-*-*-*-*-*\" -nb \"#daff30\" -nf \"#888888\" -sb \"#2A2A2A\" -sf \"#daff30\"")
    , ((modMask,               xK_F1    ), spawn "gmrun")
	, ((modMask .|. shiftMask, xK_f     ), spawn "firefox")
    , ((modMask .|. shiftMask, xK_q     ), kill)
    , ((modMask .|. shiftMask, xK_r     ), spawn "thunar")
	, ((modMask,               xK_Right ), spawn "mpc next")
	, ((modMask,               xK_Left  ), spawn "mpc prev")
    , ((modMask,               xK_Up    ), spawn "amixer -q set Master 2dB+")
    , ((modMask,               xK_Down  ), spawn "amixer -q set Master 2dB-")
    , ((modMask .|. shiftMask, xK_Left  ), spawn "mpc pause")
	, ((modMask .|. shiftMask, xK_Right ), spawn "mpc play")
	, ((modMask .|. shiftMask, xK_Down  ), spawn "mpc stop")
    , ((modMask,               xK_Print ), spawn "scrot -d 3 'shot-%Y%m%d-%H.%M.%S.png'")


    -- layouts
    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modMask,               xK_b     ), sendMessage ToggleStruts)
 
    -- floating layer stuff
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
 
    -- refresh
    , ((modMask,               xK_n     ), refresh)
    , ((modMask .|. shiftMask, xK_w     ), withFocused toggleBorder)
 
    -- focus
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)
 
    -- swapping
    , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- increase or decrease number of windows in the master area
    , ((modMask .|. controlMask, xK_h     ), sendMessage (IncMasterN 1))
    , ((modMask .|. controlMask, xK_l     ), sendMessage (IncMasterN (-1)))
 
    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
 
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_BackSpace     ), io (exitWith ExitSuccess))
    , ((modMask              , xK_q     ), restart "xmonad" True)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
-- }}}
