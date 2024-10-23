# Common packages

1. Essentials
    ```bash
    pip install \
        matplotlib seaborn numpy scipy scikit-learn scikit-image opencv-python \
        pandas h5py tqdm
    ```

2. Development related packages
    ```bash
    pip install \
        pynvim jedi-language-server pre-commit mypy==1.7.0 types-setuptools \
        pyupgrade docformatter darglint ruff typos==1.19.0 pandas-stubs \
        pyinstrument types-dataclasses==0.1.7 jupyter-nbextensions-configurator
    ```

# Ubuntu

1. If you have NVIDIA GPU, install this package for a better visualization
    ```bash
    pip install nvitop
    ```

2. PyTorch

# macOS

1. PyTorch
    ```bash
    pip install torch torchvision torchaudio
    ```

After installing all the packages, please proceed to [Other Apps](./other_apps.md)
to finish the final steps of installation.
