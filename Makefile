
switch_to_zsh:
	chsh -s $(which zsh)

ubuntu_docker:
	docker pull ubuntu:22.04
	docker run -it --rm ubuntu:22.04 bash

ubuntu_install:
	# general software install
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get -y install build-essential binutils cmake curl tmux unzip openssh-server xclip zsh ripgrep htop mc terminator clang-format ruby-full curl zoxide
	# latest git
	sudo apt-add-repository -y ppa:git-core/ppa
	sudo apt-get update
	sudo apt-get -y install git
	# SQLite
	sudo apt-get update
	sudo apt-get -y install sqlite3
	sudo apt-get -y install sqlitebrowser

nvidia_driver:
	# nvidia driver
	sudo add-apt-repository -y ppa:graphics-drivers/ppa
	sudo apt-get update
	sudo apt-get -y install nvidia-driver-$(NV_DRIVER_VERSION)  # select your version
	sudo apt-get -y install nvidia-modprobe  # for nvidia-docker

neovim_linux:
	mkdir -p $(HOME)/bin
	cd $(HOME)/bin
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	mv nvim.appimage nvim

install_homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

mac_install:
	brew install automake bison cmake ffmpeg gcc git libuv neovim pdf2htmlex tmux wget zeromq ripgrep lazygit htop midnight-commander clang-format ruby lsd zoxide shellcheck node cairo pango fd bottom
	# SQLite
	brew install sqlite 
	brew install --cask db-browser-for-sqlite
	# TeX
	brew install texlive
	brew install latexit
	# node
	npm install --global yarn

py_commons:
	pip install matplotlib seaborn
	pip install numpy scipy scikit-learn scikit-image opencv-python
	pip install pandas h5py tqdm

py_coding:
	pip install pynvim -U
	pip install neovim -U
	pip install jedi-language-server -U
	pip install pre-commit -U
	pip install mypy==0.961 types-setuptools -U
	pip install flake8 -U
	pip install black==22.3.0 -U
	pip install reorder-python-imports -U
	pip install pyupgrade -U
	pip install docformatter -U
	pip install darglint -U
	# if use a higher version of black, this might not be a problem
	pip install click==8.0.4
	pip install cpplint -U
	# python profiler
	pip install pyinstrument -U
	# Jupyter
	pip install jupyter-nbextensions-configurator

py_nvitop:
	pip install nvitop

mac_pytorch:
	pip install torch torchvision torchaudio

linux_pytorch:
	conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
