#!/bin/bash
#Trinity version - 2.14.0
#Transcriptome assembly for Pele using Trinity

workdir=./Pele_ref_Trinity

cd $workdir

# INPUT: #
R1=./Pele_kraken2_output/Pele_ref_decontaminated.R1.fastq
R2=./Pele_kraken2_output/Pele_ref_decontaminated.R2.fastq

echo "***** Trinity began to work with params: *****"
echo "R1: $R1"
echo "R2: $R2"
echo "TAG: Pele_new_ref.Trinity"
#min_contig_length 300 used for noise reduction 
nohup ./Soft/Trinity/trinityrnaseq-v2.14.0/Trinity --seqType fq --max_memory 100G --left $R1 --right $R2 --SS_lib_type FR --CPU 24 --min_contig_length 200 --output Pele_new_ref.Trinity --no_salmon --full_cleanup
wait
echo "##### Job is complete #####"
