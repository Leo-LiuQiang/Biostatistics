#require packages
library(Seurat)
library(SeuratData)
library(dplyr)
library(patchwork)
library(ggplot2)
library(SingleR)
library(ROGUE)
library(COSG)
library(clustree)

if(!dir.exists('Figure')) dir.create('Figure')

PATH = './matrix'
list.files(path = PATH)

########## Step1: construct Seurat object ##########
# 1. from matrix
pbmc <- CreateSeuratObject(counts = Read10X(data.dir = PATH), 
                           project = 'pbmc3k',
                           assay = 'RNA',
                           names.field = 1,
                           names.delim = "_",
                           min.cells = 3,
                           min.features = 200)
# 2.from database
AvailableData()
InstallData('pbmc3k')
data('pbmc3k')
dim(pbmc3k)
#remove(pbmc3k)
#invisible(gc())
dim(pbmc)

### Structure of Seurat object
#assay
pbmc@assays$RNA@counts
pbmc@assays$RNA@data
pbmc@assays$RNA@scale.data
pbmc@assays$RNA@var.features
pbmc@active.assay
#meta-feature
pbmc@meta.data
#dimension reduction
pbmc@reductions
#commands
pbmc@commands
#figure
pbmc@graphs
pbmc@images
#other
pbmc@project.name

########## Step2: Data QC ##########
### nCount_RNA; nFeature_RNA, percent.mt
pbmc[['percent.mt']] <- PercentageFeatureSet(object = pbmc,
                                             pattern = '^MT-') #mouse use ^mt-
#or pbmc@meta.data$percent.mt
#or pbmc <- PercentageFeatureSet(object = pbmc, pattern = '^MT-', col.name = 'percent.mt')
#PercentageFeatureSet or edit(PercentageFeatureSet)
VlnPlot(object = pbmc, features = c('nCount_RNA', 'nFeature_RNA', 'percent.mt'))
ggsave(filename = 'Figure/Fig1.vlnplot.pdf')

FeatureScatter(object = pbmc, feature1 = 'nCount_RNA', feature2 = 'nFeature_RNA')
ggsave(filename = 'Figure/Fig2.featurescatterplot.pdf') #need deeper
### filter low quality cells
pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)
dim(pbmc)

########## Step3: Data Normalize ##########
pbmc <- NormalizeData(object = pbmc,
                      normalization.method = 'LogNormalize',
                      scale.factor = 1e4) # control size and log , don't need to normalize gene length
#the meaning of normalization.method and scale.factor
#the details of NormalizeData() function (optional)
#the result of this function?

########## Step4: Variable features identification ##########
pbmc <- FindVariableFeatures(object = pbmc, nfeatures = 2000)
#the result of this function?
#the top10 variable features
top10<- VariableFeatures(object = pbmc) %>% head(., 10)

(plot1 <- VariableFeaturePlot(object = pbmc))
(plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE))
(plot1 | plot2)
ggsave(filename = 'Figure/Fig3.variablefeatures.pdf', width = 10)

########## Step5: Scaling the data ##########
pbmc <- ScaleData(object = pbmc, vars.to.regress = 'percent.mt')
#add features = rownames(pbmc)?

########## Optional: SCTransform() #########
library(sctransform)
pbmc <- SCTransform(object = pbmc, vars.to.regress = 'percent.mt')
#the new result will be stored in SCT assay.
DefaultAssay(pbmc)
############################################

#here, we still use classical manual, you must run this step
DefaultAssay(object = pbmc) <- 'RNA'
DefaultAssay(object = pbmc)
pbmc@active.assay

########## Step6: PCA analysis ##########
#how to understand PCA (principle component analysis)?
pbmc <- RunPCA(object = pbmc, features = VariableFeatures(pbmc))

VizDimLoadings(object = pbmc, dims = 1:2, reduction = 'pca')
DimPlot(object = pbmc, dims = c(1, 2), reduction = 'pca')
ggsave(filename = 'Figure/Fig4.pcaplot.pdf')
#how to understand different PCs
pdf(file = 'Figure/Fig5.dimheatmap.pdf')
DimHeatmap(object = pbmc, 
           dims = 1:9, 
           nfeatures = 30, 
           reduction = 'pca', 
           ncol = 3)
dev.off()

##determine how many PCs to use
pbmc <- JackStraw(pbmc, num.replicate = 100)
pbmc <- ScoreJackStraw(pbmc, dims = 1:20)
JackStrawPlot(pbmc, dims = 1:20)
ggsave(filename = 'Figure/Fig6.jackstrawplot.pdf')
ElbowPlot(pbmc)
ggsave(filename = 'Figure/Fig7.elbowplot.pdf')

########## Step7: Cluster the cells ##########
pbmc <- FindNeighbors(pbmc, dims = 1:10)
#here we will use different resolution to cluster cells
for (res in seq(0.1, 1, by = 0.1)){
  pbmc <- FindClusters(object = pbmc, resolution = res)
}
clustree(x = pbmc@meta.data, prefix = 'RNA_snn_res.')
ggsave(filename = 'Figure/Fig7.clustree.pdf', height = 9, width = 10)
#here we set resolution = 0.5
pbmc <- SetIdent(object = pbmc, value = 'RNA_snn_res.0.5')

########## Step8: tSNE/UMAP ##########
pbmc <- RunUMAP(object = pbmc,
                reduction = 'pca',
                dims = 1:10)
pbmc <- RunTSNE(object = pbmc,
                reduction = 'pca',
                dims = 1:10)
#here we can re-view the structure of pbmc
DimPlot(object = pbmc, reduction = 'tsne')
ggsave(filename = 'Figure/Fig8.tsne.pdf')
DimPlot(object = pbmc, reduction = 'umap')
ggsave(filename = 'Figure/Fig9.umap.pdf')

########## Step9: Data visualization ##########
### identify marker gene
#one cell cluster
markers_cluster0 <- FindMarkers(object = pbmc,
                                ident.1 = 0,
                                only.pos = TRUE)
DT::datatable(markers_cluster0)
markers_cluster0_and_1 <- FindMarkers(object = pbmc,
                                      ident.1 = 0,
                                      ident.2 = 1,
                                      only.pos = TRUE)
#all cell cluster
markers <- FindAllMarkers(object = pbmc, 
                          only.pos = TRUE, 
                          min.pct = 0.25, 
                          logfc.threshold = 0.25)
### visualization
#heatmap
DoHeatmap(object = pbmc, 
          features = (markers %>% 
            group_by(cluster) %>% 
            top_n(n = 10, wt = avg_log2FC))$gene,
          ) + NoLegend()
ggsave(filename = 'Figure/Fig10.heatmap.pdf')
#ridgeplot
RidgePlot(object = pbmc, features = c('CD14', 'CD8A'), ncol = 1)
ggsave(filename = 'Figure/Fig11.ridgeplot.pdf')
#vlnplot
VlnPlot(object = pbmc, features = c('CD14', 'CD8A'), ncol = 2)
ggsave(filename = 'Figure/Fig12.vlnplot.pdf')
#featureplot
FeaturePlot(object = pbmc, features = c('CD14', 'CD8A'), ncol = 2)
ggsave(filename = 'Figure/Fig13.featureplot.pdf')
#dotplot
DotPlot(object = pbmc, features = c('CD14', 'CD8A'))
ggsave(filename = 'Figure/Fig14.dotplot.pdf')

########## Step10: cell type annotation ##########
#Cluster ID	Markers	Cell Type
#0	IL7R, CCR7	Naive CD4+ T
#1	CD14, LYZ	CD14+ Mono
#2	IL7R, S100A4	Memory CD4+
#3	MS4A1	B
#4	CD8A	CD8+ T
#5	FCGR3A, MS4A7	FCGR3A+ Mono
#6	GNLY, NKG7	NK
#7	FCER1A, CST3	DC
#8	PPBP	Platelet
#where to store cell annotation?
#metadata
#method 1: RenameIdents() function
levels(pbmc)
new.cluster.ids <- c("Naive CD4 T", 
                     "CD14+ Mono", 
                     "Memory CD4 T", 
                     "B", 
                     "CD8 T", 
                     "FCGR3A+ Mono",
                     "NK", 
                     "DC", 
                     "Platelet")
names(new.cluster.ids) <- levels(pbmc)
pbmc <- RenameIdents(pbmc, new.cluster.ids)
levels(pbmc)

DimPlot(object = pbmc, 
        pt.size = 1, 
        reduction = 'tsne', 
        label = T,
        label.box = T
) + NoLegend()
ggsave(filename = 'Figure/Fig15.tsne_anno.pdf')
DimPlot(object = pbmc, 
        pt.size = 1, 
        reduction = 'umap', 
        label = T,
        label.box = T
) + NoLegend()
ggsave(filename = 'Figure/Fig16.umap_anno.pdf')
#method 2: dataframe
pbmc@meta.data <- pbmc@meta.data %>% 
  mutate(celltype = case_when(
    RNA_snn_res.0.5 == 0 ~ "Naive CD4 T",
    RNA_snn_res.0.5 == 1 ~ "CD14+ Mono",
    RNA_snn_res.0.5 == 2 ~ "Memory CD4 T",
    RNA_snn_res.0.5 == 3 ~ "B",
    RNA_snn_res.0.5 == 4 ~ "CD8 T",
    RNA_snn_res.0.5 == 5 ~ "FCGR3A+ Mono",
    RNA_snn_res.0.5 == 6 ~ "NK",
    RNA_snn_res.0.5 == 7 ~ "DC",
    RNA_snn_res.0.5 == 8 ~ "Platelet"
  ))
pbmc <- SetIdent(object = pbmc, value = 'celltype')
levels(pbmc)
pbmc@active.ident
#same result

saveRDS(object = pbmc, file = 'pbmc.rds')
