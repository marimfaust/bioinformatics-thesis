#!/bin/bash
# sort_mBAM.cmd
# Sorts the master BAMs of each patient by coordinate
# usage: sbatch sort_mBAM.cmd
# dependencies: SLURM, GATK/4.4.0.0
#SBATCH --job-name=SORT_MBAM_PATIENTID
#SBATCH --output=/LogFiles/SORT_MBAM_PATIENTID.%j.out
#SBATCH --error=/LogFiles/SORT_MBAM_PATIENTID.%j.err
#SBATCH -D /path/to/dir

echo "SORT SAM FOR MASTER BAM OF ID" >&2
module purge

module load SAMtools/1.15-GCC-11.2.0

export TMPDIR="/path/to/TMP/"

apptainer \
exec \
--no-home \
--bind /scratch_isilon \
/scratch_isilon/groups/dat/apps/GATK/4.4.0.0/gatk_4.4.0.0.sif \
gatk --java-options "-Xmx16g" SortSam \
--TMP_DIR ${TMPDIR} \
-I CHM13.ID.bam \
-O CHM13.ID.sort.bam \
-SO coordinateecho "SORT SAM FOR MASTER BAM OF ID"

if [ $? -ne 0 ]; then
echo "Failed to sort ID" >&2
echo "JOB CANCEL" >&2
exit 1
fi

printf END >&2; uptime >&2
