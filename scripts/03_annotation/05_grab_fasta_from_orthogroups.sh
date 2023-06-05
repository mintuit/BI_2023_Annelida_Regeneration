#!/bin/bash
#extracting proteinortho orthogroups fasta sequences for phylogenetic analysis 
#orthogroups_for_phylogeny.txt generated in homeobox_genes_analysis.ipynb script
cd proteinortho
while read line; 
do 
	GENE=$(echo $line | cut -d' ' -f1);
	ORTHOGROUP=$(echo $line | cut -d' ' -f2);
	/mnt/c/phylo/programms/proteinortho/src/BUILD/Linux_x86_64/proteinortho_grab_proteins.pl $ORTHOGROUP *fasta > homeobox_orthogroups_fasta/$GENE.fasta;
done <orthogroups_for_phylogeny.txt