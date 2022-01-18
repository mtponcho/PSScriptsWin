@echo regedit /s "C:\batch\ieauto.reg"
md C:\Batch
copy "\\tscmgr\Software\Citrix\IE10 disable autodetect\ieauto.reg" C:\Batch
takeown /F C:\Windows\SysWOW64\usrlogon.cmd /A
icacls "C:\Windows\SysWOW64\usrlogon.cmd" /grant Administrators:F
takeown /F C:\Windows\System32\usrlogon.cmd /A
icacls "C:\Windows\System32\usrlogon.cmd" /grant Administrators:F


pause