#-------------------------------------------------------------------------------
# Cancer Genomics
#-------------------------------------------------------------------------------
#
# In this lesson, we will cover the following topics
#
# 1. mutational landscape
# 2. mutational signature
# 3. survival analysis


# * 1. mutational landscape

# install ComplexHeatmap
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ComplexHeatmap")
library(ComplexHeatmap)
mat = read.table(file="./tcga_lung_adenocarcinoma_provisional_ras_raf_mek_jnk_signalling.txt", 
                 header = TRUE, stringsAsFactors = FALSE, sep = "\t",row.names = 1)
mat[is.na(mat)] = ""
mat=  mat[, -ncol(mat)]
mat = t(as.matrix(mat))
mat[1:3, 1:3]

# code mutations in different colors
col = c("HOMDEL" = "blue", "AMP" = "red", "MUT" = "#008000")
alter_fun = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = "#CCCCCC", col = NA))
  },
  # big blue
  HOMDEL = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = col["HOMDEL"], col = NA))
  },
  # big red
  AMP = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = col["AMP"], col = NA))
  },
  # small green
  MUT = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h*0.33, 
              gp = gpar(fill = col["MUT"], col = NA))
  }
)

# column title and heatmap legend
column_title = "OncoPrint for TCGA Lung Adenocarcinoma genes in Ras Raf MEK JNK signalling"
heatmap_legend_param = list(title = "Alternations", at = c("HOMDEL", "AMP", "MUT"), 
                            labels = c("Deep deletion", "Amplification", "Mutation"))
oncoPrint(mat,alter_fun = alter_fun, col = col, 
          column_title = column_title, heatmap_legend_param = heatmap_legend_param)

# * 2. mutational signature
# ref: https://github.com/raerose01/deconstructSigs
install.packages('deconstructSigs')
# dependencies 'BSgenome', 'BSgenome.Hsapiens.UCSC.hg19' 
BiocManager::install('BSgenome')
aBiocManager::install('BSgenome.Hsapiens.UCSC.hg19')
library(deconstructSigs)
head(sample.mut.ref)
# Convert to deconstructSigs input
sigs.input <- mut.to.sigs.input(mut.ref = sample.mut.ref, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt")
# Determine the signatures contributing an already normalized sample
test = whichSignatures(tumor.ref = randomly.generated.tumors, 
                       signatures.ref = signatures.nature2013, 
                       sample.id = 2)
# Determine the signatures contributing to the two example samples
sample_1 = whichSignatures(tumor.ref = sigs.input, 
                           signatures.ref = signatures.nature2013, 
                           sample.id = 1, 
                           contexts.needed = TRUE,
                           tri.counts.method = 'default')

sample_2 = whichSignatures(tumor.ref = sigs.input, 
                           signatures.ref = signatures.nature2013, 
                           sample.id = 2, 
                           contexts.needed = TRUE,
                           tri.counts.method = 'default')
# Plot example
plot_example <- whichSignatures(tumor.ref = randomly.generated.tumors, 
                                signatures.ref = signatures.nature2013, 
                                sample.id = 13)

# Plot output
plotSignatures(plot_example, sub = 'example')
makePie(plot_example, sub = 'example')

# * 3. survival analysis (by Jing Ye)
rm(list = ls())
library(tidyverse)
library(survival)
library(survminer)
clinical <- read_tsv(file = "breast_msk_2018_clinical_data.tsv",
                     col_names = T)

###整理数据###
clini <- clinical[,c("Patient ID",
                     "Overall Survival (Months)",
                     "Overall Survival Status",
                     "ER Status of Sequenced Sample",
                     "HER2 IHC Status of Sequenced Sample",
                     "PR Status of Sequenced Sample")]
##修改列名，方便后续操作
colnames(clini) <- c("Patient_ID","time","event","ER","HER2","PR")

##关注数据是否有缺失值NA,sum(is.na(clini))查看数据整体缺失情况,视情况进行处理
##数据存在unknown和Equivocal，过滤掉，只保留已知状况（Negative or Positive)
clini_filter <- clini[clini$ER == "Negative" | clini$ER == "Positive",]
clini_filter <- clini_filter[clini_filter$HER2 == "Negative" | clini_filter$HER2 == "Positive",]
clini_filter <- clini_filter[clini_filter$PR == "Negative" | clini_filter$PR == "Positive",]
clini_filter$event <- substr(clini_filter$event,1,1)

##给数据分组
clini_filter$group <- ifelse(clini_filter$ER == "Negative" &
                               clini_filter$HER2 == "Negative" &
                               clini_filter$PR =="Negative","All_Neg","Other")

##注意time和event列的数据类型
clini_filter$event <- as.numeric(clini_filter$event)

#surv构建对象,survfit 拟合生存曲线,属于KM方法；~group表示以group进行分组绘图
fit <- survfit(Surv(time,event)~group,data = clini_filter)
ggsurvplot(fit, #生存对象
           data = clini_filter, # 拟合生存曲线的数据集
           legend.title= "ER_HER2_PR", #图例标题
           title= "Overall Survival", # 图表标题
           legend=c(0.85,0.85),#指定图例位置。可选“top”，“bottom”，“left”，“right”，“none”等。默认“top”。也可用c（x，y）指定，x和y在0到1之间。
           pval = T, #是否显示P值
           pval.method = TRUE, #是否显示p值计算方法
           conf.int = T, # 置信区间
           conf.int.style='step',
           xlab="Time_Months", # x轴标签
           surv.median.line = 'hv',# 中位生存时间
           risk.table = T, #风险表
           palette = "lancet") #调色板
