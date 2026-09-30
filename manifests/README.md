# Input manifests

This directory contains machine-readable workflow inputs. The FASTQ manifest is populated; both post-QC BAM lists remain empty placeholders. Input lists describe file locations and sample order but do not replace biological metadata.

## Contents

- `fastq_manifest.tsv`: 529 paired FASTQ occurrences representing 278 biological fish, with source FASTQs and local symlink names. The Stage 1 manifest builder creates this file from raw FASTQ names. `../config/nf-trim-generode/samplesheet.csv` has the same 529 sample IDs and era labels; keep the two synchronized.
- `bam_list_all.txt`: ordered list of post-QC BAM files for analyses using all retained samples.
- `bam_list_matched_temporal.txt`: ordered list of post-QC BAM files for the matched historical/contemporary analysis.

Whenever possible, regenerate these files from `../metadata/samples_master.csv`. Validate that every BAM has an index, that sample names match the metadata exactly, and that BAM order agrees with any downstream group or population label file.
