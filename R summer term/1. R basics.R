#-------------------------------------------------------------------------------
# R Basics
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. R basic grammar
# 2. data types & structures
# 3. R functions
# 4. Control Flow

# * 1. R basic grammar 
# rules for variable names
# case sensitive; all alphanumeric symbols plus '.' and '_'; start with a letter
# or the dot not followed by a number

# .2var_name <- 1 # invalid
var_name <- 1 # valid

# Assignment Operators
v <- c(2,5.5,6)
t = c(8,3,4)
v
print(t)

# Arithmetic Operators
print(v+t)
v**t #chengfang
v^t #chengfang
v%%t #quyu
v%/%t #quzheng

# Relational Operators
v==t
v>=t

# Logical Operators
!t #budengyu(shibushi dengyu0)
v&t #shifou tongshimanzu
v&&t #diyigefanhuizhi shifou tongshimanzu

# bitwise logical operations
bitwAnd(2,5)
bitwAnd(3,5)
bitwOr(3,5)

intToBits(3)&intToBits(5)
intToBits(2)&intToBits(5)

# Others
v1 <- 8; v2<- 12; t<- 1:10
v1 %in% t
v2 %in% t

# importing
getwd()
setwd("./")
dir(full.names = T)
# install.packages("ggplot2")
library(ggplot2)
# source("path-to-your-script")

x=read.table(file="volcano.txt")

# exporting
# write, write.table(), write.csv()...

# usage
?read.table
help(write.table)
help.search('cluster')
example('hclust')

# * 2. data types & structures 

# data types
# create a numeric vector x with 5 components
x<-c(1,3,2,10,5); x
class(x)
# create an integer vector
x<-c(1L,2L,3L); x
class(x)
# create a logical vector x
x<-c(TRUE,FALSE,TRUE); x
class(x)
# create a character vector
x<-c("sds","sd","as"); x
class(x)
# create factors
features=c("promoter", "exon", "intron", "intron")
class(features)
f.feat=factor(features)
class(f.feat)
levels (f.feat)

# data structures
# Vectors
x <- 3; x = 3; 3 -> x
assign('x', 3)
pi
pi=3.14
pi
mean
mean=3;mean
mean(c(2,3))

# Using function c() to create vectors
y <- c(2, 3, 5);y
# Creating a null vector
y <- c(); y
# Creating a vector with a regular pattern
x <- 1:5; x
z <- seq (from =3, to =5, by =0.5) ; z
z <- rep (3, 5); z
rep(1:3,5)
rep(1:3,each=5)

# Arithmetic expressions are performed element by element
#  +, -, *, /, ^ or **, %%, %/%
x <- 1:5; y <- 6:10; x; y
2*x+y
2*x+y+1
# The resulted vector size is the same as that of the bigger vector
# when operations are done between vectors of different sizes. 
1:6 + c(1,2)
1:6*c(1,2)
# Comparison operators
# <, >, <=, >=, ==, !=, &, |, !, isTRUE
a=1:10
a>0 & a<2
a == 3
which(a == 3)
!(a)

# a few vector functions
x <- seq(1, 10, 0.5); x
length(x)
max(x)
mean(x)
sd(x)
sort(x, decreasing=TRUE)
x <- c(1, 2, 3, NA, 5); x
is.na(x)
mean(x)
mean(x, na.rm=TRUE)
sum(is.na(x))
summary(x)

# subsetting
x<- c(1, 3, -2, 5, 4, -6)
x[2:4]
x[c(2, 4, 6)]
x[-2]
names(x) <- c('a', 'b', 'c', 'd', 'e', 'f'); x
x['b']
x[(length(x)-2) : length(x)]
x[x > 2]
x[x > 3 | x < 0]
subset(x, x>3 & x<0)

# Matrix
# Create a matrix by matrix()
m <- matrix (2:7 , nrow =3, ncol =2); m
# Create a matrix from vectors by rbind() or cbind()
x<-c(1,2,3,4)
y<-c(4,5,6,7)
m1<-cbind(x,y);m1 # see also rbind
# Operations on matrix
t(m1)                # transpose of m1
dim(m1)             # dimension
sum(m)
m + m

# Data Frame
# read from file
df <- read.table("volcano.txt")
# Create a data frame
chr <- c("chr1", "chr1", "chr2", "chr2")
strand <- c("-", "-", "+", "+")
start<- c(200, 4000, 100, 400); end<-c(250, 410, 200, 450)
mydata <- data.frame(chr, start, end, strand)
names(mydata) <- c("chr", "start", "end", "strand")
# or
mydata <- data.frame(chr=chr,start=start,end=end,strand=strand)
mydata
# Get a subset of a data frame
# columns 2,3,4 of data frame
mydata[,2:4]
# columns chr and start from data frame
mydata[,c("chr","start")]
# variable start in the data frame
mydata$start
# get 1st and 3rd rows
mydata[c(1,3),] 
# get all rows where start>400
mydata[mydata$start>400,]
# by subset() function
subset(mydata, mydata$start>400)
subset(mydata, start>400)

# Array
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)
column.names <- c("COL1","COL2","COL3")
row.names <- c("ROW1","ROW2","ROW3")
matrix.names <- c("Matrix1","Matrix2")
# Take these vectors as input to the array.
result <- array(c(vector1,vector2),dim = c(3,3,2), dimnames = list(row.names,column.names, matrix.names))
print(result)

# List
# Create a list
w <- list(name="Fred", mynumbers=c(1,2,3), mymatrix=matrix(1:4,ncol=2), age=5.3)
w
# Extract elements of a list using the [[ ]] or $
w[[3]] # 3rd component of the list
w[[3]][2,2]
w[[3]][2,]
w[["mynumbers"]] # component named mynumbers in list
w$age

# * 3. R functions
# examine data type / structure
is.character()
is.finite()
is.integer()
is.numeric()
is.double()
is.na()
is.nan()
is.vector()
is.array()
is.matrix()
is.data.frame()
is.list()
# conversion of data type / structure
as.character()
as.integer()
as.numeric()
as.double()
as.vector()
as.array()
as.matrix()
as.data.frame()
as.list()
# generate sequences
seq()
rep()
1:5
# order
sort()
order()
rank()
# descriptive statistics
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
# apply a function over a list/vector/array/data.frame
tapply()
apply()
lapply()

# write your own functions

pvalue2star <- function(a=1){
  if(a>0.05){
    b="NS"
  }else if(a>0.01 & a<0.05){
      b="*"
  }else if(a>0.001 & a<=0.01){
    b="**"
  }else {
    b="***"
  }
  return(b)
}

set.seed(1)
a<-rnorm(100)
b<-rnorm(100,mean=3)
boxplot(a,b,ylim=c(-3,7))
lines(c(1,2),c(6,6))
text(1.5,6.5,pvalue2star(t.test(a,b)$p.value))

# BinnedErrorBarPlot
# input is a data.frame; x1: the column index for x; y1: the column index for y
# this function is to divide x into n bins, and make sure each bin has equal number of data points
# then for each bin, plot the median of y as a function of the median of x
# add the lower and upper quartile of x and y as their errorbars
BinnedErrorBarPlot <- function(data,x1,y1,bin=15,xlab="x",ylab="y"){
  bk <- as.double(quantile(data[,x1],probs = seq(0,1,1/bin)))
  status <- .bincode(data[,x1],bk,include.lowest = T)
  x <- data.frame(data[,x1],status)
  y <- data.frame(data[,y1],status)
  me_x <- c(); q25_x <- c(); q75_x <- c();
  me_y <- c(); q25_y <- c(); q75_y <- c();
  for(i in 1:bin){
    me_x[i]  <- median(x[status==i,1]);
    q25_x[i]  <- quantile(x[status==i,1],probs = 0.25);
    q75_x[i] <- quantile(x[status==i,1],probs = 0.75)
    me_y[i]  <- median(y[status==i,1])
    q25_y[i]  <- quantile(y[status==i,1],probs = 0.25)
    q75_y[i] <- quantile(y[status==i,1],probs = 0.75)
  }
  mat <- as.data.frame(cbind(me_x,q25_x,q75_x,me_y,q25_y,q75_y))
  
  library(ggplot2)
  p <- ggplot(mat,aes(x=me_x,y=me_y)) +
    geom_errorbar(aes(ymin = q25_y,ymax = q75_y),col="blue") + 
    geom_errorbarh(aes(xmin = q25_x,xmax = q75_x),col="blue") +
    geom_point(col="red") +
    xlab(xlab) +
    ylab(ylab) +
    theme(panel.grid.major = element_line(colour="NA"),
          panel.grid.minor = element_line(colour="NA"),
          panel.background = element_rect(fill="NA"),
          panel.border = element_rect(colour="black", fill=NA))
  print(p)
}
test=data.frame(x=sort(rnorm(100,sd=4)),y=sort(rnorm(100,sd=4)))
BinnedErrorBarPlot(test,1,2,bin=10)

# * 4. Control Flow
# loops: for and while
# for is more recommended over while
# for
for (i in 1:10) print("hello world!")
for (i in 1:10){
  print("hello world!")
}
for (i in 1:10)
  print("hello world!")
# while
i <- 1
while(i<=10){
  print("Hello world!");
  i <- i+1
}

# choices: if and switch
# if (condition) true_action
# if (condition) true_action else false_action
grade <- function(x) {
  if (x > 90) {
    "A"
  } else if (x > 80) {
    "B"
  } else if (x > 50) {
    "C"
  } else {
    "F"
  }
}
# ifelse: a short version
a = 99
ifelse(a>90,"A","not A")

# switch
grades <- c("A","B","C","F")
for (i in grades){
  print(
    switch (i,
      A = "A: Score > 90",
      B = "B: 80 < Score <= 90",
      C = "C: 50 < Score <= 80",
      F = "F: Score <= 50"
    )
  )
}


