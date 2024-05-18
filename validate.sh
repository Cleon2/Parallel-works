#!/bin/bash

GeneratedIDList="/tmp/generated_ids"
MaxID=1000

# Ensure the generated ID list exists
if [ ! -f "${GeneratedIDList}" ]; then
    echo "Generated ID list file does not exist."
    exit 1
fi

# Declare an associative array for incorrect width IDs and ids with their counts
declare -A idCount
declare -A incorrect_width 

# Populate idCount with the expected IDs as keys
for ((i=1; i<=MaxID; i++)); do
    idCount["$(printf "%05d" "$i")"]="0"
done

# Initialize lists for output
duplicates_list=()
missing_list=()
correct_list=()

# Count the number of times each ID appears in the generated ID list, and filter out those that have 
#improper width
while read -r id; do
    if [ ${#id} -ne 5 ]; then
        incorrect_width["$id"]=1 # Add the ID to the incorrect_width associative array
    else
        ((idCount["$id"]++))
    fi
done < "$GeneratedIDList"

#Channel the ids to the appropriate list based on their respective counts
for id in "${!idCount[@]}"; do
    count="${idCount["$id"]}"
    if ((count > 1)); then
        duplicates_list+=("$id")
    elif ((count == 0)); then
        missing_list+=("$id")
    else
        correct_list+=("$id")
    fi
done

# Sort the lists (Optional. Comes at the cost of performance)
incorrect_width_list=($(printf '%s\n' "${!incorrect_width[@]}" | sort)) 
duplicates_list=($(printf '%s\n' "${duplicates_list[@]}" | sort))
missing_list=($(printf '%s\n' "${missing_list[@]}" | sort))
correct_list=($(printf '%s\n' "${correct_list[@]}" | sort))

# Redirect the output to a file
{
    echo "IDs with incorrect width🙁:"
    if [ ${#incorrect_width_list[@]} -eq 0 ]; then
        echo "None"
    else
        for incorrect in "${incorrect_width_list[@]}"; do
            echo "$incorrect ❌"
        done
    fi

    echo "Duplicate IDs and their counts🙁:"
    if [ ${#duplicates_list[@]} -eq 0 ]; then
        echo "None"
    else
        for dup in "${duplicates_list[@]}"; do
            echo "$dup ❌ Count: ${idCount[$dup]}"
        done
    fi

    echo "Missing IDs🙁:"
    if [ ${#missing_list[@]} -eq 0 ]; then
        echo "None"
    else
        for missing in "${missing_list[@]}"; do
            echo "$missing ❌"
        done
    fi

    echo "Correct IDs that appeared only once😄:"
    if [ ${#correct_list[@]} -eq 0 ]; then
        echo "None"
    else
        for correct in "${correct_list[@]}"; do
            echo "$correct ✅"
        done
    fi
} > validateOutput.txt