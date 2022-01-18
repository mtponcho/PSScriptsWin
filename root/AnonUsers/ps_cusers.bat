

for /l %%A in (0,1,9) do (
	net user Anon00%%A /add Allscripts1
	\\172.30.16.7\Software\Scripts\CREATE_ANON_000_500\cusrmgr -u Anon00%%A +s CanNotChangePassword +s PasswordNeverExpires
	)

for /l %%A in (10,1,50) do (
	net user Anon0%%A /add Allscripts1
	\\172.30.16.7\Software\Scripts\CREATE_ANON_000_500\cusrmgr -u Anon0%%A +s CanNotChangePassword +s PasswordNeverExpires
	)


