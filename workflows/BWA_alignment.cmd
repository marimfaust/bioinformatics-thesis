#!/bin/bash
# BWA_alignment.cmd
# Aligns FASTQ paired end files using BWA-MEM and outputs BAM files
# usage: sbatch BWA_alignment.cmd
# dependencies: SLURM, BWA/0.7.17, SAMtools/1.15
#SBATCH --job-name=ALIGN_PATIENTID
#SBATCH --output=/LogFiles/ALIGN-PATIENTID.%j.out
#SBATCH --error=/LogFiles/ALIGN_PATIENTID.%j.err
#SBATCH -D /path/to/dir

hostname >&2
printf "START " >&2; uptime >&2
date >&2

echo "Running BWA-MEM for PATIENTID" >&2
module purge

module load BWA/0.7.17-foss-2018b
module load SAMtools/1.15-GCC-11.2.0

# Define variables
REFERENCE="/path/to/hsapiens.CHM13.fasta"
FASTQ_DIR="/path/to/dir/"
OUTPUT_DIR="/path/to/Trios/FAM/ID/"
SAMPLEID=”SMID”
LIBR=”LIBR”

# Defining the array of input fastq pairs and output bams
declare -a FASTQ_PAIRS=(
"FLI_4 CHM13.ID.FLI_4.bam"
"FLI_3 CHM13.ID.FLI_3.bam"
"FLI_2 CHM13.ID.FLI_2.bam"
"FLI_1 CHM13.ID.FLI_1.bam"
)
# Define the number of threads for BWA
THREADS=32

# Function to run bwa mem and samtools
run_bwa() {
local PLATFORM=$1
local R1=$2
local R2=$3
local OUTPUT=$4
bwa mem -t $THREADS -M -R
"@RG\tID:${PLATFORM}\tLB:${LIBR}\tPL:ILLUMINA\tPU:${PLATFORM}\tSM:${SMID}" $REFERENCE $FASTQ_DIR/$R1 $FASTQ_DIR/$R2 | \
samtools view -bS -o $OUTPUT_DIR/$OUTPUT
if [ $? -ne 0 ]; then
echo "Failed to perform BWA-MEM alignment for $R1 and $R2"
>&2
echo "JOB CANCEL" >&2
exit 1
fi
}

# Exporting the function to be used by xargs
export -f run_bwa
export REFERENCE FASTQ_DIR OUTPUT_DIR THREADS

# Run jobs in parallel using xargs
printf "%s\n" "${FASTQ_PAIRS[@]}" | xargs -n 4 -P 4 bash -c 'run_bwa"$@"' _

wait

echo "All alignments are completed."
printf END >&2; uptime >&2
