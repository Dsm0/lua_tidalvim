# lua_tidalvim


## Requirements
- [stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/)


## Install Notes

This tool was made with my personal tidal setup in mind. The `run` script will look for ` ~/.config/tidal/init/BootTidal.hs`, but this path can easily be changed.

```
cd Tidal
stack install
cd ..
make
```
When you first run `tidalvim_lua`, you might get some error about `luasnip`.
Just run `:PlugInstall` once and you shouldn't encounter it again.

`make` links folders to `~/.local/share`, and exceutable scripts to `~/.local/bin`
so if you don't already have that folder on your path, just add
`export PATH=$PATH:~/.local/bin`
to your `.bashrc` or `.zshrc` or whatever you use

# TODO
- simplify fxBindings system
- add more support for config files specifying fxBindings

- add all functions as ex-commands

## Would be nice:
- add more commonly used structures as snippets
- make snippets for all possible parameters 