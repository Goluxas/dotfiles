"" Automatically install VimPlug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"" Plugin Settings (Vim-Plug)
call plug#begin('~/.vim/plugged')

" Vim Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
" Plug 'davidhalter/jedi-vim' " disabled due to lagginess
Plug 'unblevable/quick-scope'
Plug 'tmhedberg/SimpylFold'
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Shougo/neocomplete.vim'
Plug 'Quramy/tsuquyomi'
Plug 'prettier/vim-prettier', {'do': 'npm install', 'for': ['javascript', 'typescript', 'less', 'scss'] }
Plug 'Glench/Vim-Jinja2-Syntax' " Django (jinja2) template syntax highlighting
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Add all plugins between this line and vundle#begin()
call plug#end()

"" Basic Settings
set encoding=utf-8
set termencoding=utf-8
set number " line numbers
set nowrap
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
" Default tab settings (expand to 2 spaces)
set expandtab
set shiftwidth=4
set softtabstop=4

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
set laststatus=2 " makes status appear on all buffers
let g:airline_powerline_fonts = 1
let g:airline_theme='zenburn'
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

" Makes backslash-movement resize the current split in that direction
nnoremap <leader>j :resize +5<CR>
nnoremap <leader>k :resize -5<CR>
nnoremap <leader>h :vertical resize -5<CR>
nnoremap <leader>l :vertical resize +5<CR>

" By having both of these binds, you can press j and k simultaneously to exit
" insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" Open/close folds with spacebar
nnoremap <space> za

" sudo write hack, for when you forget to sudo vim the file
cmap w!! w !sudo tee > /dev/null %


" Fill in boilerplate debug output code
inoremap <C-d> from pprint import pprint<CR>with open('~/test.txt', 'a') as outfile:<CR>

" Django dev shortcuts
command Shell ! /opt/ncigf/manage.py shell
command Dbshell ! /opt/ncigf/manage.py dbshell
command Reuwsgi ! sudo /etc/init.d/uwsgi restart

"" Python-specific settings
augroup filtype_python
	autocmd!
	" the above line clears the group to prevent autocmd duplication
	autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 " width of tab in spaces
	"" Jedi-Vim config
	autocmd FileType python setlocal completeopt-=preview " disables docstring popup during autocompletion
        " Insert/Remove @skip for all tests
        " Mnemonic: CTRL + skiP, CTRL + TesT
        autocmd FileType python nnoremap <C-p> :%s/def test/@skip('skipped')\r\t&/gc<CR>
        autocmd FileType python nnoremap <C-t> :g/@skip/d<CR>
        autocmd FileType python nnoremap <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
        autocmd FileType python nnoremap <leader>s :syntax sync fromstart<CR>
augroup END

command Argparse :normal! iimport argparse<CR>parser = argparse.ArgumentParser()<CR>parser.add_argument()<CR>args = parser.parse_args()

function MyFoldText()
	let line = getline(v:foldstart)
	let lines = v:foldend - v:foldstart
	return "+" . v:folddashes . line . " " . lines . " lines"
endfunction

"" TypeScript-specific settings
augroup filetype_typescript
	autocmd!
	au FileType typescript setlocal expandtab softtabstop=2 shiftwidth=2
	au FileType typescript setlocal foldmethod=syntax
	au FileType typescript setlocal foldtext=MyFoldText()
augroup END

augroup filetype_cs
        autocmd!
        au FileType cs setlocal expandtab softtabstop=4 shiftwidth=4
        au FileType cs setlocal foldmethod=syntax
augroup END

"" NerdTree Options ""
" NerdTree activation on CTRL+n(e)rdtree
noremap <C-e> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.js.map$', '\.js$']

" let NERDTreeQuitOnOpen = 1 
" behavior is not what i want: it closes nerdtree
" even when opening background tabs

augroup filetype_nerdtree
	autocmd!
	" makes o open the file without losing focus from NerdTree
	autocmd FileType nerdtree nmap <buffer> o go
	" makes n create a new file in the cursor's directory
	autocmd FileType nerdtree nmap <buffer> n ma
        " makes t open the file in a new tab, switch to it, and close nerdtree
        autocmd Filetype nerdtree nmap <buffer> t T<C-n>gt
augroup END

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_function_calls = 1
let g:go_auto_type_info = 1
augroup filetype_go
        autocmd!
        autocmd FileType go setlocal autowrite
        autocmd FileType go map <C-n> :cnext<CR>
        autocmd FileType go map <C-m> :cprevious<CR>
        autocmd FileType go nmap <leader>b <Plug>(go-build)
        autocmd FileType go nmap <leader>r <Plug>(go-run)
        autocmd FileType go nmap <leader>i <Plug>(go-info)
        autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END
