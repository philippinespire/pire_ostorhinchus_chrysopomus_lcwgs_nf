# Configuration

This directory contains human-edited parameters and environment-specific paths. Stage 1 is configured; the two ANGSD YAML files remain empty placeholders. Keep configurations small, reviewable, and free of credentials or restricted data.

- `paths.yaml` centralizes reference, input, scratch, software, and output locations.
- `nf-trim-generode/` configures read processing and mapping.
- `angsd/` holds separate parameter sets for all samples and the matched temporal subset.

`paths.yaml` uses the physical `/archive/..._nf` repository path. The Stage 1 launcher and `nf-trim-generode/params.yaml` also use a `/home/tburris/...` compatibility alias that the launcher verifies against the physical path. This preserves the production Nextflow resume cache; see `nf-trim-generode/README.md` and `../docs/decisions.md` before changing either representation. The launcher defines its own paths and does not read `paths.yaml` directly.

Record software and workflow versions explicitly. Avoid duplicating sample metadata in configuration files when values can be generated from `../metadata/samples_master.csv`.
