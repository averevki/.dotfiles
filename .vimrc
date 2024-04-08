" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Show current line number
"set number
" Show relative line numbers
"set relativenumber

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" While searching though a file incrementally highlight matching characters as you type.
set incsearch
" Show matching words during a search.
set showmatch
" Use highlighting when doing a search.
set hlsearch

" Show partial command you type in the last line of the screen.
set showcmd
" Set the commands to save in history default number is 20.
set history=50

" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Save cursor position
autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

