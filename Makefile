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

.PHONY: blender
blender:
	@echo "Run: bpy.utils.user_resource('CONFIG')"
	cp ~/Library/Application\ Support/Blender/2.80/config/startup.blend  programs.config/blender/.
	cp ~/Library/Application\ Support/Blender/2.80/config/userpref.blend programs.config/blender/.

