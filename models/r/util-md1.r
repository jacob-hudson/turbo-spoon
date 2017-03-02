# util-md1.r	Queueing Theory M/D/1 mean response time vs utilization
#
# USAGE: R --save < util-md1.r		# generates util-md1.pdf
#
# See the "Tunables" section for defining the mean service time.

# Tunables
svc_ms <- 1				# average disk I/O service time
pdf("util-md1.pdf", w=10, h=6)		# comment for interactive
util_min <- 0
util_max <- 100
ms_min <- 0
ms_max <- 10

# Plot mean response time vs utilization (M/D/1)
plot(x <- c(util_min:util_max), svc_ms * (2 - x/100) / (2 * (1 - x/100)),
    type="l", lty=1, lwd=1,
    xlim=c(util_min, util_max), ylim=c(ms_min, ms_max),
    xlab="Utilization %", ylab="Mean Response Time (ms)")

# Grids
abline(v=(seq(util_min, util_max, (util_max - util_min) / 10)),
    col="lightgray", lty="dotted")
abline(h=(seq(ms_min, ms_max, (ms_max - ms_min) / 10)),
    col="lightgray", lty="dotted")

title("Single Service Queue, Constant Service Times (M/D/1)")
