@echo off

IF NOT EXIST ..\dist mkdir ..\dist
pushd ..\dist

set windows_kits="C:\Program Files (x86)\Windows Kits"

set visual_studio="C:\Program Files\Microsoft Visual Studio"

set CL=/MP /nologo /Zi /c

set include_paths=/I%windows_kits%\10\Include\10.0.22621.0\shared
set include_paths=%include_paths% /I%windows_kits%\10\Include\10.0.22621.0\um
set include_paths=%include_paths% /I%visual_studio%\2022\Community\VC\Tools\MSVC\14.37.32822\include\
set include_paths=%include_paths% /I%windows_kits%\10\Include\10.0.22621.0\ucrt

set srcs=..\src\main.cpp
set srcs=%srcs% ..\src\utils.cpp

cl %include_paths% %srcs%
echo "error level %errorlevel%"

if NOT %errorlevel% == 0 (
    popd
    exit
)
echo "compilation DONE"
echo "----------------"

set lib_paths=/LIBPATH:"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\lib\x64"
set lib_paths=%lib_paths% /LIBPATH:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64"
set lib_paths=%lib_paths% /LIBPATH:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64"

@REM set libs=
@REM set libs=%libs%

set objs=main.obj
set objs=%objs% utils.obj

@REM this is a way to prepend all the options I want to the beginning of the argument list to
@REM calling link.exe
set LINK=/NOLOGO
set LINK=/DEBUG %LINK%
set LINK=%LINK% %objs%
set LINK=%LINK% %lib_paths%
@REM set LINK=%LINK% %lib_paths% %libs%

link /OUT:".\main.exe"
echo "error level %errorlevel%"

if NOT %errorlevel% == 0 (
    popd
    exit
)
echo "linking DONE"
echo "----------------"

popd