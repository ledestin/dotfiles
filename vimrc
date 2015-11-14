call pathogen#infect()

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
set runtimepath^=~/.vim/bundle/ctrlp.vim
filetype plugin on
filetype plugin indent on
colorscheme desert
syntax enable
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitepace and spaces before a tab:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
noremap <F1> :help <cword><CR>

imap <C-h> <Left>
imap <C-l> <Right>
map <F9>  :w<CR> :make<CR>
map <F11> :update<CR> : execute("! ./" . bufname(""))<CR>
map <F10> :update<CR> :!ruby -w -c %<CR>
map <Tab> :!ri <cword><CR>

" Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = "!xvfb-run ./bin/rspec {spec}"

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
