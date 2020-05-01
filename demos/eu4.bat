@echo off
REM Running IUP4Eu demos using OE4.1.0(64) - Version4.1.0.0: created
ECHO IUP4Eu demo files, running on OE4.1.0(64)

ECHO Syntax: ./eu4 filename [dll-pathname] - default = ../libs/64/

\euphoria64\bin\eui %1 %2
