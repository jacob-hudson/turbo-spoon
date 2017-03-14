#!/usr/sbin/dtrace -s

#pragma D option quiet
#pragma D option defaultargs
#pragma D option stackframes=100

inline int limit = 20;		/* Max number of stacks to print */

dtrace:::BEGIN
/$1/
{
	secs = $1;
	i = 0;
	printf("Sampling kernel stacks for %d seconds...\n", secs);
}

dtrace:::BEGIN
/!$1/
{
	printf("Sampling kernel stacks... Ctrl-C to end\n");
}

profile:::profile-99
{
	@[execname, stack()] = count();
}

profile:::tick-1s
/secs && ++i >= secs/
{
	exit(0);
}

dtrace:::END
{
	trunc(@, limit);
	printf("Top %d kernel stacks:\n", limit);
	printa(@);
}
