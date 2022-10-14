#-------------------------------------------------------------------------------
# R Basic Graph
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. appearance and annotations
# 2. different plot types
# 3. arrangement

# * 1. appearance and annotations
plot(mtcars$wt,mtcars$mpg,
     # points
     type = "p",pch=20,
     # axis
     xlim=c(1,6),ylim=c(9,35),
     xlab="Weight (lb)",ylab="MPG",
     # title
     main="Regression of MPG on Weigth",
     # size
     cex=2,
     cex.axis=1,
     cex.lab=1.2,cex.main=2,
     # font
     font=1,
     font.axis=2,
     font.lab=3,
     font.main=4,
     # line type and width
     #lty=2,lwd=2,
     # color
     col.axis=3,col.lab="#FAAFFF",col.main=rgb(1,0.5,0.3),
#     col=colorRampPalette(c("blue","red"))(length(mtcars$wt)),
     col=mtcars$vs+2,
)

# annotations
abline(lm(mtcars$mpg~mtcars$wt))
legend("topright",inset = .05, title="VS",c("0","1"),pch=20,col=c(2,3))
text(4,25,"regression line")

# title & labs can be added outside of plot() by title
# create self-defined axis by axis()
# many graphical parameters can be specified in par()
# an example from R语言实践(第2版)
x <- 1:10
y <- x
z <- 10/x
opar <- par(no.readonly = T)
par(mar=c(5,4,4,8)+0.1)
plot(x,y,type="b",pch=21,col="red",yaxt="n",lty=3,ann=FALSE)
lines(x,z,type="b",pch=22,col="blue",lty=2)
axis(2,at=x, labels=x, col.axis="red",las=2)
axis(4,at=z,labels=round(z,digits=2),
     col.axis="blue",las=2,cex.axis=0.7,tck=-0.01)
mtext("y=1/x",side=4,line=3,cex.lab=1,las=2,col="blue")
title("An example of Creative Axes", ylab="Y=X", xlab="X values")
par(opar)


# * 2. different plot types
# bar plot
barplot(table(mtcars$cyl))
# stacked bar plot
barplot(table(mtcars$cyl,mtcars$gear))
# side-by-side
barplot(table(mtcars$cyl,mtcars$gear),beside=T)
# pie chart
pie(table(mtcars$cyl))
# histogram
hist(iris$Sepal.Length,breaks = 20)
# density plot
plot(density(iris$Sepal.Length))
# box plot
boxplot(iris$Sepal.Length)
boxplot(iris$Sepal.Length ~ iris$Species)
# dot chart
dotchart(mtcars$mpg,labels = row.names(mtcars))
# others
scatter.smooth(iris$Sepal.Length)
smoothScatter(iris$Sepal.Length)
symbols(mtcars$wt,mtcars$mpg,circles = sqrt(mtcars$disp/pi),
        inches = 0.3,fg="white",bg="lightblue")
text(mtcars$wt,mtcars$mpg,rownames(mtcars),cex=0.6)

# * 3. arrangement
par(mfcol=c(2,1))
boxplot(iris$Sepal.Length ~ iris$Species)
boxplot(iris$Sepal.Width ~ iris$Species)
par(mfcol=c(1,1))
