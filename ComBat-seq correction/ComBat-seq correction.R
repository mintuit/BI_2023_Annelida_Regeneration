library("sva") #Note this exercise requires sva (>= v3.36.0) which is only available for R (>= v4.x)
library("ggplot2")
library("gridExtra")
library("edgeR")
library("UpSetR")

uncorrected_data = read.table("Pele_filtered_quants.csv", header=TRUE, sep=",", as.is=c(1,2))

uncorrected_data <- uncorrected_data[,c(1,2,3,18,19,6,7,10,11,14,15,22,23,4,5,20,21,8,9,12,13,16,17,24,25)]
sample_names = names(uncorrected_data[,c(2:length(uncorrected_data))])

head(uncorrected_data)

names(uncorrected_data) = c('ContigIDs','Pele_head1_0h','Pele_head2_0h','Pele_head1_4h','Pele_head2_4h','Pele_head1_12h','Pele_head2_12h','Pele_head1_24h','Pele_head2_24h','Pele_head1_48h','Pele_head2_48h','Pele_head1_96h','Pele_head2_96h','Pele_tail1_0h','Pele_tail2_0h','Pele_tail1_4h','Pele_tail2_4h','Pele_tail1_12h','Pele_tail2_12h','Pele_tail1_24h','Pele_tail2_24h','Pele_tail1_48h','Pele_tail2_48h','Pele_tail1_96h','Pele_tail2_96h')
sample_names = names(uncorrected_data)[2:length(names(uncorrected_data))]

#review data structure
head(uncorrected_data)
dim(uncorrected_data)

#define conditions, library methods, and replicates
conditions1 = c("head","head","head","head","head","head","head","head","head","head","head","head","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail")
conditions2 = c("0","0","4","4","12","12","24","24","48","48","96","96","0","0","4","4","12","12","24","24","48","48","96","96")
conditions3 = c("head_0","head_0","head_4","head_4","head_12","head_12","head_24","head_24","head_48","head_48","head_96","head_96","tail_0","tail_0","tail_4","tail_4","tail_12","tail_12","tail_24","tail_24","tail_48","tail_48","tail_96","tail_96")

library_methods = c("10", "14", "14", "10", "14", "10", "14", "14", "14", "14", "14", "14", "10", "14", "14", "10", "14", "10", "14", "14", "14", "14", "14", "14")
replicates = c('1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2')

#24
#calculate principal components for the uncorrected data
pca_uncorrected_obj = prcomp(uncorrected_data[,sample_names])

#pull PCA values out of the PCA object
pca_uncorrected = as.data.frame(pca_uncorrected_obj[2]$rotation)

#assign labels to the data frame
pca_uncorrected[,"condition1"] = conditions1
pca_uncorrected[,"condition2"] = conditions2
pca_uncorrected[,"condition3"] = conditions3
pca_uncorrected[,"library_method"] = library_methods
pca_uncorrected[,"replicate"] = replicates

#plot the PCA
#create a classic 2-dimension PCA plot (first two principal components) with conditions and library methods indicated
cols <- c("10" = "#481567FF", "14" = "#1F968BFF")
p1 = ggplot(data=pca_uncorrected, aes(x=PC1, y=PC2, color=library_methods, shape=conditions2))
p1 = p1 + geom_point(size=3)
p1 = p1 + stat_ellipse(type="norm", linetype=2)
p1 = p1 + labs(title="PCA, RNA-seq counts for time series of Pele (uncorrected data)", color="Library methods", shape="Condition")
p1 = p1 + scale_colour_manual(values = cols)

cols <- c("head"= "#481567FF", "tail" = "#1F968BFF")
p15 = ggplot(data=pca_uncorrected, aes(x=PC1, y=PC2, color=conditions1, shape=conditions2))
p15 = p15 + geom_point(size=3)
p15 = p15 + stat_ellipse(type="norm", linetype=2)
p15 = p15 + labs(title="PCA, RNA-seq counts for time series of Pele (uncorrected data)", color="Head/Tail", shape="Condition")
p15 = p15 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA_pele.pdf")
grid.arrange(p1, p15, nrow = 2)
dev.off()

groups = sapply(as.character(conditions1), switch, "head" = 1, "tail" = 2, USE.NAMES = F)
batches = sapply(as.character(library_methods), switch, "10" = 1, "14" = 2, USE.NAMES = F)
repl = sapply(as.character(replicates), switch, "1" = 1, "2" = 2, USE.NAMES = F)
gr = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12)
covariate_matrix = cbind(gr, groups)

head(uncorrected_data[,sample_names])

corrected_data = ComBat_seq(counts = as.matrix(uncorrected_data[,sample_names]), batch = batches, group = gr)
head(corrected_data)


corrected_data = as.data.frame(corrected_data, row.names = sample_names)
head(corrected_data)


#join the gene and chromosome names onto the now corrected counts from ComBat_seq
corrected_data = cbind(uncorrected_data[,c("ContigIDs")], corrected_data)

#compare dimensions of corrected and uncorrected data sets
dim(uncorrected_data)
dim(corrected_data)

#visually compare values of corrected and uncorrected data sets
head(uncorrected_data)
head(corrected_data)
pca_corrected_obj = prcomp(corrected_data[,sample_names])

#pull PCA values out of the PCA object
pca_corrected = as.data.frame(pca_corrected_obj[2]$rotation)

#assign labels to the data frame
pca_corrected[,"condition1"] = conditions1
pca_corrected[,"condition2"] = conditions2
pca_corrected[,"condition3"] = conditions3
pca_corrected[,"library_method"] = library_methods
pca_corrected[,"replicate"] = replicates

#as above, create a PCA plot for comparison to the uncorrected data
cols <- c("head" = "#481567FF", "tail" = "#1F968BFF")
p2 = ggplot(data=pca_corrected, aes(x=PC1, y=PC2, color=condition1, shape=condition2))
p2 = p2 + geom_point(size=3)
p2 = p2 + stat_ellipse(type="norm", linetype=2)
p2 = p2 + labs(title="PCA, RNA-seq counts for time series of Pele (corrected data)", color="Condition", shape="Library methods")
p2 = p2 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA_gr_ht.pdf")
grid.arrange(p15, p2, nrow = 2)
dev.off()

cols <- c("10" = "#481567FF", "14" = "#1F968BFF")
p25 = ggplot(data=pca_corrected, aes(x=PC1, y=PC2, color=library_methods, shape=condition2))
p25 = p25 + geom_point(size=3)
p25 = p25 + stat_ellipse(type="norm", linetype=2)
p25 = p25 + labs(title="PCA, RNA-seq counts for time series of Pele (corrected data)", color="library_method", shape="conditions")
p25 = p25 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA_gr_lm.pdf")
grid.arrange(p1, p25, nrow = 2)
dev.off()

head(corrected_data)


corrected_data2 = ComBat_seq(counts = as.matrix(uncorrected_data[,sample_names]), batch = batches, covar_mod = covariate_matrix)


corrected_data2 = as.data.frame(corrected_data2, row.names = sample_names)
#join the gene and chromosome names onto the now corrected counts from ComBat_seq
corrected_data2 = cbind(uncorrected_data[,c("ContigIDs")], corrected_data2)

#compare dimensions of corrected and uncorrected data sets
dim(uncorrected_data)
dim(corrected_data2)

#visually compare values of corrected and uncorrected data sets
head(uncorrected_data)
head(corrected_data2)

pca_corrected_obj = prcomp(corrected_data2[,sample_names])

#pull PCA values out of the PCA object
pca_corrected = as.data.frame(pca_corrected_obj[2]$rotation)

#assign labels to the data frame
pca_corrected[,"condition1"] = conditions1
pca_corrected[,"condition2"] = conditions2
pca_corrected[,"library_method"] = library_methods
pca_corrected[,"replicate"] = replicates

#as above, create a PCA plot for comparison to the uncorrected data
cols <- c("head" = "#481567FF", "tail" = "#1F968BFF")
p3 = ggplot(data=pca_corrected, aes(x=PC1, y=PC2, color=condition1, shape=library_methods))
p3 = p3 + geom_point(size=3)
p3 = p3 + stat_ellipse(type="norm", linetype=2)
p3 = p3 + labs(title="PCA, RNA-seq counts for time series of Pele (corrected data)", color="Condition", shape="Library methods")
p3 = p3 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA_сovmt.pdf")
grid.arrange(p1, p3, nrow = 2)
dev.off()




