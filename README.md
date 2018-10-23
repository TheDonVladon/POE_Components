# POE_Components
This is a free software which provides an installer for additional components for the [Path of Exile](https://www.pathofexile.com/game) (POE) game. 

### Why POE_Components is useful?
At some point, every POE player faces a need for additional programs, 
scripts, loot filters, which will make the POE experience much smoother. The installer downloads the latest versions of additional components (programs, scripts, loot filters) and installs them in the Path of Exile game folder.

In case if some component, which doesn't provide auto updater, releases a new version, execute the POE_Components installer, 
and it will download the latest version for the selected components, no need to download anything by hand.
Filters installed via POE_Components will be placed in the appropriate folder automatically, no need to move them by hand.
Additionally, POE_Components creates a custom shortcut, which runs all the scripts and shortcuts placed in the specific folder.
Check "Features" section for more info.

### Note
POE_Components was developed for Microsoft Windows users. An installer will work in any Path of Exile version unless some core changes in POE will take place in a file structure.

## Features
* AutoUpdater - download POE_Components once
* Supports English and Russian languages
* Custom shortcut, which runs all scripts and shortcuts placed in POE_Components\Components\AutoHotkey\Scripts as well as game executable - no need to run scripts/tools manually
* Chosen loot filters will be added to the game automatically - no need (but you can) in moving filter files to the appropriate folder
* Loot filter selection in the installer - no need (but you can) to select loot filter in-game if selected in the installer
* Installing LabCompass via POE_Components will add game client path to the LabCompass automatically. Run LabCompass, import maps - profit
* Compatible with GGG and Steam clients

## Components
* AutoHotkey installer
* Logout Macro
* Trade Macro
* Neversink's loot filters
* Path of Building
* LabCompass
* MercuryTrade
---
## For Developers
The installer is written using [NSIS](http://nsis.sourceforge.net/Main_Page) (Nullsoft Scriptable Install System), which is a professional open source system to create Windows installers. It is designed to be as small and flexible as possible and is therefore very suitable for internet distribution.

In order to compile source code, you should download NSIS compiler (if you prefer developing in IDE check the info below), which is available in the [NSIS package](http://nsis.sourceforge.net/Download). The file makensisw.exe in the NSIS installation folder is the actual compiler. It has a graphical front end that explains three ways to load scripts, so it's very easy to use. Once you have installed NSIS, to create an installer, copy a script into a text editor, save the file with a .nsi extension, and load the file into the makensisw compiler. Refer to [source](http://nsis.sourceforge.net/Simple_tutorials) for more info and simple tutorials.

If you prefer to work in a development environment refer to [list of IDE for NSIS](http://nsis.sourceforge.net/Category:Development_Environments). Clicking on a preferred IDE will guide you through the integration process.
