" call plug#begin(expand('~/.vim/plugged'))
" Plug 'tribela/vim-transparent'
" call plug#end()


syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
set number
set relativenumber
nnoremap <Leader>cc :set colorcolumn=80<cr>
nnoremap <Leader>ncc :set colorcolumn-=80<cr>
set mouse=a

inoremap jk <Esc>
