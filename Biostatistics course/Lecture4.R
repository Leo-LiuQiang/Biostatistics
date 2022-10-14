## loop  
for(x in 1:10){
  print(sqrt(x))
}

## apply, lapply, sapply, ....
mat <- matrix(1:100, nrow = 10, ncol = 10)
apply(mat, 2, sum)

l <- sqrt(1:10) ## unlist(lapply(1:10, sqrt))

sapply(list(1:10, 2:20), sqrt)


## R graphics 
## R base 
plot(1:10, rnorm(10), type='b', col=1:3,
     xlim = c(0,20), ylim=c(-1,2),
     xlab = 'x', ylab = 'y', main='title',
     bty='u')
lines(11:20, rnorm(10), type='p', col='orange')
points()

plot(density(rnorm(100)))

hist(rnorm(100))
boxplot()


plot(iris$Petal.Length, iris$Petal.Width,
     col=c('orange', 'red', 'green')[as.integer(iris$Species)])

## ggplot2 

library(ggplot2)

ggplot(iris, aes(x = Petal.Length, 
                 y = Petal.Width, 
                 col = Species)) + 
  geom_point() + theme_classic() + 
  scale_color_manual(values = c(virginica='orange',versicolor='grey',setosa='blue'))


### dplyr
library(dplyr)
iris %>% select(Species) 

iris %>% filter(Species %in% c("setosa")) 

iris %>% mutate(petal=Petal.Width + Petal.Length) 

iris %>% sample_n(100) %>% ggplot(aes(x = Petal.Length,
                          y = Petal.Width,
                          col = Species)) +
  geom_point() + theme_classic() +
  scale_color_manual(values = c(virginica='orange',versicolor='grey',setosa='blue'))



### 
pnorm(105, mean = 110, sd=12)

pnorm(-0.42)

L <- c(1,5,10,20,50,100)
x <- 0:50 


lambdas <- c(1,4,10)
x <- 0:20
ps <- lapply(lambdas, function(lambda){
  dpois(x, lambda = lambda)
})
#


