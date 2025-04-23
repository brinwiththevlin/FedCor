#!/usr/bin/env bash

set -e

DATASETS=("mnist")
LABEL_TAMPERING=("none" "random" "reverse" "zero")
IID=(0 1)
WEIGHT_TAMPERING=("large_neg" "reverse" "random")
USERS=(25 50 100)

for dataset in "${DATASETS[@]}"; do
    for iid in "${IID[@]}"; do
        for label_tamp in "${LABEL_TAMPERING[@]}"; do
            for user in "${USERS[@]}"; do
                RESULTS_FILE="${dataset}_${user}_cnn_${iid}_lt${label_tamp}_wtnone/results.csv"
                if [ -f "$RESULTS_FILE" ]; then
                    echo "Results already exist at $RESULTS_FILE. Skipping..."
                else
                    echo "Running federated_main.py with --dataset=$dataset --label_tampering=$label_tamp --weight_tampering=none"
                    python3 src/federated_main.py \
                        --dataset $dataset \
                        --num_users $user \
                        --frac 0.1 \
                        --model cnn \
                        --epochs 100 \
                        --label_tampering $label_tamp \
                        --weight_tampering "none" \
                        --gpu=0 \
                        --iid $iid
                fi
            done
        done
        for weight_tamp in "${WEIGHT_TAMPERING[@]}"; do
            for user in "${USERS[@]}"; do
                RESULTS_FILE="${dataset}_${user}_cnn_1_ltnone_wt${weight_tamp}/results.csv"
                if [ -f "$RESULTS_FILE" ]; then
                    echo "Results already exist at $RESULTS_FILE. Skipping..."
                else
                    echo "Running federated_main.py with --dataset=$dataset --label_tampering=none --weight_tampering=$weight_tamp"
                    python3 src/federated_main.py \
                        --dataset $dataset \
                        --num_users $user \
                        --frac 0.1 \
                        --model cnn \
                        --epochs 100 \
                        --label_tampering "none" \
                        --weight_tampering $weight_tamp \
                        --gpu=0 \
                        --iid $iid
                fi
            done
        done
    done
done
