"" Plugin Settings
" required for Vundle
set nocompatible
filetype off 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle packages (top is Vundle itself; required!)
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'davidhalter/jedi-vim'
Plugin 'unblevable/quick-scope'

" Add all plugins between this line and vundle#begin()
call vundle#end()
filetype plugin indent on " required for Vundle

"" Basic Settings
set encoding=utf-8
set termencoding=utf-8
set number " line numbers
set nowrap
set tabstop=4 " width of tab in spaces
set shiftwidth=4 " whitespace to move with > and <
set incsearch "matches search as you type
set smartcase "ignores case in searches unless you use an uppercase letter
set backspace=indent,eol,start " allows backspace to go over tabs and lines
"set foldmethod=indent
"set foldnestmax=2
set list
set listchars=tab:│\ ,trail:~,eol:¬ "displays special characters for whitespace
" Necessary to keep folds static when going into insert mode
au InsertEnter * let b:oldfdm = &l:fdm | setlocal fdm=manual
au InsertLeave * let &l:fdm = b:oldfdm
"
"" Jedi-Vim config
autocmd FileType python setlocal completeopt-=preview " disables docstring popup during autocompletion

"" Solarized config
" Enable Solarized
syntax enable
set background=dark
let g:solarized_termcolors=256 " required, for some reason
colorscheme solarized
hi SpecialKey ctermbg=none


"" Status Line settings
" commented out because PowerLine handles it for me
"set statusline=%t "filename
"set statusline+=[%{strlen(&fenc)?&fenc:'none'} "file encoding
"set statusline+=%{&ff}] "file format
"set statusline+=%h "help flag
"set statusline+=%m "modified flag
"set statusline+=%r "read-only flag
"set statusline+=%y "file type
"set statusline+=%= "left/right seperator? 
"set statusline+=%c, "cursor column position
"set statusline+=%l/%L "cursor line / total lines
"set statusline+=\ %P " percent through the file
set laststatus=2

" =================
" Remapped Commands
" =================

" Makes CTRL+jkhl move to the next split in that direction
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
inoremap <C-k> <ESC><C-w>k
inoremap <C-j> <ESC><C-w>j
inoremap <C-h> <ESC><C-w>h
inoremap <C-l> <ESC><C-w>l

" Makes CTRL+arrow keys resize the current split in that direction
nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Left> :vertical resize -5<CR>
nnoremap <C-Right> :vertical resize +5<CR>

" By having both of these binds, you can press j and k simultaneously to exit
" insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" Open/close folds with spacebar
nnoremap <space> za

" Insert/Remove @skip for all tests
" Mnemonic: CTRL + skiP, CTRL + TesT
nnoremap <C-p> :%s/def test/@skip('skipped')\r\t&/gc<CR>
nnoremap <C-t> :g/@skip/d<CR>

" Fill in boilerplate debug output code
inoremap <C-d> from pprint import pprint<CR>with open('~/test.txt', 'a') as outfile:<CR>

" Django dev shortcuts
command Shell ! /opt/ncigf/manage.py shell
command Dbshell ! /opt/ncigf/manage.py dbshell
command Reuwsgi ! sudo /etc/init.d/uwsgi restart

" NerdTree activation on F2
noremap <F2> :NERDTreeToggle<CR>
