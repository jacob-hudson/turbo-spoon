#!/usr/sbin/dtrace -s

#pragma D option quiet

dtrace:::BEGIN
{
	printf("%-20s %16s -> %16s %6s\n", "TIME", "SRC", "DEST", "ERR");
}

fbt::tcp_drop:entry
{
	printf("%-20Y %16s -> %16s %6d\n", walltimestamp,
	    xlate <tcpsinfo_t>((struct tcpcb *)arg0).tcps_laddr,
	    xlate <tcpsinfo_t>((struct tcpcb *)arg0).tcps_raddr,
	    arg1);
}
