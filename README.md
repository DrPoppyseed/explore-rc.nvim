# explorerc

explorerc is a (Neo)vim plugin written in Lua that provides an easy overview of the comments inside your vimrc file. The plugin was created in hopes of helping developers in their quest to maintain easily bloatable vimrc files without breaking a sweat.

## Demo

Coming soon...

## Installation

Use any Vim plugin manager of your choice. Some popular ones are [ vim-plug ](https://github.com/junegunn/vim-plug), [ pathogen ](https://github.com/tpope/vim-pathogen), and [ dein ](https://github.com/Shougo/dein.vim).

```
Plug 'DrPoppyseed/explorerc.vim'
```

You can also try installing the plugin with Vim's built-in package support:

```
mkdir -p ~/.vim/pack/DrPoppyseed/start
cd ~/.vim/pack/DrPoppyseed/start
git clone https://github.com/DrPoppyseed/explorerc.vim.git 
vim -u NONE -c "helptags explorerc.vim/doc" -c q
```

## Contributing

See the contribution guidelines from [CONTRIBUTING.md](https://github.com/DrPoppyseed/explorerc.vim/blob/main/CONTRIBUTING.md)

## License

The MIT License (MIT)
