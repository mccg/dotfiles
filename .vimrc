" --- Vundle Begin ---
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/plugin')
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-ruby/vim-ruby'
Plugin 'Shougo/neocomplete'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mileszs/ack.vim'
call vundle#end()            " required
filetype plugin indent on    " required
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve r
" --- Vundle End ---
" -> neocomplete begin
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Select by CR
noremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" -> vim-airline begin
let g:airline_theme='simple'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
" --- Plugin End ---
set number
set ts=4
set sts=4
set sw=4
set colorcolumn=128
set expandtab
set mouse=a
set nowrap
set hlsearch incsearch
set showmode showmatch
set autoindent
set smartindent

highlight ColorColumn ctermbg=7

syntax enable
syntax on
let mapleader=','

inoremap <c-j> <Right><esc>
vnoremap <c-j> <esc>
inoremap <c-f> <Right><esc>
vnoremap <c-f> <esc>
nnoremap <c-f> <esc>
inoremap <c-d> <esc>ddi
inoremap <c-p> <esc>pi
nnoremap <c-n> :NERDTree<cr>
inoremap <c-w> <esc><c-w>
nnoremap ; :
nnoremap <C-k> 8zh
inoremap <C-k> <esc>8zhi
nnoremap <C-l> 8zl
inoremap <C-l> <esc>8zli
nnoremap <leader>e :source $MYVIMRC<cr>
nnoremap <leader>v :set mouse=v<cr>
nnoremap <leader>a :set mouse=a<cr>
nnoremap <leader>p :set paste<cr>
nnoremap <leader>n :set nopaste<cr>
nnoremap <leader>s :%s###gc<left><left><left><left>
inoremap <leader>m <esc>d0i<bs><del>

" Erb using
" iabbrev <%= <%=  %><left><left><left>
iabbrev <% <% %><left><left><left>

" scripts using
augroup filetype_scripts
  autocmd!
  autocmd FileType ruby inoremap {}<space> {<space><space>}<Left><Left>
  autocmd FileType python,ruby,sh noremap <leader>c I#<space><esc>
  autocmd FileType cpp noremap <leader>c I//<space><esc>
  autocmd FileType sql noremap <leader>c I--<space><esc>
  autocmd FileType sql,ruby,sh,cpp set ts=2|set sts=2|set sw=2
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
