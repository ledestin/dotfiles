call pathogen#infect()
call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'jlanzarotta/bufexplorer'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'sheerun/vim-polyglot'
  Plug 'tmhedberg/matchit'
  Plug 'joker1007/vim-ruby-heredoc-syntax'
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'
  Plug 'wakatime/vim-wakatime'
  Plug 'moll/vim-bbye'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'tpope/vim-surround'
  Plug 'christoomey/vim-rfactory'
  Plug 'https://github.com/AndrewRadev/splitjoin.vim.git'
  Plug 'https://github.com/tpope/vim-fugitive.git'
  Plug 'https://github.com/tpope/vim-commentary.git'
  Plug 'https://github.com/inkarkat/vim-ReplaceWithRegister'
  Plug 'christoomey/vim-titlecase'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'kana/vim-textobj-user'
  Plug 'https://github.com/adelarsq/vim-matchit'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'tpope/vim-repeat'
  Plug 'Galooshi/vim-import-js'
  Plug 'christoomey/vim-conflicted'
  Plug 'davidpdrsn/vim-notable'
  Plug 'takac/vim-hardtime'
  Plug 'rhysd/vim-grammarous'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'svermeulen/vim-yoink'
  Plug 'liuchengxu/vim-which-key'

  Plug 'mattn/webapi-vim'
  Plug 'christoomey/vim-quicklink'
call plug#end()

set textwidth=80
set softtabstop=2
set expandtab
set sw=2
set autoindent
set foldmethod=marker
set viminfo='20,f1,%
set hidden
set showcmd
set laststatus=2
set smartcase
set modeline
set modelines=5
set backspace=indent,eol,start
set runtimepath^=~/.vim/bundle/ctrlp.vim
set updatetime=100
set nocompatible
set showcmd
set complete+=kspell " Autocomplete with dictionary words when spell check is on
set incsearch

" standard statusline
set statusline=
set statusline+=\ %f
set statusline+=\ %{&modified?'[+]':''}
set statusline+=%=
set statusline+=%{&paste?'PASTE':''}
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ %{ConflictedVersion()}

set hlsearch
nmap <silent>  <BS>  :nohlsearch<CR>

" turn relative line numbers on
set relativenumber
set rnu

colorscheme mydesert

" Color code over textwidth
autocmd ColorScheme * highlight ColorColumn ctermbg=magenta
let column_to_color = &textwidth + 1
call matchadd('ColorColumn', '\%' . column_to_color . 'v', 100)

" Auto-load .vimrc
autocmd BufWritePost .vimrc source %

if has("autocmd")
  filetype indent plugin on
endif
runtime macros/matchit.vim

autocmd ColorScheme * highlight GitGutterAdd    guifg=#009900 ctermfg=2
autocmd ColorScheme * highlight GitGutterChange guifg=#bbbb00 ctermfg=3
autocmd ColorScheme * highlight GitGutterDelete guifg=#ff2222 ctermfg=1
autocmd ColorScheme * highlight SignColumn ctermbg=black

" vim-which-key
nnoremap <silent> <leader>      :<c-u>WhichKey '\'<CR>

" Yoink - save all copied text and cycle through it on paste. Yay!
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" Also replace the default gp with yoink paste so we can toggle paste in this
" case too
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)

nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)

" Persistent undo
if has('persistent_undo')
  set undofile

  if !isdirectory($HOME . "/.vim_undo_files")
    call mkdir($HOME . "/.vim_undo_files", "p", 0700)
  endif
  set undodir=$HOME/.vim_undo_files
endif

" Hardtime
let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "BufExplorer" ]
let g:hardtime_ignore_quickfix = 1

let g:bufExplorerShowRelativePath=1

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let git_root = system('git rev-parse --show-toplevel')
let git_root = substitute(git_root, '\n$', '', '')
if !empty(git_root)
  let tags_file = git_root . '/.git/tags'
  exec 'set tags='.fnameescape(tags_file)
endif

let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

" QuickFix
noremap [q :cnext<CR>
noremap ]q :cprev<CR>
noremap <Leader>qc :cclose<CR>

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" git grep current word
function! GitGrepCurrentWord()
  silent Ggrep '\<<cword>\>'
endfunction

noremap <Leader>g :call GitGrepCurrentWord()<CR>

" Spell
autocmd Filetype markdown setlocal spell textwidth=80
autocmd Filetype gitcommit,mail setlocal spell

" Don't auto-wrap existing long lines
set fo+=l

" Toggle paste
map <silent> <Leader>p :set invpaste<CR>

" Flash cursor line
autocmd ColorScheme * highlight CursorLine term=bold cterm=inverse
function! Flash()
  set cursorline
  redraw
  sleep 200m
  set nocursorline
endfunction

nnoremap <Leader>c :call Flash()<CR>

" Hardtime
let g:hardtime_default_on = 1

" Help in a separate tab.
augroup HelpInTabs
    autocmd!
    autocmd BufEnter  *.txt   call HelpInNewTab()
augroup END

function! HelpInNewTab ()
    if &buftype == 'help'
        "Convert the help window to a tab...
        execute "normal \<C-W>T"
    endif
endfunction

" Docker
autocmd BufReadPost *dockerfile* set filetype=dockerfile

" Gemfile
let gemfile = ''
if filereadable('./Gemfile')
  let gemfile = './Gemfile'
elseif !empty(git_root) && filereadable(git_root . '/Gemfile')
  let gemfile = git_root . '/Gemfile'
endif

" Accomodate for file watchers.
set backupcopy=yes
filetype plugin on
filetype plugin indent on
syntax enable
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitepace and spaces before a tab:
autocmd Syntax * match ExtraWhitespace /\s\+$\| \+\ze\t/
noremap <F1> :help <cword><CR>

" Vue syntax highlighting support
autocmd FileType vue syntax sync fromstart

" vimrc.local stuff
function! EnableVimrcLocal()
  call mkdir(".git/safe", "p")
endfunction

" ALE
" Only run linters named in ale_linters settings.
let g:ale_enable = 0
let g:ale_linters_explicit = 1
let g:ale_fixers_explicit = 1
" let g:ale_fix_on_save = 1

highlight ALEWarning ctermbg=235

" Enable ALE in vimrc.local
function! EnableALEInVimrcLocal()
  call system("echo 'let g:ale_enable = 1' >> .git/safe/vimrc.local")
endfunction

function! EnableALEInCurrentProject()
  call EnableVimrcLocal()
  call EnableALEInVimrcLocal()
  echo "Please reload ~/.vimrc"
endfunction

" https://vimawesome.com/plugin/better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=0
let g:strip_whitelines_at_eof=1
autocmd FileType * EnableStripWhitespaceOnSave

command! Erc :e ~/.vimrc

imap <C-h> <Left>
imap <C-l> <Right>
map <Leader>d :filetype detect<CR>
map <Leader>w :Bwipeout<CR>
map <Leader>sp :split<CR>
map <Leader>vr :Erc<CR>
map <Leader>vs :source ~/.vimrc<CR>
map <Leader>br :e ~/.bashrc<CR>
map <F9>  :w<CR> :make<CR>
map <F11> :update<CR> : execute("! ./" . bufname(""))<CR>
map <F10> :update<CR> :!ruby -w -c %<CR>

" vim-notable
noremap <leader>n :call notable#open_notes_file()<cr>
let g:notable_notes_folder = "~/work/notes/"

" Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" FZF filename search
nmap <Leader>f :Files<CR>

if filereadable('./bin/spring')
  let g:rspec_command = "!xvfb-run -a ./bin/spring rspec {spec}"
elseif filereadable('./bin/rspec')
  let g:rspec_command = "!xvfb-run -a ./bin/rspec {spec}"
elseif !empty(gemfile)
  let g:rspec_command = "!xvfb-run -a bundle exec rspec {spec}"
else
  let g:rspec_command = "!xvfb-run -a rspec {spec}"
endif

:map \q mz^"zyf>`z:set comments+=n:<C-R>z<CR>gq
:set formatoptions+=cq

set wildmenu
set wcm=<Tab>
menu Encoding.koi8-r   :e ++enc=koi8-r<CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.ibm-866      :e ++enc=ibm866<CR>
menu Encoding.utf-8     :e ++enc=utf-8 <CR>
map <F8> :emenu Encoding.<TAB>

:if &term == "kterm"
:set encoding=japan
:set fileencodings=iso-2022-jp,utf-8,utf-16,ucs-2-internal,ucs-2
:endif

function! DiscoTextWidth()
  if &ft =~ 'gitcommit'
    return
  endif

  setlocal textwidth=100
endfunction

autocmd BufNewFile,BufRead              */work/disco/*    call DiscoTextWidth()

augroup encrypted
    au!

    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2>/dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg   '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost    *.gpg   u
augroup END</pre>

if filereadable(".git/safe/vimrc.local")
  source .git/safe/vimrc.local
endif

if filereadable(".git/safe/../../vimrc.local")
  source .git/safe/../../vimrc.local
endif

" ALE
if g:ale_enable == 1
  let g:ale_linters = {
    \ 'ruby': ['rubocop', 'ruby'],
    \ 'javascript': ['eslint', 'prettier-eslint'],
    \ 'sh': ['shellcheck'],
    \ 'dockerfile': ['hadolint']
  \}
  let g:ale_fixers = {
    \ 'ruby': ['rubocop'],
    \ 'javascript': ['eslint', 'prettier-eslint', 'importjs'],
    \ 'sh': ['shfmt']
  \}

  nmap <silent> <Leader>an <Plug>(ale_next_wrap)
  nmap <silent> <Leader>ap <Plug>(ale_previous_wrap)
  nmap <silent> <Leader>af :ALEFix<CR>
  nmap <silent> <Leader>ad :ALEDetail<CR>

  function! LinterStatus() abort
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:counts.total == 0 ? '' : printf(
          \   ' %d⨉ %d⚠ ',
          \   all_non_errors,
          \   all_errors
          \)
  endfunction

  augroup ALELinters
    autocmd!
    autocmd User ALELintPost   :redrawstatus
    autocmd User ALEFixPost    :redrawstatus
  augroup END

  set statusline+=%=
  set statusline+=%#PmenuSel#%#ErrorMsg#
  set statusline+=%{LinterStatus()}
endif
