#!/bin/bash

mv ~/.tmux.conf ~/.tmux.conf.bak 
ln -s $(pwd)/.tmux.conf /home/$USER/.tmux.conf
