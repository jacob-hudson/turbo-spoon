#!/usr/sbin/dtrace -s

#pragma D option quiet
#pragma D option switchrate=5

dtrace:::BEGIN
{
	printf("%-20s %-6s %-16s %11s %11s\n", "TIME", "PID", "COMM",
	   "RUNTIMEms", "TotalCPUms");
}

proc:::exec-success
{
	start[pid] = timestamp;
	tcpu[pid] = -vtimestamp;
}

proc:::lwp-exit
/start[pid]/
{
	/* remember exited thread's CPU time */
	tcpu[pid] += vtimestamp;
}

proc:::exit
/this->s = start[pid]/
{
	this->total_cpu = tcpu[pid] + vtimestamp;
	printf("%-20Y %-6d %-16s %12d %12d\n", walltimestamp, pid, execname,
	    (timestamp - this->s) / 1000000, this->total_cpu / 1000000);
	start[pid] = 0;
	tcpu[pid] = 0;
}
