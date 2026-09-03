#!/bin/bash -l

set -euo pipefail
umask 007

och_repo="/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf"
och_raw_base="/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs"
och_manifest="${och_repo}/manifests/fastq_manifest.tsv"
och_symlink_dir="${och_repo}/data/symlinks"

cd "$och_repo"

if ! grep -Fxq '/data/symlinks/' "${och_repo}/.gitignore"; then
    echo "STOP: add /data/symlinks/ to .gitignore first." >&2
    exit 1
fi

if [[ -s "$och_manifest" ]]; then
    echo "STOP: $och_manifest is already nonempty." >&2
    exit 1
fi

if [[ -e "$och_symlink_dir" || -L "$och_symlink_dir" ]]; then
    echo "STOP: $och_symlink_dir already exists." >&2
    exit 1
fi

och_manifest_tmp=$(
    mktemp "${och_repo}/manifests/.fastq_manifest.tsv.XXXXXX"
)

och_symlink_tmp=$(
    mktemp -d "${och_repo}/data/.symlinks.XXXXXX"
)

chmod 660 "$och_manifest_tmp"
chmod 770 "$och_symlink_tmp"

och_cleanup() {
    if [[ -n "${och_manifest_tmp:-}" &&
          -f "$och_manifest_tmp" ]]; then
        rm -f -- "$och_manifest_tmp"
    fi

    if [[ -n "${och_symlink_tmp:-}" &&
          -d "$och_symlink_tmp" ]]; then
        find "$och_symlink_tmp" \
            -mindepth 1 \
            -maxdepth 1 \
            -type l \
            -delete

        rmdir -- "$och_symlink_tmp" 2>/dev/null || true
    fi
}

trap och_cleanup EXIT

printf \
"sample_id\tbiological_id\tsource_biological_id\tpopulation\tera\tlibrary_id\tread_group\tsequencing_run\tsource_id\tsource_r1\tsource_r2\tsymlink_r1\tsymlink_r2\n" \
    > "$och_manifest_tmp"

declare -A och_seen_sample_id

och_count=0
och_run2_count=0
och_run3_count=0
och_run4_count=0

for och_run in 2nd 3rd 4th; do
    och_run_dir="${och_raw_base}/${och_run}_sequencing_run/fq_raw"

    case "$och_run" in
        2nd)
            och_unit="E00526-585-HJLFCCCX2-L3"
            och_expected_round="1"
            ;;
        3rd)
            och_unit="LH00328-276-22KKJLLT3-L2"
            och_expected_round="1"
            ;;
        4th)
            och_unit="LH00516-290-22M5VHLT4-L4"
            och_expected_round="2"
            ;;
    esac

    while IFS= read -r och_source_r1; do
        och_source_name="${och_source_r1##*/}"

        if [[ "$och_source_name" == "Undetermined.1.fq.gz" ]]; then
            continue
        fi

        och_source_id="${och_source_name%.1.fq.gz}"
        och_source_r2="${och_source_r1%.1.fq.gz}.2.fq.gz"

        if [[ ! -s "$och_source_r2" ]]; then
            echo "STOP: missing R2 mate for $och_source_r1" >&2
            exit 1
        fi

        if [[ "$och_source_id" =~ ^Och-([A-Za-z]+)_([0-9]{3})[-_](Ex[0-9]+)-([0-9]+[A-Za-z])-lcwgs-([0-9]+)-([0-9]+)$ ]]; then
            och_population="${BASH_REMATCH[1]}"
            och_fish_number="${BASH_REMATCH[2]}"
            och_extraction="${BASH_REMATCH[3]}"
            och_well="${BASH_REMATCH[4]}"
            och_lcwgs_batch="${BASH_REMATCH[5]}"
            och_round="${BASH_REMATCH[6]}"
        else
            echo "STOP: unrecognized FASTQ name: $och_source_name" >&2
            exit 1
        fi

        if [[ "$och_round" != "$och_expected_round" ]]; then
            echo "STOP: unexpected sequencing-round suffix in $och_source_name" >&2
            exit 1
        fi

        case "$och_population" in
            ACan|ACat|ATum)
                och_era="historical"
                ;;
            CBur|CCat|CTum)
                och_era="modern"
                ;;
            *)
                echo "STOP: unrecognized population in $och_source_name" >&2
                exit 1
                ;;
        esac

        och_biological_id="Och${och_population}${och_fish_number}"
        och_source_biological_id="Och-${och_population}_${och_fish_number}"
        och_library_id="${och_extraction}-${och_well}-lcwgs-${och_lcwgs_batch}"
        och_read_group="RG-${och_biological_id}-${och_unit}-${och_well}-B${och_lcwgs_batch}"
        och_sample_id="${och_biological_id}_${och_library_id}_${och_read_group}"

        if [[ -n "${och_seen_sample_id[$och_sample_id]+present}" ]]; then
            echo "STOP: duplicate generated sample ID: $och_sample_id" >&2
            exit 1
        fi

        och_seen_sample_id[$och_sample_id]=1

        och_link_r1="data/symlinks/${och_sample_id}_R1.fastq.gz"
        och_link_r2="data/symlinks/${och_sample_id}_R2.fastq.gz"

        ln -s -- \
            "$och_source_r1" \
            "${och_symlink_tmp}/${och_sample_id}_R1.fastq.gz"

        ln -s -- \
            "$och_source_r2" \
            "${och_symlink_tmp}/${och_sample_id}_R2.fastq.gz"

        printf \
"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
            "$och_sample_id" \
            "$och_biological_id" \
            "$och_source_biological_id" \
            "$och_population" \
            "$och_era" \
            "$och_library_id" \
            "$och_read_group" \
            "$och_run" \
            "$och_source_id" \
            "$och_source_r1" \
            "$och_source_r2" \
            "$och_link_r1" \
            "$och_link_r2" \
            >> "$och_manifest_tmp"

        och_count=$((och_count + 1))

        case "$och_run" in
            2nd) och_run2_count=$((och_run2_count + 1)) ;;
            3rd) och_run3_count=$((och_run3_count + 1)) ;;
            4th) och_run4_count=$((och_run4_count + 1)) ;;
        esac
    done < <(
        find "$och_run_dir" \
            -maxdepth 1 \
            \( -type f -o -type l \) \
            -name '*.1.fq.gz' \
            -print |
        LC_ALL=C sort
    )
done

och_manifest_rows=$(
    awk 'END {print NR - 1}' "$och_manifest_tmp"
)

och_biological_count=$(
    awk -F '\t' 'NR > 1 {print $2}' "$och_manifest_tmp" |
    LC_ALL=C sort -u |
    wc -l
)

och_symlink_count=$(
    find "$och_symlink_tmp" \
        -maxdepth 1 \
        -type l \
        -print |
    wc -l
)

if [[ "$och_count" -ne 529 ||
      "$och_manifest_rows" -ne 529 ]]; then
    echo "STOP: expected 529 manifest rows; found $och_manifest_rows." >&2
    exit 1
fi

if [[ "$och_run2_count" -ne 196 ||
      "$och_run3_count" -ne 88 ||
      "$och_run4_count" -ne 245 ]]; then
    echo "STOP: unexpected per-run counts: run2=$och_run2_count run3=$och_run3_count run4=$och_run4_count" >&2
    exit 1
fi

if [[ "$och_biological_count" -ne 278 ]]; then
    echo "STOP: expected 278 biological fish; found $och_biological_count." >&2
    exit 1
fi

if [[ "$och_symlink_count" -ne 1058 ]]; then
    echo "STOP: expected 1,058 symlinks; found $och_symlink_count." >&2
    exit 1
fi

while IFS= read -r och_link; do
    if [[ ! -s "$och_link" ]]; then
        echo "STOP: broken or empty symlink target: $och_link" >&2
        exit 1
    fi
done < <(
    find "$och_symlink_tmp" \
        -maxdepth 1 \
        -type l \
        -print
)

mv -- "$och_symlink_tmp" "$och_symlink_dir"
och_symlink_tmp=""

mv -- "$och_manifest_tmp" "$och_manifest"
och_manifest_tmp=""

trap - EXIT

echo "Manifest and FASTQ symlinks created successfully."
echo "Manifest rows: $och_manifest_rows"
echo "Biological fish: $och_biological_count"
echo "Symlinks: $och_symlink_count"
echo "Per-run pairs: run2=$och_run2_count run3=$och_run3_count run4=$och_run4_count"
