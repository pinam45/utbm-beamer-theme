@echo off
rem =============================================================================
rem Project related variables
set DOCUMENTS_NAMES=example

set NEEDS_BIBTEX=
set NEEDS_MAKEGLOSSARIES=

set PACKAGES_REQUIRED[example]=fontenc pgf tikz xcolor beamercolorthemeutbm beamerinnerthemeutbm beamerouterthemeutbm beamerthemeutbm

rem =============================================================================
rem Commands variables
set LATEX_COMPILER_CMD=xelatex
set BIBTEX_CMD=bibtex
set MAKEGLOSSARIES_CMD=makeglossaries
set KPSEWHICH_CMD=kpsewhich

rem =============================================================================
rem Other configs
set TO_DELETE_EXT=-blx.aux -blx.bib .acn .acr .alg .aux .bbl .bcf .blg .cb .cb2 .dvi .fdb_latexmk .fls .fmt .fot .glg .glo .gls .glsdefs .idx .ilg .ind .ist .lof .log .lol .lot .nav .out .pdf .pdfsync .pre .run.xml .snm .sta .synctex .synctex.gz .toc .vrb .xdv
set LATEX_COMPILER_SILENT=-interaction=batchmode ^>NUL 2^>^&1
set BIBTEX_SILENT=^>NUL 2^>^&1
set MAKEGLOSSARIES_SILENT=-q

rem =============================================================================

setlocal enableDelayedExpansion

echo.
set arg=%1
if "%arg%" == "clean" (
	call :clean
) else (
	if "%arg%" == "" (
		set SILENT=true
		set LATEX_COMPILER_SILENT_=-interaction=batchmode ^>NUL 2^>^&1
		set BIBTEX_SILENT_=^>NUL 2^>^&1
		set MAKEGLOSSARIES_SILENT_=-q
	) else (
		set SILENT=
		set LATEX_COMPILER_SILENT_=
		set BIBTEX_SILENT_=
		set MAKEGLOSSARIES_SILENT_=
	)
	call :make
)
exit /b 0

rem =============================================================================

:clean
for %%D in  (%DOCUMENTS_NAMES%) do (
	echo Clean of %%D:
	for %%E in  (%TO_DELETE_EXT%) do (
		if exist %%D%%E (
			echo ^> Removing file %%D%%E
			del %%D%%E >NUL 2>&1
		)
	)
	echo.
)
exit /b 0

rem =============================================================================

:make
for %%D in (%DOCUMENTS_NAMES%) do (
	echo Building %%D.pdf:
	call :check_packages %%D
	if ERRORLEVEL 1 (
		echo ERROR: missing packages
	) else (
		echo ^> Executing %LATEX_COMPILER_CMD%
		%LATEX_COMPILER_CMD% %%D %LATEX_COMPILER_SILENT_%
		if ERRORLEVEL 1 (
			call :print_error %LATEX_COMPILER_CMD%
		)

		set USE_BIBTEX=0
		for %%B in (%NEEDS_BIBTEX%) do (
			if "%%B" == "%%D" (
				set USE_BIBTEX=1
			)
		)
		if "!USE_BIBTEX!" == "1" (
			echo ^> Executing %BIBTEX_CMD%
			%BIBTEX_CMD% %%D %BIBTEX_SILENT_%
			if ERRORLEVEL 1 (
				call :print_error %BIBTEX_CMD%
			)
		)

		set USE_MAKEGLOSSARIES=0
		for %%B in (%NEEDS_MAKEGLOSSARIES%) do (
			if "%%B" == "%%D" (
				set USE_MAKEGLOSSARIES=1
			)
		)
		if "!USE_MAKEGLOSSARIES!" == "1" (
			echo ^> Executing %MAKEGLOSSARIES_CMD%
			%MAKEGLOSSARIES_CMD% %MAKEGLOSSARIES_SILENT_% %%D
			if ERRORLEVEL 1 (
				call :print_error %MAKEGLOSSARIES_CMD%
			)
		)

		echo ^> Executing %LATEX_COMPILER_CMD%
		%LATEX_COMPILER_CMD% %%D %LATEX_COMPILER_SILENT_%
		if ERRORLEVEL 1 (
			call :print_error %LATEX_COMPILER_CMD%
		)

		echo ^> Executing %LATEX_COMPILER_CMD%
		%LATEX_COMPILER_CMD% %%D %LATEX_COMPILER_SILENT_%
		if ERRORLEVEL 1 (
			call :print_error %LATEX_COMPILER_CMD%
		)
	)
	echo.
)
exit /b 0

rem =============================================================================

:check_packages
set MISSING=0
for %%R in (!PACKAGES_REQUIRED[%*]!) do (
	set test=
	for /f "delims=" %%a in ('%KPSEWHICH_CMD% %%R.sty') do (
		@set test=%%a
	)
	if "!test!" == "" (
		echo [XX] package %%R
		set MISSING=1
	) else (
		echo [OK] package %%R
	)
)
exit /b !MISSING!

rem =============================================================================

:print_error
if "%SILENT%" == "" (
	echo ERROR: %* failed
) else (
	echo ERROR: %* failed, run the script with parameter ^"all^" for details
)
exit /b 0
