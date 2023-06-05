#Batch-effect analysis, using one biological variable and matrix of variables

library("sva") #Note this exercise requires sva (>= v3.36.0) which is only available for R (>= v4.x)
library("ggplot2")
library("gridExtra")
library("edgeR")
library("UpSetR")

uncorrected_data = read.table("Pele_filtered_quants.csv", header=TRUE, sep=",", as.is=c(1,2))

uncorrected_data <- uncorrected_data[,c(1,2,3,18,19,6,7,10,11,14,15,22,23,4,5,20,21,8,9,12,13,16,17,24,25)]
sample_names = names(uncorrected_data[,c(2:length(uncorrected_data))])

names(uncorrected_data) = c('ContigIDs','Pele_head1_0h','Pele_head2_0h','Pele_head1_4h','Pele_head2_4h','Pele_head1_12h','Pele_head2_12h','Pele_head1_24h','Pele_head2_24h','Pele_head1_48h','Pele_head2_48h','Pele_head1_96h','Pele_head2_96h','Pele_tail1_0h','Pele_tail2_0h','Pele_tail1_4h','Pele_tail2_4h','Pele_tail1_12h','Pele_tail2_12h','Pele_tail1_24h','Pele_tail2_24h','Pele_tail1_48h','Pele_tail2_48h','Pele_tail1_96h','Pele_tail2_96h')
sample_names = names(uncorrected_data)[2:length(names(uncorrected_data))]

#review data structure
head(uncorrected_data)
dim(uncorrected_data)

#define conditions, library methods, and replicates
location = c("head","head","head","head","head","head","head","head","head","head","head","head","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail","tail")
time = c("0","0","4","4","12","12","24","24","48","48","96","96","0","0","4","4","12","12","24","24","48","48","96","96")

library_methods = c("10", "14", "14", "10", "14", "10", "14", "14", "14", "14", "14", "14", "10", "14", "14", "10", "14", "10", "14", "14", "14", "14", "14", "14")
replicates = c('1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2', '1', '2')

#24
#calculate principal components for the uncorrected data
pca_uncorrected_obj = prcomp(uncorrected_data[,sample_names])

#pull PCA values out of the PCA object
pca_uncorrected = as.data.frame(pca_uncorrected_obj[2]$rotation)

#assign labels to the data frame
pca_uncorrected[,"condition1"] = location
pca_uncorrected[,"condition2"] = time
pca_uncorrected[,"library_method"] = library_methods
pca_uncorrected[,"replicate"] = replicates

#plot the PCA
#create a classic 2-dimension PCA plot (first two principal components) with conditions and library methods indicated
cols <- c("10" = "#481567FF", "14" = "#1F968BFF")
p1 = ggplot(data=pca_uncorrected, aes(x=PC1, y=PC2, color=library_methods, shape=time))
p1 = p1 + geom_point(size=3)
p1 = p1 + stat_ellipse(type="norm", linetype=2)
p1 = p1 + labs(title="PCA, RNA-seq counts for time series of Pele (uncorrected data)", color="Library methods", shape="Condition")
p1 = p1 + scale_colour_manual(values = cols)


groups = sapply(as.character(conditions1), switch, "head" = 1, "tail" = 2, USE.NAMES = F)
batches = sapply(as.character(library_methods), switch, "10" = 1, "14" = 2, USE.NAMES = F)
repl = sapply(as.character(replicates), switch, "1" = 1, "2" = 2, USE.NAMES = F)
gr = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12)
covariate_matrix = cbind(gr, groups)

corrected_data = ComBat_seq(counts = as.matrix(uncorrected_data[,sample_names]), batch = batches, group = gr)
corrected_data = as.data.frame(corrected_data, row.names = sample_names)

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
pca_corrected[,"condition1"] = location
pca_corrected[,"condition2"] = time
pca_corrected[,"library_method"] = library_methods
pca_corrected[,"replicate"] = replicates

cols <- c("10" = "#481567FF", "14" = "#1F968BFF")
p2 = ggplot(data=pca_corrected, aes(x=PC1, y=PC2, color=library_methods, shape=time))
p2 = p2 + geom_point(size=3)
p2 = p2 + stat_ellipse(type="norm", linetype=2)
p2 = p2 + labs(title="PCA, RNA-seq counts for time series of Pele (corrected data)", color="Library method", shape="Condition")
p2 = p2 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA.pdf")
grid.arrange(p1, p2, nrow = 2)
dev.off()


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
pca_corrected[,"condition1"] = location
pca_corrected[,"condition2"] = time
pca_corrected[,"library_method"] = library_methods
pca_corrected[,"replicate"] = replicates

#as above, create a PCA plot for comparison to the uncorrected data
cols <- c("10" = "#481567FF", "14" = "#1F968BFF")
p3 = ggplotggplot(data=pca_corrected, aes(x=PC1, y=PC2, color=library_methods, shape=time))
p3 = p3 + geom_point(size=3)
p3 = p3 + stat_ellipse(type="norm", linetype=2)
p3 = p3 + labs(title="PCA, RNA-seq counts for time series of Pele (corrected data)", color="Library methods", shape="Condition")
p3 = p3 + scale_colour_manual(values = cols)

pdf(file="Uncorrected-vs-BatchCorrected-PCA_сovmt.pdf")
grid.arrange(p1, p3, nrow = 2)
dev.off()




