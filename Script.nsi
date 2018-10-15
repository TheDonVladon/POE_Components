; NSIS script for POE Components Installer
; Source: https://github.com/TheDonVladon/POE_Components
;
; Copyright (C) <2018>  <Vladislav Pishchikov>
; Email: thedonvladon@gmail.com
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <https://www.gnu.org/licenses/>.

Unicode true

; Additional includes used in the project 
!addincludedir "includes"
; Additional plugins used in the project
!addplugindir "plugins"

; Provides a user interface for NSIS installers with a modern wizard style
!include "MUI2.nsh"
; Allows creation of custom pages
!include "nsDialogs.nsh"
; Provides macros for logical structures such as conditional execution and loops
!include "LogicLib.nsh"
; File Functions header
!include "FileFunc.nsh"
; Provides a function, which dumps the log of the installer (installer details) to a file of your choice
!include "DumpLog.nsh"
; Provides list of function for string manipulations
!include "StringFunctions.nsh"
; Provides a function, which saves a list of searched files in file
!include "MakeFileList.nsh"

; General
  
  !define VERSION "1.0.0"
  !define OUT_FILE_NAME "POE_Components"

  ; Setup name
  Name "POE Components"
  ; Output file
  OutFile "Output\${OUT_FILE_NAME}_${VERSION}.exe"
  ; Request application privileges for Windows Vista/7/8/10
  RequestExecutionLevel admin
  ; Remove disk space text
  SpaceTexts none
  ; Change default branding text
  BrandingText "POE Components v${VERSION}"
  ; Version info
  VIProductVersion "${VERSION}.0"
  VIAddVersionKey "FileVersion" "${VERSION}.0"
  VIAddVersionKey "ProductVersion" "${VERSION}"
  VIAddVersionKey "ProductName" "POE Components"
  VIAddVersionKey "FileDescription" "POE Components Installer"
  VIAddVersionKey "LegalCopyright" "Copyright (C) 2018"
  
; --------------------------------
; Variables

  Var varPOEProfileDir
  Var varDialog
  Var varHwnd

; --------------------------------
; Macro's

  ; Show MRSSAGEBOX with Abort, Retry, Ignore buttons
  ; 
  ; Usage:
  ; 
  ; mandatory goto labels:
  ;  1. retry
  ;  2. abort
  ;
  ; eg. !insertmacro ShowAbortRetryIgnore "Message text"
  ;
  !macro ShowAbortRetryIgnore _Message
    MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION "${_Message}\
          $\r$\nDetails have been saved to ${ERROR_LOG_PATH}\
          $\r$\n$\r$\nClick Abort to quit installation.\
          $\r$\nClick Retry to try again.\
          $\r$\nClick Ignore to ignore AutoHotkey installation."\
          /SD IDIGNORE IDRETRY retry IDABORT abort
  !macroend
  
  ; Log error message to file
  ; 
  ; Usage:
  ;
  ; ${LogMsg} "C:\MyProject\Logs\errors.log" "Error Message"
  ;
  !define LogMsg "!insertmacro LogMsg"
  !macro LogMsg _LogPath _Message
    Push "${_LogPath}"
    Push "${_Message}"
    Call LogMsg
  !macroend
  
  ; Write list of files to a file
  ; 
  ; Usage:
  ;
  ; ${WriteFileList} "C:\TempFolder\file.txt" "*.ext" "C:\"
  ;
  !define WriteFileList "!insertmacro WriteFileList"
  !macro WriteFileList _WriteTo _Filter _SearchIn
    Push "${_WriteTo}"
    Push "${_Filter}"
    Push "${_SearchIn}"
    Call MakeFileList
  !macroend
  
  ; Remove leading and trailing whitespaces from a string
  ;
  ; Usage:
  ; 
  ; ${Trim} $trimmedString $originalString
  ;
  !define Trim "!insertmacro Trim"
  !macro Trim _ResultVar _String
    Push "${_String}"
    Call Trim
    Pop "${_ResultVar}"
  !macroend
  
; --------------------------------
; Custom Settings

  !define BATCH_PATH "$INSTDIR\..\Path of Exile With Components.bat"
  
  !define DESKTOP_SHORTCUT_PATH "$DESKTOP\Path of Exile With Components.lnk"
  
  !define POE_CONFIG_INI "production_Config.ini"
  !define POE_EXE "PathOfExile.exe"
  !define POE_PROFILE_DIR "My Games\Path of Exile"
  
  !define DEFAULT_INSTDIR_NAME "POE_Components"
  !define COMPONENTS_DIR "$INSTDIR\Components"

  !define LOGS_DIR "${COMPONENTS_DIR}\logs"
  !define ERROR_LOG_PATH "${LOGS_DIR}\errors.log"

  !define CONFIG_XML_URL "https://raw.githubusercontent.com/TheDonVladon/POE_Components/master/config.xml"
  !define CONFIG_XML_PATH "$PLUGINSDIR\config.xml"
  !define CONFIG_XML_VERSION_XPATH "POE_Components/settings/version"
  !define RELEASE_URL_PART "https://github.com/TheDonVladon/POE_Components/releases/download/"

; --------------------------------
; Interface Settings

  !define MUI_ABORTWARNING

  !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "assets\images\header\poe-components-logo.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "assets\images\wizard\page-welcome.bmp"
  !define MUI_ICON "assets\images\icons\poe-components-logo-icon.ico"
  
  !define MUI_FINISHPAGE_SHOWREADME ""
  !define MUI_FINISHPAGE_SHOWREADME_CHECKED
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(CREATE_SHORTCUT_CHECKBOX_TEXT)"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateDesktopShortcut

  !define MUI_FINISHPAGE_LINK "POE Components WIKI"
  !define MUI_FINISHPAGE_LINK_LOCATION ""

  !define MUI_COMPONENTSPAGE_NODESC
  
; --------------------------------
; Components Settings

  ; AutoHotkey
  !define AHK_URL "https://autohotkey.com/download/ahk-install.exe"
  !define AHK_DIR "${COMPONENTS_DIR}\AutoHotkey"
  !define AHK_EXE_PATH "$PLUGINSDIR\ahk-install.exe"
  !define AHK_SCRIPTS_DIR "${AHK_DIR}\Scripts"

  ; AutoHotkey Scripts
  !define AHK_TradeMacro_URL "https://github.com/PoE-TradeMacro/POE-TradeMacro/archive/master.zip"
  !define AHK_TradeMacro_DIR "${AHK_DIR}\TradeMacro"
  !define AHK_TradeMacro_ZIP_PATH "$PLUGINSDIR\POE-TradeMacro.zip"
  !define AHK_TradeMacro_SCRIPT "Run_TradeMacro.ahk"
  
  !define AHK_LogoutMacro_URL "http://lutbot.com/ahk/macro.ahk"
  !define AHK_LogoutMacro_DIR "${AHK_DIR}\LogoutMacro"
  !define AHK_LogoutMacro_SCRIPT_PATH "${AHK_LogoutMacro_DIR}\macro.ahk"  

  ; LootFilters
  !define LootFilters_DIR "${COMPONENTS_DIR}\LootFilters"
  !define LootFilters_NeverSink_URL "https://github.com/NeverSinkDev/NeverSink-Filter/archive/master.zip"
  !define LootFilters_NeverSink_DIR "${LootFilters_DIR}\NeverSink"
  !define LootFilters_NeverSink_ZIP_PATH "$PLUGINSDIR\NeverSink.zip"
  !define LootFilters_FILE_LIST_PATH "$PLUGINSDIR\filelist.txt"
  
  ; Path Of Building
  !define POB_URL "https://github.com/Openarl/PathOfBuilding/releases/download/v1.4.99/PathOfBuilding-Setup-1.4.99.exe"
  !define POB_EXE_PATH "$PLUGINSDIR\PathOfBuilding-Setup.exe"

; --------------------------------
; Pages

  !define MUI_PAGE_CUSTOMFUNCTION_SHOW WelcomePageShow
  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_LICENSE "$(MUI_PAGE_LICENSE)"

  !insertmacro MUI_PAGE_COMPONENTS

  !define MUI_PAGE_HEADER_TEXT "$(MUI_PAGE_HEADER_TEXT)"
  !define MUI_PAGE_HEADER_SUBTEXT "$(MUI_PAGE_HEADER_SUBTEXT)"
  !define MUI_DIRECTORYPAGE_TEXT_TOP "$(MUI_DIRECTORYPAGE_TEXT_TOP)"
  !insertmacro MUI_PAGE_DIRECTORY

  !insertmacro MUI_PAGE_INSTFILES

  Page custom LootFiltersPage LootFiltersPageLeave

  !define MUI_PAGE_CUSTOMFUNCTION_SHOW FinishPageShow
  !insertmacro MUI_PAGE_FINISH
  
; --------------------------------
; Languages
 
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "Russian"

; Language strings
  
  LicenseLangString MUI_PAGE_LICENSE ${LANG_ENGLISH} "LICENSE.txt"
  LicenseLangString MUI_PAGE_LICENSE ${LANG_RUSSIAN} "LICENSE_RUS.txt"

  LangString MUI_PAGE_HEADER_TEXT ${LANG_ENGLISH} "Choose Location to Path of Exile"
  LangString MUI_PAGE_HEADER_TEXT ${LANG_RUSSIAN} "Выберите путь к Path of Exile"

  LangString MUI_PAGE_HEADER_SUBTEXT ${LANG_ENGLISH} "Choose the Path of Exile folder in which POE Components will be installed."
  LangString MUI_PAGE_HEADER_SUBTEXT ${LANG_RUSSIAN} "Укажите папку Path of Exile, в которкую будут утсановлены POE Components."

  LangString MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_ENGLISH} "Setup will install POE Components in the following folder. To install in a different folder, click Browse and select another folder. \
 Click install to start the installation.$\r$\n$\r$\nIn case if the install button is not clickable, make sure that you have chosen a folder where Path of Exile is installed."
  LangString MUI_DIRECTORYPAGE_TEXT_TOP ${LANG_RUSSIAN} "Программа установки установит POE Components в следующую папку. Чтобы установить в другую папку, нажмите 'Обзор' и выберите другую папку. \
  Нажмите 'Установить', чтобы начать утсановку.$\r$\n$\r$\nВ случае, если кнопка 'Установить' недоступна, убедитесь, что вы выбрали папку, в которой установлена Path of Exile."

  LangString MUI_INNERTEXT_LICENSE_TOP ${LANG_RUSSIAN} "Для перемещения по тексту используйте клавиши 'PageUp' и 'PageDown'."
  LangString MUI_INNERTEXT_LICENSE_BOTTOM ${LANG_RUSSIAN} "Если вы принимаете условия соглашения, нажмите кнопку 'Принимаю'. Чтобы установить программу, необходимо принять соглашение."

  LangString MUI_TEXT_FINISH_INFO_TEXT ${LANG_RUSSIAN} "Установка $(^NameDA) выполнена.$\r$\n$\r$\nНажмите кнопку 'Готово' для выхода из программы установки."
  
  LangString WIKI_URL ${LANG_ENGLISH} "https://github.com/TheDonVladon/POE_Components/wiki/Home"
  LangString WIKI_URL ${LANG_RUSSIAN} "https://github.com/TheDonVladon/POE_Components/wiki/RUS:Home"  

  LangString DOWNLOAD_ERROR_TEXT ${LANG_ENGLISH} "Download Error!"
  LangString DOWNLOAD_ERROR_TEXT ${LANG_RUSSIAN} "Ошибка скачивания!"

  LangString SEARCH_LOGOUTMACRO_ERROR_TEXT ${LANG_ENGLISH} "Logout Macro script is not found in ${AHK_LogoutMacro_DIR}."
  LangString SEARCH_LOGOUTMACRO_ERROR_TEXT ${LANG_RUSSIAN} "Logout Macro не найден в ${AHK_LogoutMacro_DIR}."

  LangString UNZIP_ERROR_TEXT ${LANG_ENGLISH} "Unzip Error!"
  LangString UNZIP_ERROR_TEXT ${LANG_RUSSIAN} "Ошибка при распаковке!"

  LangString ARCHIVE_NOTFOUND_ERROR_TEXT ${LANG_ENGLISH} "Archive (.zip) is not found in"
  LangString ARCHIVE_NOTFOUND_ERROR_TEXT ${LANG_RUSSIAN} "Архив (.zip) не найдет в"

  LangString POE_NOTFOUND_ERROR_TEXT ${LANG_ENGLISH} "Path of Exile was not found on your computer. Aborting installation!"
  LangString POE_NOTFOUND_ERROR_TEXT ${LANG_RUSSIAN} "Path of Exile не был найден на вашем компьютере. Отмена установки!"

  LangString POE_PROFILE_NOTFOUND_ERROR_TEXT ${LANG_ENGLISH} "Path of Exile Profile (${POE_PROFILE_DIR}) was not found on your computer. Aborting installation."
  LangString POE_PROFILE_NOTFOUND_ERROR_TEXT ${LANG_RUSSIAN} "Профиль Path of Exile (${POE_PROFILE_DIR}) не был найден на вашем компьютере. Отмена установки."

  LangString LOOTFILTER_SELECT_FILTER_LABEL_TEXT ${LANG_ENGLISH} "Select the loot filter, which will be used in-game:"
  LangString LOOTFILTER_SELECT_FILTER_LABEL_TEXT ${LANG_RUSSIAN} "Выберите лут-фильтр, который будет использоваться в игре:"
  LangString LOOTFILTER_NOFILTER_NOTICE_TEXT ${LANG_ENGLISH} "Without loot filter the game may look like this:"
  LangString LOOTFILTER_NOFILTER_NOTICE_TEXT ${LANG_RUSSIAN} "Без лут-фильтра игра может выглядеть так:"
  LangString LOOTFILTER_SELECTED_TEXT ${LANG_ENGLISH} "filter has been selected in Path of Exile."
  LangString LOOTFILTER_SELECTED_TEXT ${LANG_RUSSIAN} "фильтр выбран в Path of Exile."
  LangString LOOTFILTER_NEVERSINK_EXISTS_TEXT ${LANG_ENGLISH} "NeverSink's loot filters already exists.$\r$\nDo you want to overwrite existing filters?"
  LangString LOOTFILTER_NEVERSINK_EXISTS_TEXT ${LANG_RUSSIAN} "NeverSink's лут-фильтры уже существуют.$\r$\nХотите переписать существующие фильтры?"

  LangString CREATE_SHORTCUT_CHECKBOX_TEXT ${LANG_ENGLISH} "Create desktop shortcut"
  LangString CREATE_SHORTCUT_CHECKBOX_TEXT ${LANG_RUSSIAN} "Создать ярлык на рабочем столе"

  LangString UPDATE_AVAILABLE_TEXT ${LANG_ENGLISH} "A newer version for POE Components is available.$\r$\nUpdate POE Components?"
  LangString UPDATE_AVAILABLE_TEXT ${LANG_RUSSIAN} "Доступна новая версия для POE Components.$\r$\nОбновить POE Components?"

; --------------------------------
; Installer Sections

; Main installer, hidden section
  Section "-POE_Components"
    DetailPrint "-------------Create Required Directories Start-------------"
    ; Required for downloads
    CreateDirectory ${COMPONENTS_DIR}
    ; Required for batch script
    CreateDirectory ${AHK_SCRIPTS_DIR}
    ; Required for logging
    CreateDirectory ${LOGS_DIR}
    DetailPrint "-------------Create Required Directories End-------------"
  SectionEnd

; AutoHotkey Section
  Section "AutoHotkey" AHK
    DetailPrint "-------------AutoHotkey Start-------------"
    retry:
      ClearErrors
      DetailPrint "Downloading AutoHotkey.exe from ${AHK_URL} to ${AHK_EXE_PATH}"
      inetc::get ${AHK_URL} ${AHK_EXE_PATH} /END
      ; Get status
      Pop $0
      DetailPrint "Download Status: $0"
      ${If} $0 == "OK"
        ExecWait '"${AHK_EXE_PATH}"' $0
        DetailPrint "Execution status: $0"
      ; Download Error
      ${Else}
        Call LogDetailPrint
        !insertmacro ShowAbortRetryIgnore "$(DOWNLOAD_ERROR_TEXT)"
      ${EndIf}
      Goto end
    abort:
      DetailPrint "-------------AutoHotkey Abort-------------"
      Quit
    end:
    DetailPrint "-------------AutoHotkey End-------------"
  SectionEnd

; AutoHotkey Scripts section group
  SectionGroup "AutoHotkey Scripts" AHK_Scripts
    
    ; AHK_LogoutMacro script section
    Section "Logout Macro (includes multiple hotkeys)" AHK_LogoutMacro
      DetailPrint "-------------AutoHotkey Scripts Logout Macro Start-------------"
      CreateDirectory ${AHK_LogoutMacro_DIR}
      retry:
        ClearErrors
        DetailPrint "Downloading Logout Macro from ${AHK_LogoutMacro_URL}"
        inetc::get ${AHK_LogoutMacro_URL} ${AHK_LogoutMacro_SCRIPT_PATH} /END
        ; Get status
        Pop $0
        DetailPrint "Download Status: $0"
        ${If} $0 == "OK"
          ${If} ${FileExists} "${AHK_LogoutMacro_SCRIPT_PATH}"
            SetOutPath ${AHK_LogoutMacro_DIR}
            CreateShortCut "${AHK_SCRIPTS_DIR}\LogoutMacro.lnk" "${AHK_LogoutMacro_SCRIPT_PATH}"
          ; File not found - error
          ${Else}
            Call LogDetailPrint
            !insertmacro ShowAbortRetryIgnore "$(SEARCH_LOGOUTMACRO_ERROR_TEXT)"
          ${EndIf}
        ; Download Error
        ${Else}
           Call LogDetailPrint
           !insertmacro ShowAbortRetryIgnore "$(DOWNLOAD_ERROR_TEXT)"
        ${EndIf}
        Goto end
      abort:
        DetailPrint "-------------AutoHotkey Scripts Logout Macro Abort-------------"
        Quit
      end:
        DetailPrint "-------------AutoHotkey Scripts Logout Macro End-------------"
    SectionEnd
    
    ; AHK_TradeMacro script section
    Section "Trade Macro" AHK_TradeMacro
      DetailPrint "-------------AutoHotkey Scripts Trade Macro Start-------------"
      CreateDirectory ${AHK_TradeMacro_DIR}
      retry:
        ClearErrors
        DetailPrint "Downloading TradeMacro from ${AHK_TradeMacro_URL}"
        inetc::get ${AHK_TradeMacro_URL} ${AHK_TradeMacro_ZIP_PATH} /END
        ; Get status
        Pop $0
        DetailPrint "Download Status: $0"
        ${If} $0 == "OK"
          ${If} ${FileExists} "${AHK_TradeMacro_ZIP_PATH}"
            DetailPrint "${AHK_TradeMacro_ZIP_PATH} exists"
            nsisunz::UnzipToStack "${AHK_TradeMacro_ZIP_PATH}" "${AHK_TradeMacro_DIR}"
            Pop $0
            DetailPrint "Unzip status: $0"
            ; Unzip success
            ${If} $0 == "success"
              ; Get unzipped folder name
              FindFirst $0 $1 "${AHK_TradeMacro_DIR}\*.*"
              ; Store $R0 in stack
              Push $R0
              ; Assign new value
              StrCpy $R0 0
              ; Search folder
              ${While} $R0 = 0
                ${IfNot} $1 == "."
                ${AndIfNot} $1 == ".."
                  StrCpy $R0 1
                ${Else}
                  FindNext $0 $1
                ${Endif}
              ${EndWhile}
              ; Restore $R0 from stack
              Pop $R0
              FindClose $0
              ; Folder found
              ${IfNot} $1 == ""
                DetailPrint "Searching unzipped folder status: $1"
                DetailPrint "Creating a shortcut for ${AHK_TradeMacro_DIR}\$1\${AHK_TradeMacro_SCRIPT}"
                SetOutPath ${AHK_TradeMacro_DIR}\$1
                CreateShortCut "${AHK_SCRIPTS_DIR}\POE-TradeMacro.lnk" "${AHK_TradeMacro_DIR}\$1\${AHK_TradeMacro_SCRIPT}"
              ${EndIf}
            ; Unzip Error
            ${Else}
              Call LogDetailPrint
              !insertmacro ShowAbortRetryIgnore "$(UNZIP_ERROR_TEXT)"
            ${EndIf}
          ; File not found - error
          ${Else}
            Call LogDetailPrint
            !insertmacro ShowAbortRetryIgnore "$(ARCHIVE_NOTFOUND_ERROR_TEXT) ${AHK_TradeMacro_ZIP_PATH}."
          ${EndIf}
        ; Download Error
        ${Else}
           Call LogDetailPrint
           !insertmacro ShowAbortRetryIgnore "$(DOWNLOAD_ERROR_TEXT)"
        ${EndIf}
        Goto end
      abort:
        DetailPrint "-------------AutoHotkey Scripts Trade Macro Abort-------------"
        Quit
      end:
        DetailPrint "-------------AutoHotkey Scripts Trade Macro End-------------"
    SectionEnd

  SectionGroupEnd

; Loot Filters section group
  SectionGroup "Loot Filters" LootFilters
  
    ; LootFilters_NeverSink filter section
    Section "NeverSink" LootFilters_NeverSink
      DetailPrint "-------------Loot Filters NeverSink Start-------------"
      CreateDirectory ${LootFilters_NeverSink_DIR}
      retry:
        ClearErrors
        DetailPrint "Downloading NeverSink loot filter from ${LootFilters_NeverSink_URL} to ${LootFilters_NeverSink_DIR}"
        inetc::get ${LootFilters_NeverSink_URL} ${LootFilters_NeverSink_ZIP_PATH} /END
        ; Get status
        Pop $0
        DetailPrint "Download Status: $0"
        ${If} $0 == "OK"
          ${If} ${FileExists} "${LootFilters_NeverSink_ZIP_PATH}"
            DetailPrint "Unzip ${LootFilters_NeverSink_ZIP_PATH}"
            nsisunz::UnzipToStack "${LootFilters_NeverSink_ZIP_PATH}" "${LootFilters_NeverSink_DIR}"
            Pop $0
            DetailPrint "Unzip status: $0"
            ${If} $0 == "success"
              ; Get unzipped folder name
              FindFirst $0 $1 "${LootFilters_NeverSink_DIR}\*.*"
              ; Store $R0 in stack
              Push $R0
              ; Assign new value
              StrCpy $R0 0
              ; Search folder
              ${While} $R0 = 0
                ${IfNot} $1 == "."
                ${AndIfNot} $1 == ".."
                  StrCpy $R0 1
                ${Else}
                  FindNext $0 $1
                ${Endif}
              ${EndWhile}
              ; Restore $R0 from stack
              Pop $R0
              FindClose $0
                       
              ; Folder found
              ${IfNot} $1 == ""
                DetailPrint "Searching unzipped folder status: $1"
                DetailPrint "Copy .filter files from ${LootFilters_NeverSink_DIR}\$1 to $varPOEProfileDir"
                
                ${WriteFileList} "${LootFilters_FILE_LIST_PATH}" "*.filter" "${LootFilters_NeverSink_DIR}\$1" 
                FileOpen $0 "${LootFilters_FILE_LIST_PATH}" r
                ${DoUntil} ${Errors}
                  ClearErrors
                  FileRead $0 $2
                  ${Trim} $2 $2
                  ${IfNot} $2 == ""
                    ${If} ${FileExists} "$varPOEProfileDir\$2"
                      SetErrors
                      MessageBox MB_YESNO|MB_ICONQUESTION  "$(LOOTFILTER_NEVERSINK_EXISTS_TEXT)" /SD IDYES IDNO end
                    ${EndIf}
                  ${EndIf}
                ${LoopUntil} 1 = 0
                FileClose $0

                CopyFiles "${LootFilters_NeverSink_DIR}\$1\*.filter" $varPOEProfileDir
              ${EndIf}
            ; Unzip Error
            ${Else}
              Call LogDetailPrint
              !insertmacro ShowAbortRetryIgnore "$(UNZIP_ERROR_TEXT)"
            ${EndIf}
          ; File not found - error
          ${Else}
            Call LogDetailPrint
            !insertmacro ShowAbortRetryIgnore "$(ARCHIVE_NOTFOUND_ERROR_TEXT) ${LootFilters_NeverSink_DIR}."
          ${EndIf}
        ; Download error
        ${Else}
           Call LogDetailPrint
           !insertmacro ShowAbortRetryIgnore "$(DOWNLOAD_ERROR_TEXT)"
        ${EndIf}
        Goto end
      abort:
        DetailPrint "-------------Loot Filters NeverSink Abort-------------"
        Quit
      end:
      DetailPrint "-------------Loot Filters NeverSink End-------------"
    SectionEnd

  SectionGroupEnd
  
  ; Path Of Building (POB) section
  Section "Path Of Building" POB
    DetailPrint "-------------Path Of Building Start-------------"
    retry:
      ClearErrors
      DetailPrint "Downloading AutoHotkey.exe from ${AHK_URL} to ${AHK_EXE_PATH}"
      inetc::get ${POB_URL} ${POB_EXE_PATH} /END
      ; Get status
      Pop $0
      DetailPrint "Download Status: $0"
      ${If} $0 == "OK"
        ExecWait '"${POB_EXE_PATH}"' $0
        DetailPrint "Execution status: $0"
      ; Download error
      ${Else}
        Call LogDetailPrint
        !insertmacro ShowAbortRetryIgnore "$(DOWNLOAD_ERROR_TEXT)"
      ${EndIf}
      Goto end
    abort:
      DetailPrint "-------------Path Of Building Abort-------------"
      Quit
    end:
    DetailPrint "-------------Path Of Building End-------------"
  SectionEnd

; --------------------------------
; Functions
  
  Function .onInit
    ; $PLUGINSDIR is the path to a temporary folder created upon the first usage of a plug-in or a call to InitPluginsDir 
    ; This folder is automatically deleted when the installer exits
    InitPluginsDir

    ; Language selection
    Push ""
    Push ${LANG_ENGLISH}
    Push "English"
    Push ${LANG_RUSSIAN}
    Push "Русский"
    ; A means auto count languages
    ; For the auto count to work the first empty push (Push "") must remain
    Push "A"
    LangDLL::LangDialog "Installer Language" "Please select the language of the installer"
    Pop $LANGUAGE
    ${If} $LANGUAGE == "cancel"
      Quit
    ${EndIf}

    ; Set default install directory
    ReadRegStr $0 HKCU "Software\GrindingGearGames\Path of Exile" InstallLocation
    ${If} $0 == ""
      MessageBox MB_OK "$(POE_NOTFOUND_ERROR_TEXT)" /SD IDOK
      Quit
    ${Endif}
    StrCpy $INSTDIR $0POE_Components

    ; Get My Documents folder path
    ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" Personal
    ; Assign valid userprofile dir for POE
    StrCpy $varPOEProfileDir "$0\${POE_PROFILE_DIR}"
    ${IfNot} ${FileExists} "$varPOEProfileDir"
      MessageBox MB_OK "$(POE_PROFILE_NOTFOUND_ERROR_TEXT)" /SD IDOK
      Quit
    ${EndIf}

    Call SelfUpdate
  FunctionEnd

  Function .onInstSuccess
    ; Create a batch script, which will run all .ahk scripts and .lnk shortcuts, 
    ; located in the ${AHK_SCRIPTS_DIR}, script will run PathOfExile.exe as well
    ; Files (.ahk, .lnk) will be executed in case if the AutoHotkey.exe processes amount is less then the files amount in ${AHK_SCRIPTS_DIR}
    FileOpen $0 "${BATCH_PATH}" w
      FileWrite $0 '@echo off$\r$\n'

      FileWrite $0 'REM count AutoHotkey processes$\r$\n'
      FileWrite $0 'for /f %%# in ($\'qprocess^|find /i /c "AutoHotkey.exe"$\') do set pcount=%%#$\r$\n'

      FileWrite $0 'REM count scripts$\r$\n'
      FileWrite $0 'set fcount=0$\r$\n'
      FileWrite $0 'for %%f in ("${AHK_SCRIPTS_DIR}\*.ahk") do set /a fcount+=1$\r$\n'
      FileWrite $0 'for %%f in ("${AHK_SCRIPTS_DIR}\*.lnk") do set /a fcount+=1$\r$\n'
      
      FileWrite $0 'REM Run all scripts from ${AHK_SCRIPTS_DIR} folder in case if some of them are not running$\r$\n'
      FileWrite $0 'if %fcount% NEQ %pcount% ($\r$\n'
        FileWrite $0 'for %%f in ("${AHK_SCRIPTS_DIR}\*.ahk") do %%f$\r$\n'
        FileWrite $0 'for %%f in ("${AHK_SCRIPTS_DIR}\*.lnk") do %%f$\r$\n'
      FileWrite $0 ')$\r$\n'

      FileWrite $0 'start "Path of Exile" "$INSTDIR\..\${POE_EXE}"$\r$\n'
      
      FileWrite $0 'exit'
    FileClose $0
  FunctionEnd
  
  Function .onVerifyInstDir
    ; Make sure that chosen installation directory or its parent has ${POE_EXE}
    IfFileExists "$INSTDIR\${POE_EXE}" change_instdir
      IfFileExists "$INSTDIR\..\${POE_EXE}" end
        Abort
    change_instdir:
      StrCpy $INSTDIR "$INSTDIR\${DEFAULT_INSTDIR_NAME}"
    end:
  FunctionEnd

  Function .onGUIEnd
    RMDir ${LOGS_DIR}
  FunctionEnd

  Function onWikiLinkClick
    ExecShell "open" "$(WIKI_URL)"
  FunctionEnd
  
  Function LootFiltersPage
    nsDialogs::create 1018
    Pop $varDialog

    ${NSD_CreateLabel} 0 0 100% 20 "$(LOOTFILTER_SELECT_FILTER_LABEL_TEXT)"
    Pop $varHwnd
    ${NSD_AddStyle} $varHwnd ${SS_Left}
    
    ${NSD_CreateDropList} 0 20 50% 100% ""
    Pop $varHwnd
    ${NSD_CB_AddString} $varHwnd "None"
    ${NSD_CB_AddString} $varHwnd "Default"

    FindFirst $0 $1 "$varPOEProfileDir\*.filter"
    ; Store $R0 in stack
    Push $R0
    ; Assign new value
    StrCpy $R0 0
    ; Search folder
    ${While} $R0 = 0
      ${If} $1 == "."
      ${ElseIf} $1 == ".."
      ${ElseIfNot} $1 == ""
        ${NSD_CB_AddString} $varHwnd $1
      ${Else}
        StrCpy $R0 1
      ${Endif}
      FindNext $0 $1
    ${EndWhile}
    ; Restore $R0 from stack
    Pop $R0
    ; Close find
    FindClose $0
    
    ; Preselect selected in-game filter
    ReadINIStr $0 "$varPOEProfileDir\${POE_CONFIG_INI}" "UI" "item_filter"
    ${If} $0 == "<default>"
      StrCpy $0 "Default"
    ${EndIf}
    ${NSD_CB_SelectString} $varHwnd $0

    ${NSD_CreateLabel} 0 60 100% 20 "$(LOOTFILTER_NOFILTER_NOTICE_TEXT)"
    Pop $0
    ${NSD_AddStyle} $0 ${SS_Left}

    ${NSD_CreateBitmap} 0 80 100% 100% ""
    Pop $0
    ${NSD_SetStretchedImage} $0 "$EXEDIR\..\assets\images\LootFilters-disabled.bmp" $1

    ; Disable cancel button
    GetDlgItem $0 $HWNDPARENT 2
    EnableWindow $0 0

    nsDialogs::Show
    ${NSD_FreeImage} $1
  FunctionEnd

  Function LootFiltersPageLeave
    Push $1
    ${NSD_GetText} $varHwnd $0
    ; Remove .filter from string
    ${StrStrip} ".filter" $0 $0
    StrCpy $1 $0
    ; Edit production_Config.ini file and set selected filter
    ${If} $0 == "Default"
      StrCpy $0 "<default>"
    ${EndIf}
    ${IfNot} $0 == ""
      DetailPrint "Adding $0 to the Path of Exile."
      WriteINIStr "$varPOEProfileDir\${POE_CONFIG_INI}" "UI" "item_filter" "$0"
      WriteINIStr "$varPOEProfileDir\${POE_CONFIG_INI}" "UI" "item_filter_loaded_successfully" "$0"
      MessageBox MB_OK "$1 $(LOOTFILTER_SELECTED_TEXT)"
    ${EndIf}
  FunctionEnd

  Function SelfUpdate
    ; Check execution parameters
    ; Parametersare used upon installer selfupdate
    ${GetParameters} $0
    ClearErrors
    ${GetOptions} $0 "--self-update=" $R0
    ${GetOptions} $0 "--old-file-path=" $R1
    ; Selfupdate was executed
    ${IfNot} ${Errors}
    ${AndIf} "$R0" == "1"
    ${AndIf} ${FileExists} "$R1"
      ; Delete old installer
      ${If} ${FileExists} "$R1"
        Delete $R1
      ${EndIf}
    ; Check for updates
    ${Else}
      inetc::get ${CONFIG_XML_URL} ${CONFIG_XML_PATH} /END
      Pop $0
      ${If} $0 == "OK"
      ${AndIf} ${FileExists} "${CONFIG_XML_PATH}"
        nsisXML::create
        nsisXML::load "${CONFIG_XML_PATH}"
        nsisXML::select "${CONFIG_XML_VERSION_XPATH}"
        nsisXML::getText
        ${IfNot} $3 == "${VERSION}"
          MessageBox MB_YESNO "$(UPDATE_AVAILABLE_TEXT)" /SD IDYES IDNO end
          inetc::get "${RELEASE_URL_PART}v$3/${OUT_FILE_NAME}_$3.exe" "$EXEDIR\${OUT_FILE_NAME}_$3.exe" /END
          Pop $0
          ${If} $0 == "OK"
            Exec '"$EXEDIR\${OUT_FILE_NAME}_$3.exe" --self-update="1" --old-file-path="$EXEPATH"'
            Quit
          ${EndIf}
        ${EndIf}
      ${EndIf}
    ${EndIf}
    end:
  FunctionEnd

  Function WelcomePageShow
    ${NSD_CreateLink} 180 285 120 15 "POE Components WIKI"
    Pop $0
    SetCtlColors $0 "0000FF" "FFFFFF"
    ${NSD_OnClick} $0 onWikiLinkClick
  FunctionEnd

  Function FinishPageShow
    FindWindow $0 "#32770" "" $HWNDPARENT
    GetDlgItem $0 $0 1204
    ${NSD_OnClick} $0 onWikiLinkClick
  FunctionEnd

  Function CreateDesktopShortcut
    SetOutPath "$INSTDIR\.."
    CreateShortCut "${DESKTOP_SHORTCUT_PATH}" "${BATCH_PATH}" "" "$INSTDIR\..\${POE_EXE}"
  FunctionEnd

  Function LogDetailPrint
    ${LogMsg} "${ERROR_LOG_PATH}" "DumpLog"
    Push "${ERROR_LOG_PATH}"
    Call DumpLog
  FunctionEnd

  Function LogMsg
    ; ${_Message}
    Exch $0
    Exch
    ; ${_LogPath}
    Exch $1
    Push $2
    ; Append
    FileOpen $2 "$1" a
    FileSeek $2 0 END
    FileWrite $2 "${__TIMESTAMP__}$\r$\n$0$\r$\n"
    FileClose $2
    Pop $2
    Pop $1
    Pop $0
  FunctionEnd
  