# Metadata

This directory holds the master table for 278 biological fish. At present it records identifiers, population, and era; it does not yet record sample-level QC or inclusion decisions.

## Contents

- `samples_master.csv`: one row per biological fish, currently with `biological_id`, `source_biological_id`, `population`, and `era` columns.

Before downstream analysis, add and validate the needed collection, QC, exclusion-reason, and analysis-inclusion fields. Keep fish-level fields distinct from the multiple sequencing occurrences recorded in `../manifests/fastq_manifest.tsv`.

This table should become the single source of truth for biological metadata and inclusion decisions. The current FASTQ manifest is built from raw FASTQ names by `../workflows/01_nf_trim_generode/build_fastq_manifest_and_symlinks.sh`; a tracked, validated generation path for all derived sample lists is still needed. Document every exclusion or reassignment in `../docs/decisions.md`.
