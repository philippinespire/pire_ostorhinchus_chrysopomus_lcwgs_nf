# Analysis decision log

Use this file to record decisions that affect reproducibility or biological interpretation. Add entries chronologically and do not silently rewrite earlier decisions.

## Entry template

### YYYY-MM-DD — Short decision title

- **Decision:** What was selected, changed, or excluded.
- **Rationale:** Scientific or technical justification.
- **Evidence:** Relevant QC report, exploratory result, or reference.
- **Affected files:** Configurations, manifests, scripts, or results that changed.
- **Analyst:** Name or initials.

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
