# vim-xi #

**Work in progress...**

A Vim plugin for [Xi](http://github.com/xi-livecode/xi/), a musical pattern
language written in Ruby.

This plugin communicate with Xi REPL asynchronously, so you need either Vim
8.0+ with `+channel` and `+job`, or Neovim.

## Getting Started ##

1. Open a .xi file
2. Press `<localleader>b` or run `:XiStart` to start REPL
3. Write code and evaluate it `<c-e>` or `<localleader>ee`
4. ???
5. Profit!

## Install ##

Install the plugin manually on your `~/.vim` (or `~/.local/share/nvim` if using
Neovim) or with a plugin manager, like
[vim-plug](https://github.com/junegunn/vim-plug):

```
Plug 'xi-livecode/vim-xi'
```

For now you need to configure your REPL path.
Run first on your terminal:

```
$ whereis xi
xi: /usr/local/bin/xi
```

And define on your `.vimrc`:

```
let g:xi_repl = '/usr/local/bin/xi'
```

## Usage ##

### Bindings ###

* `<localleader>b`: Start Xi REPL
* `<localleader>q`: Stop Xi REPL
* `<localleader>ee` or `<c-e>`: Evaluate paragraph
* `<localleader>h` or `<c-h>`: Silence all streams (hush)

## Configure ##

*to-do*

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/xi-livecode/vim-xi>.  This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

Refer to the [LICENSE](LICENSE) file.
