
##### 

N <- 10000
n <- 1000
o <- c()
for(i in seq(1, N)){
  x <- sample(c('点名','不点名'), size = n, replace = T)
  y <- table(x) / n
  p <- y['点名']
  o <- c(o, p)
}
hist(o)
mean(o)
sd(o)


##### 
students <- read.csv('../studentList.csv')
set.seed(20221004)
i <- sample(students$序号, 1)

N <- 10000
n <- 20
o <- c()
for(i in seq(1, N)){
  x <- sample(students$姓名, n, replace = T)
  y <- table(x) / n
  p <- y['徐晶颖']
  o <- c(o, p)
}

o[is.na(o)] <- 0


#### t分布图

x <- seq(-5, 5, length.out=1000)
y1 <- dt(x, df = 1)
y4 <- dt(x, df = 4)
y30 <- dt(x, df = 30)
plot(x, y1, type='l', bty='l', lwd=2, ylim = c(0, max(y1,y4,y30)))
lines(x, y4, col='orange', lwd=2)
lines(x, y30, col='red', lwd=2)
