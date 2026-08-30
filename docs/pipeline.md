# Analysis pipeline

This document describes the intended pipeline. None of the stages below has been completed, and all methods and parameters remain subject to validation and documentation.

## 1. Read processing and mapping

Raw paired-end reads will be described in the metadata and sample-sheet files. The `nf-trim-generode` workflow is intended to trim reads, map them to the selected *O. chrysopomus* reference assembly, process duplicates and indels, and produce analysis-ready BAM files. Historical and contemporary libraries may require different damage-aware processing while retaining comparable mapping and filtering criteria.

## 2. BAM quality control

Sample-level mapping rate, mapped read count, depth, breadth of coverage, duplication, insert size, damage patterns, and contamination indicators will be summarized before downstream analysis. Exclusion thresholds must be recorded before reviewing selection results. The outcome of this stage will determine the final BAM manifests.

## 3. ANGSD

ANGSD is planned because genotype likelihoods retain uncertainty in low-coverage data better than hard genotype calls. Separate configurations are planned for all retained samples and the matched temporal subset. Parameters should specify the genotype-likelihood model, base and mapping quality thresholds, BAQ settings, depth limits, missing-data requirements, minor-allele filters, and reference/ancestral-state treatment.

## 4. Downstream analysis

Planned analyses include population structure, relatedness, diversity, differentiation, and temporal selection. The matched temporal comparison is the primary dataset for testing change through time. Selection candidates should be evaluated against neutral expectations that account for drift, structure, sample size, genotype uncertainty, and linkage, and should be checked for associations with coverage, mappability, or historical-DNA damage.

## Provenance

Each stage should record the exact command, software or container version, reference assembly identifier and checksum, configuration file, input manifest, output location, date, and responsible analyst.
