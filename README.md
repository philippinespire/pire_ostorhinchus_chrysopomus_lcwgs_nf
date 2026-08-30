# Temporal population genomics of *Ostorhinchus chrysopomus*

This repository documents the processing and analysis of low-coverage whole-genome sequencing (lcWGS) data from historical and contemporary *Ostorhinchus chrysopomus*. The project is designed to characterize population genomic change through time, with particular attention to population structure, genetic diversity, differentiation, relatedness, and candidate genomic signals of selection.

> **Project status:** This is a newly initialized repository. No sequence processing, quality control, ANGSD analysis, downstream analysis, or selection testing has been completed yet. The current directories and empty files are placeholders for planned work and do not represent generated data or results.

## Analysis overview

The proposed analysis will proceed through four stages:

1. Trim raw reads and map them to the reference genome with the `nf-trim-generode` workflow.
2. Evaluate BAM quality, coverage, mapping performance, and sample identity.
3. Estimate genotype likelihoods and allele-frequency statistics with ANGSD.
4. Conduct downstream analyses of structure, relatedness, diversity, differentiation, and temporal selection.

Two related sample sets are planned:

- **All samples** will support broad quality control, population structure, relatedness, and exploratory analyses.
- **Matched temporal samples** will contain comparable historical and contemporary samples and is intended for the primary temporal analyses.

Membership has not yet been finalized. The inclusion criteria for both sets should be recorded in `metadata/samples_master.csv` and `docs/decisions.md` before downstream analysis begins.

## Repository map

| Directory | Purpose |
|---|---|
| [`config/`](config/) | Human-edited paths and parameter files for each workflow. |
| [`docs/`](docs/) | Pipeline notes, sample tracking, and records of analytical decisions. |
| [`logs/`](logs/) | Scheduler and program logs, organized by analysis stage. |
| [`manifests/`](manifests/) | Machine-readable FASTQ and BAM input lists generated from the master metadata. |
| [`metadata/`](metadata/) | Authoritative sample metadata and analysis inclusion fields. |
| [`reports/`](reports/) | Human-readable QC and analysis summaries. |
| [`results/`](results/) | Derived analysis outputs; large reproducible files should remain outside Git. |
| [`scripts/`](scripts/) | Reusable code for metadata preparation, QC, ANGSD, and downstream analyses. |
| [`workflows/`](workflows/) | Ordered entry points and SLURM submission scripts for running the analysis. |

## Workflow directories

| Directory | Expected contents |
|---|---|
| `workflows/01_nf_trim_generode/` | Nextflow/SLURM launcher and run notes for read trimming, mapping, duplicate processing, and historical-DNA-aware BAM preparation. |
| `workflows/02_bam_qc/` | Commands for mapping statistics, depth/coverage summaries, contamination checks, and sample-level inclusion decisions. |
| `workflows/03_angsd/all_samples/` | ANGSD jobs using the complete post-QC sample set. |
| `workflows/03_angsd/matched_temporal/` | ANGSD jobs for the primary historical-versus-contemporary comparison. |
| `workflows/04_downstream/` | Entry points for population-genomic summaries, candidate selection scans, and figures. |

## Configuration and inputs

- `config/paths.yaml` stores environment-specific input, software, reference, and output paths.
- `config/nf-trim-generode/` stores the Nextflow configuration, pipeline parameters, and sample sheet.
- `config/angsd/all_samples.yaml` and `config/angsd/matched_temporal.yaml` store analysis-specific ANGSD parameters.
- `metadata/samples_master.csv` is the single source of truth for biological metadata and inclusion decisions.
- `manifests/fastq_manifest.tsv` records raw read inputs.
- `manifests/bam_list_all.txt` and `manifests/bam_list_matched_temporal.txt` provide ordered BAM inputs to ANGSD.

Paths and sample membership should be generated from metadata where possible rather than edited independently in several files.

## Planned results directories

| Directory | Expected outputs |
|---|---|
| `results/mapping_qc/` | Mapping rate, depth, coverage, duplication, damage, and sample QC summaries. |
| `results/angsd/` | Genotype likelihoods, site allele-frequency likelihoods, allele frequencies, and supporting index files. |
| `results/structure/` | PCAngsd or related population-structure outputs. |
| `results/relatedness/` | Pairwise relatedness estimates and sample exclusions. |
| `results/diversity/` | Site-frequency spectra and genetic-diversity summaries. |
| `results/fst/` | Pairwise and windowed population differentiation estimates. |
| `results/selection/` | Temporal selection statistics, null-model results, candidate regions, and annotations. |
| `results/figures/` | Final and diagnostic figures derived from tracked scripts. |

## Reproducibility conventions

- Run workflows in numeric order.
- Treat `metadata/samples_master.csv` as authoritative.
- Record parameter changes and sample exclusions in `docs/decisions.md`.
- Keep generated manifests under version control when they are small and contain no restricted information.
- Do not commit FASTQ, BAM, CRAM, reference indexes, or other large intermediate files.
- Preserve exact software, container, reference-genome, and workflow versions in the configuration and run documentation.
- Write scheduler output to the appropriate subdirectory of `logs/`.
- Include the command or script that generated every reported table and figure.

## Planned next steps

1. Populate and validate `metadata/samples_master.csv`.
2. Complete `config/paths.yaml` and the `nf-trim-generode` sample sheet and parameters.
3. Document the reference genome and temporal matching rules in `docs/decisions.md`.
4. Run `workflows/01_nf_trim_generode/` and review its logs.
5. Complete BAM QC before generating the final BAM manifests.
6. Run the ANGSD analyses, followed by the downstream workflows.

See [`docs/pipeline.md`](docs/pipeline.md) for a stage-by-stage description and [`docs/sample_tracking.md`](docs/sample_tracking.md) for sample-status conventions.
