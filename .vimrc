set nocompatible              " required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" utilities
Plug 'scrooloose/nerdtree'            " split file manager
Plug 'ctrlpvim/ctrlp.vim'             " fuzzy finder
Plug 'vim-airline/vim-airline'        " tabs and statusline
" languages
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'sheerun/vim-polyglot'                             " lang packs!
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' } " java
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'sebastianmarkow/deoplete-rust', { 'for': 'rust' } " rust
Plug 'scrooloose/syntastic'           " linting
Plug 'ludovicchabant/vim-gutentags'   " tags navigation Ctrl+] or Ctrl+click to jump
" snippets
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
" color schemes
Plug 'endel/vim-github-colorscheme'
Plug 'blueshirts/darcula' 
Plug 'w0ng/vim-hybrid'
Plug 'tomasiser/vim-code-dark'
Plug 'Heorhiy/VisualStudioDark.vim'
Plug 'lifepillar/vim-solarized8'

call plug#end()             " required
filetype plugin indent on     " required

" Formatting
    " Ctrl+L Format Code
" This performs a write, and then pipes the file to the formatter
" :w save file, :mkview remember line, :%!formatter % to format and output,
" :loadview to return to previous line
augroup autoformat_settings
  autocmd FileType go noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:loadview<CR>
  autocmd FileType html,css,json noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!js-beautify %<CR>:loadview<CR>
  autocmd FileType rust noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>
  autocmd FileType python noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!autopep8 %<CR>:loadview<CR>
  autocmd FileType c,cpp,javascript,java noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
  autocmd FileType sh noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!shfmt %<CR>:loadview<CR>
augroup END

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#python_path = '/bin/python3.6'
let g:deoplete#sources#jedi#extra_path = '/usr/local/lib64/python3.6/site-packages/'
let g:deoplete#num_processes = 1

""" CtrlP
" set ctrlp to same working directory
let g:ctrlp_working_path_mode = 'ra'
" exclude compiled files class and svns
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|bin|out)$',
  \ 'file': '\v\.(exe|so|dll|class|bin|out)$',
  \ }
" Use Ripgrep = superfast
set grepprg=rg
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_clear_cache_on_exit = 0

""" Airline -> bufferline
let g:airline#extensions#tabline#enabled = 1

""" GutenTags
let g:gutentags_enabled = 1
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_cache_dir = "~/.vim/tags"
let g:gutentags_resolve_symlinks = 1
let g:gutentags_ctags_extra_args = ['--recurse=yes', '--extra=+f', '--fields=afmikKlnsStz']
"""  Syntastic
let g:syntastic_c_compiler_options = '--std=gnu11'                  " C
let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++' " C++
let g:syntastic_yaml_checkers = ['js-yaml']                         " Yaml
let g:syntastic_json_checkers = ['jsonlint']                        " Json
" Java
let g:syntastic_java_javac_config_file_enabled = 1  " enables definition of .syntastic_java_config file for custom classpaths
let g:syntastic_java_checkers=['javac']
let g:syntastic_go_checkers=['golint', 'go']                        " Go
let g:syntastic_rust_checkers = ['rustc', 'cargo']                  " Rust
let g:syntastic_python_checkers = ['python', 'flake8'] "['python', 'pylint', 'flake8']   
" Python
let g:syntastic_python_pylint_args='--jobs=8'
" Generic Options
let g:syntastic_check_on_open = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 1
" I Like snippets!
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
""" GENERIC PROGRAMMING
"
" Ctrl+] will perform GoTo. Available for c, c++, objc, objcpp, cs, go, javascript, python, rust
" will use CtrlPTags if not compatible
" On compatible langs, leader+] will open the GetDoc for the function.
" leader+[ will get the Docsets on Zeal/Dash
let g:subtype = ""
map <silent> <leader>[ :<C-u>execute '!zeal ' . &filetype . "," . subtype . ":" . expand("<cword>") . " &>> /dev/null &"<CR><CR>
map <silent> <C-]> :CtrlPTag<cr><C-\>w
" Ctrl+T fuzzy find ctags
noremap <C-T> :CtrlPTag<CR>
" Ctrl+P fuzzy find files
noremap <C-P> :CtrlP<CR>

" F-8 willl perform advanced code analyzing for JAVA
" depends on PMD and this file https://gist.github.com/89luca89/37930d89082d48441cd6fa42d1bd9bea
autocmd FileType java noremap <buffer> <F8> :<C-u>:new<CR>:0read !analyze-pmd.sh<CR>gg

" Ctrl+B open/close file explorer
noremap <C-B> :NERDTreeToggle<CR>
" Ctrl+N relocate file explorer to opened file
noremap <C-N> :NERDTreeFind<CR>

" Ctrl-E show/hide errors window
map <silent> <C-M> :<C-u>SyntasticCheck<CR>
map <silent> <C-E> :<C-u>call ToggleErrors()<CR>
function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         SyntasticCheck
         Errors
    else
        lclose
    endif
endfunction

""" Visual Mode
    """ Ctrl-C copy visual selection to clipboard
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>

""" Tabs Navigation
    " navigate tabs Tab (fw) S-Tab (prev)
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>
    " Ctrl+C close buffer ( pipe commands to fix behaviour with splits and netrw/nerdtree)
nnoremap <C-c> :bp<bar>sp<bar>bn<bar>bd!<CR>

" " Resize split window horizontally and vertically
" Shortcuts to Shift-Alt-Arrows - Alt is mapped as M in vim
noremap <S-M-Up> :2winc+<cr>
noremap <S-M-Down> :2winc-<cr>
noremap <S-M-Left> :2winc><cr>
noremap <S-M-Right> :2winc<<cr>

"shortcut night/day"
map <S-n> :colorscheme darcula<cr>
map <S-d> :colorscheme github<cr>

" ==========================================================================="
" Resize Split When the window is resized"
autocmd VimResized * :wincmd =

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set noswapfile

" play nicely with modern graphics
set encoding=utf8
colorscheme darcula
set termguicolors

set lazyredraw ttyfast synmaxcol=200 ttimeoutlen=20
set mouse=a                           " it's always useful to use the mouse then needed
set hidden                            " change buffer without saving
set wildmenu                          " Tab autocomplete in command mode
set backspace=indent,eol,start        " http://vi.stackexchange.com/a/2163
set laststatus=2                      " Show status line on startup
set splitright splitbelow             " Open new splits to the right and bottom
set autoindent smartindent                              " always set autoindenting on
set expandtab shiftwidth=4 tabstop=4 softtabstop=4      " Four spaces for tabs everywhere
set hlsearch incsearch ignorecase smartcase             " Highlight search results, ignore case if search is all lowercase
set nowrap                            " play nicely with long lines
set number                            " Enable line numbers
let &colorcolumn="80"
syntax on


