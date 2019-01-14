set nocompatible

" vim-plug install
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'altercation/vim-colors-solarized'
Plug 'farmergreg/vim-lastplace'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/camelcasemotion'
Plug 'vim-scripts/bufkill.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/vim-cursorword'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'powerman/vim-plugin-ruscmd'
Plug 'w0rp/ale'

Plug '~/Projects/smartpairs.vim'
Plug '~/Projects/smarthls.vim'
Plug '~/Projects/smartgf.vim'
Plug '~/Projects/vim-bufferline'

Plug 'elixir-editors/vim-elixir'
Plug 'dag/vim-fish'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'vim-ruby/vim-ruby'
Plug 'digitaltoad/vim-pug'
Plug 'slime-lang/vim-slime-syntax'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'yami-beta/asyncomplete-omni.vim'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" some defaults
set nofoldenable
set tabstop=2
set shiftwidth=2
set expandtab
set number
set termguicolors
set binary
set undofile
set undodir=~/.tmp/.undodir
set directory=~/.tmp/.backup,~/.tmp/.undodir,~/.tmp
set undolevels=1000
set history=1000
set noeol
set noswapfile
set nobackup
set nowritebackup
set splitbelow
set splitright
set lazyredraw
set showcmd
set hlsearch
set ignorecase
set smartcase
set gdefault
set nowrap
set formatoptions-=o
set scrolloff=2
set sidescrolloff=7
set sidescroll=1
set mouse=a
set hidden
set autowrite
set autowriteall
set signcolumn=yes
set numberwidth=10

set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~

" disable bell sound
set noerrorbells 
set novisualbell
set t_vb=
if has('autocmd')
    autocmd! GUIEnter * set vb t_vb=
endif

autocmd FileType vim setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

colorscheme solarized

set colorcolumn=120
if &background ==# "light"
    highlight ColorColumn guibg=#00303c
else
    highlight ColorColumn guibg=#efead9
endif

if has('gui_macvim')
    set guioptions-=T
    set guioptions-=m
    set guioptions-=L
    set guioptions-=e

    set t_Co=256
    set background=light
    set guitablabel=%M%t
    set guifont=Menlo\ for\ Powerline:h12

    set cursorline
    set linespace=4
    autocmd FocusLost * :wa
endif

" functions
function! OpenBuf(index)
    if len(g:bufferline_status_info.list) >= a:index
        let buf = g:bufferline_status_info.list[a:index - 1]
        let bufnum = buf[0]
        execute "silent! :buffer ".bufnum
    endif
endfunction

function! CleanClose()
    let name = bufname('%')
    if name == 'NERD_tree_1'
        exe 'NERDTreeToggle'
    elseif name != ''
        exe 'BW'
    endif
endfunction

" Repurpose arrow keys to move lines {{{
function! s:MoveLineUp()
    call <SID>MoveLineOrVisualUp(".", "")
endfunction

function! s:MoveLineDown()
    call <SID>MoveLineOrVisualDown(".", "")
endfunction

function! s:MoveVisualUp()
    call <SID>MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction

function! s:MoveVisualDown()
    call <SID>MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction

function! s:MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
    else
        let move_arg = a:line_getter." +".v:count1
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction

" Arrow key remapping:
" Up/Dn = move line up/dn
" Left/Right = indent/unindent
function! SetArrowKeysAsTextShifters()
    " Normal mode
    nnoremap <silent> <S-Left>   <<
    nnoremap <silent> <S-Right>  >>
    nnoremap <silent> <S-Up>     <Esc>:call <SID>MoveLineUp()<CR>
    nnoremap <silent> <S-Down>   <Esc>:call <SID>MoveLineDown()<CR>

    " Visual mode
    vnoremap <silent> <S-Left>   <gv
    vnoremap <silent> <S-Right>  >gv
    vnoremap <silent> <S-Up>     <Esc>:call <SID>MoveVisualUp()<CR>
    vnoremap <silent> <S-Down>   <Esc>:call <SID>MoveVisualDown()<CR>
endfunction

call SetArrowKeysAsTextShifters()

function! s:ToggleQuote()
    let q = searchpos("'", 'n', line('.'))
    let qb = searchpos("'", 'bn', line('.'))
    let dq = searchpos('"', 'n', line('.'))
    let dqb = searchpos('"', 'bn', line('.'))

    if q[0] > 0 && qb[0] > 0 && (dq[0] == 0 || dq[0] > q[0])
        execute "normal mzcs'\"`z"
    elseif dq[0] > 0 && dqb[0] > 0
        execute "normal mzcs\"'`z"
    endif
endfunction

" drop arrow keys in normal mode
for prefix in ['i', 'n', 'v']
    for key in ['<Up>', '<Down>', '<Left>', '<Right>']
        exe prefix . "noremap " . key . " <Nop>"
    endfor
endfor

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W w
command! Wq wq
" Disable K looking stuff up
nmap K <Nop>

" tab bindings
nmap <Tab> :bnext<CR>
nmap <C-Tab> :bprev<CR>

"append coma to end
map q <Nop>
map Q <Nop>
nmap qq $a,<ESC><ESC>
imap qq <END>,
"remove coma from end
nmap QQ $x
imap QQ <END><BACKSPACE>

nmap <silent> <Leader>p :NERDTreeToggle<CR>
nmap <silent>' :<C-U>call <SID>ToggleQuote()<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nmap <silent>§ :Files<CR>

" Spell check for text files
autocmd BufRead,BufNewFile *.md setlocal spell

function! SetFormatterExs()
    let l:formatters = []
    let l:directory = fnameescape(expand("%:p:h"))

    for l:fmt in findfile(".formatter.exs", l:directory . ";", -1)
        call insert(l:formatters, l:fmt)
    endfor

    call reverse(l:formatters)

    if len(l:formatters) > 0
        let g:ale_elixir_mix_format_options = "--dot-formatter " . l:formatters[0]
    endif
endfunction

autocmd BufRead *.ex call SetFormatterExs()

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

let g:smartpairs_uber_mode = 1
let g:smartpairs_start_from_word = 0
let g:smartpairs_revert_key = '<D-V>'

let g:smartgf_enable_gems_search = 1

let g:indentLine_char = '⎸'

let g:jsx_ext_required = 0

let NERDTreeDirArrows = 1

let g:EasyMotion_mapping_w  = '<Space>w'
let g:EasyMotion_mapping_e  = '<Space>e'
let g:EasyMotion_mapping_b  = '<Space>b'

let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:ale_linters = {}
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.elixir = []

let g:ale_fixers = {}
let g:ale_fixers.javascript = ['prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['prettier']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_fixers.elixir = ['mix_format']

" autocomplete via asyncomplete
set completeopt=menu,menuone,noinsert,noselect
inoremap <silent><expr> J pumvisible() ? "\<C-n>" : "J"
inoremap <silent><expr> K pumvisible() ? "\<C-p>" : "K"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-y>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()


let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 0


au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
            \ 'name': 'buffer',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#buffer#completor'),
            \ }))

au User asyncomplete_setup call asyncomplete#register_source({
            \ 'name': 'omni',
            \ 'whitelist': ['*'],
            \ 'blacklist': ['html'],
            \ 'completor': function('asyncomplete#sources#omni#completor'),
            \  })

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
            \ 'name': 'file',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#file#completor')
            \ }))

au User lsp_setup call lsp#register_server({
            \ 'name': 'elixir-ls',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, '/Users/gorkunov/Projects/elixir-ls/release/language_server.sh']},
            \ 'priority': 10,
            \ 'whitelist': ['elixir', 'eelixir'],
            \ })


" bufferline and statusline
hi ActiveBuffer  guifg=#f6f3e8  guibg=#2e8ccf  gui=NONE  ctermfg=NONE  ctermbg=NONE cterm=NONE
hi StatusNumbers guifg=#022b35  guibg=#83948f  gui=NONE  ctermfg=NONE  ctermbg=NONE cterm=NONE
hi StatusTime    guifg=#022b35  guibg=#a1aba8  gui=NONE  ctermfg=NONE  ctermbg=NONE cterm=NONE
hi StatusPercent guifg=#022b35  guibg=#798883  gui=NONE  ctermfg=NONE  ctermbg=NONE cterm=NONE

let g:bufferline_modified = '*'
let g:bufferline_echo = 0
let g:bufferline_active_buffer_left = ''
let g:bufferline_active_buffer_right = ''
let g:bufferline_inactive_highlight = 'StatusLineNC'
let g:bufferline_active_highlight = 'ActiveBuffer'
autocmd VimEnter *
            \ let &statusline=' %{bufferline#refresh_status()}'
            \ .bufferline#get_status_string()
            \ .'%='
            \ .'%#StatusPercent#'
            \ .' %4p%% '
            \ .'%#StatusNumbers#'
            \ .'%{StatusNumbers()}'
            \ .'%#StatusTime#'
            \ .'%{StatusTime()}'

function! StatusNumbers()
    let min = 15
    let c = virtcol('.')
    let l = line('.')
    let t = line('$')
    let status = ' '.c.':'.l.' L'.t.' '
    let n = strlen(status)
    if min > n
        let status = repeat(' ', min - n) . status
    endif
    return status
endfunction

function! StatusTime()
    let ti = strftime("  %k:%M ")
    return ti
endfunction