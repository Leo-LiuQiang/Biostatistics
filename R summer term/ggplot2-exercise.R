# volcano plot
# usually  used to show deferentially expressed genes
library(ggrepel)
data <- read.table(file="volcano.txt")
names(data) = c("gene","log2FoldChange","padj")
top10 = data[order(data$padj),]
top10 = subset(top10,abs(log2FoldChange) > log2(1.5))
top10 = top10[1:10,]
top10 = cbind(top10,ifelse(top10$log2FoldChange>0,"up","down"))
names(top10)=c(names(data),"color")
ggplot(data,aes(x=log2FoldChange,y=-log10(padj))) +
  geom_point(size = .3, col = "grey", alpha = 0.7) +
  geom_point(data=data[data$log2FoldChange>log2(1.5) & data$padj<=0.05,],
             aes(x=log2FoldChange,y=-log10(padj)),col="red", size = 1, alpha = .6) +
  geom_point(data=data[data$log2FoldChange<log2(2/3) & data$padj<=0.05,],
             aes(x=log2FoldChange,y=-log10(padj)),col="blue", size = 1, alpha = .6) +
  geom_vline(xintercept=c(log2(2/3), log2(1.5)), col="purple",lty = 2) +
  geom_hline(yintercept=-log10(0.05), col="purple", lty = 2) +
  ylim(0,25) +
  xlim(-4,4) + 
  #  geom_text(data=top10,aes(x=log2FoldChange,y=-log10(padj),label=gene))
  geom_text_repel(data=top10,aes(x=log2FoldChange,y=-log10(padj),label=gene,color=color)) +
  scale_color_manual(values=c("blue","red")) +
  guides(color="none") +
  theme_mine