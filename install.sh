#!/bin/bash

if grep -qEi "(Microsoft|WSL)" /proc/version; then
  echo "export TMX_ROOT_DIR=/mnt/c" >> ~/.zshrc
else
  echo "export TMX_ROOT_DIR=/" >> ~/.zshrc
fi

mv ~/.tmux.conf ~/.tmux.conf.bak 
ln -s $(pwd)/.tmux.conf /home/$USER/.tmux.conf
