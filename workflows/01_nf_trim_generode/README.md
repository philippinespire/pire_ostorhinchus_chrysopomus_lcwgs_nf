# Stage 1: read trimming and GenErode mapping

This directory is reserved for the entry point that will convert raw FASTQ files into analysis-ready BAM files with the `nf-trim-generode` Nextflow workflow. It has not yet been configured or run.

## Contents

- `run_nf_trim_generode.sbatch`: SLURM submission script. It is currently a placeholder and must be populated with cluster resources, software initialization, configuration paths, and the pinned workflow version.

Inputs are defined in `../../config/nf-trim-generode/`; logs belong in `../../logs/nf_trim_generode/`. Before running, validate the sample sheet, reference assembly, output and scratch paths, historical/modern labels, container or environment, and resume behavior.
