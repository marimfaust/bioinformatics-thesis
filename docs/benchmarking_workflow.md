# benchmarking workflow overview: Benchmarking T2T-CHM13 against GRCh38 for small variant discovery

## 1. Cell Lines
The reference material of the Personal Genome Project’s Ashkenazi Jewish son (ID huAA53E0, RM 8391 DNA) (1) was obtained from the National Institute of Standards & Technology (NIST). At the Centro Nacional de Análisis Genómico (CNAG, Barcelona, Spain), the genomic DNA was sequenced to approximately 30X coverage.

## 2. Sequence Alignments and Pre-Processing of NGS data
The raw sequencing reads for whole genome data were mapped to the GRCh38 (GRCh38.p14) and CHM13 (T2T-CHM13v2.0) assemblies of the human reference genome. For a robust comparative analysis, both reference genomes included the 22 autosomes and X sex chromosome, excluding the Y sex chromosome, mitochondrion, and decoy sequences.
The elected aligner software (BWA-MEM, version 0.7.17) (2) was run on a computing node equipped with 32 hardware threads. An average coverage of ~30X was achieved for each alignment, that is, the reads aligned to any given region of the reference about 30 times, on average. The output SAM file of the paired-end aligned reads was converted to BAM format using SAMtools (version 1.15-GCC-11.2.0) (3). Subsequently, the resulting BAM files were merged by assembly, sorted by coordinates, and tagged for duplicate reads using PICARD (GATK version 4.4.0.0) (4); ultimately producing a single master BAM file for each assembly.
This pipeline followed the standard format recommended for NGS analysis in clinical genomics (5), apart from the BQSR step, which was omitted for the T2T-CHM13-alignment due to the inherent high quality and calibration of the sequencing data.

## 3. Variant Calling
The elected algorithm for germline short variant calling was GATK’s HaplotypeCaller (version 4.4.0.0) (6), executed with a minimum MAPQ 20 and otherwise default parameters. This restricted the mismatch rate of the alignment against the human reference genome, by only allowing a 1 in 5 base mismap event. Additionally, the variant calling process was executed by chromosomal intervals due to the large quantity of input data; thus, maximising computing power and efficiency.

## 4.	Benchmarking Variant Calls
The HG002 variant call sets aligned the T2T-CHM13 and GRCh38 reference genomes were each assessed against a gold standard “truth” GIAB variant call set (7), respectively, with restriction to the confident call regions particular to each reference genome. The GIAB benchmarking “truth sets” (v4.2.1) (8,9) were employed as “standard” for the validation of the clinical sequencing pipeline and enhancement of variant calling and sequencing methods (10). BEDtools intersect (2.30.0-GCC-11.2.0) (11) executed the coordinate restriction applied for each variant call set. 
The analysis of variant concordance was executed by Hap.py (12,13). This benchmarking tool evaluated the precision, recall and F1-score parameters for variants called in the diploid HG002 genome, comparing it to the NIST/Genome in a Bottle “truth set” VCF. This comparative analysis was conducted for HG002 in alignment with GRCh38 and T2T-CHM13 for a complete comparison between the two reference genomes (14). Each reference genome was assessed for variant precision, defined by the ratio of true positives (TP) to total positive calls in the query, and variant recall, measuring the proportion of TP to total positive calls in the “truth set”. 

## 5. Variant Concordance between different genome references 
BCFtools (15) was used to derive statistical information about the variants at non-syntenic and syntenic regions of T2T-CHM13 with GRCh38. Moreover, the concordance of effect prediction of SNVs and INDELs using the GRCh38 and T2T-CHM13 references was also assessed for HG002. 
The genomic variants of HG002 aligned to the T2T-CHM13 assembly were lifted over to the GRCh38 reference for a comprehensive comparative analysis of data integration and consistency. This step was performed with PICARD LiftoverVCF tool specifying a minimum 1% match required for variant lifting, as well as recovering variants where the alternative and reference allele are swapped. Only the variants that matched in position and in reference or alternative alleles with GRCh38 were lifted.

## 6.	Variant Effect Prediction Annotation / Annotating T2T-CHM13 assemblies
ENSEMBL’s Variant Effect Prediction (VEP, version 111.0) software (16) was used to annotate the variant call data (VCFs) by integration of publicly available custom annotation data. Firstly, a generic feature format file (GFF) produced with Liftoff and GENCODEv35 Comparative Analysis Toolkit (CAT), contained the RefSeqv110 human gene and rDNA annotations of the GRCh38 assembly mapped to the T2T-CHM13 genome (17-19). Additionally, custom VCF tracks lifted over from GRCh38 by ClinVar (20) and Gnomad (v3.1.2) (21) were added. The VEP tool parsed the custom annotations and variants of each input VCFs and assessed their respective predicted molecular consequences and consequential clinical significance.

# references
(1) Xie H, Li W, Hu Y, Yang C, Lu J, Guo Y, et al. De novo assembly of human genome at single-cell levels. Nucleic Acids Research. 2022 Jul 22;50(13):7479–92.  
(2) Li H. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv; 2013 [cited 2024 Aug 14]. Available from: http://arxiv.org/abs/1303.3997 
(3) Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, et al. Twelve years of SAMtools and BCFtools. GigaScience. 2021 Jan 29;10(2):giab008
(4) Broad Institute. Picard toolkit; version 4.4.0.0; Available from: http://broadinstitute.github.io/picard/ 
(5) Koboldt DC. Best practices for variant calling in clinical sequencing. Genome Med. 2020 Dec;12(1):91
(6) Auwera GAV de, O’Connor BD. Genomics in the cloud: using Docker, GA K, and WDL in Terra. First edition. First edition. Beijing Boston Farnham Sebastopol Tokyo: O’Reill ; 2020. 467 p.  
(7) Jarvis ED, Formenti G, Rhie A, Guarracino A, Yang C, Wood J, et al. Semi-automated assembly of high-quality diploid human reference genomes. Nature. 2022 Nov 17;611(7936):519–31.
(8)  Wagner J, Olson ND, Harris L, McDaniel J, Cheng H, Fungtammasan A, et al. Towards a Comprehensive Variation Benchmark for Challenging Medically-Relevant Autosomal Genes [Internet]. 2021 [cited 2024 Aug ]; Available from: http://biorxiv.org/lookup/doi/10.1101/2021.06.07.444885 14]
(9) Zook JM, Catoe D, McDaniel J, Vang L, Spies N, Sidow A, et al. Extensive sequencing of seven human genomes to characterize benchmark reference materials. Sci Data. 2016 Jun 7;3(1):160025. 
(10) Wagner J, Olson ND, Harris L, Khan Z, Farek J, Mahmoud M, et al. Benchmarking challenging small variants with linked and long reads. Cell Genomics. 2022 May;2(5):100128.
(11) Quinlan AR, Hall IM. BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics. 2010 Mar 15;26(6):841–2.  
(12) Bonfield JK, Marshall J, Danecek P, Li H, Ohan V, Whitwham A, et al. HTSlib: C library for reading/writing high-throughput 29;10(2):giab007.  sequencing data. GigaScience. 2021 Jan 
(13) Krusche P. hap.py [Internet]. Available from: https://github.com/Illumina/hap.py
(14) Zook J, Olson N, Wagner J, McDaniel J, Dwarshuis N. GIAB Stratifications [Internet]. Available from: https://ftptrace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/genome-stratifications/v3.3/
(15) Li H. A statistical framework for SNP calling, mutation discovery, association mapping and population genetical parameter estimation from sequencing data. Bioinformatics. 2011 Nov 1;27(21):2987–93.  
(16) McLaren W, Gil L, Hunt SE, Riat HS, Ritchie GRS, Thormann A, et al. The Ensembl Variant Effect Predictor. Genome Biol. 2016 Dec;17(1):122.  
(17) CHM13 [Internet]. 2023. Available from: https://github.com/marbl/CHM13 
(18) Shumate A, Salzberg SL. Liftoff: accurate mapping of gene annotations. Bioinformatics. 2021 Jul 19;37(12):1639–43.  
(19) Fiddes IT, Armstrong J, Diekhans M, Nachtweide S, Kronenberg ZN, Underwood JG, et al. Comparative Annotation Toolkit (CAT)-simultaneous clade and personal genome annotation. Genome Res. 2018 Jul;28(7):1029–38.  
(20) Taylor DJ, McCoy RC. ClinVar Liftover Annotations [Internet]. 2022. Available from: https://s3-us-west-2.amazonaws.com/humanpangenomics/T2T/CHM13/assemblies/annotation/liftover/ClinVar.html 
(21) Chen S, Francioli LC, Goodrich JK, Collins RL, Kanai M, Wang Q, et al. A genomic mutational constraint map using variation in 76,156 human genomes. Nature. 2024 Jan 4;625(7993):92–100. 
