" iMproved powers activate!
set nocompatible

filetype off

" syntax highlighting
syntax on

set shell=bash

" 2 spaces per tab
set tabstop=2

" 2 spaces per indent
set shiftwidth=2

" better command-line completion
set wildmenu

" show partial commands in the last line
set showcmd

" show search highlights
set hlsearch

" highlight search as you type
set incsearch

" ignore case in searches, except when capital letters are given
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
"set autoindent
set noautoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
"set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
"set cmdheight=2

" Display line numbers on the left
set number

" Turn on line wrapping
set wrap

" Always show 3 lines of context around the cursor line
set scrolloff=3

" Set the terminal title
set title

"Set the colorscheme.
" Builtins:
"  blue.vim
"  darkblue.vim
"  default.vim
"  delek.vim < NICE
"  desert.vim
"  elflord.vim
"  evening.vim
"  koehler.vim
"  morning.vim
"  murphy.vim
"  pablo.vim
"  peachpuff.vim
"  ron.vim
"  shine.vim
"  slate.vim
"  torte.vim < NICE FOR DARK
"  zellner.vim
" also see https://github.com/tpope/vim-vividchalk for vividchalk
colorscheme torte

" Trim the end of the line for the entire doc
command! Trim :%s/\s\+$//
