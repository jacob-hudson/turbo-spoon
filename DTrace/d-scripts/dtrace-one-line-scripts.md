# DTrace One Line Scripts

# New processes with arguments:
dtrace -n 'proc:::exec-success { trace(curpsinfo->pr_psargs); }'

# Files opened by process:
dtrace -n 'syscall::open*:entry { printf("%s %s",execname,copyinstr(arg0)); }'

# Syscall count by program:
dtrace -n 'syscall:::entry { @num[execname] = count(); }'

# Syscall count by syscall:
dtrace -n 'syscall:::entry { @num[probefunc] = count(); }'

# Syscall count by process:
dtrace -n 'syscall:::entry { @num[pid,execname] = count(); }'

# Read bytes by process:
dtrace -n 'sysinfo:::readch { @bytes[execname] = sum(arg0); }'

# Write bytes by process:
dtrace -n 'sysinfo:::writech { @bytes[execname] = sum(arg0); }'

# Read size distribution by process:
dtrace -n 'sysinfo:::readch { @dist[execname] = quantize(arg0); }'

# Write size distribution by process:
dtrace -n 'sysinfo:::writech { @dist[execname] = quantize(arg0); }'

# Disk size by process:
dtrace -n 'io:::start { printf("%d %s %d",pid,execname,args[0]->b_bcount); }'   

# Pages paged in by process:
dtrace -n 'vminfo:::pgpgin { @pg[execname] = sum(arg0); }'

# Minor faults by process:
dtrace -n 'vminfo:::as_fault { @mem[execname] = sum(arg0); }'

# Profile user-level stacks at 99 Hertz, for PID 189:
dtrace -n 'profile-99 /pid == 189 && arg1/ { @[ustack()] = count(); }'
