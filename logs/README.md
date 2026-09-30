# Logs

This directory groups scheduler and program logs into `nf_trim_generode/`, `angsd/`, and `downstream/`. Scheduler `.out`/`.err` files and Stage 1 `.log` files are excluded from Git and may exist on Wahab even though the tracked directories contain only placeholders. Use informative filenames containing the analysis, sample set or job name, date when useful, and SLURM job ID.

Logs are diagnostic records, not results. Preserve logs needed to explain failures or final runs, and avoid committing repetitive or very large logs.
