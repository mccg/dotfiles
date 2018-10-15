SHELL=/bin/bash

usage:
	@echo "Usage: "
	@echo "        make all"
	@echo "        make vimrc"
	@echo "        make vimdict"

vimrc:
	cp ~/.vimrc .

vimdict:
	@DICTS=`ls dict/*`; \
	for dict in $${DICTS[@]}; \
	do \
	  echo "-> Make $$dict"; \
	  cat $$dict | sort -Vu > $${dict}.bak; \
	  mv $${dict}.bak $$dict; \
	done

v: vimrc vimdict

b:
	cp ~/.bashgem .

g:
	cp ~/.gitconfig .

t:
	cp ~/.tmux.conf .

all: v b g t
