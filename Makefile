
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
	ln -s ~/.vim ~/.config/nvim

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

terminal_config:
	# Darglint docstring linter support:
	ln -s ~/.vim/.darglint ~/.darglint

	# tmux config
	ln -s ~/.vim/tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

	# Install Powerline
	pip install powerline-status
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts
	./install.sh
	cd ..
	rm -rf fonts

	# Install tmux plugins
	~/.tmux/plugins/tpm/bin/install_plugins

py_nvitop:
	pip install nvitop

mac_pytorch:
	pip install torch torchvision torchaudio

linux_pytorch:
	conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

omz_install:
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	@if [ $(shell uname) = "Linux" ]; then \
		ln -s ~/.vim/zshrc_linux ~/.zshrc; \
	elif [ $(shell uname) = "Darwin" ]; then \
		ln -s ~/.vim/zshrc_mac ~/.zshrc; \
	fi
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

omz_plugins:
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
	git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

