SET VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
copy build-tripole-Desktop_Qt_5_7_0_MSVC2013_64bit-Debug\debug\tripole.exe deploy
copy tripole_init.dat deploy
windeployqt -serialport deploy\tripole.exe
