# Stage 2: BAM quality control

This directory will contain commands and submission scripts for evaluating the BAM files produced by Stage 1.

Expected checks include file/index integrity, sample identity, mapped-read count, mapping rate, duplicate rate, mean depth, breadth of coverage, insert size, damage patterns, contamination indicators, and anomalous depth by scaffold. Summary tables should be written to `../../results/mapping_qc/`, logs to `../../logs/`, and review-ready summaries to `../../reports/`.

QC thresholds and exclusion decisions must be recorded in `../../docs/decisions.md`. After QC is finalized, regenerate the BAM lists in `../../manifests/`.
