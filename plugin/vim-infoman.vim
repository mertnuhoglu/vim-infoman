" Move current note to the end of file 
" A note is a part of file that starts with "_".
command! MoveCurrentNoteToEnd .,/^_/- m$<cr>

function! SortRequirements()
	" Input:
	" Keynote text
	" Output:
	" moves lines with DTR/FUN/ISS to end
	exe 'g/^DTR\d\+\>/,/^$/mo$' 
	exe 'g/^FUN\d\+\>/,/^$/mo$' 
endfunction	
command! SortRequirements call SortRequirements()

function! ExtractListRequirements()
	" Input:
	" Keynote text
	" Output:
	" lines with DTR/FUN/ISS
	silent! exe 'norm Go---List---'
	silent! exe 'g/^DTR\d\+\>:/co$' 
	norm G2o
	silent! exe 'g/^FUN\d\+\>:/co$' 
	norm G2o
	silent! exe 'g/^ISS\d\+\>:/co$' 
	/---List---
	silent! norm dG
	split
	enew
	set buftype=nofile
	norm P
	g/file:\/\/\//d
	g/\s*>>\s*$/d
	sort u
	/^FUN
	norm 2O
	norm ggyG
endfunction	
command! ExtractListRequirements call ExtractListRequirements()

function! ExtractTagsWithUnderlineSymbol()
	" Input:
	" Keynote text file
	" Output:
	" lines starting with tag words such as _gtd
	CopyToScratch
	v/^_/d
	%s/ \+$//
	sort u
endfunction
command! ExtractTagsWithUnderlineSymbol call ExtractTagsWithUnderlineSymbol()

function! ExtractTagsWithUnderlineSymbolSingle()
	" Input:
	" Keynote text file
	" Output:
	" tag words such as _gtd
	silent ExtractTagsWithUnderlineSymbol
	silent %s/ .*//
	sort u
endfunction
command! ExtractTagsWithUnderlineSymbolSingle call ExtractTagsWithUnderlineSymbolSingle()

function! ExtractTagsWithAtSymbol()
	" Input:
	" Keynote text file
	" Output:
	" lines starting with @some_tag
	CopyToScratch
	v/^@/d
	%s/ \+$//
	sort u
endfunction
command! ExtractTagsWithAtSymbol call ExtractTagsWithAtSymbol()

function! ExtractReqsWithLinks()
	" Input:
	" Keynote text
	" Output:
	" lines with DTR/FUN and file://
	CopyToScratch
    silent! v/file:/d
    silent! v/DTR\|FUN/d
    silent! g/related/d
	sort
endfunction
command! ExtractReqsWithLinks call ExtractReqsWithLinks()

function! ConvertTagsToVimList()
	" Convert a list of tags(ids) to a list for use in vimscript:
	" Input:
	"	1. Download and merge ex lists	
	"	DTR002, DTR003, DTR007, FUN004

	"	2. Download store filing indexes	
	"	DTR011, DTR012, DTR023, DTR027, FUN007, FUN008
	" Output:
	" 	['DTR002', 'DTR003', 'DTR007', 'FUN004', 'DTR011', 'DTR012', 'DTR023', 'DTR027', 'FUN007', 'FUN008']
	CopyToScratchNoSplit
	RemoveLinesStartingWithNumbers
	RemoveBlankLines
	%ReplaceEndOfLineWithComma
	%join
	SurroundWordsWithQuotes
	" surround line with brackets []
	s/.*/[\0]/
	let line=getline('.')
	exe 'let words='.line
	return words
endfunction

function! ExtractLinesWithSearchWords()
	" words_for_search.in:
	"FUN005, DTR013, DTR030, DTR031, DTR032, ISS001
	" text_to_search.in:
	"DTR011: Store the url links t
	"DTR012: Associate amended ver
	"DTR013: Verify that we don't 
	" result:
	"DTR013: Verify that we don't 
	lcd /Users/mertnuhoglu/Dropbox/Apps/MindMup/plehn/
	e words_for_search.in
	let words=ConvertTagsToVimList()
	echo words
	e text_to_search.in
	call FindWordsInText(words)
endfunction
command! ExtractLinesWithSearchWords call ExtractLinesWithSearchWords()

" fold current note in notes.otl
function! FoldCurrentNote()
	" Replace blank lines with tabs
	?^_
	norm 2jVnNkk
	silent! '<,'>s/^$/\t/
	norm V
	" Indent current note except its header
	?^_
	norm jjVNkk>
	" Close fold
	?^_
	norm j
	foldclose
endfunction
command! FoldCurrentNote call FoldCurrentNote()

" yank folded current note in notes.otl to paste to keynote
function! YankFoldedCurrentNote()
	" Replace tabbed blank lines with blanks
	?^_
	norm 2jVnNkk
	silent! '<,'>s/^\t$//
	norm V
	" Decrease Indent current note except its header
	?^_
	norm jjVNkk<
	" Yank
	?^_
	norm jVNkky
endfunction
command! YankFoldedCurrentNote call YankFoldedCurrentNote()
