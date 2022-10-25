# 1.1
df=12
pt(-2,df=df)
pt(3,df=df,lower.tail =FALSE)
pt(2.6,df=df)-pt(-2.6,df=df)
# 1.1 verification
f1<-function(x){return(pt(x,df=12)-0.065)}
root1<-uniroot(f1,c(-10,0),tol=0.000001)
print(root1)
f2<-function(x){return(pt(x,df=12)-0.09)}
root2<-uniroot(f2,c(-10,0),tol=0.000001)
print(root2)
# 1.1
## Y<=-2
p1<-pt(-2,df=12)
cat('p1=',p1)
## Y>=3
p2<-pt(3,df=12,lower.tail = FALSE)
cat('p2=',p2)
## -2.6<=Y<=2.6
p3<-pt(2.6,df=12)-pt(-2.6,df=12)
cat('p3=',p3)
# 1.2
qt(0.065,df=12)
# 1.3
qt(0.91,df=12,lower.tail = FALSE)

# 2
x<-seq(-5,5,length.out=1000)
y<-dt(x,df=2)  ##df表示自由度,dt是函数名字
y2<-dt(x,df=30);y3=dnorm(x);y4<-dt(x,df=8)
plot(x,y,type='l',bty='l',ylim=c(0,max(y,y2)),col='black')
lines(x,y2,col='red')
lines(x,y3,col='blue')
lines(x,y4,col='orange')
legend(x='topleft',legend=c(expression(df==2),expression(df==8),expression(df==30),expression(norm)),
       lty=1,col=c('black','orange','red','blue'))
n1=rt(1000,df=2);n2=rt(1000,df=30) ##生成t分布数组
mean(n1);sd(n1)
print(mean(((n1-mean(n1))/sd(n1))^3))  ##偏斜度
print(mean(((n1-mean(n1))/sd(n1))^4)-3)  ##峭度
mean(y2);sd(y2)
print(mean(((n2-mean(n2))/sd(n2))^3))##偏斜度
print(mean(((2-mean(n2))/sd(n2))^4)-3)##峭度

# 2-1 with packages
x<-seq(-5,5,length.out=1000)
y<-dt(x,df=2)  ##df表示自由度,dt是函数名字
y2<-dt(x,30);y3=dnorm(x);y4<-dt(x,df=8)
o<-data.frame(X=x,Y=y,Y30=y2,Y8=y4,YN=y3)
library(ggplot2)
ggplot(o)+geom_line(aes(x=X,y=Y),col='blue')+geom_line(aes(x=X,y=Y30),col='red')+
  geom_line(aes(x=X,y=Y8),col='yellow')+geom_line(aes(x=X,y=YN),col='black')+
  labs(title='不同自由度t分布与正态分布对比',subtitle = 'blue:df=2,red:df=30,yellow:df=8,black:正态')
library(fBasics)
n1=rt(1000,df=2);n2=rt(1000,df=30)  ##生成t分布数组
m=mean(n1);s=sd(n1);g1=skewness(n1);g2=kurtosis(n1)
cat('平均数：',m);cat('标准差：',s);cat('偏斜度：',g1);cat('峭度：',g2)
m30=mean(n2);s30=sd(n2);g11=skewness(n2);g22=kurtosis(n2)
cat('平均数：',m30);cat('标准差：',s30);cat('偏斜度：',g11);cat('峭度：',g22)

# 2-2
curve(dnorm(x,0,1),from = -5,to = 5,xlim = c(-5,5),
      xlab = 'x',ylab = '概率密度',lty = 1,col = 'black',lwd = 3,
      main = '不同自由度t分布与标准正态分布对比')##标准正态分布
abline(v=0,lty=2,col='black')
curve(dt(x,2),from = -5,to = 5,xlim = c(-5,5),lty = 1,col = 'red',
      lwd=3,add = T)##df=2的t分布
curve(dt(x,8),from = -5,to = 5,xlim = c(-5,5),lty = 1,col = 'blue',
      lwd=3,add = T)##df=8的t分布
curve(dt(x,30),from = -5,to = 5,xlim = c(-5,5),lty = 1,col = 'green',
      lwd=3,add = T)##df=30的t分布
legend('topright',legend = c('N(0,1)','df=2','df=8','df=30'),
       col = c('black','red','blue','green'),lwd = c(3,3,3,3)
)