# AI working instructions for the *Ostorhinchus chrysopomus* project

## Project and source of truth

- This repository documents low-coverage whole-genome analysis of historical and contemporary *O. chrysopomus* to assess century-scale changes in population structure, diversity, differentiation, relatedness, and candidate selection signals. Treat these as research aims, not established findings.
- `metadata/samples_master.csv` identifies 278 biological fish: 101 historical (`ACan`, `ACat`, `ATum`) and 177 contemporary (`CBur`, `CCat`, `CTum`). The sequencing manifest contains multiple read occurrences for some fish. Do not equate sample-sheet rows with independent individuals. The final post-QC and matched temporal sets are not yet defined in the tracked documentation.
- Use the files in this repository as the source of truth for current methods and sample membership. Some introductory READMEs still describe the repository as an unconfigured placeholder; check the dated `docs/decisions.md`, actual configuration, launcher, and verified run records before describing current status.

## Working hypotheses

These null hypotheses are transcribed from `proposal_draft8(5).docx` supplied for this draft; that proposal is not tracked here. Verify them against the latest approved proposal before changing an analysis plan. They are questions to test, not findings.

- **H01:** There have been no significant temporal changes in genetic diversity or allele-frequency distributions in *O. chrysopomus*.
- **H02:** There have been no significant temporal changes in genetic differentiation or connectivity among *O. chrysopomus* populations.
- **H03:** There have been no significant temporal changes in genomic ancestry among *O. chrysopomus* populations.
- **H04:** There are no genomic regions showing temporal differentiation consistent with selection between 1908 and 2020.
- **H05:** Putative signatures of selection are randomly distributed across the genome and functional gene groups.

## Repository map and workflow

- `config/` holds paths and parameters; `metadata/` holds biological sample records; `manifests/` holds ordered FASTQ/BAM inputs. `workflows/` holds stage entry points and SLURM launchers; `scripts/` holds reusable analysis code. `docs/` records methods, tracking, and decisions; `logs/`, `reports/`, and `results/` hold run records, review summaries, and derived outputs, respectively. Large raw and intermediate data reside outside Git at documented project paths.
- The ordered stages are `workflows/01_nf_trim_generode/` (read processing and mapping), `02_bam_qc/`, `03_angsd/` (all samples and matched temporal sets), and `04_downstream/`. The latter stages have mostly placeholder entry points in the tracked branch; verify actual implementation before running or reporting them.
- The Stage 1 launcher uses `nf-trim-generode` at commit `7875891fc158ef55b35007fb298c2f2cd6ee600e`, Nextflow `23.10.1`, the `standard` SLURM profile, and the species-specific files in `config/nf-trim-generode/`. Its mapping reference is the unfiltered Iridian GenBank assembly `GCA_049176735.1` (`ASM4917673v1`); `docs/decisions.md` records FASTA MD5 `98ffe3d49eeca6d6fe832916fc32c87d`. Check the pinned checkout and reference checksum when reproducibility depends on them.
- The physical repository path is `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs_nf`. The Stage 1 launcher deliberately resolves a `/home/tburris/...` compatibility path to this repository to preserve the production Nextflow resume cache. Do not casually rewrite those paths, the resume target, or the separate analysis `work`/`results`/Conda-cache locations. Check the launcher, config, and decision log together before proposing any path change.

## Reproducible work

- Keep computational analyses and their documentation in this species repository. Use tracked scripts, configurations, manifests, and workflow entry points; document any large output stored outside Git with its exact location and how it was generated. Do not leave the sole record of a method or result in an AI chat.
- Give each substantive analysis directory a useful `README.md` with its question, input set and order, reference, versions, parameters, commands or submission script, output paths, QC checks, and interpretation limits. Update `docs/decisions.md` for exclusions or method changes; do not silently rewrite prior decisions.
- Preserve a traceable chain from commands/scripts and input manifests through logs and outputs to figures, tables, and reported conclusions. Commit compact results needed for review when appropriate; keep FASTQ, BAM, reference indexes, Nextflow intermediates, and other large generated files out of Git. Render relevant figures and tables directly in analysis READMEs with relative links or Markdown when practical so they can be reviewed on GitHub.
- Distinguish **submitted**, **running**, **failed**, and **completed successfully**. A SLURM job ID or `sbatch` response proves submission only. Check the actual exit status, Nextflow process state, logs, expected output files, and relevant QC/statistics before claiming success. Record failures and uncertainty plainly.

## Git and data safety

- Check `git status` and the current branch before edits. Make analysis changes on a dedicated branch and preserve a synchronized baseline before switching machines or working copies. Do not edit the same files concurrently on Wahab and a laptop; coordinate, commit/push the intended baseline when authorized, then update the other copy. Do not force-push or rewrite shared history without explicit instruction.
- Do not delete, move, overwrite, clean, or modify important project data, active Nextflow work directories, `.nextflow` state, caches, pipeline outputs, or reference files unless the task explicitly authorizes it. Inspect dependencies and resume behavior before any operation touching generated files. Respect narrower restrictions in the current task.

## Scientific interpretation

- Do not invent results, paths, sample attributes, parameters, completed runs, or biological explanations. Separate observations, hypotheses, and interpretations; cite the underlying file, figure, statistic, or log for each substantive claim.
- An admixture or ancestry cluster does not establish species identity. Require independent evidence before labeling clusters as species. Avoid overstating causation, adaptation, selection, ancestry, or species identity; consider QC, damage, coverage, reference bias, structure, relatedness, drift, and alternative explanations where relevant.
- Treat AI-generated interpretations and prose as drafts for researcher review against the underlying data and methods before use in a thesis, presentation, or publication.
