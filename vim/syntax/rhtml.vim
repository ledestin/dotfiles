" RHTML -- HTML with embedded Ruby
" Language:		HTML + Ruby
" Maintainer:		Tobias DiPasquale <toby@cbcg.net>
" Last Modified:	2002 Jun 11
" Location:		http://cbcg.net/rhtml.vim

" for portability
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" load all of the HTML info
source $VIMRUNTIME/syntax/html.vim
unlet b:current_syntax

" load all of the ruby info into @Ruby
syntax include @Ruby $VIMRUNTIME/syntax/ruby.vim
syntax region rhtmlRuby
	\ start=/<%/
	\ end=/%>/
	\ contains=@Ruby, rhtmlRuby

let b:current_syntax = "rhtml"
