set nocompatible
set encoding=utf-8
filetype off

packadd minpac
call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('scrooloose/nerdtree')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('mileszs/ack.vim')

call minpac#add('tpope/vim-fugitive')
call minpac#add('mhinz/vim-signify')

call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-surround')
call minpac#add('machakann/vim-highlightedyank')

call minpac#add('pangloss/vim-javascript')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('peitalin/vim-jsx-typescript')
call minpac#add('styled-components/vim-styled-components', { 'branch': 'main' })
call minpac#add('jparise/vim-graphql')


call minpac#add('rktjmp/lush.nvim')
call minpac#add('casonadams/walh')
call minpac#add('axvr/raider.vim')

call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

filetype plugin indent on

" set t_Co=256
set termguicolors
syntax enable
" autocmd ColorScheme sick highlight Normal ctermbg=235
colorscheme raider

set noerrorbells
set novisualbell
set t_vb=

" moving around, searching, and patterns ----------------------------------
set incsearch
set showmatch
set smartcase
set ignorecase
set gdefault
set inccommand=nosplit
" displaying text
set number
set relativenumber
set linebreak
set nowrap
" syntax, highlighting, spelling
set hlsearch
" set background=dark
set colorcolumn=80 
set mouse=a
set re=0

" tabs and indenting ------------------------------------------------------
set autoindent
set smartindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

"autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
"autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript
autocmd FileType mail setlocal fo+=aw
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.txt set filetype=markdown

set shiftround
" folding -----------------------------------------------------------------
set foldmethod=manual
set foldmarker={{{,}}}

" concealing --------------------------------------------------------------
set conceallevel=2

" spliting ----------------------------------------------------------------
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" line jumps --------------------------------------------------------------
noremap H ^
noremap L g_

" gui setings -------------------------------------------------------------
if has("gui")
	set guioptions-=T                             "hide toolbar in mvim
	set guioptions-=r
	set guioptions-=L
	set guifont=hack:h20
endif

let mapleader=','
let maplocalleader="\\"
nnoremap \ ,
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :noh<cr>

" project navigation  -----------------------------------------------------
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :GFiles<cr>
nnoremap & :execute 'Ag '.expand('<cword>')<CR>

" Buffers -----------------------------------------------------------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
"nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <C-l> :bnext<CR>
" Move to the previous buffer
nmap <C-h> :bprevious<CR>

"nnoremap gt :bnext<CR>
"nnoremap gT :bprevious<CR>


" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

cnoreabbrev b Buffers

nnoremap <C-k> :Buffers<CR>

" abbreviations -----------------------------------------------------------
nnoremap ; :
vnoremap ; :
inoremap jk <esc>

cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Q! q!
cnoreabbrev Tabe tabe
cnoreabbrev wrap set wrap
cnoreabbrev nowrap set nowrap

set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE

" highlight ExtraWhitespace ctermbg=0 guibg=#282a2e
" match ExtraWhitespace /\s\+$/

let g:yats_host_keyword = 1

" coc config, mostly copied from https://github.com/neoclide/coc.nvim
let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-pairs',
\ 'coc-tsserver',
\ 'coc-json'
\ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

command! -nargs=0 Prettier :CocCommand prettier.formatFile

nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>gh  :OpenGithubFile<cr>

augroup javascript_folding
    au!
    au FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

" augroup twig_ft
"   au!
"   autocmd BufNewFile,BufRead *.tsx set filetype=typescript
" augroup END

augroup todo_txt
    au!
    au filetype todo setlocal omnifunc=todo#Complete
augroup END

augroup markdown
    au!
    au FileType markdown setlocal wrap
augroup END

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=ONE guifg=NONE ctermfg=NONE

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" autocmd BufWritePre *.js,*.cjs,*.mcjs call CocAction('runCommand', 'eslint.executeAutofix')
"
function! ToggleAccent()
   " Vowels
   let withAccent   = [ "á", "é", "í", "ó", "ú", "ñ", "Á", "É", "Í", "Ó", "Ú" ]
   let withNoAccent = [ "a", "e", "i", "o", "u", "n", "A", "E", "I", "O", "U" ]

   " A better way of getting the character under the cursor
   " From: https://stackoverflow.com/a/23323958/1121933
   let character = matchstr( getline('.'), '\%' . col('.') . 'c.' )

   " If it's a vowel without an acute accent over it, 'position' will contain
   " the index of the matching element in the 'withNoAccent' list or -1 otherwise.
   let position = match( withNoAccent , character )
   if position != -1
      " Replace it with an accented vowel
      execute ":normal! r" . withAccent[position]
   else
      " Check if it's a vowel with an acute accent over it
      let position = match( withAccent , character )
      if position != -1
         " Replace it with a vowel with no accent
         execute ":normal! r" . withNoAccent[position]
     endif
   endif

   " Do nothing if it isn't a vowel
endfunction

" Map the '-' key
nnoremap <silent> - :call ToggleAccent()<CR>

