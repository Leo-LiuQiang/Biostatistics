##### packages install
#Seurat
if(!require('Seurat')) install.packages('Seurat')
#SeuratData
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::install_github('satijalab/seurat-data')
#harmony
if(!require('harmony')) install.packages('harmony')
#clustree
if(!require('clustree')) install.packages("clustree")
#ROGUE
devtools::install_github("PaulingLiu/ROGUE")
#monocle2
if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("monocle")
#COSG
if(!require('remotes')) install.packages('remotes')
remotes::install_github(repo = 'genecell/COSGR')
#singleR
devtools::install_github('dviraran/SingleR')
#celltalker
devtools::install_github("arc85/celltalker")
#complexheatmap
if(!require('ComplexHeatmap')) devtools::install_github("jokergoo/ComplexHeatmap")
#cellchat
devtools::install_github("sqjin/CellChat")
#future
if(!require('future')) install.packages('future')
#ggunchull
devtools::install_github("sajuukLyu/ggunchull", type = "source")
#RColorBrewer
if(!require('RColorBrewer')) install.packages('RColorBrewer')