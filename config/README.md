# Configuration

This directory contains empty placeholders for future human-edited parameters and environment-specific paths. The analysis has not yet been configured. Once populated, configurations should be small, reviewable, and committed to Git without credentials or restricted data.

- `paths.yaml` centralizes reference, input, scratch, software, and output locations.
- `nf-trim-generode/` configures read processing and mapping.
- `angsd/` holds separate parameter sets for all samples and the matched temporal subset.

Record software and workflow versions explicitly. Avoid duplicating sample metadata in configuration files when values can be generated from `../metadata/samples_master.csv`.
