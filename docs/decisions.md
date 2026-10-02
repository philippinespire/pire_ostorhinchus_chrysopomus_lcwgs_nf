# Analysis decision log

Use this file to record decisions that affect reproducibility or biological interpretation. Add entries chronologically and do not silently rewrite earlier decisions.

## Entry template

### YYYY-MM-DD — Short decision title

- **Decision:** What was selected, changed, or excluded.
- **Rationale:** Scientific or technical justification.
- **Evidence:** Relevant QC report, exploratory result, or reference.
- **Affected files:** Configurations, manifests, scripts, or results that changed.
- **Analyst:** Name or initials.

### 2026-10-01 — Species identity investigation documented without assigning species

- **Decision:** Document `ATum005`, `ATum016`, `ATum017`, and `ATum031` as samples for species-identity follow-up. Do not identify them as *O. sealei* from ancestry clusters or treat the K=3 pattern as a verified third biological group.
- **Rationale:** Museum adult/juvenile labels cannot yet be linked to individual ATum IDs. The preliminary COI/16S comparison has not established a diagnostic marker, and the ancestry and mitochondrial figures are not independently reproducible from inputs and scripts in this repository.
- **Evidence:** `results/species_identity/README.md` and its two supplied figures record the observations, missing provenance, and interpretation limits. Commit `626fe22` added those three files; it did not run a new analysis.
- **Affected files:** `results/species_identity/README.md`, `results/species_identity/figures/atum_ancestry_k2_k3.png`, `results/species_identity/figures/coi_cross_label_413bp.png`, and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-30 — Current workflow status and working rules documented

- **Decision:** Replace outdated placeholder descriptions with the tracked Stage 1 configuration and sample counts. Describe Stage 1 as configured and submitted, without claiming that the full workflow completed. Add repository instructions for traceable analysis, output verification, and cautious biological interpretation.
- **Rationale:** A submitted Nextflow run and successful child tasks do not establish an analysis-ready data set. The documentation must distinguish configured inputs, tracked decisions, and verified final outputs.
- **Evidence:** Commits `6cec804` and `0b905b2` added `AGENTS.md` and revised the repository, configuration, metadata, manifest, workflow, log, report, and result READMEs. The tracked sample sheet and manifest contain 529 sequencing occurrences representing 278 fish; the post-QC BAM lists and ANGSD configurations remain placeholders.
- **Affected files:** `AGENTS.md`, `README.md`, `docs/pipeline.md`, the updated directory READMEs, `config/nf-trim-generode/README.md`, and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-29 — Cache-compatible paths retained after repository move

- **Decision:** Keep the physical repository under `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs_nf` while using the `/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf` compatibility alias for the launcher's project and cache-sensitive input paths. Check that the alias resolves to the physical repository before running Nextflow.
- **Rationale:** Changing the path strings used by the production session could prevent completed tasks from being reused on resume. The alias preserves those strings after the repository move.
- **Evidence:** Commit `2de7e72` changed repository paths to `/archive`; commit `66bb412` restored the alias in `config/nf-trim-generode/params.yaml` and added a `readlink -f` check in the launcher. `config/paths.yaml` names the physical path and is not read directly by the launcher. These commits establish configuration intent; they do not by themselves verify cache reuse in a later run.
- **Affected files:** `config/paths.yaml`, `config/nf-trim-generode/params.yaml`, `workflows/01_nf_trim_generode/run_nf_trim_generode.sbatch`, and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-29 — BAM_QC assigned the pipeline Conda environment

- **Decision:** Override `BAM_QC` to disable its upstream container and use `${projectDir}/environment.yml`, with two CPUs and 8 GB of memory.
- **Rationale:** The upstream Samtools container lacks `ps`, which Nextflow's task wrapper requires before the BAM_QC command starts. The pipeline Conda environment provides Samtools without that container launch.
- **Evidence:** Commit `2de7e72` adds the `BAM_QC` override and records the container-wrapper failure in `config/nf-trim-generode/nextflow.config`. An earlier trace (`reports/nf_trim_generode/trace-6792076.txt` on Wahab) recorded one historical `BAM_QC` failure with exit code 1. The commit does not establish that BAM_QC later completed; check a subsequent task exit code, log, and QC output before reporting success.
- **Affected files:** `config/nf-trim-generode/nextflow.config` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-08 — Nextflow driver isolated from memory-starved nodes

- **Decision:** Exclude nodes `d1-w6420a-11` and `d6-w6420b-05` from the Nextflow driver allocation and request `--exclusive=user` for the driver.
- **Rationale:** Process-level `clusterOptions` protect child tasks but do not affect the outer SLURM job running Nextflow. Protecting the driver is necessary because it maintains workflow state, polls SLURM, and records completed tasks in the cache.
- **Evidence:** Driver job `6778032` was assigned to `d6-w6420b-05` and failed after `09:02:55`. The Java runtime could not allocate 16 KiB of native memory and could not start `squeue`, both reporting `errno=12` (`Cannot allocate memory`). The driver used approximately 1.6 GB RSS, indicating node-wide memory exhaustion rather than excessive driver usage. `PREP_REFERENCE_REPEAT` job `6778033` completed successfully before the driver failed. Thirty-six BWA jobs remained active without a driver and were no longer active before recovery.
- **Recovery:** Preserve the existing Nextflow work directory and cache, then resume production session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`. Completed tasks, including `PREP_REFERENCE_REPEAT`, remain eligible for cache reuse; interrupted BWA tasks will restart.
- **Affected files:** `workflows/01_nf_trim_generode/run_nf_trim_generode.sbatch` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-08 — Reference preparation switched from module ANGSD to Conda ANGSD

- **Decision:** Override `PREP_REFERENCE_REPEAT` to disable its upstream `angsd/0.940` module directive and use the pipeline's existing Conda environment. Retain one CPU, increase the recorded memory request from 4 GB to 32 GB, and use user-level node isolation.
- **Rationale:** Wahab's `angsd/0.940` module requires `container_env/0.1` and exposes ANGSD through `crun angsd`, while the upstream process directly executes `angsd`. The pipeline Conda environment already provides a directly executable ANGSD 0.940 and therefore requires no process-script modification.
- **Evidence:** Child job `6777776`, `PREP_REFERENCE_REPEAT`, failed after three seconds with exit code `1` before its command executed because Lmod could not load `angsd/0.940`. The cached pipeline environment contains a functional ANGSD `0.940-dirty` executable. The Wahab module loads only after `container_env/0.1`, provides `crun angsd` version 0.941, and does not place a direct `angsd` command on `PATH`.
- **Recovery:** Resume production session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`. RepeatModeler, RepeatMasker, and all other successful tasks should be reused from cache. `PREP_REFERENCE_REPEAT` and the canceled BWA tasks will rerun.
- **Affected files:** `config/nf-trim-generode/nextflow.config` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-06 — RepeatMasker isolated after TRF memory failure

- **Decision:** Exclude nodes `d1-w6420a-11` and `d6-w6420b-05` from every workflow process. Override `REPEAT_MASKER` to retain four CPUs, request 32 GB initially, use `--exclusive=user`, and retry once with 64 GB for memory-related exit codes.
- **Rationale:** Wahab schedules the main partition by CPU cores rather than memory. RepeatMasker therefore received an 8 GB request without a corresponding physical-memory reservation and was placed on a severely memory-pressured node.
- **Evidence:** Child job `6776793` ran `REPEAT_MASKER` on `d6-w6420b-05` and failed after 54 minutes with exit code `12`. Its TRF subprocess reported `Cannot allocate memory`. The job reached approximately batch 1,349 of 17,414, recorded 7,412,876 KB maximum RSS, and the node subsequently reported only 5,783 MB free with `AllocMem=0`. Nextflow canceled 36 other tasks. RepeatModeler job `6771488` completed successfully after 44:22:15 and remains cacheable.
- **Recovery:** Resume production session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`. RepeatModeler and the 44 successfully completed child jobs should be reused from cache. RepeatMasker will restart on a user-isolated node.
- **Affected files:** `config/nf-trim-generode/nextflow.config` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-04 — BWA tasks isolated from shared-node memory pressure

- **Decision:** Run all `BWA.*` processes with SLURM option `--exclusive=user` and exclude nodes `d1-w6420a-11` and `d6-w6420b-05`. Retain four CPUs, the 32/64 GB memory-scaled requests, and one automatic retry.
- **Rationale:** Wahab's main partition schedules resources by CPU cores rather than memory. User-level node isolation allows this workflow's BWA jobs to share nodes with one another while preventing unrelated users' jobs from consuming untracked memory on those nodes.
- **Evidence:** SLURM reports `SelectTypeParameters=CR_CORE`, unlimited per-node memory defaults, and `AllocMem=0` even on occupied nodes. Node `d6-w6420b-05` had only 8,490 MB free while 21 cores were allocated and hosted both earlier long-running BWA allocation failures. Node `d1-w6420a-11` produced repeated one-second signal-53 failures without creating process logs. SLURM 25.11.7 accepted a test-only `--exclusive=user` request with both nodes excluded.
- **Recovery:** Resume the established production Nextflow session so successful tasks remain cached. Remaining BWA tasks will use user-isolated nodes and avoid the two suspect nodes.
- **Affected files:** `config/nf-trim-generode/nextflow.config` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-04 — Production Nextflow resume session made explicit

- **Decision:** Allow the launcher to accept an explicit Nextflow resume target through `OCH_RESUME_TARGET`. Resume the current production analysis from session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`.
- **Rationale:** A bare `-resume` selects the latest Nextflow session. The configuration preview created a newer session, causing the subsequent launcher to resume the preview rather than the production workflow.
- **Evidence:** Jobs `6744733` and `6748756` share production session `7e4b1069-96a8-4680-8bc9-3bab72e898c1`, which contains 1,247 reusable tasks. Preview run `prickly_mccarthy` created session `6517bcbb-75b6-472a-932c-0d4a83ef4a5b`. Job `6765768` resumed that preview session, reported zero cached tasks, and unnecessarily reran FASTP before child job `6765796` encountered node-memory allocation errors.
- **Recovery:** Submit the launcher with `OCH_RESUME_TARGET=7e4b1069-96a8-4680-8bc9-3bab72e898c1`. This explicitly selects the production cache regardless of later previews.
- **Affected files:** `workflows/01_nf_trim_generode/run_nf_trim_generode.sbatch` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-04 — BWA tasks configured for one memory-scaled retry

- **Decision:** Retain four BWA threads and configure each `BWA.*` task for one automatic retry. The first attempt requests 32 GB and the retry requests 64 GB.
- **Rationale:** The resumed workflow failed in `bwa aln` while expanding its alignment-search stack. A retry with additional reserved node memory protects the workflow from a transient or short-lived allocation failure without changing alignment parameters.
- **Evidence:** Driver job `6748756` failed because child job `6748759`, `BWA_MERGED_PASS1` for `OchACat012`, could not allocate 64 MiB in `gap_push`. Diagnostic jobs `6765716` and `6765759` found unlimited process limits, a 64-bit BWA 0.7.17 executable, no visible finite cgroup memory limit, and successful allocation and use of 5 GiB. The short allocation peak was not captured by `sacct`, demonstrating that its sampled `MaxRSS` value cannot exclude transient peaks.
- **Recovery:** Resume from the existing Nextflow work directory. Cached tasks will be reused. A failed BWA task will restart once with 64 GB before Nextflow terminates the workflow.
- **Affected files:** `config/nf-trim-generode/nextflow.config`, `docs/decisions.md`, and `workflows/01_nf_trim_generode/audit_bwa_memory_limits.sbatch`.
- **Analyst:** `tburris`

### 2026-09-03 — BWA task memory increased after initial workflow failure

- **Decision:** Override the upstream memory request for all `BWA.*` processes from 16 GB to 32 GB while retaining four CPUs.
- **Rationale:** The upstream BWA commands pipe output through `samtools sort -m 4G -@ 4`. Because the sort memory limit is per thread and BWA and Samtools require additional memory, the original 16 GB process request was insufficient.
- **Evidence:** Initial Nextflow driver job `6744733` failed after 18:06:23 when child job `6745565`, `BWA_MERGED_PASS1` for `OchACat040`, exited `1`. Its error was `samtools sort: couldn't allocate memory for bam_mem`. Nextflow consequently canceled 100 active tasks, including RepeatModeler job `6744735`. Before termination, 1,247 tasks completed successfully and remain eligible for Nextflow cache reuse.
- **Recovery:** Resume the workflow using the existing work directory and `-resume`. Successfully completed tasks will be reused, while failed or canceled tasks will run again with the corrected BWA memory request.
- **Affected files:** `config/nf-trim-generode/nextflow.config` and `docs/decisions.md`.
- **Analyst:** `tburris`

### 2026-09-03 — Independent FASTQ inputs selected

- **Decision:** Exclude `1st_sequencing_run/fq_raw` and use paired FASTQs from the second, third, and fourth sequencing runs. Exclude the `Undetermined` pairs from runs 2 and 4.
- **Rationale:** Run 1 is an archival duplicate of data also present in run 2, not an independent sequencing run. Retaining it would double-count reads.
- **Evidence:** SLURM audit job `6744487` compared all 184 run-1 R1/R2 pairs byte-for-byte with their matched run-2 pairs: 184 were identical, with 0 different pairs, unmatched pairs, multiple matches, missing mates, or comparison errors.
- **Retained inputs:** 529 paired FASTQ occurrences: run 2 has 196, run 3 has 88, and run 4 has 245. These represent 278 biological fish: 101 historical (`ACan`, `ACat`, and `ATum`) and 177 modern (`CBur`, `CCat`, and `CTum`).
- **Population totals:** `ACan` 24, `ACat` 41, `ATum` 36, `CBur` 64, `CCat` 63, and `CTum` 50.
- **Repeated observations:** Thirty-three fish occur in one independent sequencing run and 245 occur in two. Six fish have an additional independently barcoded run-2 library and therefore have three retained occurrences: `Och-ACat_007`, `Och-ACat_009`, `Och-ACat_015`, `Och-ACat_032`, `Och-ACat_039`, and `Och-ATum_033`.
- **Identity handling:** Pipeline sample IDs contain exactly three underscore-delimited fields. The first field is the biological fish ID, allowing independently mapped library/run occurrences to be merged by biological fish.
- **Affected files:** `manifests/fastq_manifest.tsv`, `metadata/samples_master.csv`, `config/nf-trim-generode/samplesheet.csv`, `data/symlinks/`, and the FASTQ manifest/audit scripts.
- **Analyst:** `tburris`

### 2026-09-03 — nf-trim-generode execution configuration pinned

- **Decision:** Run `nf-trim-generode` from commit `7875891fc158ef55b35007fb298c2f2cd6ee600e` using its `standard` SLURM profile and Nextflow `23.10.1`.
- **Parameters:** Use `bwa aln` for initial historical mapping, mapping-quality threshold `25`, four BWA threads, and fallback trim length `85`. Enable RepeatModeler/RepeatMasker, historical FastQC, historical mapDamage, and historical and modern AMBER.
- **Execution environment:** Use the personal Miniconda installation at `/home/tburris/miniconda3`, a shared Conda environment cache under the versioned analysis directory, and the pipeline’s configured Singularity containers.
- **Storage:** Write Nextflow work files and published results beneath `/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/GenErode_Och_GCA_049176735.1/`.
- **Validation:** The exact pipeline Conda environment dry run succeeded. Nextflow configuration resolution and workflow preview both completed with exit status `0`.
- **Affected files:** `config/paths.yaml`, `config/nf-trim-generode/params.yaml`, `config/nf-trim-generode/nextflow.config`, and `workflows/01_nf_trim_generode/run_nf_trim_generode.sbatch`.
- **Analyst:** `tburris`

### 2026-09-02 — Iridian GenBank assembly selected as mapping reference

- **Decision:** Use the complete, unfiltered Iridian GenBank assembly `GCA_049176735.1` (`ASM4917673v1`) as the mapping reference for `nf-trim-generode`. The assembly isolate is `Och-CTum_014`.
- **Rationale:** This versioned assembly was selected by the PI for the current analysis and supersedes the previously used >=20-kb-filtered de novo assembly.
- **Evidence:** The downloaded NCBI package passed its supplied MD5 checks. The genomic FASTA MD5 is `98ffe3d49eeca6d6fe832916fc32c87d`. Direct FASTA validation found 235,263 sequences spanning 1,040,770,694 bp, with lengths from 200 to 90,505,346 bp. The FASTA index and sequence dictionary contain matching sequence names, lengths, and order.
- **Indexing:** Generated with Samtools 1.19.2 and BWA 0.7.17 in SLURM job `6742754`, which completed successfully with exit code `0:0`.
- **Affected files:** `data/reference/GCA_049176735.1/`, `.gitignore`, and `workflows/01_nf_trim_generode/index_reference_GCA_049176735.1.sbatch`.
- **Analyst:** `tburris`

## Decisions still required

- Rules for constructing the matched temporal sample set.
- BAM QC and sample-exclusion thresholds.
- ANGSD filtering and likelihood parameters.
- Population group definitions.
- Temporal-selection method and neutral null model.
- Window size, step size, scaffold eligibility, and multiple-testing procedure.
