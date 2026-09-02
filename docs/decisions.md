# Analysis decision log

Use this file to record decisions that affect reproducibility or biological interpretation. Add entries chronologically and do not silently rewrite earlier decisions.

## Entry template

### YYYY-MM-DD — Short decision title

- **Decision:** What was selected, changed, or excluded.
- **Rationale:** Scientific or technical justification.
- **Evidence:** Relevant QC report, exploratory result, or reference.
- **Affected files:** Configurations, manifests, scripts, or results that changed.
- **Analyst:** Name or initials.

### 2026-09-02 — Iridian GenBank assembly selected as mapping reference

- **Decision:** Use the complete, unfiltered Iridian GenBank assembly `GCA_049176735.1` (`ASM4917673v1`) as the mapping reference for `nf-trim-generode`. The assembly isolate is `Och-CTum_014`.
- **Rationale:** This versioned assembly was selected by the PI for the current analysis and supersedes the previously used >=20-kb-filtered de novo assembly.
- **Evidence:** The downloaded NCBI package passed its supplied MD5 checks. The genomic FASTA MD5 is `98ffe3d49eeca6d6fe832916fc32c87d`. Direct FASTA validation found 235,263 sequences spanning 1,040,770,694 bp, with lengths from 200 to 90,505,346 bp. The FASTA index and sequence dictionary contain matching sequence names, lengths, and order.
- **Indexing:** Generated with Samtools 1.19.2 and BWA 0.7.17 in SLURM job `6742754`, which completed successfully with exit code `0:0`.
- **Affected files:** `data/reference/GCA_049176735.1/`, `.gitignore`, and `workflows/01_nf_trim_generode/index_reference_GCA_049176735.1.sbatch`.
- **Analyst:** `tburris`

## Decisions still required

- Historical and contemporary period definitions.
- Rules for constructing the matched temporal sample set.
- BAM QC and sample-exclusion thresholds.
- ANGSD filtering and likelihood parameters.
- Population group definitions.
- Temporal-selection method and neutral null model.
- Window size, step size, scaffold eligibility, and multiple-testing procedure.
