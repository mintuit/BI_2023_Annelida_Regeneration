#!/bin/bash
#software version - HMMER 3.1b2 (February 2015)
#Pfam-A.hmm database contains data about protein domains of main protein families and downloaded from https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
hmmsearch --tblout hmmer_results/pele/seq.txt --domtblout hmmer_results/pele/domains.txt /mnt/f/phylo/programs/hmmer_data/Pfam-A.hmm filtered/Pele_amin_av.fasta
hmmsearch --tblout hmmer_results/pdum/seq.txt --domtblout hmmer_results/pdum/domains.txt /mnt/f/phylo/programs/hmmer_data/Pfam-A.hmm filtered/Pdum_amin_av.fasta
wait
echo 'hmmsearch is done'