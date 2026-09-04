#!/bin/bash -l
#SBATCH --job-name=och_bwa_limit
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=00:05:00
#SBATCH --output=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.out
#SBATCH --error=/home/tburris/pire_ostorhinchus_chrysopomus_lcwgs_nf/logs/nf_trim_generode/%x-%j.err

set -euo pipefail
umask 007

echo "Host: $(hostname)"
echo "Job: ${SLURM_JOB_ID:-unset}"
echo "CPUs: ${SLURM_CPUS_PER_TASK:-unset}"
echo "Memory per node: ${SLURM_MEM_PER_NODE:-unset} MiB"

printf '\n=== Soft limits ===\n'
ulimit -aS

printf '\n=== Hard limits ===\n'
ulimit -aH

printf '\n=== Process limits ===\n'
cat /proc/self/limits

printf '\n=== Memory information ===\n'
grep -E 'MemTotal|MemAvailable|SwapTotal|SwapFree' /proc/meminfo

printf '\n=== Control group ===\n'
cat /proc/self/cgroup

och_cgroup=$(awk -F: '$1 == "0" {print $3}' /proc/self/cgroup)

for och_name in memory.max memory.current memory.swap.max; do
    och_file="/sys/fs/cgroup${och_cgroup}/${och_name}"

    if [[ -r "$och_file" ]]; then
        printf '%s: ' "$och_file"
        cat "$och_file"
    fi
done

printf '\n=== BWA executable ===\n'

och_conda_env="/archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/GenErode_Och_GCA_049176735.1/conda/envs/trimming-f3f05d0956aa310758906fd10e23a20e"

ls -lh "$och_conda_env/bin/bwa"
file "$och_conda_env/bin/bwa"
"$och_conda_env/bin/bwa" 2>&1 | head -n 5 || true

printf '\n=== Parent control-group limits ===\n'

och_cgroup=$(awk -F: '$1 == "0" {print $3}' /proc/self/cgroup)

while true; do
    och_file="/sys/fs/cgroup${och_cgroup}/memory.max"

    if [[ -r "$och_file" ]]; then
        printf '%s: ' "$och_file"
        cat "$och_file"
    fi

    [[ "$och_cgroup" == "/" ]] && break
    och_cgroup=$(dirname "$och_cgroup")
done

printf '\n=== Controlled 5-GiB allocation ===\n'

/home/tburris/miniconda3/bin/python - <<'PY'
size = 5 * 1024**3
memory = bytearray(size)

for position in range(0, size, 4096):
    memory[position] = 1

print(f"Successfully allocated and touched {size / 1024**3:.1f} GiB")
PY

echo "Memory diagnostic completed successfully."
