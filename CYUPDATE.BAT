@ECHO OFF
C:
cd\cycon
copy cycon.pas \tpx\cycondos.pas
copy cycon.exe \cycon\temp
copy verbs.txt \tpx
copy verbs.txt d:\bbs\doors\cycon
copy verbs.txt \cycon\temp
copy cycrmdat.dat \cycon\temp
copy cycrmdat.dat \tpx
copy cycrmdat.dat d:\bbs\doors\cycon
copy c:\tpx\cycondos.exe  d:\bbs\doors\cycon
copy c:\tpx\cycondos.exe  \cycon\temp
call cyconzip.bat
