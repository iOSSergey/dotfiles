#!/usr/bin/env bash

set -e

ln -sf "$PWD/.bashrc" ~/.bashrc
ln -sf "$PWD/.bash_aliases" ~/.bash_aliases
ln -sf "$PWD/.bash_functions" ~/.bash_functions

source ~/.bashrc
