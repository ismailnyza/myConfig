#!/usr/bin/env bash

echo "🧠 Checking Neovim plugin health..."

if ! command -v nvim &>/dev/null; then
  echo "❌ Neovim not installed"
  exit 0
fi

nvim --headless +"echo 'Neovim OK'" +qall

