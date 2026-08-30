# Workflows

This directory establishes the planned order for the project's cluster-facing entry points. The workflow files have not yet been implemented:

1. `01_nf_trim_generode/` — read processing and mapping.
2. `02_bam_qc/` — BAM and sample quality control.
3. `03_angsd/` — genotype-likelihood analyses for all samples and the matched temporal subset.
4. `04_downstream/` — structure, relatedness, diversity, FST, selection, and figures.

Each workflow should read tracked configurations and manifests, write logs and results to their designated directories, stop on errors, and preserve the exact command and software version used.
