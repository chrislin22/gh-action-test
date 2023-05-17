#! /usr/bin/env bash 
set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$(dirname "$SCRIPT_DIR")

BATCH_SIZE=3
cd $ROOT_DIR
clusters=($(find test-dirs  -type d -maxdepth 2 -mindepth 2 | sort))

function join_by { local IFS="$1"; shift; echo "$*"; }

# construct a json array each containing a string of list of directories with size of BATCH_SIZE and use vertical bar to separate them  
# e.g. ["test-dirs/cluster1/1|test-dirs/cluster1/2", "test-dirs/cluster2/1|test-dirs/cluster2/2"] 

for ((i=0; i<${#clusters[@]}; i+=BATCH_SIZE)); do
    batch=("${clusters[@]:i:BATCH_SIZE}")
    batch=$(join_by "|" "${batch[@]}")
    echo $batch
    cluster_array+=("\"$batch\"")
done
cluster_array_json=$(join_by ", " "${cluster_array[@]}")
echo "[$cluster_array_json]"

echo "[$cluster_array_json]" | jq -r '.[]' | while read cluster; do
    echo "${cluster//|/ }"
    # for c in ${cluster//|/ }; do
    #     echo $c
    # done      
done    



# cluster_json_array="["

# for ((i=0; i<${#clusters[@]}; i+=BATCH_SIZE)); do
#     batch=("${clusters[@]:i:BATCH_SIZE}")
#     batch=$(printf '%s\n' "${batch[@]}" | paste -sd "|" -)
#     cluster_json_array+="\"$batch\""
#     if [ $i -lt $((${#clusters[@]} - $BATCH_SIZE)) ]; then
#         cluster_json_array+=","
#     fi
# done
# cluster_json_array+="]"
# echo "$cluster_json_array"

# for ((i=0; i<${#clusters[@]}; i+=BATCH_SIZE)); do
#     batch=("${clusters[@]:i:BATCH_SIZE}")
#     batch=$(printf '"%s"\n' "${batch[@]}" | paste -sd "|" -)
#     batch_list+=("$batch")
# done



