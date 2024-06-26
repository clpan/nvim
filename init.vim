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

" clone vim-snippets to nvim subfolder. source: chatgpt :P
:if !isdirectory("~/.config/nvim/vim-snippets")
    :silent execute "!mkdir -p ~/.config/nvim/vim-snippets"
    :silent execute "!git clone https://github.com/honza/vim-snippets ~/.config/nvim/vim-snippets"
:endif

" disable plugin auto-pair keybind <C-h> before loading
let g:AutoPairsMapCh = 0

" disable unloaded providers
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

call plug#begin()
" call plug#begin("~/.nvim/plugged")
" Plug 'tpope/vim-sensible'
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
Plug 'gosukiwi/vim-smartpairs'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
Plug 'preservim/tagbar'
Plug 'vim-scripts/indentpython.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/AutoComplPop'
Plug 'tenfyzhong/CompleteParameter.vim'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'alvan/vim-closetag'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'jupyter-vim/jupyter-vim'
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jpalardy/vim-slime'
Plug 'matschaffer/vim-islime2'
" Plug 'klafyvel/vim-slime-cells'
Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}
" Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'lervag/vimtex'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'SirVer/ultisnips'
Plug 'edluffy/hologram.nvim', {'auto_display': 'true'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'honza/vim-snippets'
Plug 'rcarriga/nvim-notify'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'kkharji/sqlite.lua'
Plug 'kode-team/mastodon.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'puremourning/vimspector'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'
Plug 'neovim/nvim-lspconfig'
"web development
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'
" colorscheme
Plug 'romgrk/doom-one.vim'
Plug 'github/copilot.vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'ap/vim-css-color'
Plug 'lukas-reineke/headlines.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Plug 'bennypowers/nvim-regexplainer'
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
        " PLug ''

call plug#end()

:command PI :PlugInstall
:command PU :PlugUpdate
:command PC :PlugClean

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

" show whitespace. Must be inserted before colorscheme command

" autocmd Colorscheme * highlight ExtraWhitespace ctermbg=red guibg=red
" au InsertLeave * match ExtraWhitespace /\s\+s$/
" :match ExtraWhitespace /\s\+$\| \+\ze\t/| /^\t*\zs \+/

" source: https://vim.fandom.com/wiki/Highlight_unwanted_spaces
" show all tabs
:command HT /\t
" show trailing whitespace after text
:command HS /\S\zs\s\+$
" :command HS2 :%s/\s\+$//e
" show space before a tab
:command HST / \+\ze\t

" trim whitespace
" source: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Display_or_remove_unwanted_whitespace_with_a_script
" source: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function DHS() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

" command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% DHS <line1>,<line2>call DHS()

" enable 256 colors
set t_Co=256
" set t_ut=  " this disables Background Color Erase

" disable the default Vim startup message
set shortmess+=I

" turn on line numbering
" source https://jeffkreeftmeijer.com/vim-number/
" source https://stackoverflow.com/a/15958387
set number
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | hi LineNr cterm=NONE | endif
" :  autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | endif
" :  autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | hi LineNrAbove ctermfg=190 | hi LineNrBelow ctermfg=81 | hi LineNr ctermfg=NONE ctermbg=NONE cterm=NONE | hi CursorLineNr ctermfg=118 ctermbg=NONE cterm=NONE | endif
:  autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | hi LineNr ctermfg=NONE ctermbg=NONE cterm=NONE | hi CursorLineNr ctermbg=NONE cterm=NONE | endif
:augroup END

" Enable searching as you type
set incsearch

" replace selected block - C-r to activate
" source: https://stackoverflow.com/a/676619
":'<,'>s/red/green/g, or use 'gc' to confirm before replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" turn off search highlighting. source: https://stackoverflow.com/a/25569434
" set nohlsearch    " this permanently disable highlighing when searching
nnoremap <C-l> :nohlsearch<CR><C-L>

" search for visually selected text by using //. source:
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" captalize/lowercase first character of each words in one line
" souce: https://stackoverflow.com/questions/17440659/capitalize-first-letter-of-each-word-in-a-selection-using-vim
vnoremap <leader>u :s/\<./\U&/g<CR>:noh<CR>
" place everything selected under [  ]
vnoremap <silent> <leader>[ :s/\%V\(\w.*\)/[\1]/<CR>
vnoremap <silent> <leader>( :s/\%V\(\w.*\)/(\1)/<CR>
vnoremap <silent> <leader>' :s/\%V\(\w.*\)/'\1'/<CR>
vnoremap <silent> <leader>" :s/\%V\(\w.*\)/"\1"/<CR>
vnoremap <silent> <leader>{ :s/\%V\(\w.*\)/{\1}/<CR>

" highlight whatever visually selected til end
vnoremap <silent> <leader>se :s/\%V\(\w.*\)
" select only one word
vnoremap <silent> <leader>sw :s/\%V\(\w\+\)


" Define a function to wrap selected text with user-inputted characters
function! WrapSurronding()
  " Save the current register contents
  let register_save = @@
  " Save the visual selection to the register
  normal! gv"xy
 " Get user input for the wrapper characters
  let wrapper = input("Enter wrapper characters (separated by a space): ")
  " Split the wrapper input into left and right parts
  let [left_wrapper, right_wrapper] = split(wrapper)
  " Replace the selected text with the wrapped text
  execute "'<,'>s/\\V" . escape(@x, '/\') . "/".left_wrapper."\\0".right_wrapper."/g"
  " Restore the previous register contents
  " let @@ = register_save
endfunction
" Create a keybinding for the WrapSelectedText function
vnoremap <leader>ap :<c-u>call WrapSurronding()<cr>

function! SetCursorPos(line, col)
  let pos = [0, a:line, a:col, 0]
  call setpos('.', pos)
endfunction

function! DeleteCharAtPosition(line_num, col_num)
  let line_content = getline(a:line_num)
  let new_content = strpart(line_content, 0, a:col_num - 1) . strpart(line_content, a:col_num)
  call setline(a:line_num, new_content)
endfunction

function! RemoveSurrounding()
  " Enter visual mode to select text
  normal! gv
  " Copy selected text to register 'a'
  normal! "ay
  " Assign selected text to variable 'selected_text'
  let selected_text = @a
  let start_line = getpos("'<")[1]
  let start_col = getpos("'<")[2]
  let end_line = getpos("'>")[1]
  let end_col = getpos("'>")[2]
  call DeleteCharAtPosition(start_line, start_col - 1)
  call DeleteCharAtPosition(end_line, end_col)
  echo "selected_text: " . selected_text
endfunction
vnoremap <leader>mw :call RemoveSurrounding()<CR><CR>

function! ReplaceSurronding()
  normal! gv
  normal! "ay
  let selected_text = @a
  let start_line = getpos("'<")[1]
  let start_col = getpos("'<")[2]
  let end_line = getpos("'>")[1]
  let end_col = getpos("'>")[2]
  let cursor_line = getpos('.')[1]
  let cursor_col = getpos('.')[2]
  call DeleteCharAtPosition(start_line, start_col - 1)
  call DeleteCharAtPosition(end_line, end_col)
  echo "selected_text: " . selected_text
  let wrapper = input("Enter wrapper characters (separated by a space): ")
  let [left_wrapper, right_wrapper] = split(wrapper)
  execute "'<,'>s/\\V" . escape(@x, '/\') . "/".left_wrapper."\\0".right_wrapper."/g"
  call SetCursorPos(cursor_line, cursor_col)
endfunction

vnoremap <leader>b :call ReplaceSurronding()<CR><CR>

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set expandtab
set cursorcolumn
set cursorline
" set showmatch
" set matchtime=10

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
" au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

" setup telescope to view images
" require('telescope').load_extension('media_files')
" require'telescope'.setup {
  " extensions = {
    " media_files = {
      " -- filetypes whitelist
      " -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      " filetypes = {"png", "webp", "jpg", "jpeg"},
      " find_cmd = "rg" -- find command (defaults to `fd`)
    " }
  " },
" }


" let g:telescope_extensions = ['media_files']

" lua <<EOF
" require('telescope').load_extension('media_files')
" EOF

" let g:telescope_preview_options = {
    " \ 'options': {
        " \ 'image_formats': ['png', 'jpg', 'jpeg', 'gif'],
    " \ },
    " \ 'mappings': {
        " \ 'preview': '<CR>',
        " \ },
    " \ }
" :Telescope media_files

" in init.vim

" luafile $VIMRUNTIME . '/lua/telescope/extensions/media_files.lua'
" lua require('telescope').extensions.media_files.media_files()


" Setup Hologram for image display in neovim
" source: https://github.com/edluffy/hologram.nvim/issues/17#issuecomment-1314562139
lua << EOF
require'hologram'.setup{
    auto_display = true -- WIP automatic markdown image display, may be prone to breaking
}
EOF

let g:hologram_theme = 'custom'
let g:hologram_custom_theme = {
      \ 'delimiter': ['<DELIM>', '</DELIM>'],
      \ 'image_formats': ['png'],
      \ }

" Optional: set a custom output directory
let g:hologram_output_dir = '~/hologram_images'

" Optional: set a custom file extension
let g:hologram_file_extension = 'png'

" Optional: set a custom image width
let g:hologram_width = 800


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

" config for jed-vim for python ====
" source: https://stackoverflow.com/a/33752169
" source: https://stackoverflow.com/q/18279658
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#usages_command = "<leader>u"
let g:jedi#show_call_signatures = "2"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#rename_command = "<leader>m"
let g:jedi#rename_command_keep_name = "<leader>M"
let g:jedi#completion_command = "<C-Space>"
" let g:jedi#completions_enabled = 0
" let g:jedi#goto_definition_command = "<leader>d"
" let g:jedi#get_definition_command = "<leader>d"
" let g:jedi#autocompletion_command = "<C-Space>"
" == if jedi is very slow after initial completion, try: 
" let g:pymode_rope = 0
" let g:jedi#show_call_signatures = 0

" complete parameter setting 
inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)

" put parenthesis around highlighted words
" source: https://superuser.com/questions/875095/adding-parenthesis-around-highlighted-text-in-vim

" setup for latex ====
" config for vim-tex
" source: https://web.ma.utexas.edu/users/vandyke/notes/getting_started_latex_vim/getting_started.pdf
" let g:vimtex_view_method='skim'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
nnoremap <localleader>c <Cmd>update<CR><Cmd>VimtexCompileSS<CR>
nnoremap <LocalLeader>vs <Cmd>VimtexStop<CR>
nnoremap <LocalLeader>v <Cmd>VimtexView<CR>
" Don't open QuickFix for warning messages if no errors are present
let g:vimtex_quickfix_open_on_warning = 0  
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
      \]

let g:vimtex_view_method = "zathura"


" config for vim-latex-live-preview
" source: https://medium.com/rahasak/vim-as-my-latex-editor-f0c5d60c66fa
autocmd FileType tex setl updatetime=1
if has('mac')
    let g:livepreview_previewer = 'open -a Preivew'
elseif has('linux')
    let g:livepreview_previewer = 'open -a zathura'
endif

" config for snippet: UltiSnips ====
" make sure to store honza/vim-snippets repo to the following dir:
" this require python3 and pynvim installed.
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/vim-snippets/UltiSnips']
let g:UltiSnipsExpandTrigger  = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
autocmd FileType tex,html,css       let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
" open snippets files with user defined command, type :Texs to open tex.snippets horizontally
let g:tex_snippets_path = expand("~/.config/nvim/vim-snippets/UltiSnips/tex.snippets")
command! Texs execute "split" . g:tex_snippets_path
" add a keybind to reload snippets after making changes. source: https://ejmastnak.github.io/tutorials/vim-latex/ultisnips.html#tip-refreshing-snippets
" unresolved - function not found #TODO
nnoremap <leader>rl <cmd>call UtilSnips#RefreshSnippets()<CR>

" config for web development ====
" tagalong
let g:tagalong_filetype = ['html']
let g:tagalong_verbose = 1

" emmet-vim 
" to load boilerplate: type !, move cursor to '!', then press <C-y>,
" use emmet-vim to load boilerplate: type 'html:5,', move cursor to ',' then
" press <C-y>,
" only function in normal mode
" select entire tag: v-a-t. Source: https://stackoverflow.com/a/41616833
" let g:user_emmet_mode='n'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" config for vim-slime and vim-islime2 ====
" use <C-c><C-c> to send script to target terminal for REPL
" also need to add `map c-c<Esc>` in "/kitty.conf"
if has('linux')
    let g:slime_jobid = "ipython"
    " let g:slime_target = "neovim"
    if $TERM == "xterm-kitty"
        let g:slime_target = "kitty"
        let g:slime_kitty_socket = system("echo $KITTY_LISTEN_ON")
        let g:slime_cmd = "kitty +kitten ipython"
    elseif $TERM == "xterm-256color"
        let g:slime_target = "neovim"
        echo 'g:slime_target = ' . g:slime_target
    else
        let g:slime_target = "tmux"
    endif
    let g:slime_preserve_curpos = 0
    let g:slime_python_ipython = 1
    let g:slime_python_cmd = "python"
    let g:slime_python_repl = "ipython"
    let g:slime_r_runner = "R"
    let g:slime_r_source_cmd = 'source(%filename%)'
    fun! StartREPL(repl)
      execute 'terminal '.a:repl
      setlocal nonumber
      let t:term_id = b:terminal_job_id
      wincmd p
      execute 'let b:slime_config = {"jobid": "'.t:term_id . '"}'
    endfun
    vnoremap <C-CR> <Plug>SlimeRegionSend
    nnoremap <C-CR> :SlimeSend<CR>
    " vnoremap <silent> <C-A-CR> :<C-u>silent execute("'<,'>SlimeSend") \| let lnum=line("'>") \| execute("silent normal! " . (lnum+1) . "G")<CR>
    vnoremap <silent> <C-A-CR> :<C-u>silent execute("normal! \<Plug>SlimeRegionSend") \| let lnum=line("'>") \| execute("silent normal! " . (lnum+1) . "G")<CR>
    nnoremap <silent> <C-A-CR> :SlimeSend<CR>j
elseif has('mac')
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
endif
    
" settings for R ----
" autocmd FileType r     nnoremap <buffer><leader>rs <Plug>:RStart
" activate shortcut by file type - for Python and R
" source: https://vi.stackexchange.com/a/10666

autocmd BufNewFile,BufRead *.r set filetype=r

" config for Nvim-R

let g:R_disable_warnings = 1
let g:R_auto_start_session = 1
let g:R_echo_messages = 0
let g:R_repl_send_line_when_complete = 1
let g:R_repl_send_on_enter = 0
let g:R_repl_send_on_motion = 0


" Configure R language server
au FileType r,nz setlocal omnifunc=lsp#complete
au FileType r,nz nnoremap <buffer> <silent> K :LspHover<CR>
au FileType r,nz nnoremap <buffer> <silent> <C-]> :LspDefinition<CR>
au FileType r,nz nnoremap <buffer> <silent> <leader>rn :LspRename<CR>

" Configure the R language server executable
let g:lsp_r_language_server_executable = 'R'
" let g:lsp_r_language_server_args = csplit(&shellcmdflag, ' ') + ['--slave', '-e', 'languageserver::run()']
let g:lsp_r_language_server_args = split(&shellcmdflag) + ['--slave', '-e', 'languageserver::run()']
let g:lsp_r_language_server_stdin = v:true


let g:LanguageClient_serverCommands = {
    \ 'r': ['R', '--slave', '-e', 'languageserver::run()'],
    \ }


let g:LanguageServer_stdio = 1

function! SetupRls()
    let server_cmd = ["julia", "-e", "using LanguageServer; server = LanguageServer.LanguageServerInstance(stdin, stdout, false); run(server);"]
    let options = {
        \ 'cmd': server_cmd,
        \ 'filetypes': ['r'],
        \ }
    call language_client#start('r', options)
endfunction

autocmd FileType r call SetupRls()

" avoid nest nvim
" source: https://www.reddit.com/r/vim/comments/edrs9q/comment/fbl0e94/?utm_source=share&utm_medium=web2x&context=3
" command! Unwrap let g:file = expand('%') | bdelete | exec 'silent !echo -e "\033]51;[\"drop\", \"'.g:file.'\"]\007"' | q

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
" source: https://stackoverflow.com/a/46541477/20031408
nnoremap <Tab> >>
nnoremap <S-tab> <<
imap <S-Tab> <Esc><<i
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" mouse
set mouse=a
let g:is_mouse_enabled = 1

" always show the status bar
set laststatus=2
set statusline=
set statusline+=\ %f

" set time display on the editor status line
" source: https://stackoverflow.com/questions/28284276/how-i-can-show-the-time-in-vim-status-bar
" source: https://vim.fandom.com/wiki/Display_date-and-time_on_status_line
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set statusline=\PATH:\ %r%F\ \ \ \ \LINE:\ %l/%L/%P\ TIME:\ %{strftime('%c')}

" color scheme
syntax on
" set termguicolors
set background=dark
colorscheme onedark
filetype on

" neovim terminal colorscheme. source: https://github.com/romgrk/doom-one.vim
" set it to true if using this neovim terminal colorscheme:
" souce: 
" let g:doom_one_terminal_colors = v:true

" lightline
set noshowmode
let g:lightline = { 'colorscheme': 'onedark' }

" highlighting, must be placed after colorscheme
" highlight certain words: source: https://stackoverflow.com/a/27686668/20031408
" source: https://stackoverflow.com/a/15288278/20031408
" source: https://stackoverflow.com/a/237293/20031408
" color schema: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
" source: https://www.reddit.com/r/vim/comments/l9or1w/comment/gljots6/?utm_source=share&utm_medium=web2x&context=3
" source: https://stackoverflow.com/a/5296709
" function written by chatgpt
function! SetTermColor()
    if &termguicolors == 1
        echo "background is dark"
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        hi LineNrAbove guifg=yellow
        hi LineNrBelow guifg=blue
        hi LineNr guifg=green
        hi mygroup guifg=purple
        :match mygroup /\<self\>/
    else
        hi LineNrAbove ctermfg=190
        hi LineNrBelow ctermfg=81
        " hi LineNr ctermfg=118 ctermbg=25 cterm=bold
        hi LineNr ctermfg=118 ctermbg=25
        " hi CursorLineNr ctermfg=118 ctermbg=25 cterm=bold
        hi CursorLineNr ctermfg=118 cterm=bold
        hi Cursorline guibg=#0f0f0f
        hi! mygroup ctermfg=141
        :match mygroup /\<self\>/
    endif
endfunction
call SetTermColor()

" source: https://vi.stackexchange.com/a/31912
" source: more transparency setting: https://www.reddit.com/r/neovim/comments/ncv6oj/comment/gy77nhx/?utm_source=share&utm_medium=web2x&context=3
let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 0
    hi Normal guibg=none ctermbg=none
    let t:is_transparent = 1
  else
    " hi Normal guibg=NONE ctermbg=NONE
    hi Normal guibg=NONE
    set background=dark
    call SetTermColor()
    let t:is_transparent = 0
  endif
endfunction

autocmd VimEnter * call Toggle_transparent_background()
" command! ToggleBg :call Toggle_transparent_background()
 nnoremap <silent> <F4> :call Toggle_transparent_background()<CR>
 vnoremap <silent> <F4> :call Toggle_transparent_background()<CR>

" disable audible bell
set noerrorbells visualbell t_vb=

" shows what key that just been typed out
set showcmd
" give more space for displaying messages.
set cmdheight=1

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

let g:vimspector_enable_mappings = "HUMAN"
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dd :VimspectReset<CR>
nnoremap <leader>de :VimspectorEval
nnoremap <leader>dw :VimspectorWatch
nnoremap <leader>do :VimspectorSHowOutput


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
    let g:kitty_navigator_no_mappings = 1
    nnoremap <silent> <a-h> :KittyNavigateLeft<cr>
    nnoremap <silent> <a-j> :KittyNavigateDown<cr>
    nnoremap <silent> <a-k> :KittyNavigateUp<cr>
    nnoremap <silent> <a-l> :KittyNavigateRight<cr>
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
nnoremap <leader>ff :NERDTreeFind<CR>
" nnoremap <leader>d :NERDTree<CR>
"" Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff: source: https://stackoverflow.com/a/42154947

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

" Auto-enable NERDTree once open, and move cursor to file
" source: https://stackoverflow.com/a/24809018
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" commenting
" source: https://stackoverflow.com/a/22246318
autocmd FileType c,cpp,java,scala     let b:comment_leader = '//'
autocmd FileType javascript           let b:comment_leader = '//'
autocmd FileType sh,ruby,python,r     let b:comment_leader = '#'
autocmd FileType conf,fstab,snippets  let b:comment_leader = '#'
autocmd FileType yaml                 let b:comment_leader = '#'
autocmd FileType desktop              let b:comment_leader = '#'
autocmd FileType tex                  let b:comment_leader = '%'
autocmd FileType mail                 let b:comment_leader = '>'
autocmd FileType vim                  let b:comment_leader = '"'
autocmd FileType lua                  let b:comment_leader = '--'
autocmd FileType css                  let b:comment_leader = '/*'
autocmd FileType html,xhtml,xml       let b:comment_leader = '<!--'
function! CommentToggle()
    let comment_leader = b:comment_leader
    let comment_start = ''
    let comment_end = ''

    if &filetype == 'css'
        let comment_start = '/*'
        let comment_end = '*/'
    elseif &filetype == 'html' || &filetype == 'xhtml' || &filetype == 'xml'
        let comment_start = '<!--'
        let comment_end = '-->'
    endif

    " if comment_start != ''
        " Check if the line is already commented
        " let is_commented = getline('.') =~ '\v^\s*' . escape(comment_start, '/') . '.*' . escape(comment_end, '/') . '\s*$'

  " Get the current line number
    let line_number = line('.')

    " Toggle commenting
    if comment_start != ''
        " Check if the line is already commented
        let is_commented = match(getline(line_number), '\v^\s*' . escape(comment_start, '/') . '.*' . escape(comment_end, '/') . '\s*$') != -1
        if is_commented
            " Uncomment the line
            execute 'silent! s/\v^\s*' . escape(comment_start, '/') . '(.*)' . escape(comment_end, '/') . '\s*/\1/'
        else
            " Comment out the line
            execute 'silent! s/\v^\s*/\=comment_start/'
            execute 'silent! s/\v\s*$/\=comment_end/'
        endif
    else
        " If the filetype is not CSS or HTML, use the existing CommentToggle logic
        " execute ':silent! s/\([^ ]\)/' . escape(comment_leader,'\/') . ' \1/'
        " execute ':silent! s/^\( *\)' . escape(comment_leader,'\/') . ' \?' . escape(comment_leader,'\/') . ' \?/\1/'
        execute ':silent! s/\v^\s*' . escape(comment_leader, '/') . '\s*\([^ ]\)/\1/'
        execute ':silent! s/\v^\s*' . escape(comment_leader, '/') . '\s*$/'
    endif
    " execute ':silent! s/\([^ ]\)/' . escape(b:comment_leader,'\/') . ' \1/'
    " execute ':silent! s/^\( *\)' . escape(b:comment_leader,'\/') . ' \?' . escape(b:comment_leader,'\/') . ' \?/\1/'
endfunction
map <silent> <leader><Space> :call CommentToggle()<CR>
" commenting html: https://stackoverflow.com/a/75526410
nnoremap <silent> <leader>h :set lazyredraw<cr>mhvato<ESC>i<!-- <ESC>vatA --><ESC>`h:set nolazyredraw<cr>
nnoremap <silent> <leader>H :set lazyredraw<cr>mhvat<ESC>4xvato<ESC>5X`h:set nolazyredraw<cr>
" autocmd FileType html nnoremap <silent> <leader>h :set lazyredraw<cr>mhvato<ESC>i<!-- <ESC>vatA --><ESC>`h:set nolazyredraw<cr>
" ale
" map <C-e> <Plug>(ale_next_wrap)
" map <C-r> <Plug>(ale_previous_wrap)
map <C-r> :later<CR>

" tags
" source: https://stackoverflow.com/a/50136849
" source: https://stackoverflow.com/a/52983182
" let ctag_loc = system('which ctags')
let ctag_loc = substitute(system('which ctags'), '\n\+$', '','')
let g:tagbar_ctags_bin = ctag_loc
" let g:tagbar_ctags_bin = "/usr/bin/ctags"
" let g:tagbar_ctags_bin = "/usr/local/bin/ctags"
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
    \ set tabstop=8
    \ set softtabstop=4
    \ set shiftswidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" complete & spelling check. 
" source: https://jdhao.github.io/2019/04/29/nvim_spell_check/
" source: https://neovim.io/doc/user/spell.html
" source: https://vimtricks.com/p/vim-spell-check/
set complete+=kspell
set completeopt=menuone,longest
set spelllang=en,cjk
set spellsuggest=best,9
set mousemodel=popup
:menu PopUp.save :w<CR>
nnoremap <silent><F11> :set spell!<CR>
inoremap <silent><F11><C-0> :set spell!<CR>

" set liner to follow flake8,set line length to be 120
let g:ale_linters = { 'python':['flake8']}
let g:ale_python_flake8_options = '--max-line-length=80'
" set linting for javascript with eslint_d
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1
" autofix visually selected area with eslint_d
vnoremap <leader>f :!eslint_d --stdin --fix-to-stdout<CR>gv

" setup up debugger "
lua << EOF
require("dapui").setup()
EOF

" setup notification "
lua << EOF
require("notify").setup{
    timeout=4000,
    render='mininal',
    stages='static',
}
EOF

" setup indent blankline "
lua << EOF
require("ibl").setup()
EOF

" set up mastodon.nvim "
lua << EOF
require("mastodon").setup()
EOF

" set up headlines.nvim"
lua << EOF
require("headlines").setup()
EOF
