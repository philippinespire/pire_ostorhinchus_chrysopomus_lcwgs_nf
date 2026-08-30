# Analysis scripts

This directory provides placeholders for future reusable, version-controlled code grouped by purpose. No analysis scripts have been implemented yet:

- `metadata/` validates and standardizes sample metadata.
- `manifests/` generates workflow sample sheets and BAM lists.
- `qc/` summarizes mapping and coverage quality.
- `angsd/` prepares or runs genotype-likelihood analyses.
- `pcangsd/` evaluates population structure from genotype likelihoods.
- `relatedness/` estimates pairwise kinship or relatedness.
- `diversity/` calculates site-frequency spectra and diversity statistics.
- `fst/` calculates population differentiation.
- `selection/` performs temporal selection scans and candidate annotation.
- `plotting/` produces diagnostic and final figures.

Scripts should accept paths and parameters through command-line arguments or tracked configuration files, use deterministic seeds where relevant, and write outputs only to the corresponding `results/`, `reports/`, or `logs/` directory.
