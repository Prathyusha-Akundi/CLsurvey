#!/usr/bin/env bash

# DEMO showing how to get survey results
# First make sure your project is configured: See /README.md
# Install requirements, config project paths, data preperation of iNaturalist
MY_PYTHON=python
EXEC=./framework/main.py

# Add root path
this_script_path=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P) # Change location to current script
root_path=${this_script_path}/../src/
export PYTHONPATH=$PYTHONPATH:$root_path
echo "Project src root '${root_path}' added to Python path"

# params
gridsearch_name='reproduce'      # Give arbitrary gridsearch name
ds_name='inat'                  # Dataset, e.g. {tiny, tinyhardeasy, inat, inatrelunrel}
model='alexnet_pretrained'      # Other survey models:
                                # iNaturalist/RecogSeq:{alexnet_pretrained},
                                # TinyImagenet: {small: small_VGG9_cl_512_512,
                                #                base: base_VGG9_cl_512_512,
                                #                wide: wide_VGG9_cl_512_512,
                                #                deep: deep_VGG22_cl_512_512}

lr_grid='1e-2,5e-3,1e-3,5e-4,1e-4'
boot_lr_grid=lr_grid

# First task modeldump for SI
method_name='SI'
$MY_PYTHON $EXEC --runmode "first_task_basemodel_dump" \
                 --gridsearch_name ${gridsearch_name} --method_name ${method_name} --ds_name ${ds_name} \
                 --lr_grid ${lr_grid} --boot_lr_grid ${boot_lr_grid} \
                 ${model}

# Run any method using this first task model (enable testing by --test argument)
method_name='SI' # Choose any method name (see methods/method.py for method names)
$MY_PYTHON $EXEC --gridsearch_name ${gridsearch_name} --method_name ${method_name} --ds_name ${ds_name} \
                 --lr_grid ${lr_grid} --boot_lr_grid ${boot_lr_grid} \
                 --test ${model}

# Methods with possible deviations from default hyperparam values
method_name='EBLL'
$MY_PYTHON $EXEC --gridsearch_name ${gridsearch_name} --method_name ${method_name} --ds_name ${ds_name} \
                 --static_hyperparams 'def;def;1e-1,1e-2;200,500' --lr_grid ${lr_grid} --boot_lr_grid ${boot_lr_grid} \
                 --test ${model}