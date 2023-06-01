#!/bin/bash
#Transcriptome assembly for Pele using rnaSPades

### INPUT ###
R1=./Pele_kraken2_output/Pele_ref_decontaminated.R1.fastq
R2=./Pele_kraken2_output/Pele_ref_decontaminated.R2.fastq
OUTDIR=./Pele_ref_rnaSPAdes

### SOFT ###

SPADES=./Soft/SPAdes-3.15.4-Linux/bin/rnaspades.py

### MAIN ###
echo "***** rnaSPAdes began to work with params: *****"
echo "R1: $R1"
echo "R2: $R2"
echo "OUTDIR: $OUTDIR"
nohup $SPADES -1 $R1 -2 $R2 --ss fr --threads 24 --memory 100 -o $OUTDIR
wait
echo "##### Job is complete #####"

