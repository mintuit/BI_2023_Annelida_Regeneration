#!/bin/bash
#downloading databases for kraken

### INPUT ###

OUTDIR=./Kraken2_DB/

### Processing ###

cd $OUTDIR

nohup kraken2-build --download-taxonomy --db PlusPF_db --threads 5 --use-ftp
wait
nohup kraken2-build --download-library archaea --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library viral --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library bacteria --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library plasmid --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library human --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library fungi --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library protozoa --db PlusPF_db --threads 5
wait
nohup kraken2-build --download-library UniVec_Core --db PlusPF_db --threads 5
wait

echo "##### Job is complete #####"
