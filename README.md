# bioinformatics-masters

# project - 'Enhancing Variant Discovery for Rare Genetic Diseases in African Populations'
This research was undertaken as part of my Masters of Science in Genetics and Genomics. This project aimed to curate a pipeline for the analysis of next generation sequencing (NGS) data using a novel human reference genome (T2T-CHM13). This pilot project was my first experience managing high-throughput datasets, and working in a high-performance computing environment (SLURM HPC). I greatly enjoyed the opportunity to learn a huge range of bioinformatic skills, from managing the large NGS datasets through pipeline development and benchmarking, to undertaking primary, secondary and tertiary analyses in the context of diagnostic research. 

# overview 
This repository contains bash scripts for genomic data analysis, including:
- FASTQ alignment using BWA-MEM.
- BAM file sorting, merging, and deduplication using SAMtools and GATK toolsets.
- Variant calling and annotation using GATK HaplotypeCaller and VEP.
- _Nextflow_ pipeline for Benchmarking.

These workflows are optimized for large-scale datasets and use SLURM for parallel processing.

# dependencies 
- SLURM
- BWA 0.7.17
- SAMtools 1.15
- GATK 4.4.0.0
- VEP


# updates
2025-01-06 created repository and uploaded drafted workflows
