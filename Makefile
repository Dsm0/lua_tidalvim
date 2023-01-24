mkfile_path := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

prefix=${HOME}

# todo: add checks for the installation of neovim, supercollider, ghc, tidal, and P5hs
install:
	ln -fs $(mkfile_path) $(prefix)/.local/share
	ln -fs $(mkfile_path)/run $(prefix)/.local/bin/tidalvim_lua

