# Stage 3: ANGSD

This stage estimates genotype likelihoods, allele frequencies, site-frequency spectra, and related statistics without requiring hard genotype calls from lcWGS data.

- `all_samples/` is reserved for jobs using the complete post-QC dataset.
- `matched_temporal/` is reserved for jobs using the primary matched historical/contemporary comparison.

The corresponding configurations are in `../../config/angsd/`, and ordered BAM inputs are in `../../manifests/`. Keep sample order synchronized with population labels and never reuse an output prefix across the two datasets.
