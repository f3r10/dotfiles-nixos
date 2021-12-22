-- The xmonad configuration of Derek Taylor (DistroTube)
-- http://www.youtube.com/c/DistroTube
-- http://www.gitlab.com/dwt1/
------------------------------------------------------------------------
---IMPORTS
------------------------------------------------------------------------
{-# OPTIONS_GHC -Wno-deprecations #-}

-- Utilities

-- Actions

-- Hooks

-- , doFullFloat

-- , isFullscreen

-- ( WSType(..)
-- , moveTo
-- , nextScreen
-- , prevScreen
-- , shiftPrevScreen
-- , shiftTo
-- , swapNextScreen
-- , toggleWS'
-- )

-- import XMonad.Actions.MouseResize
-- Layouts modifiers

-- Layouts

-- Prompt Modules

-- Data module
import Data.List (isInfixOf)
import qualified Data.Map as Map
import Data.Monoid
import Data.Maybe (fromJust)

import System.IO (hPutStrLn)
import XMonad hiding ((|||))
import XMonad.Actions.CopyWindow (copy, copyToAll, kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaceGroups
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.GridSelect
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Navigation2D
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.TagWindows
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Warp
import XMonad.Actions.WindowGo
import XMonad.Actions.WindowGo (raiseMaybe, runOrRaise)
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Actions.MouseResize
import XMonad.Hooks.DynamicLog (xmobarProp)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks as M
import XMonad.Hooks.ManageHelpers
  ( Side (NC, NE),
    doCenterFloat,
    doRectFloat,
    doSideFloat,
    isDialog,
    (/=?),
  )
import XMonad.Hooks.RefocusLast (refocusLastLogHook)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar (StatusBarConfig, defToggleStrutsKey, statusBarProp, withEasySB, withSB)
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Accordion
import XMonad.Layout.ShowWName
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Circle
import XMonad.Layout.Grid as G1
import XMonad.Layout.GridVariants as G
import qualified XMonad.Layout.Groups.Helpers as Gh (focusDown, focusUp)
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutScreens
import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
import XMonad.Layout.MultiToggle (Toggle (..), mkToggle, single)
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL))
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed as R (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.TwoPane
import XMonad.Prompt
import XMonad.Prompt.Shell
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare (getSortByTag)

------------------------------------------------------------------------
---CONFIG
------------------------------------------------------------------------

colorScheme = "doom-one"

colorBack = "#282c34"
colorFore = "#bbc2cf"

color01 = "#1c1f24"
color02 = "#ff6c6b"
color03 = "#98be65"
color04 = "#da8548"
color05 = "#51afef"
color06 = "#c678dd"
color07 = "#5699af"
color08 = "#202328"
color09 = "#5b6268"
color10 = "#da8548"
color11 = "#4db5bd"
color12 = "#ecbe7b"
color13 = "#3071db"
color14 = "#a9a1e1"
color15 = "#46d9ff"
color16 = "#dfdfdf"

colorTrayer :: String
colorTrayer = "--tint 0x282c34"

myFont = "xft:Mononoki Nerd Font:regular:pixelsize=18"

myModMask = mod4Mask -- Sets modkey to super/windows key

myTerminal = "alacritty" -- Sets default terminal

myTextEditor = "vim" -- Sets default text editor

myLow = "#000000" -- Lowlight color

myBack = "#1a1a1a" -- Bar background

myFore = "#999999" -- Bar foreground

myAcc = "#25629f" -- Accent color

myHigh = "#629f25" -- Highlight color

ignoredWorkspaces = ["NSP"]

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

windowCount =
  gets $
    Just
      . show
      . length
      . W.integrate'
      . W.stack
      . W.workspace
      . W.current
      . windowset

--
myXmobarPP :: PP
myXmobarPP =
  def
    { ppCurrent = xmobarColor color06 "" . wrap ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
    , ppVisible = xmobarColor color06 ""
    , ppHidden = xmobarColor color05 "" . wrap ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" 
    , ppHiddenNoWindows = xmobarColor color05 ""
    , ppTitle = xmobarColor color16 "" . shorten 60
    , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
    , ppUrgent = xmobarColor color02 "" . wrap "!" "!", -- Urgent workspace
      ppExtras = [windowCount], -- # of windows current workspace
      ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
    }

statusBar :: StatusBarConfig
statusBar = statusBarProp "/home/f3r10/.cabal/bin/xmobar ~/.config/xmobar/xmobarrc2" $ pure pp
  where
    pp =
      filterOutWsPP
        ignoredWorkspaces
        $ myXmobarPP

main =
  xmonad
    -- . ewmhFullscreen
    . ewmh
    . withSB statusBar
    . docks
    $ myConfig

myConfig =
  def
    { manageHook = myHooks,
      logHook = myLogHook,
      modMask = myModMask,
      terminal = myTerminal,
      startupHook = myStartupHook,
      layoutHook = showWName' myShowWNameTheme $ myLayoutHook,
      workspaces = myWorkspaces,
      borderWidth = myBorderWidth,
      normalBorderColor = myNormColor,
      focusedBorderColor = myFocusColor,
      mouseBindings = myMouseBindings
    }
    `additionalKeysP` newMyKeys

-- manage hooks

myHooks =
  myManageHook <+> manageDocks <+> namedScratchpadManageHook myScratchPads

myLogHook =
  refocusLastLogHook
    <> historyHook
    <> updatePointer (0.5, 0.5) (0, 0)

------------------------------------------------------------------------
---AUTOSTART
------------------------------------------------------------------------
myStartupHook =
  --spawnOnce "emacs --daemon &"
  -- spawnOnce "nitrogen --restore &"
  do
    spawn "dunst"
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    spawnOnce
      "trayer --edge top --align right --widthtype request --padding 10 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x292d3e --height 18 &"
    setWMName "LG3D"
    -- return () >> checkKeymap myConfig newMyKeys

------------------------------------------------------------------------
---KEYBINDINGS
------------------------------------------------------------------------
newMyKeys =
  --- Xmonad
  [ ("M-C-r", spawn "xmonad --recompile"), -- Recompiles xmonad
    ("M-S-r", spawn "xmonad --restart"), -- Restarts xmonad
    -- , ("M-S-q", io exitSuccess)                  -- Quits xmonad
    --- Windows
    ("M-S-q", kill1), -- Kill the currently focused client
    -- , ("M-S-a", killAll) -- Kill all the windows on current workspace
    --- Floating windows
    ("M-<Delete>", withFocused $ windows . W.sink), -- Push floating window back to tile.
    ("M-S-<Delete>", sinkAll), -- Push ALL floating windows back to tile.
    --- Windows navigation
    --
    --
    ("M-m", windows W.focusMaster), -- Move focus to the master window
    ("M-j", Gh.focusDown), -- Move focus to the next window
    ("M-k", Gh.focusUp), -- Move focus to the prev window
    ("M-S-m", windows W.swapMaster), -- Swap the focused window and the master window
    ("M-S-j", windows W.swapDown), -- Swap the focused window with the next window
    ("M-S-k", windows W.swapUp), -- Swap the focused window with the prev window
    -- , ("M-<Backspace>", promote) -- Moves focused window to master, all others maintain order
    -- this is the same the windows W.swapMaster
    ("M1-S-<Tab>", rotSlavesDown), -- Rotate all windows except master and keep focus in place
    ("M1-<Tab>", rotAllDown), -- Rotate all the windows in the current stack
    --- Layouts
    ("M-<Space>", sendMessage NextLayout), -- Switch to next layout
    ("M-f", sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts), -- Switch the current window to full screen
    -- , ("M-S-n", sendMessage $ Toggle NOBORDERS) --
    ("M-S-=", sendMessage ToggleStruts), -- Toggles noborder/full
    ("M-S-f", sendMessage (T.Toggle "float")),
    -- , ("M-S-x", sendMessage $ Toggle REFLECTX) -- it reflect the currect layout position to the same but on the other side
    ("M-S-y", sendMessage $ Toggle REFLECTY),
    --, ("M-S-m", sendMessage $ Toggle MIRROR)
    -- , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf)
    ("M-<KP_Multiply>", sendMessage (IncMasterN 1)), -- Increase number of clients in the master pane
    ("M-<KP_Divide>", sendMessage (IncMasterN (-1))), -- Decrease number of clients in the master pane
    ("M-S-<KP_Multiply>", increaseLimit), -- Increase number of windows that can be shown
    ("M-S-<KP_Divide>", decreaseLimit), -- Decrease number of windows that can be shown
    ("M1-C-h", sendMessage Shrink), -- horizontal
    ("M1-C-l", sendMessage Expand), -- horizontal
    ("M1-C-j", sendMessage MirrorShrink), -- vertical
    ("M1-C-k", sendMessage MirrorExpand), -- vertical

    --- Workspaces
    ("M-<Tab>", nextMatch History (return True)), -- return to the last active window. It does not matter if it is on other screen. Taken from https://xiangji.me/2018/11/19/my-xmonad-configuration/#layouts
    ("M-.", swapNextScreen),
    ("M-M1-k", nextScreen),
    ("M-M1-j", prevScreen),
    ("C-M-.", shiftPrevScreen),
    ("M-S-`", cycleWS Next >> bringMouse),
    ("M-`", toggleWS' ["NSP"] >> bringMouse),
    ("M-w", selectWindow),
    ("M-S-w", bringWindow),
    ("M-g", selectWS),
    ("M-S-g", takeToWS),
    ("M-S-a", addWorkspacePrompt myXPConfig),
    -- Window tagging
    ("M-t", tagWindow),
    ("M-S-t", bringTagged),
    ("C-M1-<Left>", shiftTo Next nonNSP >> moveTo Next nonNSP), -- Shifts focused window to next workspace
    ("C-M1-<Right>", shiftTo Prev nonNSP >> moveTo Prev nonNSP), -- Shifts focused window to previous workspace
    --- Open Terminal
    ("M-<Return>", spawn myTerminal),
    --- Dmenu Scripts (Alt+Ctr+Key)
    ( "M-S-d",
      spawn
        "dmenu_run -fn 'UbuntuMono Nerd Font:size=10' -nb '#292d3e' -nf '#bbc5ff' -sb '#82AAFF' -sf '#292d3e' -p 'dmenu:'"
    ),
    ("M1-C-e", spawn "./.dmenu/dmenu-edit-configs.sh"),
    -- , ("M1-C-m", spawn "./.dmenu/dmenu-sysmon.sh")
    ("M1-C-;", spawn "passmenu"),
    ("M1-C-s", spawn "./.dmenu/dmenu-surfraw.sh"),
    --- Emacs commands (Alt+key)
    ( "M1-<Space>",
      (sendMessage $ JumpToLayout "oneBig")
        >> spawn "emacs-capture --eval \'(org-capture nil\'\\\"i\\\"\')\'"
    ),
    ( "M1-d",
      (sendMessage $ JumpToLayout "oneBig")
        >> spawn ("emacs-capture --eval \'(org-capture nil\'\\\"n\\\"\')\'") --
    ),
    ---
    --- My Applications (Super+Alt+Key) ----------
    ---
    ("M-M1-w", spawn "/home/f3r10/dev/dotfiles/scripts/wacomToSideMonitor.sh"),
    ("M-M1-r", spawn $ "rofi-theme-selector"),
    ( "M1-S-d",
      spawn $ "rofi -combi-modi window,run,drun -show combi -modi combi"
    ),
    ("M-M1-v", spawn $ "pavucontrol"),
    ("M-M1-x", spawn $ "oblogout"),
    ("M-M1-d", spawn $ "thunar"),
    --
    ("M-M1-<Page_Up>", spawn ("setxkbmap es")),
    ("M-M1-<Page_Down>", spawn ("setxkbmap us")),
    -- open / close microfono
    ("M-M1-m", spawn "amixer set Capture toggle"),
    --- Multimedia Keys
    ("<XF86AudioPlay>", spawn "playerctl play-pause"),
    ("<XF86AudioMute>", spawn "amixer set Master toggle"), -- Bug prevents it from toggling correctly in 12.04.
    ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute"),
    ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute"),
    ("<xF86XK_MonBrightnessUp>", spawn "brightnessctl set 20%+"),
    ("<xF86XK_MonBrightnessDown>", spawn "brightnessctl set 20%-"),
    ("C-<Print>", spawn "xfce4-screenshooter -r "),
    ("C-M-<Print>", spawn "maim -s | xclip -selection clipboard -t image/png"),
    -- Shell Prompt
    ( "M-p",
      spawn
        ( "dmenu_run -b -i -fn '"
            ++ myFont
            ++ "' -nb '"
            ++ myBack
            ++ "' -nf '"
            ++ myFore
            ++ "' -sb '"
            ++ myHigh
            ++ "'"
        )
    ),
    ("M-r-l", shellPrompt myXPConfig)
  ]
    -- inspiration for this and many other things come from here https://gist.github.com/tylevad/3146111
    ++ [("M-d " ++ k, f) | (k, f) <- utils]
    ++ [("M-a " ++ k, f) | (k, f) <- style]
    ++ [ ("M-s " ++ k, (bindOn [("vbox", firefoxPrompt f), ("", firefoxPrompt f)]))
         | (k, f) <- query
       ]
    ++ [ ("M-S-s " ++ k, (bindOn [("vbox", firefoxSelect f), ("", firefoxSelect f)]))
         | (k, f) <- query
       ]
  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "nsp"))
    role = stringProperty "WM_NAME"
    firefoxPrompt f = S.promptSearchBrowser myXPConfig "firefox" f
    chromiumPrompt f = S.promptSearchBrowser myXPConfig "google-chrome" f
    firefoxSelect f = S.selectSearchBrowser "firefox" f
    chromiumSelect f = S.selectSearchBrowser "google-chrome" f
    utils =
      [ ("a", spawnApp),
        ("t", scratchToggle "terminal" <!> notification "hello"),
        ("c", scratchToggle "asana"),
        ("d", scratchToggle "dictionary"),
        ("m", spawn "xrandr --output eDP-1 --off --output DP-2 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output HDMI-1-0 --off --output DP-1-0 --off --output DP-1-1 --off" <!> notification "monitor"),
        ("b", spawn "xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --primary --mode 2560x1080 --pos 1920x0 --rotate normal --output HDMI-1 --off" <!> notification "monitor and laptop")
      ]
    style =
      [ ("t", sendMessage $ JumpToLayout "Tile"),
        ("u", sendMessage $ JumpToLayout "Wide"),
        ("d", sendMessage $ JumpToLayout "Dual"),
        ("f", sendMessage $ JumpToLayout "FullNoBorders"),
        ("a", sendMessage $ JumpToLayout "Fold"),
        ("q", sendMessage $ JumpToLayout "ResizableTall"),
        ("m", sendMessage $ Toggle MIRROR),
        ("r", sendMessage $ Toggle REFLECTX),
        ("s", layoutSplitScreen 2 (TwoPane 0.5 0.5)),
        ("z", layoutSplitScreen 2 (TwoPane 0.4 0.6)),
        ("w", rescreen),
        -- Copy Window
        ("c", windows copyToAll),
        ("x", killAllOtherCopies)
      ]
    query =
      [ ("g", S.intelligent S.google),
        ( "a",
          S.searchEngine
            "Arch"
            "http://wiki.archlinux.org/index.php/Special:Search?search="
        ),
        ( "d",
          S.searchEngine "Dictionary" "http://dictionary.reference.com/browse/"
        ),
        ( "e",
          S.searchEngine "Etymology" "http://www.etymonline.com/index.php?term="
        ),
        ( "t",
          S.searchEngine "Thesaurus" "http://thesaurus.reference.com/browse/"
        ),
        ( "w",
          S.searchEngine
            "Wikipedia"
            "http://en.wikipedia.org/wiki/Special:Search?search="
        )
      ]
    notification msg = Message Normal "Screen layout" msg

------------------------------------------------------------------------
---WORKSPACES
------------------------------------------------------------------------
myWorkspaces :: [String]
myWorkspaces =
  -- clickable . map xmobarEscape $
  ["dev", "web", "NSP"]

myWorkspaceIndices = Map.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ Map.lookup ws myWorkspaceIndices

-- where
--   clickable l =
--     [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>"
--     | (i, ws) <- zip [1 .. 3] l
--     , let n = i
--     ]

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook =
  composeAll
    [ className =? "Virtualbox" --> doFloat,
      className =? "Oblogout" --> doCenterFloat,
      -- , className =? "Gimp"        --> doShift "<action=xdotool key super+8>gfx</action>"
      (className =? "firefox" <&&> resource =? "Toolkit")
        --> ( doRectFloat (W.RationalRect (0.5) (0.03) (0.5) (0.5)) -- Float Firefox Dialog
            ),
      (className =? "firefox" <&&> resource =? "whatsappWindow") --> doFloat, -- Float Firefox Dialog
      (className =? "Emacs" <&&> resource =? "emacs-capture") --> doSideFloat NC, -- Float Firefox Dialog
      isDialog --> doCenterFloat,
      ( role =? "Picture-in-Picture"
          -->
          -- doRectFloat (W.RationalRect (0.69) (0.03) (0.3) (0.5))
          doSideFloat NE
      )
    ]
  where
    role = stringProperty "WM_NAME"

-- inspiration: https://gist.github.com/wfaler/d8c0e25c19883f38b31376156ea0a467
myLayoutHook =
  avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
  mkToggle (single MIRROR) $
    mkToggle (single REFLECTX) $
      mkToggle
        (single NBFULL) -- put only the select window to Full mode
        main
  where
    main =
      threeColMid
        ||| resizableTall
        ||| noBordersFull
        ||| tall
        ||| grid
        ||| dual
        ||| fold
    tall = renamed [R.Replace "Tile"] (ResizableTall 1 (2 / 100) (11 / 18) [])
    grid = renamed [R.Replace "Grid"] $ G.Grid (16 / 9)
    dual = renamed [R.Replace "Dual"] (TwoPane (2 / 100) (1 / 2))
    -- full = Full
    fold = renamed [R.Replace "Fold"] Accordion
    threeColMid = renamed [R.Replace "Wide"] $ (ThreeColMid 1 (3 / 100) (3 / 7))
    resizableTall =
      renamed [R.Replace "ResizableTall"] $
        (ResizableTall 1 (3 / 100) (1 / 2) [])
    noBordersFull = renamed [R.Replace "FullNoBorders"] $ noBorders Full -- grid2 = renamed [R.Replace "Grid2"] $ G1.Grid
    floats   = renamed [Replace "floats"]
      $ smartBorders
      $ limitWindows 20 simplestFloat

------------------------------------------------------------------------
---SCRATCHPADS
------------------------------------------------------------------------
myScratchPads =
  [ NS "asana" spawnAsana findAsana manageAsana,
    NS "terminal" spawnTerm findTerm manageTerm,
    NS "dictionary" spawnDict findDict manageDict
    -- , NS "xournalpp" spawnXournalapp findXournalapp manageXournalapp
  ]
  where
    spawnAsana =
      "google-chrome --app='https://app.asana.com/0/14375516061093/list'"
    findAsana = resource =? "app.asana.com__0_14375516061093_list"
    manageAsana = doCenterFloat
    spawnTerm = myTerminal ++ " -t scratchpad"
    findTerm = role =? "scratchpad"
    manageTerm = smallRect
    spawnDict = "stardict"
    findDict = className =? "Stardict"
    manageDict = customFloating $ W.RationalRect l t w h
      where
        h = 0.6
        w = 0.6
        t = (1 - h) / 2
        l = (1 - w) / 2
    role = stringProperty "WM_NAME"
    smallRect =
      (customFloating $ W.RationalRect (1 / 6) (1 / 6) (2 / 3) (2 / 3)) -- ++

myMouseBindings (XConfig {XMonad.modMask = modMask}) =
  Map.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modMask, 1),
        (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modMask, 2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modMask, 3),
        (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
      )
    ] -- Get workspace sort without NSP

---- utils ----

getFilterSort = fmap (. filterWS "NSP") getSortByTag

filterWS a = filter (\(W.Workspace tag _ _) -> tag /= a)

-- Find and display hidden workspace in given direction using sort
findWS dir t = findWorkspace getFilterSort dir t 1

viewWS dir = windows . W.greedyView =<< findWS dir HiddenNonEmptyWS

-- Warp
bringMouse = warpToWindow (9 / 10) (9 / 10)

-- Remove empty workspaces except static ones declared in myWS
cycleWS dir = removeEmptyWorkspaceAfterExcept myWorkspaces (viewWS dir)

spawnApp = runSelectedAction (myGSConfig pink) myApps

selectWindow =
  goToSelected (myGSConfig blue) >> windows W.swapMaster >> bringMouse

bringWindow = bringSelected (myGSConfig orange) >> bringMouse

selectWS = gridselectWorkspace (myGSConfig green) W.greedyView >> bringMouse

takeToWS =
  gridselectWorkspace (myGSConfig purple) (\ws -> W.greedyView ws . W.shift ws)
    >> bringMouse

-- GridSelect config
myGSConfig colorizer =
  (buildDefaultGSConfig colorizer)
    { gs_cellheight = 45,
      gs_cellpadding = 5,
      gs_cellwidth = 325
    }

-- Colorizer colors for GridSelect
--aqua   = myColor "#259f62"
blue = myColor "#25629f"

green = myColor "#629f25"

orange = myColor "#9f6225"

pink = myColor "#9f2562"

purple = myColor "#62259f"

-- Colorizer generator
myColor color _ isFg = do
  return $
    if isFg
      then (color, myLow)
      else (myLow, color)

-- XPConfig - Prompt fields
myXPConfig =
  def
    { font = "xft:" ++ myFont,
      fgColor = myFore,
      bgColor = myBack,
      bgHLight = myBack,
      fgHLight = myHigh,
      borderColor = myBack,
      position = Bottom,
      height = 16,
      historySize = 0
    }

-- Window tagging
bringTagged =
  withTaggedGlobalP "tagged" shiftHere
    >> withTaggedGlobal "tagged" (delTag "tagged")

tagWindow = withFocused (addTag "tagged")

myApps =
  [ ("emacs", (raiseClass "emacsclient -a emacs -c" "Emacs")),
    ("Firefox", (raiseApp "fox" "firefox")),
    ("Slack", (raiseApp "chat" "slack")),
    ( "Chrome",
      ( raiseApp''
          "work"
          "google-chrome --profile-directory='Default'"
          "google-chrome"
          "Google-chrome"
      )
    ),
    ("Terminal", (spawn myTerminal)),
    ( "logseq",
      ( raiseApp'''
          "google-chrome --app='https://logseq.com/' --profile-directory='Profile 1'"
          "logseq.com"
          "Google-chrome"
      )
    ),
    ( "tk-dev",
      ( raiseRole
          "work"
          "alacritty --class tk-dev --title tk-dev  --working-directory /home/f3r10/dev/listatree/talenteca"
          "tk-dev"
      )
    ),
    ( "notes",
      (raiseRole' "emacsclient -c -F \"((name . \\\"notes\\\"))\"" "notes")
    )
    -- ,("GVim",         (raiseApp' "gvim"))
    -- ,("Steam",        (raiseApp  "steam" "steam"))
    -- ,("Gimp",         (raiseApp  "gimp" "gimp"))
    -- ,("Win7",         (raiseApp  "Win7" "virtualbox --startvm Win7 --start-paused"))
    -- ,("Inkscape",     (raiseApp  "ink" "inkscape"))
    -- ,("LibreOffice",  (raiseApp  "doc" "libreoffice"))
    -- ,("Video",        (spawn     "vlc"))
    -- ,("Themes",       (spawn     "lxappearance"))
    -- ,("Wallpaper",    (raiseApp' "nitrogen"))
  ]
  where
    raiseApp ws a =
      (raiseNextMaybe (spawnWS ws a) (className ~? a)) >> bringMouse
    raiseApp' a = (raiseNextMaybe (spawn a) (appName ~? a)) >> bringMouse
    raiseClass c a =
      (raiseNextMaybe (spawn c) (className ~? a <&&> title /=? "notes"))
        >> bringMouse
    raiseRole ws c r =
      (raiseNextMaybe (spawnWS ws c) (appName ~? r)) >> bringMouse
    raiseRole' c r = (raiseNextMaybe (spawn c) (title ~? r)) >> bringMouse
    raiseApp'' ws a r c =
      (raiseNextMaybe (spawnWS ws a) (resource ~? r <&&> className ~? c))
        >> bringMouse
    raiseApp''' a r c =
      (raiseNextMaybe (spawn a) (resource ~? r <&&> className ~? c))
        >> bringMouse
    role = stringProperty "WM_NAME"

-- , ("M-M1-c", runOrRaise "slack" (className =? "Slack"))

-- Named Workspace Navigation
spawnWS ws a = addWorkspace ws >> spawn a

-- Scratchpad invocation (for brevity)
scratchToggle a = namedScratchpadAction myScratchPads a >> bringMouse

q ~? x = fmap (x `isInfixOf`) q -- haystack includes needle?

-- Send notification
data UrgencyLevel
  = Low
  | Normal
  | Critical

instance Show UrgencyLevel where
  show Low = "low"
  show Normal = "normal"
  show Critical = "critical"

data Notification
  = Message UrgencyLevel String String
  | Command UrgencyLevel String String

wrapInQuotes, wrapIntoCommand :: String -> String
wrapInQuotes = wrap "'" "'"

wrapIntoCommand = wrap "$(" ")"

sendNotification :: Notification -> X ()
sendNotification (Message uLevel summary body) =
  spawn
    ("notify-send " ++
     wrapInQuotes summary ++ " " ++ wrapInQuotes body ++ " -u " ++ wrapInQuotes (show uLevel))
sendNotification (Command uLevel summary body) =
  spawn
    ("notify-send " ++
     wrapInQuotes summary ++ " " ++ wrapIntoCommand body ++ " -u " ++ wrapInQuotes (show uLevel))

(<!>) :: X () -> Notification -> X ()
(<!>) action notification = action >> sendNotification notification

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }
