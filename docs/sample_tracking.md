# Sample tracking

Sample state is maintained in `../metadata/samples_master.csv` rather than in prose or filenames alone.

Recommended QC states are `pending`, `pass`, `review`, and `exclude`. Every excluded sample should have a concise, reproducible reason, such as insufficient mapped reads, low breadth of coverage, contamination, sample duplication, close relatedness, or missing temporal match.

Inclusion in the all-sample and matched-temporal datasets should use separate Boolean fields. A sample can therefore pass technical QC and remain in exploratory analyses while being excluded from the primary temporal comparison because its locality or sampling period is unmatched.

When a decision changes, update the master table, record the rationale in `decisions.md`, and regenerate the affected manifests.
