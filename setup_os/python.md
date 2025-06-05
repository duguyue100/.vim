# Common packages

For development related packages, I'm switching to use `uv`, therefore, you only need
to install `uv` by
``bash
pip install uv
```

**TODO**: The following packages can be refactored to a `pyproject.toml` file for better management.

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
        pyinstrument types-dataclasses==0.1.7 jupyter-nbextensions-configurator \
        yamllint
    ```

# Ubuntu

1. If you have NVIDIA GPU, install this package for a better visualization
    ```bash
    pip install nvitop
    ```

# macOS

No more packages to install

---
After installing all the packages, please proceed to [Other Apps](./other_apps.md).
