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

  Plug 'mattn/webapi-vim'
  Plug 'christoomey/vim-quicklink'
call plug#end()

set textwidth=80
set colorcolumn=+1
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

" standard statusline
set statusline=
set statusline+=\ %f
set statusline+=\ %{&modified?'[+]':''}
set statusline+=%=
set statusline+=\ %p%%
set statusline+=\ %l:%c

if has("autocmd")
  filetype indent plugin on
endif
runtime macros/matchit.vim

autocmd ColorScheme * highlight GitGutterAdd    guifg=#009900 ctermfg=2
autocmd ColorScheme * highlight GitGutterChange guifg=#bbbb00 ctermfg=3
autocmd ColorScheme * highlight GitGutterDelete guifg=#ff2222 ctermfg=1
autocmd ColorScheme * highlight SignColumn ctermbg=black

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
colorscheme mydesert
syntax enable
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitepace and spaces before a tab:
autocmd Syntax * match ExtraWhitespace /\s\+$\| \+\ze\t/
noremap <F1> :help <cword><CR>

" Vue syntax highlighting support
autocmd FileType vue syntax sync fromstart


" ALE
" Only run linters named in ale_linters settings.
let g:ale_enable = 0
let g:ale_linters_explicit = 1
let g:ale_fixers_explicit = 1
" let g:ale_fix_on_save = 1

highlight ALEWarning ctermbg=235

" https://vimawesome.com/plugin/better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=0
let g:strip_whitelines_at_eof=1
autocmd FileType * EnableStripWhitespaceOnSave

imap <C-h> <Left>
imap <C-l> <Right>
map <F9>  :w<CR> :make<CR>
map <F11> :update<CR> : execute("! ./" . bufname(""))<CR>
map <F10> :update<CR> :!ruby -w -c %<CR>

" Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

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

if filereadable(".git/safe/../../vimrc.local")
  source .git/safe/../../vimrc.local
endif

" ALE
if g:ale_enable == 1
  let g:ale_linters = {
    \ 'ruby': ['rubocop', 'ruby'],
    \ 'javascript': ['eslint', 'prettier-eslint']
  \}
  let g:ale_fixers = {
    \ 'ruby': ['rubocop'],
    \ 'javascript': ['eslint', 'prettier-eslint']
  \}

  nmap <silent> <Leader>e <Plug>(ale_next_wrap)

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
