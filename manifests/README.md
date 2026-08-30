# Input manifests

This directory is reserved for machine-readable input lists that will be used by the workflows. The current files are empty placeholders. When populated, they will describe data locations and sample order but will not replace the authoritative biological metadata.

## Contents

- `fastq_manifest.tsv`: sample-to-FASTQ mapping used to prepare the Nextflow sample sheet.
- `bam_list_all.txt`: ordered list of post-QC BAM files for analyses using all retained samples.
- `bam_list_matched_temporal.txt`: ordered list of post-QC BAM files for the matched historical/contemporary analysis.

Whenever possible, regenerate these files from `../metadata/samples_master.csv`. Validate that every BAM has an index, that sample names match the metadata exactly, and that BAM order agrees with any downstream group or population label file.
