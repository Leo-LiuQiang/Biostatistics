#-------------------------------------------------------------------------------
# Introduction to R graphics with ggplot2
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. grammar of ggplot2
# 2. data prep
# 3. common types of plots
# 4. make your figures more elegant
# 5. repeat sci figures in bio literature

# * 0. prep
# install ggplot2 if not yet
# install.packages("ggplot2")
# load ggplot2
library(ggplot2)

# * 1. grammar of ggplot2

# Mandatory features
# Data: data=iris
# Aesthetic mapping: aes(x=Sepal.Length,y=Sepal.Width,color=Species)
# Geometric object: geom_point() +  geom_smooth(method = "lm",formula = y ~ x)

# Optional features
# Statistical transformation: no in this case
# Scales:scale_color_brewer(palette = "Set1")
# Coordinate system: ylim(2,4.5) + coord_flip()
# Facet: facet_grid(.~Species)
ggplot(data=iris,aes(x=Sepal.Length,y=Sepal.Width,color=Species)) +
  geom_point() +
  geom_smooth(method = "lm",formula = y ~ x) +
  scale_color_brewer(palette = "Set1") +
  ylim(2,4.5) +
  coord_flip() +
  facet_grid(.~Species)

# Layer by layer
a <- ggplot(data=iris,aes(x=Sepal.Length,y=Sepal.Width,color=Species)) + geom_point()
a <- a + geom_smooth(method = "lm",formula = y ~ x)
a <- a + scale_color_brewer(palette = "Set1")
a <- a +   ylim(2,4.5) + coord_flip() + facet_grid(.~Species)
a

# Statistical transformation
# how many diamonds are high quality diamonds (defined as: Very good + Premium + Ideal)?
diamonds
str(diamonds)
# using basic graphics in R (you need to count first)
barplot(table(diamonds$cut))
plot(table(diamonds$cut))
# with ggplot2
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
ggplot(data = diamonds, aes(x = cut)) + 
  geom_bar(stat = "count")
ggplot(data = diamonds) + 
  geom_bar(aes(x = cut),stat = "count")

# * 2. data prep

# relationship between sepal length and sepal width
str(iris)
ggplot(data=iris,aes(x=Sepal.Length,y=Sepal.Width,color=Species)) +
  geom_point() +
  geom_smooth(method = "lm",formula = y ~ x) +
  facet_grid(.~Species) +
  theme_bw()
# change "wide" format data.frame to "tall" format data.frame when necessary
# e.g., using boxplots to show the distribution of sepal length and width, and petal length and width?
library(reshape2)
iris.tall <- melt(iris,id="Species")
iris.tall
ggplot(data=iris.tall,aes(x=variable,y=value,col=Species)) +
  geom_boxplot()

# * 3. common types of plots

# BAR GRAPH
# basic bar graph
library(gcookbook)
pg_mean
ggplot(pg_mean, aes(x=group, y=weight)) +
  geom_bar(stat="identity")
# grouping bars together
cabbage_exp
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity",position="dodge")

ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity")

# LINE GRAPH
# basic line graph
BOD
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line() +
  geom_point()
# multiple lines
library(plyr)
tg <- ddply(ToothGrowth, c("supp", "dose"), summarise, length=mean(len))
ggplot(tg, aes(x=dose, y=length, colour=supp)) + geom_line(size=1)
ggplot(tg, aes(x=dose, y=length, linetype=supp)) +
  geom_line(size=1) +
  geom_point(shape=22, size=3, fill="white")
# stacked area graph
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) +
  geom_area(colour="black", size=.2, alpha=.4) +
  scale_fill_brewer(palette="Blues", breaks=rev(levels(uspopage$AgeGroup)))

uspopage_prop <- ddply(uspopage, "Year", transform,
                       Percent = Thousands / sum(Thousands) * 100)
ggplot(uspopage_prop, aes(x=Year, y=Percent, fill=AgeGroup)) +
  geom_area(colour="black", size=.2, alpha=.4) +
  scale_fill_brewer(palette="Blues", breaks=rev(levels(uspopage$AgeGroup)))

# SCATTER PLOT
# basic scatter plot
heightweight[, c("ageYear", "heightIn")]
ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
heightweight[, c("sex", "ageYear", "heightIn")]
ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + geom_point()
# Bubble plot (mapping a continuous variable to size & color)
ggplot(heightweight, aes(x=ageYear, y=heightIn, size=weightLb, colour=sex)) +
  geom_point(alpha=.5) +
  scale_colour_brewer(palette="Set1")
# Volcano plot (volcano shaped scatter plot)

# Plot for distribution: HISTOGRAM, DENSITY plot, BOXPLOT and VIOLIN plot
ggplot(iris, aes(x=Sepal.Length)) + geom_histogram(bins=30, fill="white", colour="black") +
  facet_grid(Species ~ .)

ggplot(iris, aes(x=Sepal.Length,fill=Species)) + geom_density(alpha=.5) 
ggplot(iris, aes(x=Sepal.Length,color=Species)) + geom_line(stat="density")

ggplot(iris, aes(x=Species, y=Sepal.Length)) + geom_boxplot(notch = T) +
  stat_summary(fun ="mean", geom="point", shape=23, size=3, fill="white")

ggplot(iris, aes(x=Species, y=Sepal.Length,color=Species)) + geom_violin() +
  geom_boxplot(notch = T,width=.2)

# * 4. make your figures more elegant

# AXIS

iriscp <- iris
iriscp$Species=factor(iriscp$Species,levels=c("virginica","versicolor","setosa"))

ggplot(iris, aes(x=Species, y=Sepal.Length)) +
  geom_boxplot(notch = T) +
# swapping X- and Y- axes
#  coord_flip() +
# setting the range of a continuous axis
#  ylim(c(4,8)) +
# or
#  scale_y_continuous(limits = c(4,8)) +
# or
#  coord_cartesian(ylim = c(4,8)) +
# changing the order of items on a categorical axis,
# or by changing the factor orders of the original data (see iriscp)
  scale_x_discrete(limits=c("virginica","versicolor","setosa")) +
# setting the position (breaks=) & names (labels=) of ticks
  scale_y_continuous(breaks = seq(4,8,by=0.5)) +
# theme: appearance of grid, tick, tick labels, axis labels, frame
# The hjust and vjust settings specify the horizontal alignment (left/center/right) and vertical alignment (top/middle/bottom).
  theme(panel.grid.major = element_blank(),
        axis.ticks.x = element_line(size=1),
        axis.text.x = element_text(angle=30, hjust=1, vjust=1),
        axis.title.x=element_text(face="italic", colour="darkred", size=14),
        axis.line = element_line(color="black"),
        plot.title = element_text(colour="red", size=8, face="bold")) +
  ylab("Sepal Length") +
  ggtitle("sepal length distribution of three iris sub-population")

# define a personalized theme
# try different themes
# bw, classic, dark, grey(gray), light, linedraw, minimal
ggplot(data=iris,aes(x=Species,y=Sepal.Length, color = Species)) +
  geom_boxplot(notch = T,size=1) +
  theme_mine

# build your own one
theme_mine = theme_bw() + 
  theme(panel.grid.major = element_line(colour="NA"),
        panel.grid.minor = element_line(colour="NA"),
        panel.background = element_rect(fill="NA"),
        panel.border = element_rect(colour="black", fill=NA))


# LEGEND

ggplot(iris, aes(x=Species, y=Sepal.Length,color=Species)) +
  geom_boxplot(notch = T) +
# legend
  # do not show legend
#  guides(color="none") + 
  # change the position
  theme(legend.position="top") +
  # change the order
  scale_color_discrete(limits=c("virginica","versicolor","setosa")) +
  # change the appearance of legend labels
  theme(legend.text=element_text(face="italic", family="Times", colour="red",
                                 size=14))
  
# COLOR 

# fill vs color: fill= color=

# discrete
ggplot(iris, aes(x=Species, y=Sepal.Length,fill=Species)) +
  geom_boxplot(notch = T) +
  # 1. color blind friendly
 #  scale_fill_viridis_d(option="C") + 
 # scale_fill/color_xx
 # "magma" (or "A")
 # "inferno" (or "B")
 # "plasma" (or "C")
 # "viridis" (or "D")
 # "cividis" (or "E")
 # "rocket" (or "F")
 # "mako" (or "G")
 # "turbo" (or "H")
  # 2. brewer
  # scale_fill_brewer(palette = "Oranges") +
  # 3. manual
  scale_fill_manual(values = c("red", "blue","green"))

library(RColorBrewer)
display.brewer.all()

# continuous
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width,color=Sepal.Width)) +
  geom_point() +
  # gradient between 2 colors
  # scale_color_gradient(low="red",high="blue") +
  # gradient of n colors
  # scale_colour_gradientn(colours = c("darkred", "orange", "yellow", "white")) +
  # with midpoint
  scale_color_gradient2(
    low = "red",
    mid = "white",
    high = "blue",
    midpoint = 3
  )

# ANNOTATION
# add text
p <- ggplot(faithful, aes(x = eruptions, y = waiting)) +
  geom_point()
p +
  annotate("text", x = 3, y = 48, label = "Group 1") +
  annotate("text", x = 4.5, y = 66, label = "Group 2")

ggplot(mpg, aes(x = displ, y = hwy, color=as.factor(cyl))) +
  geom_point() + geom_text(aes(label=hwy))

# add lines
# geom_vline()
# geom_hline()
# geom_abline()
# annotate("segment", x = 1950, xend = 1980, y = -.25, yend = -.25)

# add area
# annotate("rect", xmin = 1950, xmax = 1980, ymin = -1, ymax = 1,alpha = .1,fill = "blue")



# FACET
# together in one plot
ggplot(mpg, aes(x = displ, y = hwy, color=as.factor(cyl))) +
  geom_point()
# using facet
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  # by row
  facet_grid(.~cyl) +
  # or by column
  facet_grid(cyl~.) +
  # by n-row and n-column
  facet_wrap( ~ cyl, nrow = 2, scales = "free")
  # or create grid based on two variable
  facet_grid(drv ~ cyl)


# * 5. repeat sci figures in bio literature (as a exercise)

# volcano plot
# usually  used to show deferentially expressed genes
# see code in a separate file
