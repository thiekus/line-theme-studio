@echo off
set AppName=LineTS

FOR /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') DO Set _DTS=%%a
Set datetime=%_DTS:~6,2%-%_DTS:~4,2%-%_DTS:~0,4%@%_DTS:~8,2%-%_DTS:~10,2%-%_DTS:~12,2%
Echo %datetime%

ren ..\BuildBackup\backup.7z %AppName%-%datetime%.7z
pause