" NeoBundle Start{{{1
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim', {'directory': 'neobundle'}

" Sensible{{{1
" https://github.com/tpope/vim-sensible
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

set ttimeout
set ttimeoutlen=100

set incsearch

set laststatus=2
set ruler
set showcmd
set wildmenu

set scrolloff=3
set sidescrolloff=5
set display+=lastline

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

setglobal tags-=./tags tags^=./tags;

set autoread
set fileformats+=mac

set history=1000
set tabpagemax=50
set viminfo^=!
set sessionoptions-=options

runtime! macros/matchit.vim

inoremap <C-U> <C-G>u<C-U>

" Options {{{1

"set showbreak=↪
"set listchars+=tab:▸\ 
"set listchars+=eol:¬
"highlight NonText guifg=#4a4a59
"highlight SpecialKey guifg=#4a4a59

set modeline
"set relativenumber
"set cursorline
set colorcolumn=80
" disable startup message
set shortmess+=I
set fileencodings=ucs-bom,utf-8,cp936,default,latin1
set ignorecase
set smartcase
set hlsearch
set wildignore=
set splitright splitbelow
set lazyredraw

" Always backup {{{2
let s:savedir = expand('~/.vim/save')
if !isdirectory(s:savedir)
  call mkdir(s:savedir, 'p', 0700)
  call mkdir(s:savedir . '/undo/')
  call mkdir(s:savedir . '/backup/')
  call mkdir(s:savedir . '/swap/')
endif
set swapfile
let &directory = s:savedir . '/swap/'
set undofile
let &undodir = s:savedir . '/undo/'
set backup
let &backupdir = s:savedir . '/backup/'

" Mappings {{{1
map Q gq
nnoremap <F5> :update<CR>
inoremap <F5> <C-o>:update<CR>
"nnoremap / /\v
"vnoremap / /\v
nnoremap <silent> <leader>s :set spell!<CR>
"nnoremap ; :
inoremap kj <ESC>

" Quick toggles {{{2
nnoremap <silent> <leader>l :set list!<CR>
nnoremap <silent> <leader>n :silent :nohlsearch<CR>

" Window switching {{{2
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" File opening {{{2
" Shortcuts for opening file in same directory as current file
cnoremap <expr> %% getcmdtype() == ':' ? escape(expand('%:h'), ' \').'/' : '%%'
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
" Prompt to open file with same name, different extension
map <leader>er :e <C-R>=expand("%:r")."."<CR>

" Fix the & command in normal+visual modes {{{2
nnoremap & :&&<Enter>
xnoremap & :&&<Enter>

" Recall command history {{{2
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Indentation {{{1
set ts=8 sts=4 sw=4 et
" http://vimcasts.org/episodes/tabs-and-spaces/
" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Autocmd {{{1
if has("autocmd")
  augroup vimrcEX
    autocmd!
    " space and tab
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noet
    autocmd FileType vim,yaml,html,css,ruby,eruby,sh setlocal ts=2 sts=2 sw=2 et
    autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noet

    " filetype specific mapping
    autocmd FileType vim nnoremap <buffer> K :h <C-r><C-w><CR>

    " no list and relativenumber for manpages
    autocmd FileType man setlocal nolist norelativenumber colorcolumn=

    " treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml

    " treat .mrconfig files as cfg, ~/.mrlib as sh
    autocmd BufNewFile,BufRead */.mrconfig setfiletype cfg
    autocmd BufNewFile,BufRead ~/.mrlib setfiletype sh

    " .adoc as asciidoc
    autocmd BufNewFile,BufRead *.adoc,*.asc setfiletype asciidoc

    " set spell for git commit msg
    autocmd FileType gitcommit setlocal spell

    " auto save file on losing focus
    autocmd FocusLost * silent! :update

    " auto load .vimrc
    autocmd BufWritePost ~/.vimrc source $MYVIMRC

    " restore cursor position
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " load ~/.Xresources if modified
    autocmd BufWritePost ~/.Xresources :silent !xrdb ~/.Xresources
  augroup END
endif

" Command {{{1
command! CleanSRT normal :%s/{[^}]*}//g<CR>

" Commands to quickly set >1 option in one go {{{2
command! -nargs=* Wrap set wrap linebreak nolist


if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

" Recipe {{{1
" trailing whitespace http://www.bestofvim.com/tip/trailing-whitespace/
"match ErrorMsg '\s\+$'
match ErrorMsg /\s\+\%#\@<!$/
command! RTW normal :%s/\s\+$//e<CR>

" General Bundles {{{1
" airline
NeoBundle 'bling/vim-airline'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" zenburn
NeoBundle 'jnurmine/Zenburn', {'directory': 'zenburn'}

" gundo
NeoBundle 'sjl/gundo.vim', {'directory': 'gundo'}
map <Leader>u :GundoToggle<CR>

" man
runtime ftplugin/man.vim
nmap K <Leader>K


" NeoBundle End {{{1
call neobundle#end()
NeoBundleCheck

" Ending configs {{{1
" colorscheme
colorscheme zenburn
filetype plugin indent on
syntax enable

" vim: fdm=marker
