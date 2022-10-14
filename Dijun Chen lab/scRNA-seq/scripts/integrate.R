rm(list = ls())
invisible(gc())

library(Seurat)
library(dplyr)
library(future)

options(future.globals.maxSize = 3000 * 1024^2)

dirs <- list.files('dataset/data')
dirs

PATH = 'dataset/data'

plan('multiprocess', workers = 5)


sce_list <- lapply(dirs, FUN = function(dir){
  dir
  print(Sys.time())
  sce <- CreateSeuratObject(counts = Read10X(file.path(PATH, dir)),
                            project = dir)
  return(sce)
})

#filter cells
sce_list <- lapply(sce_list, FUN = function(sce){
  sce <- subset(sce, subset = nFeature_RNA >=200 & nFeature_RNA <=5000)
  return(sce)
})

#integrate
sce_list <- lapply(sce_list, FUN = function(sce) {
  x <- NormalizeData(sce)
  x <- FindVariableFeatures(sce, 
                            selection.method = "vst", 
                            nfeatures = 2000)
})
# select features that are repeatedly variable across datasets for integration
features <- SelectIntegrationFeatures(object.list = sce_list)
anchor <- FindIntegrationAnchors(object.list = sce_list, 
                                 anchor.features = features)
# create an 'integrated' data assay
sce <- IntegrateData(anchorset = anchor)
#add source


##downstream
DefaultAssay(sce) <- 'integrated'

sce <- ScaleData(sce)
sce <- RunPCA(sce, npcs = 30, verbose = FALSE)
sce <- RunTSNE(sce, reduction = "pca", dims = 1:20)
sce <- FindNeighbors(sce, reduction = "pca", dims = 1:30)
sce <- FindClusters(sce, resolution = 1.2)

