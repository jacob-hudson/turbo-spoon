# scale.r	Amdahl's law and USL scalability using R statistics.
#
# This applies both Amdahl's law to model scalability (maximum speedup) and
# Universal Scalability Law to the input data set.  It uses regression
# analysis to determine the constants.
#
# USAGE: R --save < scale.r		# generates scale.pdf
#
# See the "Tunables" section for defining the input data file, and the number
# of rows to include as model input.  The remainder of rows are drawn as
# "extra" data points.  The file has the form:
#
# N	Result
# 1	2.1
# 2	4.0
# 3	5.9
# ...
#
# The heading line is important (processed by R).

# Tunables
filename <- "data.txt"		# data file (see top comment for format)
inputN <- 10			# rows to include as model input
padding <- 1.1			# chart padding
pdf("scale.pdf", w=10, h=6)	# comment for interactive

# Input
input_full <- read.table(filename, header=TRUE)
input_model <- subset(input_full, input_full$N <= inputN)
input_extra <- subset(input_full, input_full$N > inputN)

# Calculate normalization rate based on 1st datum
input_model$Norm <- input_model$Result/input_model$Result[1]

# Regression analysis: standard non-linear least squares (NLS) fit
amdahl <- nls(Norm ~ N / (1 + alpha * (N - 1)),
    input_model, start=c(alpha=0.1))
usl <- nls(Norm ~ N / (1 + alpha * (N - 1) + beta * N * (N - 1)),
    input_model, start=c(alpha=0.1, beta=0.01))

# Print parameters
print(summary(amdahl))
print(coef(amdahl))
amdahls.coef <- coef(amdahl)
print(summary(usl))
print(coef(usl))
usls.coef <- coef(usl)

# Chart padding
max_x <- padding * max(input_full$N)
max_y <- padding * max(input_full$Result)

# Plot model results
plot(x <- c(0:max_x), input_model$Result[1] * x /
    (1 + usls.coef['alpha'] * (x - 1) + usls.coef['beta'] * x * (x - 1)),
    type="l", lty=2, lwd=1,
    xlim=c(0, max_x), ylim=c(0, max_y),
    xlab="CPUs (N)", ylab="Throughput X(N)")
points(x <- c(0:max_x),
    input_model$Result[1] * x / (1 + amdahls.coef['alpha'] * (x - 1)),
    type="l", lty=3, lwd=1)

# Plot data
points(input_model$N, input_model$Result, pch=1)
points(input_extra$N, input_extra$Result, pch=4)

title("Scalability Models")
legend("bottomright", c("model input", "extra measurements"), pch=c(1,4))
legend("bottom", c("Amdahl", "USL"), lty=c(3,2))
