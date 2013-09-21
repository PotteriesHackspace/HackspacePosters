@ECHO OFF
SetLocal EnableDelayedExpansion

::PROGRAMFILESDIR
SET PROGRAMFILESDIR=%ProgramFiles%
IF EXIST "%ProgramFiles(x86)%" SET PROGRAMFILESDIR=%ProgramFiles(x86)%
SET INKSCAPEDIR=%PROGRAMFILESDIR%\Inkscape
SET INKSCAPEEXE=%INKSCAPEDIR%\inkscape.exe
SET PDFTKEXE=%PROGRAMFILESDIR%\PDFtk\bin\pdftk.exe
SET OUTPUTPDF=HackspacePosters.pdf
SET EXPORTDIR=temp

:START
TITLE MAKE
ECHO This will convert *.svg files into *.pdf files.
ECHO Then it will merge *.pdf files into "%OUTPUTPDF%". 
PAUSE
ECHO.
ECHO Making...

:CHECK
ECHO Checking...
IF NOT EXIST "%INKSCAPEEXE%" (
  ECHO Could not locate "%INKSCAPEEXE%".
  ECHO Download http://downloads.sourceforge.net/inkscape/inkscape-0.48.4-1-win32.exe
  GOTO END
)

IF NOT EXIST "%PDFTKEXE%" (
  ECHO Could not locate "%PDFTKEXE%".
  ECHO Download http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_free-2.02-win-setup.exe
  GOTO END
)

:OLD
IF EXIST %OUTPUTPDF% MOVE %OUTPUTPDF% %OUTPUTPDF%.old

:EXPORT
ECHO Exporting...
SET PDFFILES=
FOR /f "tokens=*" %%A IN ('DIR /b /O:N *.svg') DO (
  "%INKSCAPEEXE%" -f "%%A" -A "%%A.pdf"
  SET PDFFILES=!PDFFILES! "%%A.pdf"
)

:MERGE
ECHO Merging...
"%PDFTKEXE%" %PDFFILES% cat output "%OUTPUTPDF%"

:DELETE
ECHO Deleting...
DEL /Q %PDFFILES%

:END

:DONE
ECHO Done!
IF "%NOPAUSE%" == "" PAUSE

:END_NO_PAUSE
::EOF