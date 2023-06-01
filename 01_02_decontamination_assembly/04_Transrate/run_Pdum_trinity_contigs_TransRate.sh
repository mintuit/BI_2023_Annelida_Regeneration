#!/bin/bash
#Counting Pele contigs quality from Trinity assembly using Transrate

source activate ./miniconda3/envs/transrate_env

workdir=./QC

cd $workdir

# INPUT: #
R1=./Pdum_kraken2_output/Pdum_ref_decontaminated.R1.fastq
R2=./Pdum_kraken2_output/Pdum_ref_decontaminated.R2.fastq
Contigs=./Pdum_ref_Trinity/Pdum_new_ref.Trinity.renamed.long.fasta.fasta
OUTDIR=Pdum_new_ref_Trinity_TransRate_output

echo "***** TransRate (v1.0.1) began to work with params: *****"
echo "R1: $R1"
echo "R2: $R2"
echo "Assembly: $Contigs"
nohup ./Soft/TransRate_v101/transrate-1.0.1/bin/transrate --assembly=$Contigs --left=$R1 --right=$R2 --threads=24 --output=${workdir}/${OUTDIR}
wait
echo "##### Job is complete #####"
