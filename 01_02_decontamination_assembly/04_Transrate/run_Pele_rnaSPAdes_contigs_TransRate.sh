#!/bin/bash
#clustering Pele contigs from rnaSPAdes assembly using Transrate

workdir=./QC

cd $workdir

# INPUT: #
R1=./Pele_kraken2_output/Pele_ref_decontaminated.R1.fastq
R2=./Pele_kraken2_output/Pele_ref_decontaminated.R2.fastq
Contigs=./Pele_ref_rnaSPAdes/Pele_new_ref.rnaSPdes.renamed.long.fasta
OUTDIR=Pele_new_ref_rnaSPAdes_TransRate_output

echo "***** TransRate (v1.0.1) began to work with params: *****"
echo "R1: $R1"
echo "R2: $R2"
echo "Assembly: $Contigs"
nohup ./Soft/TransRate_v101/transrate-1.0.1/bin/transrate --assembly=$Contigs --left=$R1 --right=$R2 --threads=24 --output=${workdir}/${OUTDIR}
wait
echo "##### Job is complete #####"
