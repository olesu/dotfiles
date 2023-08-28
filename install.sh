#!/usr/bin/env bash

cat "${BASH_SOURCE%/*}/zshrc" > ~/.zshrc
cat "${BASH_SOURCE%/*}/bash_profile" > ~/.bash_profile
cat "${BASH_SOURCE%/*}/bashrc" > ~/.bashrc
