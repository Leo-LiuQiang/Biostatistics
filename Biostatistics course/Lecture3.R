## install R packages
install.packages(c('ggpolt2','dplyr'))

##### array
x <- c(1,2,3,4,5,6,7,8,9)
x <- 1:9 
x <- seq(1,9)
x <- seq(1,9,by=0.5)

y <- rep(1:5,times=10)
y <- rep(1:5,each=10)

z <- rnorm(100)
z[10]
z[1:10]
z[c(5,8,60)]

### data.frame / matrix 

m <- matrix(1:9, nrow = 3, ncol = 3)
m[2:3, 2:3]

m <- matrix(letters, nrow = 13, ncol = 2)
m <- matrix(c(letters,1:10), nrow = 6, ncol = 6)

w <- data.frame(letters, 
           rep(c('F','M'),13), 
           rnorm(26))
rownames(w) <- LETTERS
colnames(w) <- c('name', 'sex', 'height')

#### list 

l <- list(v=x,d=w)
l$d
l[[2]][3:5,1:2]
names(l)

### factor
factor(w[,2], levels = c('M','F'))

s <- sample(c("优","良","中","差"),100,replace = T)
s <- factor(s, levels = c("优","良","中","差"))
table(s)

