# lua_tidalvim


## Requirements
- [stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/)


## Install Notes

```
cd Tidal
stack install
cd ..
make
```
When you first run `tidalvim_lua`, you'll get some error about `luasnip`.
Just run `:PlugInstall` once and you shouldn't encounter it again.

`make` links folders to `~/.local/share`, and exceutable scripts to `~/.local/bin`
so if you don't already have that folder on your path, just add
`export PATH=$PATH:~/.local/bin`
to your `.bashrc` or `.zshrc` or whatever you use


# TODO
- simplify fxBindings
	- could just make a dict with evrey possible binding
- add support for config files specifying fxBindings

- full ex-command support


## Would be nice:
- add more commonly used structures as snippets
- make snippets for all possible parameters 