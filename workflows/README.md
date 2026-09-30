# Workflows

This directory establishes the order for the project's cluster-facing entry points. Stage 1 has a populated launcher and supporting scripts; later stages have planning READMEs and placeholder directories:

1. `01_nf_trim_generode/` — read processing and mapping.
2. `02_bam_qc/` — BAM and sample quality control.
3. `03_angsd/` — genotype-likelihood analyses for all samples and the matched temporal subset.
4. `04_downstream/` — structure, relatedness, diversity, FST, selection, and figures.

Each workflow should read tracked configurations and manifests, write logs and results to their designated directories, stop on errors, and preserve the exact command and software version used.
