" <Vundle>
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/plugin')
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-ruby/vim-ruby'
Plugin 'elixir-editors/vim-elixir'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Shougo/neocomplete'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mileszs/ack.vim'
call vundle#end()            " required
filetype plugin indent on    " required
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve r
" </Vundle End>
" <Plugins>
"   <nerdtree>
let g:NERDTreeWinSize = 32
"   </nerdtree>
"   <neocomplete>
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 0
let g:neocomplete#disable_auto_complete = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
set dictionary+=~/.vim/dict/ruby.dict
let g:neocomplete#sources#dictionary#dictionaries = {
\ 'default' : '',
\ 'ruby' : $HOME.'/.vim/dict/ruby.dict',
\ }
" Select by CR
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-n> neocomplete#start_manual_complete()."\<C-n>"
"   </neocomplete>
"   <vim-airline>
let g:airline_theme='simple'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"   </vim-airline>
" </Plugins>

set backspace=indent,eol,start
set number
set ts=2
set sts=2
set sw=2
set colorcolumn=128
set expandtab
set mouse=v
set nowrap
set hlsearch incsearch
set showmode showmatch
set autoindent
set smartindent

highlight ColorColumn ctermbg=7

syntax enable
syntax on

let mapleader=','

function! MyMatchBracketJump()
  let dq_match = search('{\|[\| \|(', 'b')
endfunction

nnoremap ; :
nnoremap ZA :wa<cr>
nnoremap ZX :wqa<cr>
nnoremap ZD :qa!<cr>
imap     <c-c> <c-f>
inoremap <c-d> <esc>ddi
inoremap <c-f> <right><esc>
nnoremap <c-f> <esc>
vnoremap <c-f> <esc>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>
nnoremap <c-l> 8zh
nnoremap <c-n> :NERDTree<cr>
inoremap <c-p> <esc>pi
nnoremap <c-p> 8zl
inoremap <c-w> <esc><c-w>
inoremap <leader>ad =><space>
inoremap <leader>al <space><-<space>
inoremap <leader>ap <bar>><space>
inoremap <leader>ar <space>->
nnoremap <leader>a :set mouse=a<cr>
inoremap <leader>bb ()<left>
inoremap <leader>bs []<left>
inoremap <leader>bc {}<left>
inoremap <leader>ba <><left>
inoremap <leader>db "<esc>:call MyMatchBracketJump()<cr>a"<esc>f"a
inoremap <leader>dw "<esc>bi"<esc>wwa
nnoremap <leader>e :source $MYVIMRC<cr>
nnoremap <leader>h <c-w>4+
inoremap <leader>k <cr><up><esc>ddp<up>i
nnoremap <leader>l :set list<cr>
inoremap <leader>m <esc>d0i<bs><del>
nnoremap <leader>nh <c-w>4-
nnoremap <leader>nl :set nolist<cr>
nnoremap <leader>np :set nopaste<cr>
nnoremap <leader>nt :set noexpandtab<cr>
nnoremap <leader>nw <c-w>8<
inoremap <leader>o <esc>o
nnoremap <leader>p :set paste<cr>
nnoremap <leader>re :%s###gc<left><left><left><left>
nnoremap <leader>rs :%s#[ ]\+$##gc<cr>
inoremap <leader>sb '<esc>:call MyMatchBracketJump()<cr>a'<esc>f'a
inoremap <leader>sw '<esc>bi'<esc>wwa
nnoremap <leader>t :set expandtab<cr>
inoremap <leader>u <esc>ui
nnoremap <leader>v :set mouse=v<cr>
nnoremap <leader>w <c-w>8>
nnoremap <leader>y "0p
vnoremap // y/<c-r>"<cr>
vnoremap /a y:Ack<space><c-r>"<cr>
vnoremap /r y:%s#<c-r>"##gc<left><left><left>

" Command vary with file's type
augroup file_types
  autocmd!
  autocmd FileType python,ruby,sh,elixir,coffee noremap <leader>c I#<space><esc>
  autocmd FileType cpp,php,javascript noremap <leader>c I//<space><esc>
  autocmd FileType sql,lua noremap <leader>c I--<space><esc>
  autocmd FileType erlang noremap <leader>c I%<space><esc>

  autocmd FileType eruby,eelixir inoremap <leader>eq <%=<space><space>%><left><left><left>
  autocmd FileType eruby,eelixir inoremap <leader>ee <%<space><space>%><left><left><left>
augroup END

" Command at switching mode
augroup mode_actions
  autocmd!
  autocmd InsertEnter,InsertLeave * set cuc!
augroup END

" NerdTreeGit symbol using
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeGlyphReadOnly = '[RO]'
