" <vim-plug>
call plug#begin('~/.vim/plugged')
if $USER != "root"
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
endif
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mileszs/ack.vim'
Plug 'terryma/vim-smooth-scroll'
Plug 'mccg/vim-elixir', { 'for': 'elixir' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
Plug 'mattn/emmet-vim'
call plug#end()
" :PlugInstall
" :PlugClean
" </vim-plug>

" <deoplete>
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = expand('~/.pyenv/versions/3.7.0/bin/python')
" </deoplete>

" <Plugins>
"   <nerdtree>
let g:NERDTreeWinSize = 32
"   </nerdtree>
"   <vim-airline>
let g:airline_theme='simple'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"   </vim-airline>
" </Plugins>

function! SetTabs(et, n)
  exec "set ts=".a:n
  exec "set sts =".a:n
  exec "set sw=".a:n
  if a:et == "et" | set et
  elseif a:et == "noet" | set noet | set list
  endif
endfunction

call SetTabs("et", 2)
scriptencoding utf-8
set encoding=utf-8
set listchars=tab:│·,trail:·,extends:→
set backspace=indent,eol,start
set number
set colorcolumn=128
set mouse=v
set nowrap
set hlsearch incsearch
set showmode showmatch
set autoindent
set smartindent
set background=dark

highlight ColorColumn ctermbg=240
language en_US

syntax enable
syntax on

let mapleader=','

function! MyMatchBracketJump()
  let dq_match = search('{\|[\| \|(', 'b')
endfunction

function! MyMatchSpaceJump()
  let dq_match = search(' ', 'b')
endfunction

command! -count -nargs=* TS   sp | set nonu | exe 'term' | exe 'normal! a'
command! -count -nargs=* VTS vsp | set nonu | exe 'term' | exe 'normal! a'

nnoremap ; :
nnoremap TS :TS<cr>
nnoremap TT :VTS<cr>
nnoremap ZA :wa<cr>
nnoremap ZX :wqa<cr>
nnoremap ZD :qa!<cr>
nnoremap ZB :badd<space>
imap     <c-c> <c-f>
inoremap <c-d> <esc>ddi
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<cr>
inoremap <c-f> <right><esc>
nnoremap <c-f> <esc>
tnoremap <c-f> <c-\><c-n>
vnoremap <c-f> <esc>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>
nnoremap <c-l> 8zh
nnoremap <c-n> :NERDTree<cr>
inoremap <c-p> <esc>pi
nnoremap <c-p> 8zl
nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<cr>
inoremap <c-w> <esc><c-w>
tnoremap <c-w> <c-\><c-n><c-w>
vnoremap <leader>a y:Ack<space><c-r>"<cr>
inoremap <leader>aa <esc>A
inoremap <leader>ad =><space>
inoremap <leader>al <-<space>
inoremap <leader>ap <bar>><space>
inoremap <leader>ar ->
nnoremap <leader>a :set mouse=a<cr>
inoremap <leader>ba <><left>
inoremap <leader>bb ()<left>
inoremap <leader>bc {}<left>
inoremap <leader>bs []<left>
inoremap <leader>db "<esc>:call MyMatchBracketJump()<cr>a"<esc>f"a
inoremap <leader>ds "<esc>:call MyMatchSpaceJump()<cr>a"<esc>f"a
inoremap <leader>dw "<esc>bi"<esc>wwa
nnoremap <leader>e :source $MYVIMRC<cr>
nnoremap <leader>h <c-w>4+
inoremap <leader>j <esc>Ji
inoremap <leader>k <cr><up><esc>ddp<up>i
vnoremap <leader>l "*y
inoremap <leader>m <esc>d0i<bs><del>
nnoremap <leader>nh <c-w>4-
nnoremap <leader>nl :set nolist<cr>
nnoremap <leader>np :set nopaste<cr>
nnoremap <leader>nt :set noexpandtab<cr>
nnoremap <leader>nw <c-w>8<
inoremap <leader>o <esc>o
inoremap <leader>O <esc>O
inoremap <leader>p <esc>"*pa
nnoremap <leader>p "*p
vnoremap <leader>p "*p
vnoremap <leader>r y:%s#<c-r>"##gc<left><left><left>
nnoremap <leader>re :%s###gc<left><left><left><left>
nnoremap <leader>rs :%s#[ ]\+$##gc<cr>
inoremap <leader>sb '<esc>:call MyMatchBracketJump()<cr>a'<esc>f'a
nnoremap <leader>sl :set list<cr>
nnoremap <leader>sp :set paste<cr>
inoremap <leader>ss '<esc>:call MyMatchSpaceJump()<cr>a'<esc>f'a
inoremap <leader>sw '<esc>bi'<esc>wwa
nnoremap <leader>t :set expandtab<cr>
inoremap <leader>u <esc>ui
inoremap <leader>U <esc>wbgUeea
nnoremap <leader>v :set mouse=v<cr>
nnoremap <leader>w <c-w>8>
vnoremap <leader>/ y/<c-r>"<cr>

" Autocommand vary with file's type
augroup file_types
  autocmd!
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=dockerfile

  autocmd FileType python,ruby,sh               noremap <leader>c I#<space><esc>
  autocmd FileType elixir,coffee,yaml           noremap <leader>c I#<space><esc>
  autocmd FileType julia,dockerfile,conf        noremap <leader>c I#<space><esc>
  autocmd FileType cpp,php,javascript,go,rust   noremap <leader>c I//<space><esc>
  autocmd FileType sql,lua                      noremap <leader>c I--<space><esc>
  autocmd FileType erlang,tex,cls,sty           noremap <leader>c I%<space><esc>

  autocmd FileType eruby,eelixir                inoremap <leader>ee <%<space><space>%><left><left><left>
  autocmd FileType yaml                         inoremap <leader>ee {%<space><space>%}<left><left><left>
  autocmd FileType elixir                       inoremap <leader>em %{}<left>
  autocmd FileType text                         inoremap <leader>el `<space><>`_<left><left><left><left><left>
  autocmd FileType yaml                         inoremap <leader>el {{<space><space>}}<left><left><left>
  autocmd FileType eruby,eelixir                inoremap <leader>eq <%=<space><space>%><left><left><left>
  autocmd FileType yaml                         inoremap <leader>eq {%=<space><space>%}<left><left><left>
  autocmd FileType elixir                       inoremap <leader>es {}<esc>bbi%<esc>ww<right>i
  autocmd FileType elixir,ruby,coffee           inoremap <leader>ev #{}<left>

  autocmd FileType go,make                      :call SetTabs("noet", 4)
  autocmd FileType python,rust                  :call SetTabs("et", 4)
  autocmd FileType css,scss                     :call SetTabs("et", 4)
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
