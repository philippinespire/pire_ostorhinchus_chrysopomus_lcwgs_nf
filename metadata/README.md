# Metadata

This directory is reserved for the authoritative biological and analytical metadata for every sequenced individual. The master table has not yet been populated.

## Contents

- `samples_master.csv`: one row per biological sample, including identifiers, collection period and locality, sequencing information, input-file locations, QC status, and inclusion in each analysis set.

Recommended fields include `sample_id`, `individual_id`, `period`, `collection_year`, `locality`, `latitude`, `longitude`, `preservation`, `sequencing_run`, `library_id`, `historical`, `include_all`, `include_matched_temporal`, `qc_status`, and `exclusion_reason`.

This table should be treated as the single source of truth. Manifests and sample lists should be generated from it, and every exclusion or reassignment should be documented in `../docs/decisions.md`.
