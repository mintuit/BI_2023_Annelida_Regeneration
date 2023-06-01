#!/bin/bash
#building databases for kraken

### INPUT ###

OUTDIR=./Kraken2_DB/

### Processing ###

cd $OUTDIR

nohup kraken2-build --build --db PlusPF_db --threads 12
wait

echo "##### Job is complete #####"

