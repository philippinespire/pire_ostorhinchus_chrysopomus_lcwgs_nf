#!/bin/bash -l
#SBATCH --job-name=och_generode
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=30-00:00:00
#SBATCH --chdir=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf
#SBATCH --output=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.out
#SBATCH --error=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.err

set -euo pipefail
umask 007

och_project_root="/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf"
och_pipeline_dir="${och_project_root}/nf-pipelines/nf-trim-generode"
och_expected_pipeline_commit="7875891fc158ef55b35007fb298c2f2cd6ee600e"

och_params="${och_project_root}/config/nf-trim-generode/params.yaml"
och_config="${och_project_root}/config/nf-trim-generode/nextflow.config"
och_samplesheet="${och_project_root}/config/nf-trim-generode/samplesheet.csv"
och_indir="${och_project_root}/data/symlinks"
och_reference="${och_project_root}/data/reference/GCA_049176735.1/GCA_049176735.1.fasta"
och_amber="/archive/carpenterlab/pire/softwares/AMBERv2/AMBER"

och_analysis_root="/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/GenErode_Och_GCA_049176735.1"
och_work_dir="${och_analysis_root}/work"
och_output_dir="${och_analysis_root}/results"
och_conda_env_cache="${och_analysis_root}/conda/envs"
och_conda_package_cache="${och_analysis_root}/conda/pkgs"

och_logs_dir="${och_project_root}/logs/nf_trim_generode"
och_reports_dir="${och_project_root}/reports/nf_trim_generode"
och_miniconda="/home/tburris/miniconda3"

echo "nf-trim-generode launcher started: $(date)"
echo "Driver host: $(hostname)"
echo "SLURM job: ${SLURM_JOB_ID:-not-set}"

for och_file in \
    "${och_pipeline_dir}/main.nf" \
    "${och_pipeline_dir}/nextflow.config" \
    "${och_pipeline_dir}/environment.yml" \
    "$och_params" \
    "$och_config" \
    "$och_samplesheet" \
    "$och_reference" \
    "${och_reference}.fai" \
    "${och_reference%.fasta}.dict" \
    "${och_reference}.amb" \
    "${och_reference}.ann" \
    "${och_reference}.bwt" \
    "${och_reference}.pac" \
    "${och_reference}.sa" \
    "$och_amber"
do
    if [[ ! -s "$och_file" ]]; then
        echo "STOP: required file is missing or empty: $och_file" >&2
        exit 1
    fi
done

for och_dir in \
    "$och_indir" \
    "$och_work_dir" \
    "$och_output_dir" \
    "$och_conda_env_cache" \
    "$och_conda_package_cache" \
    "$och_logs_dir"
do
    if [[ ! -d "$och_dir" || ! -w "$och_dir" ]]; then
        echo "STOP: required directory is missing or not writable: $och_dir" >&2
        exit 1
    fi
done

if [[ ! -x "${och_miniconda}/bin/conda" ]]; then
    echo "STOP: Conda executable is unavailable." >&2
    exit 1
fi

och_pipeline_commit=$(git -C "$och_pipeline_dir" rev-parse HEAD)

if [[ "$och_pipeline_commit" != "$och_expected_pipeline_commit" ]]; then
    echo "STOP: pipeline commit does not match the recorded commit." >&2
    echo "Expected: $och_expected_pipeline_commit" >&2
    echo "Observed: $och_pipeline_commit" >&2
    exit 1
fi

if [[ -n "$(git -C "$och_pipeline_dir" status --porcelain)" ]]; then
    echo "STOP: the nf-pipelines checkout contains local changes." >&2
    git -C "$och_pipeline_dir" status --short >&2
    exit 1
fi

och_sample_rows=$(awk 'END {print NR - 1}' "$och_samplesheet")
och_link_count=$(find "$och_indir" -maxdepth 1 -type l -print | wc -l)
och_broken_count=$(find "$och_indir" -maxdepth 1 -xtype l -print | wc -l)

if [[ "$(head -n 1 "$och_samplesheet")" != "sample,era" ]]; then
    echo "STOP: unexpected samplesheet header." >&2
    exit 1
fi

if [[ "$och_sample_rows" -ne 529 ]]; then
    echo "STOP: expected 529 samplesheet rows; found $och_sample_rows." >&2
    exit 1
fi

if ! awk -F, '
    NR > 1 && $2 != "historical" && $2 != "modern" {
        exit 1
    }
' "$och_samplesheet"
then
    echo "STOP: samplesheet contains an unexpected era." >&2
    exit 1
fi

if [[ "$och_link_count" -ne 1058 ]]; then
    echo "STOP: expected 1058 FASTQ symlinks; found $och_link_count." >&2
    exit 1
fi

if [[ "$och_broken_count" -ne 0 ]]; then
    echo "STOP: found $och_broken_count broken FASTQ symlinks." >&2
    exit 1
fi

mkdir -p "$och_reports_dir"

module purge
module load nextflow/23.10.1
module list

export PATH="${och_miniconda}/bin:${PATH}"
export CONDA_PKGS_DIRS="$och_conda_package_cache"
export NXF_OPTS="-Xms1g -Xmx12g"
export NXF_ANSI_LOG=false

echo
echo "Pipeline commit: $och_pipeline_commit"
echo "Samplesheet rows: $och_sample_rows"
echo "FASTQ symlinks: $och_link_count"
echo "Reference: $och_reference"
echo "Work directory: $och_work_dir"
echo "Output directory: $och_output_dir"

nextflow -version
conda --version

nextflow \
    -log "${och_logs_dir}/nextflow-${SLURM_JOB_ID}.log" \
    -c "$och_config" \
    run "${och_pipeline_dir}/main.nf" \
    -profile standard \
    -params-file "$och_params" \
    -with-report "${och_reports_dir}/report-${SLURM_JOB_ID}.html" \
    -with-trace "${och_reports_dir}/trace-${SLURM_JOB_ID}.txt" \
    -with-timeline "${och_reports_dir}/timeline-${SLURM_JOB_ID}.html" \
    -with-dag "${och_reports_dir}/dag-${SLURM_JOB_ID}.html" \
    -resume

echo "nf-trim-generode launcher completed: $(date)"
