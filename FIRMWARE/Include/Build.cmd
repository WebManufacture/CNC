cd ..\include\
D:
SET ST_TOOL=C:\Program Files (x86)\STMicroelectronics\st_toolset
SET COSMIC=C:\Program Files (x86)\COSMIC\CXSTM8_16K

"%COSMIC%\cxstm8" -i"%COSMIC%\Hstm8" -i"%ST_TOOL%\include" +mods0 +debug -pxp -pp -l -ttmp -cetmp -cl"tmp\" -co"tmp\" *.c
PAUSE