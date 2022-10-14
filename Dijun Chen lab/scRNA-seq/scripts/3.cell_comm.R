## celltalker
library(celltalker)

#View the ligand and receptor pair
ramilowski_pairs %>% head()

#step1: Run celltalker
pbmc_interaction <- celltalk(
  input_object = pbmc,
  metadata_grouping = 'celltype',
  ligand_receptor_pairs = ramilowski_pairs
)

pbmc_interaction %>% head()

#step2: find the interaction with high confidence
top_interaction <- pbmc_interaction %>% 
  filter(p_val < 0.05) %>%
  group_by(cell_type1) %>%
  top_n(3, interact_ratio) %>%
  ungroup()

#step3: Generate a circos plot
library(ggsci)
library(scales)
colors_use <- pal_npg()(9)

pdf('Figure/Fig24.celltalker.pdf')
circos_plot(ligand_receptor_frame = top_interaction,
            cell_group_colors = colors_use,
            ligand_color = "blue",
            receptor_color = "red",
            cex_outer = 0.5,
            cex_inner = 0.4)
dev.off()

## cellchat
library(CellChat)
library(future)

#step1: prepare the dataset
data <- pbmc@assays$RNA@data #scaled data
meta <- pbmc@meta.data #cell information

#step2: create cellchat dataset
cellchat <- createCellChat(object = data, meta = meta, group.by = 'celltype')

#step3: infer cell interaction
#CellChatDB is a manually curated database of literature-supported 
#ligand-receptor interactions in both human and mouse
CellChatDB <- CellChatDB.human
CellChatDB$interaction %>% head()
#set the used database in the object
cellchat@DB <- CellChatDB
#save computation cost
cellchat <- subsetData(cellchat)

plan(strategy = 'multiprocess', workers = 4)
plan()

cellchat <- identifyOverExpressedGenes(cellchat)
cellchat <- identifyOverExpressedInteractions(cellchat)

cellchat <- computeCommunProb(cellchat)
# Filter out the cell-cell communication if there are only few number of cells in certain cell groups
cellchat <- filterCommunication(cellchat, min.cells = 10)

cellchat <- computeCommunProbPathway(cellchat)
cellchat <- aggregateNet(cellchat)


groupSize <- as.numeric(table(cellchat@idents))
pdf(file = 'Figure/Fig25.netVisual_circle.pdf')
par(mfrow = c(1, 2), xpd = TRUE)
netVisual_circle(cellchat@net$count, 
                 vertex.weight = groupSize, 
                 weight.scale = T, 
                 label.edge = F, 
                 title.name = "Number of interactions")
netVisual_circle(cellchat@net$weight, 
                 vertex.weight = groupSize, 
                 weight.scale = T, 
                 label.edge = F, 
                 title.name = "Interaction weights/strength")
dev.off()

pdf(file = 'Figure/Fig26.netVisual_circle_per_celltype.pdf')
par(mfrow = c(3, 3), xpd = TRUE)
for (i in 1:nrow(cellchat@net$weight)){
  mat <- matrix(0, ncol = ncol(cellchat@net$weight), nrow = nrow(cellchat@net$weight))
  mat[i, ] <- cellchat@net$weight[i, ]
  rownames(mat) <- rownames(cellchat@net$weight)
  colnames(mat) <- colnames(cellchat@net$weight)
  netVisual_circle(mat, 
                   vertex.weight = groupSize, 
                   weight.scale = T, 
                   label.edge = F, 
                   title.name = "Interaction weights/strength")
}
dev.off()


netVisual_circle(cellchat@net$weight, 
                 vertex.weight = groupSize, 
                 sources.use = c('NK', 'B'),
                 targets.use = c('DC', 'CD8 T'),
                 weight.scale = T, 
                 label.edge = F, 
                 title.name = "Interaction weights/strength")

cellchat@netP$pathways
netVisual_aggregate(cellchat, signaling = 'MHC-I')