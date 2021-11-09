" Setup plugins
lua require('plugins')

" General
set nocompatible
set number
filetype on
filetype plugin on
filetype indent on
syntax on
set hidden

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Spacing
set cc=80
set autoindent
set cindent
"set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" Highlight Trailing Whitespace
match ErrorMsg '\s\+$'

" Search
set hlsearch

" Code Folding
set foldmethod=manual

" Shell
set shell=fish

" Colors
set background=dark
colorscheme palenight

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

" Statusline
set laststatus=2

" Mappings
let mapleader=" "

" Disable Arrow Keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Buffer Management
nmap <leader>l  :bnext<CR>
nmap <leader>h  :bprevious<CR>
nmap <leader>f  :buffer<SPACE>
nmap <leader>bq :bp <BAR> bd #<CR>
"nmap <leader>p  :b#<CR>

" Splits
nmap <leader><BAR> :vsplit<CR>
nmap <leader>-     :split<CR>

" Commands
nnoremap <leader>rtw :%s/\s\+$//e<CR>

" Plugin Configs

" mucomplete
set completeopt+=menuone
set shortmess+=c
set belloff+=ctrlg

" ALE
let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\  'python': ['black'],
\  'cpp': ['clang-format'],
\  'rust': ['rustfmt'],
\  'go': ['gofmt'],
\}

" nvim-tree
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 0,
    \ 'folder_arrows': 1,
    \ }

let g:nvim_tree_icons = {
    \ 'folder': {
    \   'arrow_open': "▼",
    \   'arrow_closed': "▶",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   },
    \ }
