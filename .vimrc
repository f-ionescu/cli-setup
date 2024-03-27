set laststatus=2
set rnu nu
syntax on

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

colorscheme delek
