syntax on

" ===== PATHOGEN =====
call pathogen#infect()
filetype plugin indent on

" ===== VARIABLES =====
set nocompatible
set shell=/bin/zsh
set ofu=syntaxcomplete#Complete
set number
set background=dark
colorscheme PaperColor
set cc=80
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set hidden
set encoding=utf-8
set conceallevel=0
setlocal conceallevel=0
set hlsearch
set pastetoggle=<F5>

" ===== MAPPINGS =====
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F9> :setlocal spell! spelllang=en_us<CR>
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
" Maps F4 to toggle TagBar
map <F4> :TagbarToggle<cr>
" Maps F3 to toggle the TaskList
map <F3> :TaskList<cr>
" HexMan Toggle
map <F6> <Plug>HexManager
" Buffer Management
nmap <leader>l  :bnext<CR>
nmap <leader>h  :bprevious<CR>
nmap <leader>f  :buffer<SPACE>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>p  :b#<CR>
" Basic window splitting
nmap <leader><BAR> :vsplit<CR>
nmap <leader>- :split<CR>
" Trailing Whitespace highlight and removal
match ErrorMsg '\s\+$'
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" ===== STATUSLINE =====
hi StatusLine ctermbg=0 ctermfg=0
" blue (Field 1)
hi User1 ctermbg=5 ctermfg=0
" magenta (Field 2)
hi User2 ctermbg=4 ctermfg=0
" cyan (Field 3)
hi User3 ctermbg=6 ctermfg=0
" brightblack (Background)
hi User5 ctermbg=236 ctermfg=0

function! GitStatus()
    let l:fugitive = fugitive#statusline()
    let l:fugitive = substitute(l:fugitive, '\[', '', 'g')
    let l:fugitive = substitute(l:fugitive, '\]', '', 'g')
    return strlen(l:fugitive) > 0 ? l:fugitive : 'n/a'
endfunction

function! AleLinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
                \'%d Warnings %d Errors',
                \ all_non_errors,
                \ all_errors
                \)
endfunction

let sline=""
" Filename
let sline.="%1*"
let sline.=" %-.80f "
" Git status
let sline.="%2*"
let sline.=" %{GitStatus()} "
" Modified/Readonly
let sline.="%3*"
let sline.=" %{&modified?'+':''}"
let sline.="%{&readonly?'RO':''} "
" left/right separator
"let sline.="%#StatusLine#"
let sline.="%5*"
let sline.="%=""
" Filetype
let sline.="%3*"
let sline.=" %{&filetype} "
" Cursor line and column
let sline.="%2*"
let sline.=" %c:%l (%p%%) "
" ALE status
let sline.="%1*"
let sline.=" %{AleLinterStatus()} "

set laststatus=2
set statusline=%!sline

" ===== AUTOCMD =====
" Omnicomplete
autocmd cursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Set up rust files to use cargo to make/build
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo

" gitcommit
autocmd Filetype gitcommit setlocal spell textwidth=72

"
" ========== PLUGINS ==========
"

" ===== TAGBAR =====
let g:tagbar_left = 1
let g:tagbar_autoclose = 1

" ===== SUPERTAB =====
let g:SuperTabDefaultCompletionType="context"

" ===== NERDTREE =====
map <leader>n :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

" ===== BUFFERGATOR =====
let g:buffergator_viewport_split_policy="T"
let g:buffergator_hsplit_size=10

" ===== MANPAGES =====
source $VIMRUNTIME/ftplugin/man.vim
autocmd FileType man,help wincmd L
nmap K :Man <cword><CR>

" ===== ALE =====
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_echo_msg_format = '[%linter%] %severity% %s'
let g:ale_rust_cargo_use_check=1
let g:ale_linters = {
\    'rust': ['cargo'],
\}

" ===== INDENTLINE =====
let g:indentLine_conceallevel=0

" ===== LATEX =====
set cole=2
let g:tex_conceal=""

" ===== PYDOC =====
let g:pydoc_open_cmd = 'vsplit'
autocmd BufRead,BufNewFile __doc__ wincmd L

" ===== AUTOPEP8 =====
let g:autopep8_disable_show_diff=1

" ===== JEDI =====
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures="2"
let g:jedi#usages_command=""

" ===== RUSTDOC =====
let g:rust_doc#download_rust_doc_dir='$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'
