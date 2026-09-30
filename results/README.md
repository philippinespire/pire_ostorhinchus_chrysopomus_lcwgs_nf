# Results

This directory organizes derived outputs by mapping QC, ANGSD, structure, relatedness, diversity, FST, selection, and figures. Its tracked subdirectories currently contain only placeholders. Stage 1 publishes large outputs to the separate analysis location recorded in `../config/paths.yaml`; inspect that location and the run logs before making claims about generated results.

Only compact results needed to reproduce figures, tables, or key conclusions should be committed. Large genotype-likelihood files, BAM-derived intermediates, and regenerable binary outputs should remain in documented project storage and be excluded through `.gitignore` before those files are generated.

Every result should be traceable to a script, configuration, input manifest, and software version. The `angsd/all_samples/` and `angsd/matched_temporal/` directories must remain separate to prevent accidental mixing of sample sets.
