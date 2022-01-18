REM Robocopy from PVS001 to PVS002 - should always be done from 001 to 002 ONLY
REM Deletes files from other server if not present on local server which is ok as 002 is a failover node only
REM Add lines needed for each store foler **pay attention to folders as /mir will blow away any differneces on 002 form 001**
REM you must right click and run this as administrator - review the results when done and pause is in effect

robocopy E:\PVSSTORE_PROD\PROD \\vpadppvs002\e$\PVSSTORE_PROD\PROD *.vhd *.avhd *.pvp /b /mir /sec /secfix /xf *.lok /xd WriteCache /xo

pause


