@echo off
setlocal EnableDelayedExpansion
:main
echo Benvenuto %USERNAME%
echo Script ModUpdater V2.3 by Killer
echo Questo Script cancellera' tutte le mod e scarichera' quelle Nuove
echo Inizializzazione Script, Potrebbe volerci un po'...

REM Passo gli argomenti
set potatoOrNot=%1
set debugOrNot=%2

REM Specifica la parte finale del percorso desiderato
set "parteFinalePercorso=\Lethal Company\BepInEx"
set "ScriptPath=%CD%"
REM Verifica se la parte finale del percorso è presente nel percorso corrente
set "ultimaPartePercorso=!CD:~-23!"
if /I "!ultimaPartePercorso!" equ "!parteFinalePercorso!" (
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

    set LGVers=3.0.4
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/malco/Lategame_Upgrades/!LGVers!/', 'LG.zip')"
    powershell -Command "& { Expand-Archive -Path 'LG.zip' -DestinationPath '.' -Force }"
    xcopy ".\BepInEx\plugins\MoreShipUpgrades" ".\plugins\egypt\MoreShipUpgrades" /E /I /Y >NUL 2>&1
    del ".\icon.png" >NUL 2>&1
    del ".\installing.txt" >NUL 2>&1
    del ".\License.txt" >NUL 2>&1
    del ".\manifest.json" >NUL 2>&1
    del ".\README.md" >NUL 2>&1
    rd /s /q ".\BepInEx" >NUL 2>&1

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

    set egyptVers=2.0.7
    set egyptVendor=KayNetsua/E_Gypt_Moon
    set orionVers=1.0.2
    set orionVendor=sfDesat/Orion
    set aquatisVers=0.4.2
    set aquatisVendor=sfDesat/Aquatis
    set celestVers=0.2.1
    set celestVendor=sfDesat/Celest
    set christmasVers=1.3.16
    set christmasVendor=HolographicWings/ChristmasVillage_Legacy
    set secretlabsVers=3.2.4
    set secretlabsVendor=Zingar/SecretLabs
    set starlancerVers=0.2.1
    set starlancerVendor=AudioKnight/StarlancerMoons
    set peachescastleVers=1.0.41
    set peachescastleVendor=TeamBridget/Peaches_Castle
    set ducksVers=1.1.3
    set ducksVendor=FireNoobsta/Ducks_Moons
    set atlasabyssVers=1.0.2
    set atlasVendor=Zingar/Atlas_Abyss
    set kastVers=1.0.3
    set kastVendor=Ceelery/Kast
    mkdir "!ScriptPath!\plugins\Modules" >NUL 2>&1
    REM Controllo mappe installate
    if exist ".\maps\" (
        if exist ".\maps\egypt\" (
            if exist ".\maps\egypt\egypt!egyptVers!.lethalbundle" (
                echo Mappa Egypt gia' all'ultima versione
            ) else (
                echo Mappa Egypt da aggiornare...
                for %%i in (".\maps\egypt\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/KayNetsua/E_Gypt_Moon/!egyptVers!/', 'egypt.zip')"
                powershell -Command "& { Expand-Archive -Path 'egypt.zip' -DestinationPath '.' -Force }"
                move ".\egypt.lethalbundle" ".\maps\egypt\egypt!egyptVers!.lethalbundle" >NUL 2>&1
                del ".\egypt.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\orion\" (
            if exist ".\maps\orion\orion!orionVers!.lem" (
                echo Mappa Orion gia' all'ultima versione
            ) else (
                echo Mappa Orion da aggiornare...
                for %%i in (".\maps\orion\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Orion/!orionVers!/', 'orion.zip')"
                powershell -Command "& { Expand-Archive -Path 'orion.zip' -DestinationPath '.' -Force }"
                move ".\orion.lem" ".\maps\orion\orion!orionVers!.lem" >NUL 2>&1
                del ".\orion.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\aquatis\" (
            if exist ".\maps\aquatis\aquatis!aquatisVers!.lem" (
                echo Mappa Aquatis gia' all'ultima versione
            ) else (
                echo Mappa Aquatis da aggiornare...
                for %%i in (".\maps\aquatis\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Aquatis/!aquatisVers!/', 'aquatis.zip')"
                powershell -Command "& { Expand-Archive -Path 'aquatis.zip' -DestinationPath '.' -Force }"
                move ".\aquatis.lem" ".\maps\aquatis\aquatis!aquatisVers!.lem" >NUL 2>&1
                del ".\aquatis.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\celest\" (
            if exist ".\maps\celest\celest!celestVers!.lem" (
                echo Mappa Celest gia' all'ultima versione
            ) else (
                echo Mappa Celest da aggiornare...
                for %%i in (".\maps\celest\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Celest/!celestVers!/', 'celest.zip')"
                powershell -Command "& { Expand-Archive -Path 'celest.zip' -DestinationPath '.' -Force }"
                move ".\celest.lem" ".\maps\celest\celest!celestVers!.lem" >NUL 2>&1
                del ".\celest.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\christmas\" (
            if exist ".\maps\christmas\christmas!christmasVers!.lem" (
                echo Mappa Christmas gia' all'ultima versione
            ) else (
                echo Mappa Christmas da aggiornare...
                for %%i in (".\maps\christmas\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/HolographicWings/ChristmasVillage_Legacy/!christmasVers!/', 'christmas.zip')"
                powershell -Command "& { Expand-Archive -Path 'christmas.zip' -DestinationPath '.' -Force }"
                move ".\christmasvillage.lem" ".\maps\christmas\christmasvillage!christmasVers!.lem" >NUL 2>&1
                del ".\christmas!christmasVers!.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\secretlabs\" (
            if exist ".\maps\secretlabs\secretlabs!secretlabsVers!.lem" (
                echo Mappa Secretlabs gia' all'ultima versione
            ) else (
                echo Mappa Secretlabs da aggiornare...
                for %%i in (".\maps\secretlabs\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Zingar/SecretLabs/!secretlabsVers!/', 'secretlabs.zip')"
                powershell -Command "& { Expand-Archive -Path 'secretlabs.zip' -DestinationPath '.' -Force }"
                move ".\secret labs.lem" ".\maps\secretlabs\secretlabs!secretlabsVers!.lem" >NUL 2>&1
                del ".\secretlabs!secretlabsVers!.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\starlancer\" (
            if exist ".\maps\starlancer\starlancermoons!starlancerVers!.lem" (
                echo Mappa Starlancer gia' all'ultima versione
            ) else (
                echo Mappa Starlancer da aggiornare...
                for %%i in (".\maps\starlancer\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/AudioKnight/StarlancerMoons/!starlancerVers!/', 'starlancer.zip')"
                powershell -Command "& { Expand-Archive -Path 'starlancer.zip' -DestinationPath '.' -Force }"
                move ".\plugins\Starlancer\starlancermoons.lem" ".\maps\starlancer\starlancermoons!starlancerVers!.lem" >NUL 2>&1
                del ".\starlancer.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\peachescastle\" (
            if exist ".\maps\peachescastle\castlegrounds!peachescastleVers!.lem" (
                echo Mappa Peaches Castle gia' all'ultima versione
            ) else (
                echo Mappa Peaches Castle da aggiornare...
                for %%i in (".\maps\peachescastle\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/TeamBridget/Peaches_Castle/!peachescastleVers!/', 'peachescastle.zip')"
                powershell -Command "& { Expand-Archive -Path 'peachescastle.zip' -DestinationPath '.' -Force }"
                move ".\BepInEx\plugins\Modules\castlegrounds.lem" ".\maps\christmas\castlegrounds!peachescastleVers!.lem" >NUL 2>&1
                del ".\peachescastle.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\ducks\" (
            if exist ".\maps\ducks\ducksmoons!ducksVers!.lem" (
                echo Mappa Ducks gia' all'ultima versione
            ) else (
                echo Mappa Ducks da aggiornare...
                for %%i in (".\maps\ducks\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/FireNoobsta/Ducks_Moons/!ducksVers!/', 'ducksmoons.zip')"
                powershell -Command "& { Expand-Archive -Path 'ducksmoons.zip' -DestinationPath '.' -Force }"
                move ".\ducksmoons.lem" ".\maps\ducks\ducksmoons!ducksVers!.lem" >NUL 2>&1
                del ".\ducksmoons.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\atlasabyss\" (
            if exist ".\maps\atlasabyss\atlasabyss!atlasabyssVers!.lem" (
                echo Mappa Atlas Abyss gia' all'ultima versione
            ) else (
                echo Mappa Atlas Abyss da aggiornare...
                for %%i in (".\maps\atlasabyss\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Zingar/Atlas_Abyss/!atlasabyssVers!/', 'atlasabyss.zip')"
                powershell -Command "& { Expand-Archive -Path 'atlasabyss.zip' -DestinationPath '.' -Force }"
                move ".\atlasabyss.lem" ".\maps\atlasabyss\atlasabyss!atlasabyssVers!.lem" >NUL 2>&1
                del ".\atlasabyss.zip" >NUL 2>&1
            )
        )
        if exist ".\maps\kast\" (
            if exist ".\maps\kast\kast!kastVers!.lem" (
                echo Mappa Kast gia' all'ultima versione
            ) else (
                echo Mappa Kast da aggiornare...
                for %%i in (".\maps\kast\*.*") do (
                    del /q "%%i" >NUL 2>&1
                )
                powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Ceelery/Kast/!kastVers!/', 'kast.zip')"
                powershell -Command "& { Expand-Archive -Path 'kast.zip' -DestinationPath '.' -Force }"
                move ".\kast.lem" ".\maps\kast\kast!kastVers!.lem" >NUL 2>&1
                del ".\kast.zip" >NUL 2>&1
            )
        )
    ) else (
        REM Scarico tutte le mappe
        echo Scarico tutte le mappe, potrebbe volerci un bel po' di tempo...
        mkdir "!ScriptPath!\maps" >NUL 2>&1
        mkdir "!ScriptPath!\maps\egypt" >NUL 2>&1
        mkdir "!ScriptPath!\maps\orion" >NUL 2>&1
        mkdir "!ScriptPath!\maps\aquatis" >NUL 2>&1
        mkdir "!ScriptPath!\maps\celest" >NUL 2>&1
        mkdir "!ScriptPath!\maps\christmas" >NUL 2>&1
        mkdir "!ScriptPath!\maps\secretlabs" >NUL 2>&1
        mkdir "!ScriptPath!\maps\starlancer" >NUL 2>&1
        mkdir "!ScriptPath!\maps\peachescastle" >NUL 2>&1
        mkdir "!ScriptPath!\maps\ducks" >NUL 2>&1
        mkdir "!ScriptPath!\maps\atlasabyss" >NUL 2>&1
        mkdir "!ScriptPath!\maps\kast" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/KayNetsua/E_Gypt_Moon/!egyptVers!/', 'egypt.zip')"
        powershell -Command "& { Expand-Archive -Path 'egypt.zip' -DestinationPath '.' -Force }"
        move ".\egypt.lethalbundle" ".\maps\egypt\egypt!egyptVers!.lethalbundle" >NUL 2>&1
        del ".\egypt.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Orion/!orionVers!/', 'orion.zip')"
        powershell -Command "& { Expand-Archive -Path 'orion.zip' -DestinationPath '.' -Force }"
        move ".\orion.lem" ".\maps\orion\orion!orionVers!.lem" >NUL 2>&1
        del ".\orion.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Aquatis/!aquatisVers!/', 'aquatis.zip')"
        powershell -Command "& { Expand-Archive -Path 'aquatis.zip' -DestinationPath '.' -Force }"
        move ".\aquatis.lem" ".\maps\aquatis\aquatis!aquatisVers!.lem" >NUL 2>&1
        del ".\aquatis.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/sfDesat/Celest/!celestVers!/', 'celest.zip')"
        powershell -Command "& { Expand-Archive -Path 'celest.zip' -DestinationPath '.' -Force }"
        move ".\celest.lem" ".\maps\celest\celest!celestVers!.lem" >NUL 2>&1
        del ".\celest.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/HolographicWings/ChristmasVillage_Legacy/!christmasVers!/', 'christmas.zip')"
        powershell -Command "& { Expand-Archive -Path 'christmas.zip' -DestinationPath '.' -Force }"
        move ".\christmasvillage.lem" ".\maps\christmas\christmasvillage!christmasVers!.lem" >NUL 2>&1
        del ".\christmas!christmasVers!.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Zingar/SecretLabs/!secretlabsVers!/', 'secretlabs.zip')"
        powershell -Command "& { Expand-Archive -Path 'secretlabs.zip' -DestinationPath '.' -Force }"
        move ".\secret labs.lem" ".\maps\secretlabs\secretlabs!secretlabsVers!.lem" >NUL 2>&1
        del ".\secretlabs!secretlabsVers!.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/AudioKnight/StarlancerMoons/!starlancerVers!/', 'starlancer.zip')"
        powershell -Command "& { Expand-Archive -Path 'starlancer.zip' -DestinationPath '.' -Force }"
        move ".\plugins\Starlancer\starlancermoons.lem" ".\maps\starlancer\starlancermoons!starlancerVers!.lem" >NUL 2>&1
        del ".\starlancer.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/TeamBridget/Peaches_Castle/!peachescastleVers!/', 'peachescastle.zip')"
        powershell -Command "& { Expand-Archive -Path 'peachescastle.zip' -DestinationPath '.' -Force }"
        move ".\BepInEx\plugins\Modules\castlegrounds.lem" ".\maps\peachescastle\castlegrounds!peachescastleVers!.lem" >NUL 2>&1
        del ".\peachescastle.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/FireNoobsta/Ducks_Moons/!ducksVers!/', 'ducksmoons.zip')"
        powershell -Command "& { Expand-Archive -Path 'ducksmoons.zip' -DestinationPath '.' -Force }"
        move ".\ducksmoons.lem" ".\maps\ducks\ducksmoons!ducksVers!.lem" >NUL 2>&1
        del ".\ducksmoons.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Zingar/Atlas_Abyss/!atlasabyssVers!/', 'atlasabyss.zip')"
        powershell -Command "& { Expand-Archive -Path 'atlasabyss.zip' -DestinationPath '.' -Force }"
        move ".\atlasabyss.lem" ".\maps\atlasabyss\atlasabyss!atlasabyssVers!.lem" >NUL 2>&1
        del ".\atlasabyss.zip" >NUL 2>&1

        powershell -Command "(New-Object Net.WebClient).DownloadFile('https://thunderstore.io/package/download/Ceelery/Kast/!kastVers!/', 'kast.zip')"
        powershell -Command "& { Expand-Archive -Path 'kast.zip' -DestinationPath '.' -Force }"
        move ".\kast.lem" ".\maps\kast\kast!kastVers!.lem" >NUL 2>&1
        del ".\kast.zip" >NUL 2>&1
        
    )
    echo Copio le mappe nella directory...
    copy ".\maps\egypt\egypt!egyptVers!.lethalbundle" ".\plugins\egypt.lethalbundle" >NUL 2>&1
    copy ".\maps\orion\orion!orionVers!.lem" ".\plugins\Modules\orion.lem" >NUL 2>&1
    copy ".\maps\aquatis\aquatis!aquatisVers!.lem" ".\plugins\Modules\aquatis.lem" >NUL 2>&1
    copy ".\maps\celest\celest!celestVers!.lem" ".\plugins\Modules\celest.lem" >NUL 2>&1
    copy ".\maps\christmas\christmasvillage!christmasVers!.lem" ".\plugins\Modules\christmasvillage.lem" >NUL 2>&1
    copy ".\maps\secretlabs\secretlabs!secretlabsVers!.lem" ".\plugins\Modules\secretlabs.lem" >NUL 2>&1
    copy ".\maps\starlancer\starlancermoons!starlancerVers!.lem" ".\plugins\Starlancer\starlancermoons.lem" >NUL 2>&1
    copy ".\maps\ducks\ducksmoons!ducksVers!.lem" ".\plugins\Modules\ducksmoons.lem" >NUL 2>&1
    copy ".\maps\atlasabyss\atlasabyss!atlasabyssVers!.lem" ".\plugins\Modules\atlasabyss.lem" >NUL 2>&1
    copy ".\maps\kast\kast!kastVers!.lem" ".\plugins\Modules\kast.lem" >NUL 2>&1

    del ".\CHANGELOG.md" >NUL 2>&1
    del ".\README.md" >NUL 2>&1
    del ".\icon.png" >NUL 2>&1
    del ".\manifest.json" >NUL 2>&1
    del ".\egypt.lethalbundle.manifest" >NUL 2>&1

    echo Mod Aggiornate con successo.
    exit /b 0

) else (
    echo Non sei nella directory giusta
    exit /b 1
)

exit /b 2
