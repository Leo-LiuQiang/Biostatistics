# install.packages('remotes')
remotes::install_github(repo = 'genecell/COSGR')

library(DT)

# check cell types
celltype <- table(pbmc@meta.data$celltype)
datatable(as.data.frame(celltype))

# FindAllMarkers() function
starttime <- Sys.time()
Seurat_markers <- FindAllMarkers(pbmc, only.pos = TRUE)
endtime <- Sys.time()
timecost <- endtime - starttime
print(timecost)

#COSG
library(COSG)
library(dplyr)
starttime <- Sys.time()
COSG_markers <- cosg(
  pbmc,
  groups='all',
  assay='RNA',
  slot='data',
  mu=1)
endtime <- Sys.time()
timecost <- endtime - starttime
print(timecost)

#compare
library(patchwork)
library(ggplot2)
p1 <- DotPlot(pbmc, 
              assay = 'RNA',
              features = subset(Seurat_markers, cluster == 'B')$gene[1:10]) + 
  theme(axis.text.x = element_text(hjust = 1, angle = 45)) + 
  ggtitle(label = 'B cell Markers with Seurat') +
  NoLegend()
p2 <- DotPlot(pbmc, 
              assay = 'RNA',
              features = COSG_markers$names$B[1:10]) +
  ggtitle(label = 'B cell Markers with COSG') + 
  theme(axis.text.x = element_text(hjust = 1, angle = 45))
p1 + p2
ggsave('Figure/Fig23.COSG.pdf', height = 5, width = 12)
