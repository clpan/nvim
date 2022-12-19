" plugins
let need_to_install_plugins = 0
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let need_to_install_plugins = 1
endif

" source: https://github.com/othree/vim-autocomplpop/issues/9
if has("nvim")
    au BufEnter,TermOpen term://* AcpDisable
    au BufLeave term://* AcpEnable
endif

" vscode config
if exists('g:vscode')
    " VSCode extension
else
    " ordinary Neovim
endif

" disable plugin auto-pair keybind <C-h> before loading
let g:AutoPairsMapCh = 0

call plug#begin()
" call plug#begin("~/.nvim/plugged")
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
" Plug 'vim-airline/vim-airline' 
" Plug 'vim-airline/vim-airline-themes' 
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'preservim/tagbar'
Plug 'vim-scripts/indentpython.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/AutoComplPop'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'alvan/vim-closetag'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'jupyter-vim/jupyter-vim'
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'jpalardy/vim-slime'
Plug 'matschaffer/vim-islime2'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
Plug 'lervag/vimtex'
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
        " PLug ''

call plug#end()

filetype plugin indent on
syntax on

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall
    echo "Done!"
    q
endif

" source .vimrc if there's one in the directory - allow project-specific vimrc
set exrc 

" set shell to iterm2 to plot matplotlib figures
" set shell=/Applications/iTerm.app/Contents/MacOS/iTerm2
" set shell=iTerm.app

" always show the status bar
set laststatus=2

" show whitespace. Must be inserted before colorscheme command
" source https://www.youtube.com/watch?v=YhqsjUUHj6g
autocmd Colorscheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+s$/

" enable 256 colors
set t_Co=256
" set t_ut=  " this disables Background Color Erase

" disable the default Vim startup message
set shortmess+=I  

" turn on line numbering
set number
set number relativenumber

" Enable searching as you type
set incsearch

" turn off search highlighting. source: https://stackoverflow.com/a/25569434
" set nohlsearch    " this permanently disable highlighing when searching
nnoremap <C-l> :nohlsearch<CR><C-L>

" search for visually selected text by using //. source:
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" captalize/lowercase first character of each words in one line
" souce: https://stackoverflow.com/questions/17440659/capitalize-first-letter-of-each-word-in-a-selection-using-vim
vnoremap <leader>u :s/\<./\U&/g<CR>:noh<CR>

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=120
set expandtab

" easy formatting for paragraphs
" source: https://www.youtube.com/watch?v=YhqsjUUHj6g
vmap QQ gq
nmap QQ gqap

" setups for coc.nvim ---
" Some servers have issues with backup files, see #649.
" source: https://www.youtube.com/watch?v=YhqsjUUHj6g
set nobackup
set nowritebackup
set noswapfile

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" end setup for coc.nvim ---

" set leader key
let mapleader = ","
let maplocalleader = ","

" set viminfo='25,\"50,n~/.viminfo
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
nmap Q <Nop> 

" auto-pairs
au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

" run python scripts
" source: https://stackoverflow.com/a/18948530 
" source: https://stackoverflow.com/a/63760249
" source: https://towardsdatascience.com/getting-started-with-vim-and-tmux-for-python-707ec5ff747f
" autocmd FileType python map <buffer> <LocalLeader>r :w<CR>:exec '!python3 %' shellescape(@%, 1)<CR>
" autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python map <buffer> <LocalLeader>r <Esc>:w<CR>: !python3<CR>
autocmd FileType python map <buffer> <LocalLeader>rf <Esc>:w<CR>: !python3 %<CR>
autocmd FileType python map <buffer> <LocalLeader>rt :split term://python3 %<CR>
" run partial scripts in python
" source: https://stackoverflow.com/a/40290101
" may not need the '%'
xnoremap <Leader>e :w !python3<cr>
nnoremap <Leader>e :w !python3<cr>

" put parenthesis around highlighted words
" source: https://superuser.com/questions/875095/adding-parenthesis-around-highlighted-text-in-vim
" xnoremap <leader>s xi()<Esc>P
" try auto-disable cap - unsure if it works - does not work
" au InsertLeave * call TurnOffCaps()

" setup for latex
let g:vimtex_view_method='skim'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

let g:slime_preserve_curpos = 0

" config for vim-slime
let g:slime_target = "neovim"

" config for vim-islime2 ====
let g:islime2_29_mode = 1 
" autocmd FileType python     nnoremap <buffer><leader>rf :%y r<cr>:call islime2#iTermSendNext(@r)<CR>
nnoremap <silent> <Leader>il :ISlime2CurrentLine<CR>
nnoremap <silent> <Leader>ij :ISlime2NextLine<CR>
vnoremap <silent> <Leader>ij :ISlime2NextLine<CR>
nnoremap <silent> <Leader>ik :ISlime2PreviousLine<CR>
vnoremap <silent> <Leader>ik :ISlime2PreviousLine<CR>
nnoremap <silent> <Leader>ii :set opfunc=islime2#iTermSendOperator<CR>
vnoremap <silent> <Leader>ii :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
nnoremap <leader>cf :%y r<cr>:call islime2#iTermSendNext(@r)<CR>
inoremap <leader>cc <Esc>vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
vnoremap <leader>cc :<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
nnoremap <leader>cc vip:<C-u>call islime2#iTermSendOperator(visualmode(), 1)<CR>
nnoremap <leader>ff :call islime2#iTermRerun()<CR>
nnoremap <leader>fp :call islime2#iTermSendUpEnter()<CR>
" modify so that different filetype using the same keybind will function
" differently. (for both python & R (Nvim-R)

" settings for R ----
" autocmd FileType r     nnoremap <buffer><leader>rs <Plug>:RStart
" activate shortcut by file type - for Python and R
" source: https://vi.stackexchange.com/a/10666

" open init.vim in horizontal splitwindow
nnoremap <Leader>ev :split $MYVIMRC<cr>  
nnoremap <leader>sv :source $MYVIMRC<cr>

" word movement
imap <S-Left> <Esc>bi
nmap <S-Left> b
imap <S-Right> <Esc><Right>wi
nmap <S-Right> w

" map :sort to a key, source: https://www.youtube.com/watch?v=YhqsjUUHj6g
vnoremap <leader>s :sort<CR>

" indent/unindent with tab/shift-tab
nmap <Tab> >>
nmap <S-tab> <<
imap <S-Tab> <Esc><<i
vmap <Tab> >gv
vmap <S-Tab> <gv

" mouse
set mouse=a
let g:is_mouse_enabled = 1
noremap <silent> <Leader>m :call ToggleMouse()<CR>
function ToggleMouse()
    if g:is_mouse_enabled == 1
        echo "Mouse OFF"
        set mouse=
        let g:is_mouse_enabled = 0
    else
        echo "Mouse ON"
        set mouse=a
        let g:is_mouse_enabled = 1
    endif
endfunction

" color scheme
syntax on
colorscheme onedark
filetype on
filetype plugin indent on

" lightline
set noshowmode
let g:lightline = { 'colorscheme': 'onedark' }

" highlighting, must be placed after colorscheme
" source: https://stackoverflow.com/a/237293/20031408
" color schema: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi LineNrAbove ctermfg=190
hi LineNrBelow ctermfg=81
highlight LineNr ctermfg=green
" highlight certain words: source: https://stackoverflow.com/a/27686668/20031408
hi! mygroup ctermfg=141
:match mygroup /self/

" disable audible bell
set noerrorbells visualbell t_vb=

" shows what key that just been typed out
set showcmd
" give more space for displaying messages.
set cmdheight=2

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
" source: https://github.com/iamcco/coc-flutter/issues/47#issuecomment-657481794
set hidden

" split buffer from bottom and right side
set splitbelow
set splitright

" allows using system clipboard to copy & paste
" source: https://unix.stackexchange.com/a/12571
set clipboard=unnamed
set clipboard=unnamedplus

" code folding
" source: https://stackoverflow.com/a/360634
set foldmethod=indent
set foldnestmax=2
set foldlevel=99

" keybinding to increase productivity:
" source: https://stackoverflow.com/a/21761782/20031408
" nnoremap ; :
" vnoremap ; :

" command remap :W -> :w, Magma-nvim command
" source: https://stackoverflow.com/a/3879737/20031408
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

" wrap toggle
setlocal nowrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>

" remap vim buffer - vim-buffertabline
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" remap folding key 'za' to space
nnoremap <space> za 
vnoremap <space> zf

" use mapped key for moving vim to background (suspend the vim session)
nnoremap <leader>bg :stop<CR>

" settings for magma-nvim 
cnoreabbrev <expr> mi ((getcmdtype() is# ':' && getcmdline() is# 'mi') ? ('MagmaInit python3'):('mi'))
cnoreabbrev <expr> md ((getcmdtype() is# ':' && getcmdline() is# 'md') ? ('MagmaDeinit'):('md'))
nnoremap <silent><expr> <LocalLeader>o  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>rr :<C-U>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:false
" let g:magma_image_provider = "ueberzug"

function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
endfunction

" move through split windows
" OS dependent command. source: https://vi.stackexchange.com/questions/2572/detect-os-in-vimscript
if has('mac')
    nnoremap ˚ :wincmd k<CR>
    nnoremap ∆ :wincmd j<CR>
    nnoremap ˙ :wincmd h<CR>
    nnoremap ¬ :wincmd l<CR>
elseif has('linux')
    nnoremap <A-k> :wincmd k<CR>
    nnoremap <A-j> :wincmd j<CR>
    nnoremap <A-h> :wincmd h<CR>
    nnoremap <A-l> :wincmd l<CR>
endif
" move through buffers
" nmap <leader>[ :bp!<CR>
" nmap <leader>] :bn!<CR>
nnoremap <leader>x :bp<bar>bd#<CR>
nnoremap <leader>x! :bp<bar>bd#!<CR>
nnoremap <M-f> :bn!<CR> 
nnoremap <M-b> :bp!<CR> 

" split term
" source: https://www.reddit.com/r/neovim/comments/ezt2cu/making_neovims_terminal_behave_more_like_vims/
command! TN tabnew<Bar>term
command! SN split<Bar>term
command! VN vs<Bar>term

" restore place in file from previous session
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" file browser
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0

:let g:netrw_browser_viewer='open'

" automatically change the current directory and set it as working dir
set autochdir

" NERDTree automatically change directory and enter that dir once a new
" directory is selected-- below let g:xxxx does not seem to work
" let g:NERDTreeChDirMode = 2

"NREDTREE Keybind and setting
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFocus<CR>
nnoremap <leader>d :NERDTree<CR>

" map <leader>n :call NERDTreeToggle()<CR>
" functionNERDTreeToggle()
"     NERDTreeTabsToggle
"     if g:nerdtree_open == 1
"         let g:nerdtree_open = 0
"     else
"         let g:nerdtree_open = 1
"         wincmd p
"     endif
" endfunction

function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction
autocmd VimEnter * call StartUp()

" Auto-enable NERDTree once open
autocmd VimEnter * NERDTree

" commeting 
" source: https://stackoverflow.com/a/22246318
autocmd FileType c,cpp,java,scala     let b:comment_leader = '//'
autocmd FileType sh,ruby,python,r     let b:comment_leader = '#'
autocmd FileType conf,fstab           let b:comment_leader = '#'
autocmd FileType tex                  let b:comment_leader = '%'
autocmd FileType mail                 let b:comment_leader = '>'
autocmd FileType vim                  let b:comment_leader = '"'
function! CommentToggle()
    execute ':silent! s/\([^ ]\)/' . escape(b:comment_leader,'\/') . ' \1/'
    execute ':silent! s/^\( *\)' . escape(b:comment_leader,'\/') . ' \?' . escape(b:comment_leader,'\/') . ' \?/\1/'
endfunction
map <leader><Space> :call CommentToggle()<CR>

" ale
map <C-e> <Plug>(ale_next_wrap)
map <C-r> <Plug>(ale_previous_wrap)

" tags
" source: https://stackoverflow.com/a/50136849
let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
map <leader>t :TagbarToggle<CR>

" copy, cut and paste 
" vnoremap <C-c> "+y
" vnoremap <C-x> "+c
" vnoremap <C-v> c<ESC>"+p
" inoremap <C-v><ESC>"+pa 

" disable keys - disable capital J to join lines
noremap J <nop>
" remap join line (capital J) to ctrl + J
nnoremap <C-j> J  

" move to the right w/o leaving INSERT mode
inoremap <C-l> <Right>
" remap <C-d> to be <C-b>, delete the character to the left
inoremap <C-b> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
" remap <C-h> to move cursor to the left w/o leaving INSERT mode

" remap to delete characters in NORMAL mode
" source: https://vi.stackexchange.com/questions/20552/backspace-functionality-in-normal-mode
nnoremap <BS> X
" remap to allow forward-delete in INSERT mode
" source: https://superuser.com/questions/153372/is-there-a-way-to-forward-delete-in-insert-mode-in-vim
inoremap <C-d> <Del>

" insert blank lines
nnoremap <CR> o<Esc>

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" set indent for .py file
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftswidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" complete & spelling check
set complete+=kspell
set completeopt=menuone,longest

" set liner to follow flake8,set line length to be 120
let g:ale_linters = { 'python':['flake8']}
let g:ale_python_flake8_options = '--max-line-length=120'

" try to see if can auto turn off caps: - TurnOffCaps() not recognized
" au InsertLeave * call TurnOffCaps()
