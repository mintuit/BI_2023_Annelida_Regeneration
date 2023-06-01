#!/bin/bash
#Trinity version - 2.14.0
#Transcriptome assembly for Pdum using Trinity

workdir=./Pdum_ref_Trinity

cd $workdir

# INPUT: #
R1=./Pdum_kraken2_output/Pdum_ref_decontaminated.R1.fastq
R2=./Pdum_kraken2_output/Pdum_ref_decontaminated.R2.fastq
TAG=Pdum_new_ref.Trinity

echo "***** Trinity began to work with params: *****"
echo "R1: $R1"
echo "R2: $R2"
echo "TAG: $TAG"
#min_contig_length 300 used for noise reduction 
nohup ./Soft/Trinity/trinityrnaseq-v2.14.0/Trinity --seqType fq --max_memory 100G --left $R1 --right $R2 --SS_lib_type FR --CPU 24 --min_contig_length 200 --output $TAG --no_salmon --full_cleanup
wait
echo "##### Job is complete #####"
