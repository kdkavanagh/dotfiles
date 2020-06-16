DEFAULT_GOAL: help

all: tmux vim bash git ## Install everything


~/.tmux.conf: $(PWD)/tmux/tmux.conf
ifeq (, $(shell which tmux))
	@echo "Installing tmux"
	@wget -O /tmp/tmux.tgz https://github.com/tmux/tmux/releases/download/3.1/tmux-3.1.tar.gz
	@mkdir -p /tmp/tmux-build
	@tar -zxf /tmp/tmux.tgz -C /tmp/tmux-build
	@cd /tmp/tmux-build/tmux-3.1 && ./configure && make && sudo make install
endif
	@rm -rf $@
	@ln -s $< $@
	
.PHONY: tmux
tmux: ~/.tmux.conf ## Install TMUX and tmux.conf


~/.vim/bundle/Vundle.vim:
	@git clone https://github.com/VundleVim/Vundle.vim.git $@

~/.vundler.vim: $(PWD)/vim/vundler.vim ~/.vim/bundle/Vundle.vim
	@rm -rf $@
	@ln -s $< $@
	@vim -u $@ +PluginInstall +qall

~/.vimrc: $(PWD)/vim/vimrc ~/.vundler.vim
	@rm -rf $@
	@ln -s $< $@

.PHONY: vim
vim: ~/.vimrc ## Install awesome_vimrc from github

~/.bashrc: | $(PWD)/bash/bashrc.sh
	@cp $(PWD)/bash/bashrc.sh $@

~/.bashrcExtras.sh: $(PWD)/bash/bashrcExtras.sh | ~/.bashrc
	@rm -rf $@
	@envsubst < $< > $@
	@grep -qxF 'source $@' ~/.bashrc || echo 'source $@' >> ~/.bashrc

~/.gitShortcut.sh: $(PWD)/scripts/gitShortcut.sh | ~/.bashrc
	@chmod +x $<
	@$<
	@grep -qxF 'source $@' ~/.bashrc || echo 'source $@' >> ~/.bashrc

.PHONY: bash
bash: ~/.bashrcExtras.sh ~/.gitShortcut.sh ## Install Bash shortcuts

~/.gitconfig: $(PWD)/scripts/setupGitconfig.sh
	@chmod +x $<
	@$<

.PHONY: git
git: ~/.gitconfig ## Install gitconfig

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY:clean
clean: ## Remove everything this makefile installs.  Moves ~/.bashrc to ~/.bashrc.bck
	@rm -rf ~/.gitShortcut.sh
	@rm -rf ~/.gitconfig
	@rm -rf ~/.bashrcExtras.sh
	@rm -rf ~/.vim*
	@rm -rf ~/.tmux.conf
	@mv ~/.bashrc ~/.bashrc.bck
