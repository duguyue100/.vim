#!/usr/bin/env bash

case $option in
    conda)
        # Check if conda is installed
        if command -v conda &> /dev/null; then
            echo "🧚 Conda is already installed."
            exit 0
        fi

        echo "🧚 Installing Conda..."
        # Download miniconda installer through wget
        if [[ $(uname) != "Darwin" ]]; then
            CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py310_24.3.0-0-Linux-x86_64.sh
        else
            CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py310_24.3.0-0-MacOSX-arm64.sh
        fi
        wget $CONDA_URL -O "${HOME}"/miniconda.sh

        # Install miniconda
        bash "${HOME}"/miniconda.sh -b -p "${HOME}"/miniconda3
        rm "${HOME}"/miniconda.sh
        ;;

    python_commons)
        pip install \
            matplotlib seaborn numpy scipy scikit-learn scikit-image opencv-python \
            pandas h5py tqdm

        # if it's nvidia-smi is available, install nvitop
        if command -v nvidia-smi &> /dev/null; then
            pip install nvitop
        fi
        ;;

    python_dev)
        pip install \
            pynvim neovim jedi-language-server pre-commit mypy==1.7.0 types-setuptools \
            pyupgrade docformatter darglint ruff typos==1.19.0 pandas-stubs \
            pyinstrument types-dataclasses==0.1.7 jupyter-nbextensions-configurator
        ;;

    pytorch)
        if [[ $(uname) != "Darwin" ]]; then
            conda install -y pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
        else
            pip install torch torchvision torchaudio
        fi
        ;;
    esac
