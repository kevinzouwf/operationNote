#!/bin/bash

#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#cp ./vimrc ~/.vim/vimrc
#ln ~/.vimrc ~/.vim/vimrc
#vim +PluginInstall +qall
tar zxf vimconfig.tar.gz -C ~/
ln -fs $(pwd)/vimrc ~/.vim/vimrc
echo "dont forget to install / update YoucompleteMe"

