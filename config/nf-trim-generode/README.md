# Stage 1 configuration

- `samplesheet.csv` lists 529 sequencing occurrences (`sample,era`), representing 278 biological fish in `../../metadata/samples_master.csv`. The IDs and era labels match `../../manifests/fastq_manifest.tsv` in the tracked branch. These rows are not independent fish counts.
- `params.yaml` sets the sample sheet, FASTQ symlink directory, reference, output location, historical/modern processing options, and other pipeline parameters.
- `nextflow.config` sets the Wahab SLURM executor, external work and Conda-cache paths, Singularity/Conda handling, and process-specific resource or environment overrides.

`../paths.yaml` names the physical `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs_nf` repository. The launcher in `../../workflows/01_nf_trim_generode/` instead uses a `/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf` compatibility alias for cache-sensitive project and input paths and verifies that it resolves to the physical repository. `params.yaml` retains that alias. The launcher does not read `../paths.yaml` directly. The Nextflow work, published outputs, and Conda caches are in a separate versioned analysis directory under `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/`.

The launcher checks the nested `nf-pipelines/nf-trim-generode` checkout against commit `7875891fc158ef55b35007fb298c2f2cd6ee600e`, uses Nextflow `23.10.1` with the `standard` profile, and defaults to the production resume session recorded in `../../docs/decisions.md`. The upstream pipeline checkout and local reference are ignored by Git. Preserve the existing work directory and caches; review the launcher, decision log, and run evidence before changing paths or a resume target.
