@echo off
color 2
cls
timeout /t 10

set wimURL="https://www.mistrelci.com.ar/Script/install.wim"

:inicio
echo 0. Probar conectividad
echo 1. Automaticamente particionar y formatear para UEFI 
echo 2. Automaticamente particionar y formatear para BIOS
echo 3. Particionado y formateo manual
echo 4. Salir

set /p "format_option=Seleccione (1/2/3): "

REM Según la opción seleccionada
if %format_option% equ 0 (
	REM Probar conexión
	ipconfig /all
	"%~d0%~p0CURL\bin\curl.exe" %wimURL% -I
	
	goto :inicio
	
) else if %format_option% equ 1 (
	REM UEFI

	Diskpart /s "%~d0%~p0get_disks.txt"
	set /p "disk=Seleccione el disco: "
	echo Formateando en UEFI
	Diskpart /s "%~d0%~p0CreatePartitions-UEFI.txt"

	REM Ejecutamos Overprovissioning script
	start cmd /c "%~d0%~p0Overprovissioning.bat"       

) else if %format_option% equ 2 (
	REM BIOS

	Diskpart /s "%~d0%~p0get_disks.txt"
	set /p "disk=Seleccione el disco: "
	echo Formateando en UEFI
	Diskpart /s "%~d0%~p0CreatePartitions-BIOS.txt"

	REM Ejecutamos Overprovissioning script
	start cmd /c "%~d0%~p0Overprovissioning.bat"


) else if %format_option% equ 3 (
	REM Manual

	start notepad "%~d0%~p0readme.txt"
	Diskpart

) else if %format_option% equ 4 (
	echo Saliendo sin formatear.
	exit /b 0

) else (
	goto :inicio
	exit
)


REM Creamos la carpeta temporal para colocar la wim dentro
MD W:\temp\wim\

REM Descargamos la wim de la web

"%~d0%~p0CURL\bin\curl.exe" %wimURL% --output W:\temp\wim\install.wim

REM Aplicamos la WIM
"%~d0%~p0applyimage.bat" "W:\temp\wim\install.wim"

Exit