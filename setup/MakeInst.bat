@echo off

echo * Protecting EXE *
echo.

cd ..\BuildTools
start /i /wait protect.bat
cd ..\setup

echo * Compiling MSI Installer *
echo.

echo Executing candle..
"C:\wix3\candle.exe" -nologo "lts_setup.wxs" -out "lts_setup.wixobj" -ext WixUIExtension -ext WixUtilExtension

echo.
echo Executing Light...
"C:\wix3\light.exe" -nologo "lts_setup.wixobj" -out "LTSsetup.msi" -ext WixUIExtension -ext WixUtilExtension

del LineThemeStudio_Setup.exe
rem ..\BuildTools\7zr a lts_setup.7z LTSsetup.msi -m0=BCJ2 -m1=LZMA:d25:fb255 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3 -mx
rem ..\BuildTools\7zr a lts_setup.7z LTSsetup.msi data.cab -m0=BCJ2 -m1=LZMA:d25:fb255 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3 -mx
rem copy /b 7zSD.sfx + config.txt + lts_setup.7z LineThemeStudio_Setup.exe

echo.
echo * Removing temporary files *
echo.

del lts_setup.wixobj
rem del lts_setup.7z

pause

exit