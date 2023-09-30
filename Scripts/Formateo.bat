@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo Asistente para particionar y formatear
echo ==========================================
echo.

REM Mostrar la lista de discos disponibles
diskpart /s list_disks.txt

REM Pedir al usuario seleccionar un disco
set /p "disk_number=Seleccione el número de disco: "

REM Verificar que el número de disco sea válido
set "valid_number=false"
for /f %%i in ('type list_disks.txt ^| "%~d0%~p0findstr" /c:"Disk ###"') do (
    set "disk_number=%%i"
    if !disk_number! equ %disk_number% set "valid_number=true"
)

if not %valid_number%==true (
    echo Número de disco no válido.
    exit /b 1
)

REM Solicitar el tamaño de la partición
set /p "partition_size=Ingrese el tamaño de la partición (en MB): "

REM Crear la partición primaria
echo.
echo Creando partición primaria...
echo select disk %disk_number% > create_partition.txt
echo clean >> create_partition.txt
echo create partition primary size=%partition_size% >> create_partition.txt
echo assign letter=C >> create_partition.txt
diskpart /s create_partition.txt

REM Formatear la partición como NTFS
echo.
echo Formateando la partición como NTFS...
echo select volume C > format_partition.txt
echo format fs=ntfs quick >> format_partition.txt
echo assign letter=C >> format_partition.txt
diskpart /s format_partition.txt

REM Finalizar
echo.
echo Partición creada y formateada con éxito.
endlocal
exit /b 0


