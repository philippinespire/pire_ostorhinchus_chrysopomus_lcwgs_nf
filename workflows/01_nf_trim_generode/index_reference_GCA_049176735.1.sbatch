#!/bin/bash -l
#SBATCH --job-name=och_ref_index
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.out
#SBATCH --error=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.err

set -euo pipefail
umask 007

och_reference_dir="/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/data/reference/GCA_049176735.1"
och_ref="GCA_049176735.1.fasta"
och_dict="GCA_049176735.1.dict"

cd "$och_reference_dir"
test -s "$och_ref"

echo "Reference indexing started: $(date)"
echo "Host: $(hostname)"

module purge
module load container_env/0.1 samtools/1.19
module list

crun samtools faidx "$och_ref"
crun samtools dict -o "$och_dict" "$och_ref"

module unload samtools/1.19
module load bwa/0.7.17
module list

crun bwa index "$och_ref"

test -s "${och_ref}.fai"
test -s "$och_dict"
test -s "${och_ref}.amb"
test -s "${och_ref}.ann"
test -s "${och_ref}.bwt"
test -s "${och_ref}.pac"
test -s "${och_ref}.sa"

ls -lh \
  "$och_ref" \
  "${och_ref}.fai" \
  "$och_dict" \
  "${och_ref}.amb" \
  "${och_ref}.ann" \
  "${och_ref}.bwt" \
  "${och_ref}.pac" \
  "${och_ref}.sa"

echo "Reference indexing completed: $(date)"
