#-------------------------------------------------------------------------------
# Clustering Analysis
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. data pre-processing
# 2. k-means clustering
# 3. hierarchical clustering
# 4. others


# * 1 data pre-processing
## load % scale iris data
plot(iris)
irisScaled <- scale(iris[,-5])
# check data
head(iris)
head(irisScaled)
hist(iris[,1],breaks = 20)
hist(irisScaled[,1],breaks = 20)
# scaled vs non-scaled
irisdup <- as.matrix(iris[,1:4])
rownames(irisdup) = 1:nrow(irisdup)
irisdup[,1] = iris$Sepal.Length * 10
anno_row=data.frame(species=iris$Species)
library(pheatmap)
pheatmap(irisdup,annotation_row = anno_row,show_rownames = F, clustering_method = "ward.D2", scale = "column")
pheatmap(irisdup,annotation_row = anno_row,show_rownames = F, clustering_method = "ward.D2")

# * 2. k-means clustering
fitK <- kmeans(irisScaled,3)
str(fitK)
plot(iris,col=fitK$cluster)

# how to choose K
# by between SS / Total SS
k <- list()
for(i in 1:10){
  k[[i]] <- kmeans(irisScaled,i)
}
k

betweenss_totss <- list()
for(i in 1:10){
  betweenss_totss[[i]] <- k[[i]]$betweenss/k[[i]]$totss
}

plot(1:10,betweenss_totss,type="b",
     ylab="between SS / Total SS", xlab="Clusters (k)")

# by mutiple criteria in NbClust
library(NbClust)
nc <- NbClust(irisScaled,min.nc = 2,max.nc = 15, method = "kmean")
barplot(table(nc$Best.nc[1,]),
        xlab="Number of Clusters",ylab="Number of Criteria",
        main="Number of Clusters chosen")

# * 3. hierarchical clustering
d <- dist(irisScaled,method = "euclidean")
# method: This must be one of "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski".
fitH <- hclust(d,"ward.D2")
plot(fitH)
rect.hclust(fitH,k=3, border = "red")
clusters <- cutree(fitH,3)
plot(iris,col=clusters)

# * 4. model-based clustering
library(mclust)
fitM <- Mclust(irisScaled)
fitM
plot(fitM)

# * 5. density-based clustering
library(dbscan)
kNNdistplot(irisScaled,k=3)
fitD <- dbscan(irisScaled,eps = 0.7,minPts = 5)
plot(iris,col=fitD$cluster)

data=irisScaled[,1:4]
rownames(data)=1:nrow(data)
anno_row = data.frame(species=iris[,5])
rownames(anno_row)=1:nrow(anno_row)
pheatmap(data,annotation_row = anno_row,clustering_method = "average")
