@echo off
color 2

set /p "OverProv=Overprovisioning en (MB): "
echo select vol W > "%temp%\shrink.txt"
echo shrink desired=%OverProv% >> "%temp%\shrink.txt"
echo exit >> "%temp%\shrink.txt"

diskpart /s "%temp%\shrink.txt"
diskpart /s "%~d0%~p0get_disks.txt"
cmd