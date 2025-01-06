#!/bin/bash
# sort_BAM.cmd
# Sorts aligned BAM files by coordinate using GATK SortSam
# usage: sbatch sort_BAM.cmd
# dependencies: SLURM, GATK/4.4.0.0
#SBATCH --job-name=SORT_BAMS_PATIENTID
#SBATCH --output=/LogFiles/SORT_BAMS_PATIENTID.%j.out
#SBATCH --error=/LogFiles/SORT_BAMS_PATIENTID.%j.err
#SBATCH -D /path/to/dir

echo "SAMTOOLS MERGE ALL BAMS FOR ID" >&2
module purge

module load SAMtools/1.15-GCC-11.2.0

# Define variables
REFERENCE="/path/to/hsapiens.CHM13.fasta"
BAM_DIR="/path/to/Trios/FAM"
OUTPUT_DIR="path/to/Trios/FAM"

# Defining the array of input BAMs and output file names
declare -a BAMS=(
"CHM13.ID.FLI1_4.bam CHM13.ID.FLI1_4.sort.bam"
"CHM13.ID.FLI1_3.bam CHM13.ID.FLI1_3.sort.bam"
"CHM13.ID.FLI1_2.bam CHM13.ID.FLI1_2.sort.bam"
"CHM13.ID.FLI1_1.bam CHM13.ID.FLI1_1.sort.bam"
"CHM13.ID.FLI2_4.bam CHM13.ID.FLI2_4.sort.bam"
"CHM13.ID.FLI2_3.bam CHM13.ID.FLI2_3.sort.bam"
"CHM13.ID.FLI2_2.bam CHM13.ID.FLI2_2.sort.bam"
"CHM13.ID.FLI2_1.bam CHM13.ID.FLI2_1.sort.bam"
)
run_sort() {
local INBAM=$1
local OUTBAM=$2

export TMPDIR="/path/to/TMP/"

apptainer \
exec \
--no-home \
--bind /scratch_isilon \
/scratch_isilon/groups/dat/apps/GATK/4.4.0.0/gatk_4.4.0.0.sif \
gatk --java-options "-Xmx16g" SortSam \
--TMP_DIR ${TMPDIR} \
-I $BAM_DIR/$INBAM \
-O $BAM_DIR/$OUTBAM \
-SO coordinate
if [ $? -ne 0 ]; then
echo "Failed to sort $1" >&2
echo "JOB CANCEL" >&2
exit 1
fi
}

export -f run_sort
export REFERENCE OUTPUT_DIR BAM_DIR

# Running jobs in parallel using xargs
printf "%s\n" "${BAMS[@]}" | xargs -n 4 -P 4 bash -c 'run_sort "$@"'

wait

echo "All bams are sorted"
printf END >&2; uptime >&2
