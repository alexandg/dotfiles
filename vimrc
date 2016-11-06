set nocompatible
syntax on
call pathogen#infect()
filetype plugin on
set ofu=syntaxcomplete#Complete
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F9> :setlocal spell! spelllang=en_us<CR>
filetype plugin indent on
set t_Co=256
set background=dark
colorscheme base16-tomorrow-night
set cc=80
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set hidden
set encoding=utf-8
" Remap <Leader> to Space
let mapleader=" "
" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
" Highlight Search results
set hlsearch
" Maps F4 to toggle TagBar
map <F4> :TagbarToggle<cr>
" Maps F3 to toggle the TaskList
map <F3> :TaskList<cr>
" HexMan Toggle
map <F6> <Plug>HexManager
" Paste Auto-Indent Toggle
set pastetoggle=<F5>
" Statusline
set laststatus=2
set statusline=%-.100F
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]  "file format
set statusline+=\ %h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set statusline+=\ %{fugitive#statusline()} "Git info from Fugitive
" Close Omnicomplete window on select
autocmd cursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Tagbar config
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
" Tagbar support for Rust
let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'m:modules,module names',
        \'c:consts,static constants',
        \'T:types,type definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'t:traits,traits',
        \'i:impls,trait implementations',
        \'f:functions,function definitions',
    \]
    \}
" SuperTab
let g:SuperTabDefaultCompletionType="context"
" NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
" BufExplorer
nmap <leader>b  :BufExplorer<CR>
nmap <leader>l  :bnext<CR>
nmap <leader>h  :bprevious<CR>
nmap <leader>f  :buffer 
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>p  :b#<CR>
" Basic window splitting
nmap <leader><BAR> :vsplit<CR>
nmap <leader>- :split<CR>
" Manpages
source $VIMRUNTIME/ftplugin/man.vim
autocmd FileType man,help wincmd L
nmap K :Man <cword><CR>
" Pydoc plugin
let g:pydoc_open_cmd = 'vsplit' 
autocmd BufRead,BufNewFile __doc__ wincmd L
" Turn off LaTeX conceal for things
set cole=2
let g:tex_conceal=""
" Trailing Whitespace highlight and removal
match ErrorMsg '\s\+$'
nnoremap <Leader>rtw :%s/\s\+$//e<CR>
" Syntastic stuff
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -std=c11'
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
" Racer
let g:racer_cmd = $HOME . "/src/racer/target/release/racer"
let $RUST_SRC_PATH = $HOME . "/src/rust/src/"
" Set cc based on file type
"autocmd FileType rust setlocal cc=100
" Set up rust files to use cargo to make/build
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
" Config autopep8
let g:autopep8_disable_show_diff=1
