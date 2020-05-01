@echo off
REM Running IUP4Eu demos using OE4.1.0(32) - Version4.1.0.0: created
ECHO IUP4Eu demo files, running on OE4.1.0(32)

ECHO Syntax: ./eu32 filename

set dir=../libs/32/

\euphoria32\bin\eui %1 %dir%
