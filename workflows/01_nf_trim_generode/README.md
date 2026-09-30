# Stage 1: read trimming and GenErode mapping

This stage uses `nf-trim-generode` to process historical and modern paired FASTQs against the `GCA_049176735.1` reference. The tracked launcher is configured for Wahab and pins the upstream pipeline to commit `7875891fc158ef55b35007fb298c2f2cd6ee600e`, Nextflow `23.10.1`, and the `standard` SLURM profile. See `../../config/nf-trim-generode/README.md` for inputs and the cache-compatible path arrangement.

## Tracked scripts

- `audit_run1_run2_duplicates.sbatch` compares run-1 and run-2 FASTQ pairs. The result and job ID recorded in `../../docs/decisions.md` explain why run 1 was excluded; its detailed output is in the corresponding Wahab scheduler log.
- `build_fastq_manifest_and_symlinks.sh` constructs `../../manifests/fastq_manifest.tsv` and ignored `../../data/symlinks/` from raw FASTQ names in runs 2–4. It requires empty destinations and is not an update command for existing inputs.
- `index_reference_GCA_049176735.1.sbatch` creates the reference `.fai`, sequence dictionary, and BWA indexes in the ignored `../../data/reference/GCA_049176735.1/` location. The decision log records the indexing job and its outcome.
- `audit_bwa_memory_limits.sbatch` records node/process memory diagnostics and tests an allocation. Its findings are summarized in the decision log; detailed output belongs to its scheduler log.
- `run_nf_trim_generode.sbatch` validates the pinned checkout, input count, symlinks, reference indexes, and runtime directories, then launches Nextflow with an explicit resume session. It directs SLURM and Nextflow logs to `../../logs/nf_trim_generode/`, reports and traces to `../../reports/nf_trim_generode/`, and published pipeline outputs to the separate analysis directory specified in the launcher.

## Run status and review

`../../docs/decisions.md` records Stage 1 preparation, failed driver or child jobs, and some successful tasks. Those entries do not establish completion of the full workflow. Before reporting a run as successful, verify the driver exit status, Nextflow log and trace, expected published files, and relevant QC outputs; record the exact job ID, session, command/configuration, and output location.

The physical repository is under `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs_nf`. The launcher checks that a `/home/tburris/...` compatibility alias resolves to it and uses that alias for cache-sensitive project and input paths. Preserve the active Nextflow work directory and cache. Do not replace alias paths or resume settings without first assessing cache compatibility and recording the decision.
