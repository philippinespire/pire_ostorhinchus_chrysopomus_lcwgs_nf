# K=2 ancestry provenance and biological/technical audit

## Scope

This report documents a read-only investigation of the existing K=2 ancestry result from:

`/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/angsd_analysis`

No analysis was rerun. No BAM, genotype-likelihood, ancestry, PCA, relatedness, result, figure, or analysis-script file was changed during the audit.

K1 and K2 are ancestry components. They are not species assignments.

## K=2 provenance

The primary K=2 matrix is:

`angsd_analysis/results/admixture/angsd_admix_notrans.admix.2.Q`

It is associated with PCAngsd job `4649920`, submitted August 8, 2025.

The recorded command was:

```bash
crun pcangsd \
  -b angsd_depth1_15_notrans.beagle.gz \
  --admix \
  --maf 0.001 \
  --threads 16 \
  --out angsd_admix_notrans \
  --it 500
```

Available evidence indicates:

- PCAngsd version: 1.21, based on nearby surviving logs
- Number of individuals: 278
- Number of input sites: 2,802,660
- Sites after MAF 0.001: likely 2,754,201
- Maximum iterations: 500
- Actual K=2 convergence iteration: unavailable
- Output prefix: `angsd_admix_notrans`
- Q-matrix SHA-256: `6C5E3249619BDBB8CA7B390F0EA747A5C13220D6FDEF3BC613072A133959B383`

The original K=2 Slurm log, expected as `pcangsd_admix_notrans-4649920.out`, was not available during the audit.

The current `logs/tool_logs/angsd_admix_notrans.log` describes a later K=4 run and cannot serve as the K=2 log.

The original K=2 `.P` file and contemporaneous `angsd_admix_notrans.cov` were unavailable. The preserved `angsd_notrans_snps_pca.cov` belongs to the parallel PCA run, job `4649921`.

Only one defensible biological K=2 result was found. No NGSadmix K=2 result was found.

## Sample-order verification

The K=2 Q matrix contains 278 two-column rows. All rows sum to approximately one.

Both BAM lists contain 278 unique samples and agree row for row. The preserved full-path BAM-list copies have SHA-256:

`0D340FA2BBBBAAD21AA885F7C7E4AB75161AC35DE52BE84E5CEEB3B7D3152934`

The plotting code assigns Q rows to BAM-list rows positionally before grouping or plotting. A previous image audit found that the existing K=2 PNG reproduces the Q matrix and sample order with correlation 0.99999.

The Beagle header was unavailable. Generic Beagle labels such as `Ind0`, `Ind1`, and subsequent labels could not be checked directly. Positional correspondence remains dependent on ANGSD retaining BAM-list order.

## Population structure

| Population | n | Mean K1 | Mean K2 | Median K1 | Median K2 | Hard K1 | Hard K2 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ACan | 24 | 0.8812 | 0.1188 | 0.9999 | 0.0001 | 21 | 3 |
| ACat | 41 | 0.0540 | 0.9460 | 0.0343 | 0.9657 | 0 | 41 |
| ATum | 36 | 0.3572 | 0.6428 | 0.2036 | 0.7964 | 11 | 25 |
| CBur | 64 | 0.0019 | 0.9981 | 0.0001 | 0.9999 | 0 | 64 |
| CCat | 63 | 0.0023 | 0.9977 | 0.0001 | 0.9999 | 0 | 63 |
| CTum | 50 | 0.0164 | 0.9836 | 0.0131 | 0.9869 | 0 | 50 |

Threshold counts are shown as K1/K2:

| Population | Greater than 0.80 | Greater than 0.90 | Greater than 0.95 |
|---|---:|---:|---:|
| ACan | 21/3 | 21/2 | 21/2 |
| ACat | 0/40 | 0/36 | 0/28 |
| ATum | 5/18 | 4/15 | 3/5 |
| CBur | 0/64 | 0/64 | 0/64 |
| CCat | 0/63 | 0/63 | 0/63 |
| CTum | 0/50 | 0/50 | 0/48 |

Historical specimens:

- Number of specimens: 101
- Mean K1/K2: 0.3586/0.6414
- Median K1/K2: 0.0941/0.9059
- Hard K1/K2 assignments: 32/69
- Greater than 0.90 K1/K2: 25/53
- Greater than 0.95 K1/K2: 24/35

Contemporary specimens:

- Number of specimens: 177
- Mean K1/K2: 0.0062/0.9938
- Median K1/K2: 0.0001/0.9999
- Hard K1/K2 assignments: 0/177
- All 177 have greater than 0.90 K2 ancestry
- 175 have greater than 0.95 K2 ancestry

Descriptive group-mean models explained:

- Era alone: 32.3% of K1 variance
- Location alone: 64.0%
- Era plus location: 70.3%
- Six era-by-location populations: 74.1%

Location is more predictive than era in this dataset. However, location, era, preservation, and laboratory processing are incompletely crossed. These percentages do not establish a causal explanation.

## Four focal Tumindao specimens

| Sample | K1 | K2 | Assignment | ATum K1 rank | Overall K1 rank |
|---|---:|---:|---:|---:|---:|
| OchATum005 | 0.9702734 | 0.0297266 | K1 | 1/36 | 22/278 |
| OchATum016 | 0.9642733 | 0.0357267 | K1 | 2/36 | 23/278 |
| OchATum031 | 0.9518160 | 0.0481839 | K1 | 3/36 | 24/278 |
| OchATum017 | 0.9406954 | 0.0593046 | K1 | 4/36 | 25/278 |

These are the four strongest K1 ATum individuals. Globally, however, they are not unique. Their ancestry proportions closely resemble those of the 21 strongly K1 historical Canipaan specimens.

OchATum007 has K1 = 0.8918, and several other ATum specimens occupy intermediate positions. ATum therefore shows a broader ancestry continuum with four specimens at its K1 extreme.

The four focal specimens resemble ACan more strongly than ACat or the contemporary populations in this analysis. This is an ancestry-pattern result and does not establish species identity.

## PCA comparison

The preserved PCA covariance matrix contains 278 rows and 278 columns and uses the same sample order.

Results from its eigen-decomposition were:

- PC1 variance: 25.52%
- PC2 variance: 0.50%
- Correlation of K1 with PC1: 0.999935
- Correlation of K2 with PC1: -0.999935
- Correlation of K1 with PC2: -0.014996
- Correlation of K2 with PC2: 0.014996

Nearest PC1-PC2 neighbors included:

- OchATum005: OchATum016, OchACan012, OchACan010, OchACan004, OchATum031, and OchATum017
- OchATum016: OchACan010, OchATum031, OchATum005, OchATum017, and OchACan012
- OchATum017: OchATum031, OchATum016, OchACan010, OchATum005, OchACan012, and OchACan015
- OchATum031: OchATum017, OchATum016, OchACan010, OchATum005, OchACan015, and OchACan012

PCA and K=2 describe essentially the same dominant genomic axis. They are different summaries of the same genotype-likelihood dataset rather than independent molecular evidence.

## Geography versus era

The strongest observed pattern is:

- ACan: predominantly K1
- Historical ACat: predominantly K2
- Historical ATum: a continuum between K1 and K2
- All contemporary populations: nearly pure K2

The result is inconsistent with a simple “historical equals K1” explanation because all ACat and most ATum historical specimens are K2.

The effect cannot be attributed cleanly to geography because the sampling design does not fully cross era and location. Canipaan is represented historically, while Burias is represented contemporarily.

## Technical-artifact assessment

The four focal specimens do not form a unique processing batch:

- All four use historical rescaled BAMs, as do all 101 historical specimens.
- They share extraction plate `Och-A_001` with 77 ACat and ATum specimens whose K1 values span approximately 0.019 to 0.970.
- They share the original and redo library series with those specimens.
- They occupy distinct extraction and library wells.
- No focal specimen has an index duplicate.
- No focal specimen has a sequencing-name duplicate.
- No focal specimen has a decode mismatch.
- No focal specimen has a GenErode symlink mismatch.

The available repository snapshot did not contain sufficient per-sample information to test:

- coverage or depth
- read counts
- mapped-read counts
- mapping percentage
- mapping quality
- postmortem-damage measurements
- genotype-likelihood missingness
- number of usable sites per specimen
- PCAngsd sensitivity to per-sample missingness

Historical BAMs are rescaled, whereas contemporary BAMs are not. Rescaling is therefore confounded with era and cannot be separated without a controlled sensitivity analysis.

Era or rescaling alone cannot explain the full pattern because all historical specimens received the historical treatment while historical ACan, ACat, and ATum have substantially different ancestry patterns.

A technical contribution to the broader historical/contemporary contrast nevertheless remains possible.

## Relatedness assessment

NGSremix relatedness was calculated as `r = 0.5 × k1 + k2`.

| Pair | Relatedness | ATum percentile |
|---|---:|---:|
| OchATum016-OchATum017 | 0.068010 | 89.2 |
| OchATum005-OchATum031 | 0.066376 | 88.4 |
| OchATum005-OchATum016 | 0.062396 | 85.2 |
| OchATum016-OchATum031 | 0.058697 | 82.5 |
| OchATum005-OchATum017 | 0.056358 | 81.7 |
| OchATum017-OchATum031 | 0.055281 | 81.3 |

The focal-pair mean was 0.0612. The mean among other ATum pairs was 0.0320, and the ATum median was 0.0261.

The four are somewhat more related than average ATum pairs, but no focal pair reaches the project’s 0.125 high-relatedness threshold. Their mean is also close to the 0.0693 mean among all hard-K1 pairs.

Family structure may contribute to their similarity, but the estimates do not support a close-family group sufficient to explain the K=2 component. Population structure itself can elevate relatedness among specimens sharing an ancestry component.

## K=3 stability

K=3 was used only as a secondary stability check.

- K=2 K1 versus PCAngsd K=3 column 2: `r = 0.999808`
- K=2 K1 versus no-MAF PCAngsd K=3 column 2: `r = 0.997503`
- K=2 K1 versus plotted NGSadmix K=3 V3: `r = 0.997584`

K=3 preserves the dominant K=2 division and subdivides other variation. These analyses are not completely independent because they use the same or closely related genotype-likelihood inputs.

## Provenance problems

1. `pcangsd_admix_it500.sbatch` and the MAF 0.02 script both use the `angsd_admix_notrans` output prefix.
2. The worklog’s December MAF 0.05 script also shows the reused prefix, while the currently tracked MAF 0.05 script uses the safer `angsd_admix_maf_05_notrans` prefix.
3. The surviving `angsd_admix_notrans.log` is a December 25, 2025 K=4 run rather than the August K=2 run.
4. `angsd_admix_notrans.cov` was vulnerable to being overwritten.
5. The original K=2 `.P` file and Slurm log were not present in the audited evidence.
6. The current `admixture_ceb.R` points to K=4 and K=3 matrices rather than the K=2 matrix.
7. `make_bamlists.R` still reads the K=2 matrix.
8. The repository was reorganized after the original analysis, while historical scripts expect inputs and outputs in the project root.
9. The Beagle header was unavailable for direct biological-label verification.

Despite these problems, the preserved K=2 Q matrix is credibly associated with job `4649920`: it was copied and documented immediately after that run, has the August timestamp, matches the existing figure, and predates the later output-prefix reuse.

## Species-identity interpretation

K1 and K2 are nuclear-genomic ancestry components.

The four focal Tumindao specimens occupy the ACan-like end of the dominant nuclear-genomic axis. The ancestry, PCA, and relatedness results do not identify them as *Ostorhinchus sealei* or any other species.

The mitochondrial reference audit also found no validated fixed COI or 16S discriminator in the available reference set.

Species identification therefore still requires independently validated voucher-linked genetic references, morphological evidence, or both.

## Remaining uncertainties

- Whether the live HPC still contains the original K=2 Slurm log
- Whether the original K=2 `.P` file is recoverable
- Whether the live HPC Q matrix still has the audited checksum
- Per-sample coverage and mapping quality
- Postmortem-damage differences
- Genotype-likelihood missingness
- Individual numbers of usable sites
- Robustness to LD pruning and alternative missingness filters
- Robustness across independent PCAngsd or NGSadmix seeds
- Whether the structure persists in historical-only or ATum-only analyses
- Morphological and voucher evidence for the focal specimens

## Recommended analyses

### Possible immediately with existing files

1. Recover the original K=2 Slurm log, `.P` file, Beagle header, checksums, and timestamps.
2. Join K1 with existing coverage, mapping, damage, and missingness measurements.
3. Model K1 against location, era, depth, missingness, damage, and laboratory batch.
4. Plot K1 and PC1 against each available QC variable.

### Requiring PCAngsd or NGSadmix reruns

1. Repeat K=2 across multiple random seeds.
2. Compare MAF thresholds.
3. Apply LD pruning and alternative missingness filters.
4. Run historical-only, ATum-only, and balanced era/location analyses.
5. Test damage-aware or non-rescaled sensitivity datasets where scientifically appropriate.

### Requiring independent evidence

1. Review specimen vouchers.
2. Re-examine morphology without using ancestry assignments as labels.
3. Obtain independently validated and geographically appropriate genetic references.

## Minimum PI evidence bundle

```text
angsd_analysis/results/admixture/angsd_admix_notrans.admix.2.Q
angsd_analysis/results/admixture/angsd_admix_notrans.admix.2.Q.png
angsd_analysis/data/bam_list/bam_list_all.txt
angsd_analysis/data/bam_list/bam_list_all_fullpath.txt
angsd_analysis/scripts/sbatch/pcangsd_admix_it500.sbatch
angsd_analysis/worklog.md.save
angsd_analysis/angsd_notrans_snps_pca.cov
angsd_analysis/results/remix/outputs/ngsremix_fixed_k3
```

The original `pcangsd_admix_notrans-4649920.out` should be added if it can be recovered.

## Final audit statement

No analysis input, BAM, ancestry matrix, PCA result, relatedness result, figure, or analysis script was created, modified, regenerated, or overwritten during this audit.
