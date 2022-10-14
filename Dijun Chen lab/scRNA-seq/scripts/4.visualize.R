
## Figure 17/18: marker gene visualization ##
marker_gene <- c('IL7R', 'CCR7',
                 'CD14', 'LYZ',
                 'IL7R', 'S100A4',
                 'MS4A1',
                 'CD8A',
                 'FCGR3A', 'MS4A7',
                 'GNLY', 'NKG7',
                 'FCER1A', 'CST3',
                 'PPBP')
library(RColorBrewer)
colors <- c(brewer.pal(8, "Set1"), brewer.pal(7, "Set2"))
VlnPlot(object = pbmc, features = marker_gene, stack = T) + 
  scale_fill_manual(values = colors) +
  theme(
    axis.title = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text = element_text(size = 10),
    strip.text.x = element_text(angle = 45, size = 10, hjust = .2, vjust = .3)
  ) + 
  NoLegend()
ggsave(filename = 'Figure/Fig17.vlnplotplus.pdf')

VlnPlot(object = pbmc, features = marker_gene, stack = T, flip = T) + 
  scale_fill_manual(values = colors) +
  theme(
    axis.title = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(angle = 45, size = 10, hjust = .2, vjust = .3)
  ) + 
  NoLegend()
ggsave(filename = 'Figure/Fig18.vlnplotplus.rotate.pdf', height = 7)

## Figure 19/20: umap/tsne plot with ggplot2 ##
#get the cell location and celltype, store in a dataframe
plotdata <- Embeddings(object = pbmc, reduction = 'tsne') %>%  
  merge(data.frame(pbmc@meta.data$celltype, row.names = rownames(pbmc@meta.data)), by = 0)
colnames(plotdata) <- c('cell', 'tSNE_1', 'tSNE_2', 'celltype')
head(plotdata)
## ggplot2
library(ggplot2)
library(ggunchull)
plot_scrna <- function(metadata, colors = brewer.pal(9,"Set1")){
  
  axis <- data.frame(x = c(-45, -45),
                     xend = c(-20, -45),
                     y = c(-37, -37),
                     yend = c(-37, -17))
  
  ggplot(data = metadata, aes(x = tSNE_1, 
                              y = tSNE_2)) + 
    geom_point(aes(color = celltype), size = .5) + 
    scale_color_manual(values = colors) + 
    scale_x_continuous(limits = c(-45, 45)) + 
    scale_y_continuous(limits = c(-37, 37)) +
    theme_classic() + 
    theme(
      axis.line = element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank()
    ) + 
    geom_segment(data = axis, size = 1,
                 mapping = aes(x = x, 
                               xend = xend, 
                               y = y, 
                               yend = yend),
                 arrow = arrow(length=unit(0.3, "cm"), 
                               type = 'open')) + 
    theme(
      axis.title.x.bottom = element_text(hjust = 0.1, vjust = -0.5, size = 15),
      axis.title.y.left = element_text(hjust = 0.1, vjust = -0.5, size = 15)
    )
}
(plot3 <- plot_scrna(metadata = plotdata))
ggsave(filename = 'Figure/Fig19.tsneplus.pdf', width = 6.5, height = 5)

##ggunchull function
ggplot(plotdata, aes(x = tSNE_1, 
                     y = tSNE_2, 
                     fill = celltype, 
                     color = celltype)) + 
  geom_point(size = 1) + 
  scale_color_manual(values = brewer.pal(9,"Set1")) + 
  theme_classic() + 
  stat_unchull(alpha = 0.2, size = .5, nbin = 100, nsm = 10) +
  scale_x_continuous(limits = c(-45, 45)) + 
  scale_y_continuous(limits = c(-37, 37))
ggsave(filename = 'Figure/Fig20.tsneplus.circle.pdf', width = 6.5, height = 5)