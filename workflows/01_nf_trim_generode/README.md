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

## Pipeline progress — October 23 to November 23, 2026

### Completed

- The historical `OchACan008` LH00328 `BWA_MERGED_PASS1` retry finished on November 16 with exit code `0` after about 6 days and 8 hours. The production `nextflow log` records task hash `6e/897e92`.
- In the November 17 run, SLURM accounting shows completed historical PASS2 mapping, `INDEL_REALN` (64 jobs), `INDEX_REALIGNED` (19), `BAM_QC` (9 of 9 recorded jobs, all `0:0`), `MAPDAMAGE` (6), and `AMBER_PREP` (9). The BAM_QC completions are production evidence for the [September Conda override](../../docs/decisions.md#2026-09-29--bam_qc-assigned-the-pipeline-conda-environment). Historical `AMBER` started, with six jobs recorded as canceled. Modern PASS1 mapping, duplicate marking, and BAM merges completed for jobs in the accounting export, and modern `INDEL_REALN` started.
- The November 23 output inventory recorded `79G` of published results, including BAM and rescaled BAM directories and depth, mapDamage, and statistics directories.

### Failures and recovery

- SLURM recorded driver `7359429` as `CANCELLED by 0` on November 2 and driver `7558748` as `CANCELLED by 637020` on November 10. The associated OchACan008 BWA children were also canceled. On November 10, the first OchACan008 attempt under the next driver (`4e/f7a63f`) exited `143`, then the retry completed.
- On November 17, driver `7665875` failed with exit `1:0`. SLURM recorded seven modern `INDEL_REALN` jobs with `NODE_FAIL` (`7819823`, `7819824`, `7819827`, `7819832`, `7819836`, `7819837`, `7819839`), all on `d5-w6420b-07`. These were scheduler-reported node failures. The export omits the scheduler’s node reason, so the reported reboot remains unverified. Other jobs canceled during the workflow abort do not establish additional sample failures. See `nextflow-7665875.log`, `trace-7665875.txt`, and the job IDs above.
- Recovery driver `7856782` launched on November 19. Its Nextflow log shows the same LH00328 mapping running as child `7856786` with hash `d7/bc4730` after the successful retry under `6e/897e92`. This is consistent with a [reported Nextflow retry-cache limitation](https://github.com/nextflow-io/nextflow/issues/6884).

### Status at the November 23 audit

- At 08:52 CST on November 23, `squeue` and `sacct` showed driver `7856782` and OchACan008 LH00328 child `7856786` running on `d1-w6420a-22`. The BWA task had run for about 4 days and 6 hours, with 16 CPUs and `96G` requested in the audit's earlier queue snapshot. Stage 1 was still in progress.

### Important paths

- On Wahab, published `results/`, Nextflow `work/`, and `conda/` are under `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/GenErode_Och_GCA_049176735.1/`. The production session database is under `.nextflow/cache/` in the repository launch directory.
- The launcher writes SLURM and Nextflow logs to `logs/nf_trim_generode/` and reports, traces, timelines, and DAGs to `reports/nf_trim_generode/` under the repository. Match the filenames to the driver job ID.
- Configuration files are [`nextflow.config`](../../config/nf-trim-generode/nextflow.config) and [`params.yaml`](../../config/nf-trim-generode/params.yaml). The entry point is [`run_nf_trim_generode.sbatch`](run_nf_trim_generode.sbatch). The reference is `data/reference/GCA_049176735.1/GCA_049176735.1.fasta` under the repository compatibility path.

### Reproducibility

- The audited branch was `fix/bam-qc-conda-archive-paths` at `d5aff28`, which introduced the exact-library [16-CPU, 96-GB override](../../docs/decisions.md#2026-11-10--ochacan008-lh00328-historical-pass1-mapping-resources-increased).
- The upstream checkout on Wahab matched the launcher's exact pin `7875891fc158ef55b35007fb298c2f2cd6ee600e`. The launcher defaults to an explicit `-resume` targeting production session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`, the session used for the task history above.
