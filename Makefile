SHELL=/bin/bash

usage:
	@echo "Usage: "
	@echo "        make all"
	@echo "        make vimrc"
	@echo "        make v g"

b:
	cp ~/.bashgem .

g:
	cp ~/.gitconfig .

nvim:
	cp ~/.config/nvim/init.vim nvim.init.vim

t:
	cp ~/.tmux.conf .

v: vimrc nvim

vimrc:
	cp ~/.vimrc .

all: v b g t

.PHONY: blender
blender:
	@echo "Run: bpy.utils.user_resource('CONFIG')"
	cp ~/Library/Application\ Support/Blender/2.81/config/startup.blend  programs.config/blender/.
	cp ~/Library/Application\ Support/Blender/2.81/config/userpref.blend programs.config/blender/.

.PHONY: juliarc
juliarc:
	cp ~/.julia/config/startup.jl .
