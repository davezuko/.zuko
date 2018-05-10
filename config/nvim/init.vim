" vim: foldmethod=marker

" Documentation -------------------------------------------- {{{
" Reference:
" - http://statico.github.io/vim.html
" - http://www.oliversherouse.com/2017/08/21/vim_zero.html
" - https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux
" - https://statico.github.io/vim3.html
" - https://fortes.com/2017/language-server-neovim
"}}}

" Plugins -------------------------------------------------- {{{
" Install the plugin manager if it does not exist.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" Basics
Plug 'mhinz/vim-startify'             " Improved startup screen
Plug 'itchyny/lightline.vim'          " Customizable status line
Plug 'editorconfig/editorconfig-vim'  " Use .editorconfig settings when found
Plug '/usr/local/opt/fzf'             " Import native FZF binary (brew install fzf)
Plug 'junegunn/fzf.vim'               " FuzzyFind integration
Plug 'w0rp/ale'                       " Asynchronous linter
Plug 'scrooloose/nerdtree'            " File explorer
Plug 'christoomey/vim-tmux-navigator' " Seamlessly navigate between tmux and vim
Plug 'aquach/vim-http-client'         " Make HTTP requests from vim
Plug 'shime/vim-livedown'             " Realtime markdown preview
Plug 'romainl/vim-qf'                 " Better Quickfix List management
Plug 'vimwiki/vimwiki'                " Personal wiki manager

" IMproved Editing
Plug 'tpope/vim-commentary'           " Easier commenting
Plug 'tpope/vim-repeat'               " Make '.' smarter
Plug 'tpope/vim-unimpaired'           " More symmetrical mappings
Plug 'machakann/vim-sandwich'         " Intuitive surround commands
Plug 'junegunn/vim-easy-align'        " Text alignment commands
Plug 'wellle/targets.vim'             " Additional/smarter text objects

" Version Control
Plug 'tpope/vim-fugitive'             " Git integration
Plug 'mhinz/vim-signify'              " Sidebar version control integration

" Language Support
Plug 'sheerun/vim-polyglot'           " Suite of language packages
Plug 'jpalardy/vim-slime'             " REPL integration
Plug 'tpope/vim-fireplace'            " Clojure integration
Plug 'bhurlow/vim-parinfer'           " Lisp structural editing
Plug 'autozimu/LanguageClient-neovim', {
\  'branch': 'next',
\  'do': 'bash install.sh',
\ }

" Theming
Plug 'luochen1990/rainbow'            " Rainbow parentheses
Plug 'lifepillar/vim-solarized8'
Plug 'liuchengxu/space-vim-dark'

" NeoVim
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()
filetype plugin indent on
"}}}

" Main Settings -------------------------------------------- {{{
set ttimeoutlen=50                    " Reduce input delay when entering normal mode
set undofile                          " Remember undo history between sessions...
set undodir=~/.vim/undo               " ...and store it here
set noswapfile                        " Don't create swap files
set hidden                            " Allow unsaved buffers (i.e. switch buffers w/o saving current)
set autoread                          " Automatically reload files changes outside of vim
set expandtab                         " Convert tabs to spaces
set tabstop=2                         " Number of spaces for a tab
set softtabstop=2                     " Replace tabs with this number of spaces
set shiftwidth=2                      " Use this number of spaces for shift motions (e.g. indent, dedent)
set shiftround                        " Restrict indentations to multiples of shiftwidth
set backspace=indent,eol,start        " Allow backspacing over these regions (for backwards compat)
set number                            " Show line numbers
set ruler                             " Show current column and line number
set cursorline                        " Highlight the current line
set showcmd                           " Show when leader key has been pressed
set wrap                              " Enable visual line wrapping
set wrapmargin=0                      " Number of characters from the window edge to start wrapping
set foldmethod=syntax                 " Fold based on syntax rules
set foldlevelstart=20                 " Automatically expand all folds (well, up to 20 levels)
set ignorecase                        " Ignore case when searching...
set smartcase                         " ...except when search term starts with a capital
set hlsearch                          " Highlight active search
set incsearch                         " Show search/replace in real time
set modeline                          " Enable modeline
set laststatus=2                      " Always show the status line
set diffopt+=vertical                 " Split diffs vertically (left/right pane)
set scrolloff=3                       " Number of rows to keep visible above/below scroll threshold
set sidescrolloff=3                   " Number of columns to keep visible
set sidescroll=1                      " Scroll columns incrementally at max width, don't jump
set splitright                        " Open new vertical splits to the right
set splitbelow                        " Open new horizontal splits below
set mouse=a                           " Enable mouse interaction, for when all else fails
set lazyredraw                        " Better rendering performance
set ttyfast                           " Improve redraw speed (enabled by default in neovim)
set wildignore+=*.jpg,*.jpeg,*.png,*.svg
let g:jsx_ext_required=0

if has('clipboard')
  set clipboard=unnamedplus           " Use system clipboard with yank/delete
endif
if exists('+colorcolumn')
  set colorcolumn=81                  " Show line length guide
endif
if exists('&inccommand')
  set inccommand=nosplit              " Show substitutions in place
endif
if has('nvim')
  set completeopt-=preview            " Disable preview scratch buffer
endif

" Replace grep with ripgrep for speed
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m
endif

" Prevent grep from automatically opening the first matching file
ca grep grep!
"}}}

" Plugin Configurations ------------------------------------ {{{
" deoplete
let g:deoplete#enable_at_startup=1

" vim-slime
let g:slime_target="neovim"

" vim-sandwich (vim-surround alternative)
" Disable animations
call operator#sandwich#set('all', 'all', 'highlight', 0)

" vim-http-client
let g:http_client_focus_output_window=0

" Ale
let g:ale_fix_on_save=1
let g:ale_fixers={
\  'javascript': ['eslint'],
\}

" vimwiki
let g:vimwiki_list=[
\  {'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}
\]
au FileType vimwiki set syntax=markdown

" LanguageClient-nvim
let g:LanguageClient_autoStart=0

" Minimal LSP configuration for JavaScript
let g:LanguageClient_serverCommands = {}

if executable('javascript-typescript-stdio')
  let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
  let g:LanguageClient_serverCommands['javascript.jsx'] = ['javascript-typescript-stdio']
endif

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
"}}}

" Auto Commands -------------------------------------------- {{{
" Delete all other buffers when running :BufOnly
command! BufOnly silent! execute "%bd|e#|bd#"

" Only show cursor line in active window
augroup cursorLine
  autocmd!
  autocmd BufEnter * setlocal cursorline
  autocmd BufLeave * setlocal nocursorline
augroup end

" Remove trailing whitespace on save
augroup autoTrimWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Automatically open the quickfix list when it gets populated
augroup autoOpenQuickFixList
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END

" Language Support
augroup autoSetFileType
  autocmd!
  autocmd BufNewFile,BufRead *.tsx set filetype=typescript.jsx
augroup END
"}}}

" Theming -------------------------------------------------- {{{
" Don't clobber existing syntax highlighting if config is re-sourced.
if !exists('g:syntax_on')
  syntax enable
endif
if has("termguicolors")
  set termguicolors
endif

set background=dark
colorscheme space-vim-dark
let g:solarized8_term_italics=1

" Display comments in italics
hi Comment cterm=italic

" Lightline
let g:lightline = {
\   'colorscheme': 'deus',
\   'component': {
\     'readonly': '%{&readonly?"\ue0a2":""}',
\   },
\   'active': {
\     'left': [
\       ['mode', 'paste'],
\       [ 'readonly', 'relativepath', 'modified']
\     ],
\     'right': [
\        [ 'lineinfo'],
\        [ 'filetype' ],
\     ]
\   },
\   'inactive': {
\     'right': [
\        [ 'lineinfo' ],
\        [ 'gitversion', 'percent' ],
\     ]
\   },
\ }

" Signify (VCS Gutter)
let g:signify_show_count=1
let g:signify_sign_add='●'
let g:signify_sign_change='●'

" Rainbow Parentheses
let g:rainbow_active=1
let rainbow_colors_light=['#06e5ff', '#e806ff', '#06ff72', '#ffa406']
let rainbow_colors_dark=['DarkBlue', 'Magenta', 'Black', 'Red', 'DarkGray', 'DarkGreen', 'DarkYellow']
let g:rainbow_conf={
\  'guifgs': (&background == 'light' ? rainbow_colors_dark : rainbow_colors_light),
\  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\}

" Fix vim-jsx not coloring closing tags. Seriously?
" https://github.com/mxw/vim-jsx/issues/124
hi Tag        ctermfg=04
hi xmlTag     ctermfg=04
hi xmlTagName ctermfg=04
hi xmlEndTag  ctermfg=04
hi xmlTagName guifg=#59ACE5
hi xmlTag     guifg=#59ACE5
hi xmlEndTag  guifg=#2974a1
"}}}

" Keybindings ---------------------------------------------- {{{
let g:mapleader=' '

" More efficient file saving by double tapping <Esc>
map <Esc><Esc> :w<CR>

" Custom unimpaired bindings
nmap [w <Plug>(ale_previous_wrap)
nmap ]w <Plug>(ale_next_wrap)
nmap [W <Plug>(ale_first)
nmap ]W <Plug>(ale_last)

" Move vertically through visual lines, not logical lines
nnoremap k gk
nnoremap j gj
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

" Disable Shift-Up/Down in visual mode, which 99% of the time is me
" accidentally jumping to the top/bottom of the screen. Prefer H and J.
vnoremap <S-Up> <NOP>
vnoremap <S-Down> <NOP>

" Center screen during jump movements
nnoremap n nzz
nnoremap } }zz

" Don't insert certain deletions into the default register
nnoremap x "_x

" Clear search highlights on Escape...
nnoremap <Esc> :nohlsearch<return><Esc>
" ...but mapping Escape causes weird arrow key behavior, so fix that
" https://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
nnoremap <Esc>^[ <Esc>^[

" Don't automatically jump forward when selecting current word
nnoremap * *<c-o>

" Enable Tab completion for deoplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" Persist selection in visual mode after indent
vnoremap > >gv
vnoremap < <gv

" Option to go to file in vertical split
nnoremap gF :vertical wincmd f<CR>

" Make `gs` useful: search/replace in current buffer (default: sleep)
nnoremap gs :%s/

" Quick access to the macro in the `q` register; I don't care about Ex mode
nnoremap Q @q
xnoremap Q :normal @q<CR>

" Suggested vim-easy-align mappings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Editor-agnostic commenting. More vim emulators seem to support `CMD + /`
" for commenting than `gcc`, so this eases some friction. If outside of a GUI,
" <D-/> (CMD + /) will not work since the command key is ignored. To fix this,
" map the desired key combinations to the function keys as a proxy, and then
" map those to the desired behavior within vim.
" e.g. F6 escape sequence = \x1b[17~
vmap <F6> gcc
nnoremap <F6> <Esc>:Commentary<CR>
inoremap <F6> <Esc>:Commentary<CR>

" Suggested external mapping: CMD + P -> F7
nnoremap <F7> <Esc>:FZF<CR>
nnoremap <F7> <Esc>:FZF<CR>
"}}}

" Mnemonics ------------------------------------------------ {{{
" [A]le
nmap <Leader>af <Plug>(ale_fix)

" [B]uffer
nnoremap <Leader><Tab> :b#<CR>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bo :BufOnly<CR>
xnoremap <Leader>br y:%s/<C-r>"//g<Left><Left>

" [F]ind
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>ff :FZF<CR>
nnoremap <Leader>fw :grep! "<cword>"<CR>
nnoremap <Leader>fs :call LanguageClient_textDocument_documentSymbol()<cr>

" [G]it
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Gbrowse<CR>

" [P]roject
nnoremap <Leader>pt :NERDTreeToggle<CR>

" [Q]uickFix List
nnoremap <Leader>ql :copen<CR>

" [R]epl
nmap <Leader>rc <Plug>SlimeConfig
nmap <Leader>rl <Plug>SlimeLineSend
nmap <Leader>rr <Plug>SlimeParagraphSend
xmap <Leader>rr <Plug>SlimeRegionSend

" [T]erminal
nnoremap <Leader>t? :echo b:terminal_job_id<CR>

" [W]indow
nnoremap <Leader>w= <C-W>=
nnoremap <Leader>w<Down> :split<CR>
nnoremap <Leader>w<Right> :vsplit<CR>
"}}}
