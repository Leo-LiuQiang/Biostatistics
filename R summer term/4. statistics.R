#-------------------------------------------------------------------------------
# Basic Statistics in R
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. descriptive statistics
# 2. statistical tests
# 3. Monte Carlo simulation
# 4. multiple testing correction


# * 1. descriptive statistics
summary(iris)
min(iris[,1])
max(iris[,1])
range(iris[,1])
range(iris[,1])[1]
range(iris[,1])[2]
median(iris$Sepal.Length)
mean(iris[,"Sepal.Length"])
quantile(iris[,1])
quantile(iris$Sepal.Length,0.5)
# InterQuartile Range
IQR(iris$Sepal.Length)
quantile(dat$Sepal.Length, 0.75) - quantile(dat$Sepal.Length, 0.25)
sd(iris$Sepal.Length)
var(dat$Sepal.Length)
# CV: Coefficient of variation
sd(iris$Sepal.Length) / mean(iris$Sepal.Length)

# exercise 1: try to write a function to calculate median of a given vector
# tip 1: using bubble sort (https://www.runoob.com/w3cnote/ten-sorting-algorithm.html)
# tip 2: simply based on sort() / order() / rank() function (https://www.cnblogs.com/hider/p/10019536.html)

# exercise 2: write a function to get the mode of a given vector
# tips: based on table() and sort()
# generate random numbers: set.seed(yourid); test <- abs(round(rnorm(1000,mean=100,sd=100),0))


# 2. statistical tests

# 2.1 distribution
# Every distribution has four associated functions whose prefix indicates the type of function
# and the suffix indicates the distribution. let's take normal distribution for an example
# ref: https://www.datascienceblog.net/post/basic-statistics/distributions/

# dnorm: density function of the normal distribution
sample.range <- 50:150
iq.mean <- 100
iq.sd <- 15
iq.dist <- dnorm(sample.range, mean = iq.mean, sd = iq.sd)
iq.df <- data.frame("IQ" = sample.range, "Density" = iq.dist)
library(ggplot2)
ggplot(data=iq.df, aes(x = IQ, y = Density)) + 
  geom_point()
# likelihood of IQ=140?
dnorm(140,mean=iq.mean,sd=iq.sd)

# pnorm: cumulative density function of the normal distribution
cdf <- pnorm(sample.range, iq.mean, iq.sd)
iq.df <- cbind(iq.df, "CDF_LowerTail" = cdf)
ggplot(iq.df, aes(x = IQ, y = CDF_LowerTail)) + 
  geom_point()
# likelihood of IQ<=140?
pnorm(140,mean=iq.mean,sd=iq.sd)
# if lower.tail=F
# likelihood of IQ>140?
pnorm(140,mean=iq.mean,sd=iq.sd,lower.tail = F)

# qnorm: quantile function of the normal distribution
# The quantile function is simply the inverse of the cumulative density function (iCDF).
# input to qnorm is a vector of probabilities
prob.range <- seq(0, 1, 0.001)
icdf.df <- data.frame("Probability" = prob.range, "IQ" = qnorm(prob.range, iq.mean, iq.sd))
ggplot(icdf.df, aes(x = Probability, y = IQ)) +
  geom_point()
# what is the 25th IQ percentile? == the IQ which 25% people are not higher than?
print(icdf.df$IQ[icdf.df$Probability == 0.25])

# rnorm: random sampling from the normal distribution
hist(rnorm(1000,mean=iq.mean,sd=iq.sd))

# Poisson distribution: dpois, ppois, qpois, rpois
# Hypergeometric Distribution: dyper, phyper, qhyper, rhyper
# Binomial Distribution: dbinom, pbinom, qbinom, rbinom
# Negative Binomial Distribution: dnbinom, pnbinom, qnbinom, rnbinom
# ... ...

# 2.2 parametric hypothesis testing

# 2.2.1 t-test
# Performs the Shapiro-Wilk test of normality. visualized by qqplot
set.seed(1)
shapiro.test(rnorm(100))
shapiro.test(rnbinom(100, mu = 4, size = 1))
qqnorm(rnorm(100))
qqnorm(rnbinom(100, mu = 4, size = 1))

# one sample t-test
# is used to compare the mean of one sample to a known standard (or theoretical/hypothetical) mean (??).
# H0:m=0 H1:m!=0 (different): two-tailed / two-sided test
# H0:m=0 H1:m>0 (greater): one-tailed / one-sided test
# H0:m=0 H1:m<0 (less):one-tailed / one-sided test
t.test(rnorm(100),mu=0)
t.test(rnorm(100),mu=1)
t.test(rnorm(100),mu=1,alternative = 'less')
t.test(rnorm(100),mu=1,alternative = 'greater')

# two sample t-test (independent)
t.test(rnorm(100),rnorm(100,mean = 1))
t.test(iris[1:100,1]~iris[1:100,5])

# two sample t-test (paired), e.g., pre-post design, repeated measures design
t.test(rnorm(100),rnorm(100)+0.5,paired = T)


# 2.3 non-parametric hypothesis testing
set.seed(1)
a=rnorm(100)
b=rnorm(100,mean = 1)
wilcox.test(a,b)

# 2.4 Pearson vs Spearson correlation
# Pearson but not Spearman is sensitive to outliers
set.seed(1)
a <- abs(c(rnorm(20,mean=2,sd=1),10))
b <- c(rnorm(20),10)
plot(a,b)
cor(a,b)
cor.test(a,b,method = "pearson")
cor(a,b,method = "spearman")
cor.test(a,b,method = "spearman")

# Pearson but not Spearman is changed if your data is transformed
a = log2(a)
cor(a,b)
cor.test(a,b,method = "pearson")
cor(a,b,method = "spearman")
cor.test(a,b,method = "spearman")

# 2.5 ANOVA
str(InsectSprays)
# exercise: get the mean count for each spray
ggplot(data=InsectSprays,aes(x=spray,y=count)) +
  geom_boxplot() +
  geom_point()
# one-way anova
# parametric
oneway.test(InsectSprays$count~InsectSprays$spray)
aov.out <- aov(count ~ spray, data=InsectSprays)
summary(aov.out)
# non-parametric
# kruskal.test(count ~ spray, data=InsectSprays)

# Tukey HSD
TukeyHSD(aov.out)

# * 3. monte carlo simulation
# flip a coin (head vs tail)
steps = seq(10,100000,by=10)
probs = data.frame(probs=0,times=steps)
for(i in 1:nrow(probs)){
  probs[i,1] = sum(sample(c(0,1),steps[i],replace = T))/steps[i]
}

samples = c()
for(i in 1:nrow(probs)){
  samples = c(samples,sample(c(0,1),10,replace = T))
  probs[i,1] = sum(samples)/steps[i]
}

ggplot(data = probs,aes(x=times,y=probs)) +
  geom_line() +
  geom_hline(yintercept = 0.5, lty=2, col="red") +
  theme_classic()

# 50 heads / 120 times. is it normal?
occ = c()
for(i in 1:10000){
  occ[i] = sum(sample(c(0,1),replace = T,120))
}
hist(occ)
table(occ<=50)

  
# * 4. multiple testing correction

# 4.1 to understand why we need multiple testing correction
# sample data:
# cont: the expression levels are measured three times for all 20,000 genes, and all follow normal distribution (mean = 0 and sd = 1)
# case: the first 19,000 come from norm(0,1), and the last 100 from norm(10,2)

control1=matrix(0,nrow=20000,ncol=3)
control2=matrix(0,nrow=20000,ncol=3)
for (i in 1:20000){
  control1[i,] = rnorm(3,mean=0,sd=1)
  control2[i,] = rnorm(3,mean=0,sd=1)
}

case=matrix(0,nrow=20000,ncol=3)
for (i in 1:20000){
  if(i<=19000){
    case[i,] = rnorm(3,mean=0,sd=1)
  }else{
    case[i,] = rnorm(3,mean=10,sd=2)
  }
}

# cont vs cont t.test 1 time
i=sample(1:20000,1)
t.test(control1[i,],control2[i,])
# cont vs cont t.test 20,000 times
pconvscon = c()
for (i in 1:20000){
  pconvscon[i] = t.test(control1[i,],control2[i,])$p.value
}
# false positives
length(which(pconvscon<0.05))
length(which(pconvscon<0.01))
length(which(pconvscon<0.0001))

# cont vs case
pconvscase = c()
for (i in 1:20000){
  pconvscase[i] = t.test(control1[i,],case[i,])$p.value
}
# false positives
alpha = seq(0.001,0.1,by=0.001)
fp=matrix(0,nrow=100,ncol=4)
for(i in 1:100){
  fp[i,1] = alpha[i]
  fp[i,2] = length(which(pconvscase<alpha[i]))
  fp[i,3] = length(which(which(pconvscase<alpha[i])<=19000))
  fp[i,4] = length(which(which(pconvscase<alpha[i])>19000))
}
library(ggplot2)
fp=as.data.frame(fp)
names(fp) = c("alpha","t","fp","tp")
ggplot(data=fp,aes(x=alpha,y=fp/t)) + 
  geom_point() +
  geom_line() +
  ylim(0,0.65) +
  geom_vline(xintercept = c(0.001,0.01,0.05),col="red",lty=2) +
  theme_classic()

# 4.2 Bonferroni Correction
# manually
pconvscase.bonf.man <- pconvscase * 20000
pconvscase.bonf.man[pconvscase.bonf.man>1] = 1
which(pconvscase.bonf.man<0.05)
# by p.adjust
pconvscase.bonf.padj <- p.adjust(pconvscase,method="bonferroni")
identical(pconvscase.bonf.man,pconvscase.bonf.padj)

# 4.2 FDR (Bonferroni Holm method)
# noise vs signal
par(mfrow=c(2,1))
hist(pconvscon,breaks=20)
hist(pconvscase[19001:20000],breaks=20)
par(mfrow=c(1,1))
df <- data.frame(p=pconvscase,class=c(rep("cont",19000),rep("case",1000)))
ggplot(df,aes(x=p,fill=class)) +
  geom_histogram(bins=20,position = "stack",col="black",breaks=seq(0,1,by=0.05)) +
#  geom_histogram(bins=20,position = position_dodge(),breaks=seq(0,1,by=0.05)) +
  geom_hline(yintercept = 19000/20,lty=2) +
  theme_classic()

# by p.adjust()
pconvscase.fdr = p.adjust(pconvscase,method = "fdr")
table(which(pconvscase.fdr<0.05)<=19000)
