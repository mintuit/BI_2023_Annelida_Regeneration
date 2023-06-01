### Libraries ###
library(topGO)
library(dplyr)
library(rrvgo)
library(ggplot2)

### Input data ###
# Previously, removed the line containing genes from the Cluster_Objects.tsv 2 file, and also removed everything in the column names that was rinsed in brackets (like (5540 genes))
Pdum_head_clusters <- read.csv2("./Clust/Clusters_Objects_pdum_head.tsv", sep="\t", header = T) 
## Universe ##
Pdum_geneID2GO <- readMappings(file="./Go_analysis/Pdum_go_an.csv", sep = '\t')
Pdum_geneNames <- names(Pdum_geneID2GO)

### GOenrichment analysis ###
head_clusters <- colnames(Pdum_head_clusters)

## Head ##
for (i in head_clusters){
  all_genes <- factor(as.integer(Pdum_geneNames %in% Pdum_head_clusters[[i]]))
  names(all_genes) <- Pdum_geneNames
  ## Biological Processes (BP) ##
  GOdata_set_BP <- new("topGOdata", ontology="BP", allGenes=all_genes, annot=annFUN.gene2GO, gene2GO=Pdum_geneID2GO)
  resultsFisher_set_BP <- runTest(GOdata_set_BP, algorithm="classic", statistic="fisher")
  resultsFisher_set_BP_df <- as.data.frame(score(resultsFisher_set_BP))
  colnames(resultsFisher_set_BP_df) <- "P-values"
  resultsFisher_set_BP_df_subset <- subset(resultsFisher_set_BP_df, resultsFisher_set_BP_df$`P-values` < 0.01)
  results_set_BP <- GenTable(GOdata_set_BP, classicFishes=resultsFisher_set_BP,
                             ranksOf="classicFisher", topNodes=length(resultsFisher_set_BP_df_subset$`P-values`))
  results_set_BP_short <- subset(results_set_BP, Significant >= 10)
  output_file_name <- sprintf("Pdum_head_co-expression_cluster_%s_GOenrichment_BP_Fisher.min_10_genes.tsv", i)
  write.table(results_set_BP_short, file=output_file_name, sep="\t", quote=F, col.names = T, row.names = F)
  if (nrow(results_set_BP_short) > 0){
    ## Reduced Terms ##
    set_simMatrix <- calculateSimMatrix(results_set_BP_short[["GO.ID"]], 
                                        orgdb = "org.Hs.eg.db", 
                                        ont="BP", method="Rel") #generalization through H. Sapiens
    set_classicFisher <- gsub("< ", "", results_set_BP_short[["classicFisher"]])
    set_scores <- setNames(-log10(as.numeric(as.character(set_classicFisher))), results_set_BP_short[["GO.ID"]])
    set_reducedTerms <- reduceSimMatrix(set_simMatrix, set_scores, threshold = 0.7, orgdb="org.Hs.eg.db")
    set_reducedTerms_selected <- select(set_reducedTerms, parent, score, parentTerm)
    # duplication removing: #
    set_reducedTerms_uniq <- set_reducedTerms_selected %>% 
      group_by(parentTerm) %>%
      filter(row_number() == 1)
    # Preparation for visualization #
    set_reducedTerms_uniq_df <- as.data.frame(set_reducedTerms_uniq)
    set_reducedTerms_uniq_df$GOid_and_desc <- paste(set_reducedTerms_uniq_df$parent, "|", set_reducedTerms_uniq_df$parentTerm)
    set_reducedTerms_uniq_df$score_signif <- signif(set_reducedTerms_uniq_df$score, digits = 3)
    # Visualization #
    pdf(file=sprintf("Pdum_head_co-expression_cluster_%s_GOenrichment_BP_Fisher.min_10_genes.reduced_GSEA_results.visual.tsv", i), width = 10, height = 12)
    result_plot <- set_reducedTerms_uniq_df %>%
      arrange(score) %>%
      mutate(GOid_and_desc=factor(GOid_and_desc, levels=GOid_and_desc)) %>% 
      ggplot(aes(x=score, y=GOid_and_desc, fill=as.factor(score_signif))) + 
      geom_point(alpha=0.9, shape=21, size=5, color="black") + theme_bw() + 
      # legend.position = "right", axis.text=element_text(size=12, face="bold")
      theme(legend.position = "none", 
            plot.title = element_text(hjust = 0.5, size = 15, face="bold"), 
            axis.title.x = element_text(size=13, face="bold"), 
            axis.title.y = element_text(size=13, face="bold")) + 
      xlab("-log10(Fisher's Test p-values)") + ylab("Parental Gene Ontology terms (H. Sapiens)") + 
      ggtitle(sprintf("Reduced GSEA results: \n Pdum head co-expression cluster %s", i)) + labs(fill="Log-transformed scores")
    print(result_plot)
    dev.off()
    # Output writing #
    write.table(set_reducedTerms, file=sprintf("Pdum_head_co-expression_cluster_%s_GOenrichment_BP_Fisher.min_10_genes.reduced_GSEA_results.tsv", i),
                sep="\t", quote = F, col.names = T, row.names = F)
  } else {
    print(sprintf("There is not enough enriched GO-terms for %s"))
  }
}


