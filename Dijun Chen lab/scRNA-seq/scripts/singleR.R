library(SingleR)
library(celldex)

#in-built annotation
ref <- HumanPrimaryCellAtlasData()

annotation <- SingleR(test = pbmc@assays$RNA@data,
                      ref = ref,
                      labels = ref$label.main,
                      clusters = pbmc@meta.data$RNA_snn_res.0.5)

#verify
pdf('Figure/Fig21.singleR.pdf')
plotScoreHeatmap(annotation)
dev.off()


#you can use more ref
ref_2 <- DatabaseImmuneCellExpressionData()
annotation_new <- SingleR(test = pbmc@assays$RNA@data,
                          ref = list(ref, ref_2),
                          labels = list(ref$label.main, ref_2$label.main),
                          clusters = pbmc@meta.data$RNA_snn_res.0.5)
pdf('Figure/Fig22.singleR_new.pdf', height = 18)
plotScoreHeatmap(annotation_new)
dev.off()
