#!/bin/bash

### Input ###

tmmdir=/home/maxnest/Pele_tmm/
outdir=/home/maxnest/Pele_kraken2_output/
suffix=#

### Processing ###

cd $outdir

for dir in $(find $tmmdir -mindepth 1 -type d); do
        r1="$(find $dir -type f -name '*.clean.R1.fastq.gz')"
        r2="$(find $dir -type f -name '*.clean.R2.fastq.gz')"
        tag=$(basename $dir)
        echo "Kraken2 starts to work with: "
        echo "R1: $r1"
        echo "R2: $r2"
        echo "TAG: $tag"
	mkdir ${tag}_vs_PlusPF_db
	cd ${tag}_vs_PlusPF_db
        nohup kraken2 --db /home/maxnest/Kraken2_DB/PlusPF_db/ --threads 12 --paired --gzip-compressed --unclassified-out ${tag}.unclass.R${suffix}.fastq --classified-out ${tag}.class.R${suffix}.fastq --output ${tag}_vs_PlusPF_db.tab --report ${tag}_vs_PlusPF_db.report ${r1} ${r2}
	cd ..
        wait
done

echo "##### Job is complete #####"

