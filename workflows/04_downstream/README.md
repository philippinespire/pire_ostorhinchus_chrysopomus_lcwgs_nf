# Stage 4: downstream population genomics

This directory will contain workflow entry points for population structure, relatedness, diversity, FST, temporal selection, annotation, and plotting. Reusable implementation code belongs in `../../scripts/`; this directory should primarily coordinate inputs, configurations, dependencies, and cluster submissions.

Temporal selection analyses should use the matched temporal dataset unless a documented analysis calls for otherwise. Candidate signals must be checked against coverage, mappability, damage, structure, relatedness, and an appropriate neutral expectation before biological interpretation.
