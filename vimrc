set nocompatible
syntax on
call pathogen#infect()
set shell=/bin/zsh
filetype plugin on
set ofu=syntaxcomplete#Complete
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F9> :setlocal spell! spelllang=en_us<CR>
filetype plugin indent on
set t_Co=256
set background=dark
colorscheme apprentice
set cc=80
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set hidden
set encoding=utf-8
set conceallevel=0
setlocal conceallevel=0
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
function! GitStatus()
    let l:fugitive = fugitive#statusline()
    let l:fugitive = substitute(l:fugitive, '\[', '', 'g')
    let l:fugitive = substitute(l:fugitive, '\]', '', 'g')
    return strlen(l:fugitive) > 0 ? ' > '.l:fugitive : ''
endfunction
function! AleStatus()
    let l:alestatus = ale#statusline#Status()
    return l:alestatus ==? "OK" ? '' : ' < '.l:alestatus
endfunction
hi StatusLine ctermbg=238 ctermfg=231
set laststatus=2
set statusline=
" Filename
set statusline+=\ %-.80f
" Git status
set statusline+=%{GitStatus()}
" Modified/Readonly
set statusline+=%{&modified?'\ +':''}
set statusline+=%{&readonly?'\ RO':''}
set statusline+=\ \>
" left/right separator
set statusline+=%=
" Modified/Readonly
" Filetype
set statusline+=\ \<\ %{&filetype}
" File encoding
set statusline+=\ \<\ %{&fileencoding}
" Cursor line and column
set statusline+=\ \<\ %c:%l\ (%p%%)
" ALE status
"set statusline+=\ \<\ %{ALEGetStatusLine()}
set statusline+=%{AleStatus()}
set statusline+=\  " Padding
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
" Buffer Management
nmap <leader>l  :bnext<CR>
nmap <leader>h  :bprevious<CR>
nmap <leader>f  :buffer<SPACE>
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
" Racer
let $RUST_SRC_PATH = $HOME . "/src/rust/src/"
" Set up rust files to use cargo to make/build
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
" Config autopep8
let g:autopep8_disable_show_diff=1
" jedi python autocomplete only when asked not by default
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures="2"
let g:jedi#usages_command=""
" ale error navigation commands
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_echo_msg_format = '[%linter%] %severity% %s'
let g:ale_rust_cargo_use_check=1
let g:ale_linters = {
\    'rust': ['cargo'],
\}
let g:indentLine_conceallevel=0
" Tagbar support for Markdown
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : $HOME . '/src/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
