#!/bin/bash -l
#SBATCH --job-name=och_r1r2_audit
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=06:00:00
#SBATCH --output=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.out
#SBATCH --error=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.err

set -uo pipefail
umask 007

och_raw_base="/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs"
och_run1_dir="${och_raw_base}/1st_sequencing_run/fq_raw"
och_run2_dir="${och_raw_base}/2nd_sequencing_run/fq_raw"
och_decode="${och_run1_dir}/decode_sedlist.txt"

och_total=0
och_identical=0
och_different=0
och_no_match=0
och_multiple_matches=0
och_missing_mate=0
och_compare_error=0

printf "source_code\trun1_r1\trun2_target\tstatus\n"

while IFS= read -r och_run1_r1; do
    och_total=$((och_total + 1))

    och_run1_name="${och_run1_r1##*/}"
    och_source="${och_run1_name%%_*}"
    och_run1_r2="${och_run1_r1%_1.fq.gz}_2.fq.gz"

    if [[ ! -s "$och_run1_r2" ]]; then
        printf "%s\t%s\tNA\tmissing_run1_R2\n" \
            "$och_source" "$och_run1_name"
        och_missing_mate=$((och_missing_mate + 1))
        continue
    fi

    mapfile -t och_targets < <(
        awk -F/ -v source="$och_source" '
            $2 == source {
                print $3
            }
        ' "$och_decode" |
        while IFS= read -r och_target; do
            if [[ -s "${och_run2_dir}/${och_target}.1.fq.gz" &&
                  -s "${och_run2_dir}/${och_target}.2.fq.gz" ]]; then
                printf "%s\n" "$och_target"
            fi
        done
    )

    if [[ "${#och_targets[@]}" -eq 0 ]]; then
        printf "%s\t%s\tNA\tno_matching_run2_pair\n" \
            "$och_source" "$och_run1_name"
        och_no_match=$((och_no_match + 1))
        continue
    fi

    if [[ "${#och_targets[@]}" -gt 1 ]]; then
        och_target_list=$(
            IFS=';'
            printf "%s" "${och_targets[*]}"
        )
        printf "%s\t%s\t%s\tmultiple_matching_run2_pairs\n" \
            "$och_source" "$och_run1_name" "$och_target_list"
        och_multiple_matches=$((och_multiple_matches + 1))
        continue
    fi

    och_target="${och_targets[0]}"
    och_run2_r1="${och_run2_dir}/${och_target}.1.fq.gz"
    och_run2_r2="${och_run2_dir}/${och_target}.2.fq.gz"

    cmp -s -- "$och_run1_r1" "$och_run2_r1"
    och_r1_result=$?

    cmp -s -- "$och_run1_r2" "$och_run2_r2"
    och_r2_result=$?

    if [[ "$och_r1_result" -eq 0 && "$och_r2_result" -eq 0 ]]; then
        och_status="identical"
        och_identical=$((och_identical + 1))
    elif [[ "$och_r1_result" -gt 1 || "$och_r2_result" -gt 1 ]]; then
        och_status="comparison_error"
        och_compare_error=$((och_compare_error + 1))
    else
        och_status="different"
        och_different=$((och_different + 1))
    fi

    printf "%s\t%s\t%s\t%s\n" \
        "$och_source" "$och_run1_name" "$och_target" "$och_status"

done < <(
    find "$och_run1_dir" \
        -maxdepth 1 \
        \( -type f -o -type l \) \
        -name '*_1.fq.gz' \
        -print |
    LC_ALL=C sort
)

printf "\nSUMMARY\n"
printf "Run-1 pairs examined: %d\n" "$och_total"
printf "Identical run-2 pairs: %d\n" "$och_identical"
printf "Different pairs: %d\n" "$och_different"
printf "No matching run-2 pair: %d\n" "$och_no_match"
printf "Multiple matching run-2 pairs: %d\n" "$och_multiple_matches"
printf "Missing run-1 R2 mates: %d\n" "$och_missing_mate"
printf "Comparison errors: %d\n" "$och_compare_error"
