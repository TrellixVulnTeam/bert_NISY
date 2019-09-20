#!/bin/bash
export CUDA_VISIBLE_DEVICES=0

paragraph_extraction ()
{
    SOURCE_DIR=$1
    TARGET_DIR=$2
    echo "Start paragraph extraction, this may take a few hours"
    echo "Source dir: $SOURCE_DIR"
    echo "Target dir: $TARGET_DIR"

    echo "Processing testset"
    cat $SOURCE_DIR/testset/test_set.json | python paragraph_extraction.py test \
            > $TARGET_DIR/testset/final_test_set.json
    
    echo "Processing trainset"
    cat $SOURCE_DIR/trainset/pre_train.json | python paragraph_extraction.py train \
            > $TARGET_DIR/trainset/final_train_set.json
    

    echo "Processing devset"
    cat $SOURCE_DIR/devset/pre_dev.json | python paragraph_extraction.py test \
            > $TARGET_DIR/devset/final_dev_set.json


    echo "Paragraph extraction done!"
}


PROCESS_NAME="$1"
case $PROCESS_NAME in
    --para_extraction)
    # Start paragraph extraction 
    if [ ! -d ../data ]; then
        echo "Please download the preprocessed data first (See README - Preprocess)"
        exit 1
    fi
    paragraph_extraction  ../data  ../data/extracted
    ;;
    --prepare|--train|--evaluate|--predict)
        # Start Paddle baseline
        python run.py $@
    ;;
    *)
        echo $"Usage: $0 {--para_extraction|--prepare|--train|--evaluate|--predict}"
esac
