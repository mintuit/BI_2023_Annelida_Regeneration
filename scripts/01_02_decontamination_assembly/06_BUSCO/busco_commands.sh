#!/bin/bash
#BUSCO odb10 metazoa database was downloaded locally
#busco for draft assemblies
for NAME in $(ls ./draft_assemblies/*fasta); do busco -i ./$NAME -l metazoa_odb10 --offline -m transcriptome -o $(basename -- "$NAME" .fasta) --download_path /mnt/f/phylo/WORMS/busco_analysis/busco_downloads/ -c 8; done

#busco for decontaminated assemblies
for NAME in $(ls ./decontaminated/*fasta); do busco -i ./$NAME -l metazoa_odb10 --offline -m transcriptome -o $(basename -- "$NAME" .fasta) --download_path /mnt/f/phylo/WORMS/busco_analysis/busco_downloads/ -c 8; done

#results visualization
python3 /mnt/f/phylo/programs/busco/scripts/generate_plot.py --working_directory ./BUSCO_summaries

