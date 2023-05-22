# Analysis of developmental gene expression dynamics during anterior and posterior regeneration of Platynereis dumerilii (Nereididae, Annelida) and Pygospio elegans (Spionidae, Annelida).

Authors: 

- Elena Novikova, The Zoological Institute of Russian Academy of Science (supervisor)
- Maksim Nesterenko, All-Russia Research Institute for Agricultural Microbiology (supervisor)
- Sergei Fomenko
- Dudkovskaia Anastasiia

We analysed gene expression changes during regeneration of two Annelida, Pygospio elegans, capable of anterior and posterior regeneration, and Platynereis dumerilii, capable of only posterior regeneration. Given the homeobox genes play a key role in the anteroposterior axis patterning and organs morphogenesis, we aimed to study the expression pattern of this superfamily of transcription factors during anterior and posterior regeneration.

## Aim, tasks and data
Samples of P.elegans and P.dumerilii were collected for bulk RNA sequencing during anterior (data marked as 'tail') and posterior regeneration (data marked as 'head') in 6 time points (0, 4, 12, 24, 48, and 96 hours after injury). The **available data** at the start of the project were: 24 RNA-seq (2 species * 2 sites * 6 time points) datasets of reads after basic quality check and trimming, same reads after decontamination with [MCSC Decontamination method](https://github.com/Lafond-LapalmeJ/MCSC_Decontamination) and draft <em>de novo</em> [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki) transcriptome assemblies for P.elegans and P.dumerilii. 

**Aim**: find and reveal phylogenetic history of genes involved in anterior and posterior regeneration in Annelida worms P. elegans and P. dumerilii

  

**Objectives**:

  

-   Compare transcriptome assemblies quality’s and completeness performed with different algorithms (Trinity, rnaSPAdes, RNA-Bloom) (S)
    
-   Study batch-effects for differential expression analysis (A)
    
-   Identify genes from Homeobox Superfamily in transcriptomes using HMMSearch, [eggNOG-mapper](http://eggnog-mapper.embl.de/) and Orthofinder (S)
    
-   Build phylogenetic trees for homeobox-genes and analyse their expression dynamics during various stages of regeneration (S)
    
-   Build species phylogenetic  tree using single-copy orthologous genes (S)
    
-   Identification of co-expression clusters (A)
    
-   Analysis and visualization of the GO-enrichment with genes demonstrating a coordinated change in expression (A)



## Improvement of <em>de novo</em> transcriptome assemblies
Workflow for this part of analysis:
![](workflow_01_02.png) 
Alternative decontamination method with [Kraken2](https://github.com/DerrickWood/kraken2) (v.2.1.2) was used to improve decontamination quality. Further commands were performed on supervisors server due to high computational demands of this part of analysis. Scripts used for decontamination can be found in **01_02_decontamination_assembly\01_kraken2** folder. Kraken2 reports visualisation performed online with [Pavian](https://fbreitwieser.shinyapps.io/pavian/).
![](decontamination_example.png) 

To further improve assemblies completeness 2 different assemblers were used - [rnaSPAdes](https://cab.spbu.ru/software/rnaspades/) (v.3.15.4) and [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki). Commands can be found in **01_02_decontamination_assembly\02_rnaSPades** and **01_02_decontamination_assembly\03_Trinity** folders.

Contigs quality from both assemblies was evaluated with [TransRate](https://hibberdlab.com/transrate/installation.html) (v.1.0.1), contigs with high scores were clusterised with [CDHIT-est](https://github.com/weizhongli/cdhit) (v.4.8.1) (threshold c=0.95 used for  duplicated sequence removal according to CDHIT user guide). Protein-coding ORFs in contigs were identified by [Transdecoder](https://github.com/TransDecoder/TransDecoder) (v.5.5.0).
Gene expression was quantified with [Salmon](https://github.com/COMBINE-lab/salmon) (v.1.2.1). For further analysis we used contigs with protein length > 100 aminoacids and expression level > 2 TPM at least in one time point.  
[BUSCO](https://gitlab.com/ezlab/busco) (v. 5.4.4) completeness analysis against Metazoa odb10 orthologs database of draft assemblies and 3 assemblies after decontamination (rnaSPAdes, Trinity and final CDHIT clustered and filtered assembly) revealed that decontamination with KRAKEN2 and clusterisation of 2 different assemblies improved transcriptomes completeness.
![](busco_assemblies.png) 

## Transcriptomes annotation
eggNOG-mapper and HMMsearch against the PfamA database were used for transcriptomes annotation and protein domains identification. Orthogroups identification between Annelida species studied and various metazoan species was carried out with reference proteomes from UniProt database (protein length >100 aminoacids) and OrthoFinder software.
Reference proteomes that were used:
- Apis mellifera (Insecta)
- Homo sapiens
- Biomphalaria glabrata (Mollusca)
- Crassostrea gigas (Mollusca)
- Lottia gigantea (Mollusca)
- Pomacea canaliculata (Mollusca)
- Capitella teleta (Annelida)
- Dimorphilus gyrociliatus (Annelida)
- Owenia fusiformis (Annelida)**

## Batch-effect estimation and correction
We noticed that there is no significant difference between data from different libraries, contrast, after using ComBat-seq most of biological differences were smoothed. Adding more biological variables to analysis needs ComBat-seq optimization. So we used uncorrected data.

![PCA](https://github.com/mintuit/BI_2023_Annelida_Regeneration/blob/main/ComBat-seq%20correction/Uncorrected-vs-BatchCorrected-PCA_Pele.pdf)



## Phylogenetic analysis

For 2 homeobox gene families (NKX2 and PBX) phylogenetic analysis was performed. Multiple protein alignment generated with MAFFT. Model selection and phylogenetic tree construction performed in IQTREE2

