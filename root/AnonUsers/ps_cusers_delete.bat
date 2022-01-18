

for /l %%A in (0,1,9) do (
	net user Anon00%%A /delete
)
for /l %%A in (10,1,99) do (
	net user Anon0%%A /delete
)
for /l %%A in (100,1,500) do (
	net user Anon%%A /delete
)
