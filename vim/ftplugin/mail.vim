" $Id: mail.vim,v 1.2 2003/10/19 03:08:02 walrus Exp walrus $

let s:qi = '[[:alnum:]]\{1,6}'

" Builds a set of comment chars that represents all the quote strings
" found in the message in the current buffer.
function! MailQuotersToComments() abort
    " Skip headers.
    let savedLine = line('.') | let savedCol = col('.') | normal G$
    let endOfHeaders = search('^$', 'w')
    if !endOfHeaders | call cursor(savedLine, savedCol) | return | endif

    " Default comment chars set.
    let &l:comments = 'n:>'

    " Look at each body line.
    while line('.') < line('$')
	normal j
	let curLine = getline('.')

	" Stop working on signature start.
	if curLine == '-- ' | break | endif

	" Skip unquoted lines.
	let quoter = matchstr(curLine, '^\(\s*\(' . s:qi . '\s*\)\?>\)\+ \?')
	if quoter == '' | continue | endif
	if quoter == curLine | call setline('.', '') | continue | endif

	let quoterLen = strlen(quoter)
	let newQuoter = substitute(quoter, '[^>]\+', '', 'g')

	" Does the quoter contain initials?  Pick the last.
	let initials = matchstr(quoter, s:qi . '[ \t>]\+$')
	if initials != ''
	    let initials = strpart(initials, 0, match(initials, '[ \t>]'))
	    if match(&comments, ':' . initials . '>\($\|,\)') < 0
		let &l:comments = &comments . ',n:' . initials . '>'
	    endif
	    let newQuoter = initials . newQuoter
	endif

	" Now replace the curLine.
	call setline('.', ' ' . newQuoter . ' ' . strpart(curLine, quoterLen))

	" Fix the saved position.
	if line('.') == savedLine
	    let savedCol = savedCol + strlen(newQuoter) - quoterLen
	endif
    endwhile

    call cursor(savedLine, savedCol)
endfunction

" Removes extra spaces after the quoter from the first paragraph line, then
" formats it usual way.
function! MailQuoteFormat() abort
    " Find current quote string.
    let pat = '^\s*\(' . s:qi . '\)\?>\+'
    let quoter = matchstr(getline('.'), pat)

    if quoter == ''
	normal gq$j
	return
    endif

    " Find the first matching line.
    if search('^\(' . quoter . '\([^>]\|$\)\)\@!', 'b')
	normal j
    endif

    " Remove extra spaces.
    exec 's/' . pat . '\s*/' . quoter . ' '

    " Remember the line and find the last one.
    let firstLine = line('.')
    if search('^\(' . quoter . '\([^>]\|$\)\)\@!')
	normal k
    else
	normal G
    endif

    " Format all the lines in between.
    let lines = line('.') - firstLine
    let lines = lines . (lines > 0 ? 'jj' : 'j')
    exec 'normal ' . firstLine . 'Ggq' . lines
endfunction

" Calls MailQuoteFormat() for the whole body.
function! MailQuoteFormatAll() abort
    let savedLine = line('.') | let savedCol = col('.') | normal G$
    if !search('^$', 'w') | call cursor(savedLine, savedCol) | return | endif
    while getline(line('.') + 1) != '-- ' | call MailQuoteFormat() | endwhile
    call cursor(savedLine, savedCol)
endfunction

" Call MailQuotersToComments(), add mappings.
call MailQuotersToComments()

nnoremap Q		:call MailQuoteFormat()<CR>
nnoremap <Leader>Q	:call MailQuoteFormatAll()<CR>

" $Log: mail.vim,v $
" Revision 1.2  2003/10/19 03:08:02  walrus
" Add: $Id$ and $Log$
"
