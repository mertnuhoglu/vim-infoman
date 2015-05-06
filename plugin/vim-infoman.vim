" sort words in a line
command! SortWords call setline('.', join(sort(split(getline('.'), ' ')), " "))

function! SortParagraphs()
	%s/\(.\+\)\n/\1™/
	sort
	%s/™/\r/g
endfunction
command! SortParagraphs call SortParagraphs()

" copies the whole text to a scratch win
function! CopyToScratch()
	norm ggyG
	split
	Enew2
	norm P
endfunction
command! CopyToScratch call CopyToScratch()

" copies the whole text to a scratch win
function! CopyToScratchNoSplit()
	norm ggyG
	Enew2
	norm P
endfunction
command! CopyToScratchNoSplit call CopyToScratchNoSplit()

" searches for given words in a given text
" copies the found lines to a scratch win
function! FindWordsInText(words)
	CopyToScratch
	"let words=['DTR002', 'DTR003', 'DTR007', 'FUN004']
	let words=a:words
	norm Gmx
	for word in words
		exe 'g/'.word.'/t$'
	endfor
	norm 'xdgg
	"sort u
endfunction
command! FindWordsInText call FindWordsInText()

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
	silent! exe 'normal Go---List---'
	silent! exe 'g/^DTR\d\+\>:/co$' 
	normal G2o
	silent! exe 'g/^FUN\d\+\>:/co$' 
	normal G2o
	silent! exe 'g/^ISS\d\+\>:/co$' 
	/---List---
	silent! normal dG
	split
	enew
	set buftype=nofile
	normal P
	g/file:\/\/\//d
	g/\s*>>\s*$/d
	sort u
	/^FUN
	normal 2O
	normal ggyG
endfunction	
command! ExtractListRequirements call ExtractListRequirements()

function! ExtractTagsWithUnderlineSymbol()
	" Input:
	" Keynote text file
	" Output:
	" lines starting with tag words such as _gtd
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
	" tag words such as _gtd
	silent ExtractTagsWithUnderlineSymbol
	silent %s/ .*//
	sort u
endfunction
command! ExtractTagsWithUnderlineSymbolSingle call ExtractTagsWithUnderlineSymbolSingle()

function! ExtractTagsWithAtSymbol()
	" Input:
	" Keynote text file
	" Output:
	" lines starting with @some_tag
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
	normal 2jVnNkk
	silent! '<,'>s/^$/\t/
	normal V
	" Indent current note except its header
	?^_
	normal jjVNkk>
	" Close fold
	?^_
	normal j
	foldclose
endfunction
command! FoldCurrentNote call FoldCurrentNote()

" yank folded current note in notes.otl to paste to keynote
function! YankFoldedCurrentNote()
	" Replace tabbed blank lines with blanks
	?^_
	normal 2jVnNkk
	silent! '<,'>s/^\t$//
	normal V
	" Decrease Indent current note except its header
	?^_
	normal jjVNkk<
	" Yank
	?^_
	normal jVNkky
endfunction
command! YankFoldedCurrentNote call YankFoldedCurrentNote()
noremap <Leader>i :YankFoldedCurrentNote<CR>

command! SaveAndSource exe 'w'|exe 'source %'
noremap <S-F12> SaveAndSource

function! TestDelete()
	/id=reportlast
	"normal V
	"/id=ref
	"normal d
endfunction
command! TestDelete call TestDelete()

function! ReportLastIds() 
	normal gg
	/^_ref
	/id=reportlast
	normal V
	/^_ref
	normal kd
	normal O_ref id=reportlast
	"normal i_ref id=reportlast
	normal mp
	normal o
	normal mq
	g/id=last/co'p
	"normal Gmq
	'p,'qs/\d\+\.* *//
	normal 'pV'q20<
	'p,'qs/id=\(r_\d\+\)/<url:#r=\1>/
	'p,'qs/id=\(last\d*\)/\1/
endfunction
command! ReportLastIds call ReportLastIds()

" ^\\(\\t*\\)\\(> *\\)*
command! -range=% RemovePreSymbols  <line1>,<line2>s/^\(\t*\)\(> *\)*/\1/
command! -range=% RemovePreSymbols2  <line1>,<line2>s/^\\(\\t*\\)\\(> *\\)*/\\1/

" Sort all tags starting with '_' and move them to the end
function! SortNoteTags()
	normal ggyG
	let text = @"
	silent! ExtractTagsWithUnderlineSymbolSingle
	file sorted_notes
	silent! let words = ReadWordsInFile()
	"echo words
	%d _
	put = text
	for word in words
		exe 'g/^'.word.'\>/,/^_/-1 m$ '
	endfor
	set ft=vo_base
endfunction
command! SortNoteTags call SortNoteTags()

" Inp:	a list of words
" word1
" word2
" Out:   read into a vimscript variable
function! ReadWordsInFile()
	ReplaceEndOfLineWithComma
	%join
	SurroundWordsWithQuotes
	%s/.*/[\0]/
	exe 'let words='.getline('.')
	return words
endfunction

function! TestReadWordsIntoVariable()
	let words = ReadWordsInFile()
	echo words
endfunction
 
function! ConvertKeynoteFile()
	g/^--- \d/ s/\(^--- \)\(\d\)\(.*\)/\1\2\3{{{\2/
	set foldmethod=marker
   set noignorecase
   silent! %s/ý/ı/g
   silent! %s/Ý/İ/g 
   silent! %s/ţ/ş/g
   silent! %s/đ/ğ/g
   set ignorecase
	w
endfunction
command! ConvertKeynoteFile call ConvertKeynoteFile() 

function! CodePostgreImportFromListOfDataFiles()
	" convert flow.otl data input/output descriptions into postgre copy_to code
	" < company_exchange_from_10k_filings
	" >
	" pg = copy_to(db, read_company_exchange_from_10k_filings(), name = 'company_exchange_from_10k_filings', temporary = FALSE)
	v/<\|>/d
	%s/^.*\<//
	sort u
	%s/\w*/pg = copy_to(db, read_\0(), name = "\0", temporary = FALSE)/
endfunction
command! CodePostgreImportFromListOfDataFiles call CodePostgreImportFromListOfDataFiles()

function! Id()
	" puts id to the end of current line. eg:
	"
	" task ... 
	" >
	" task ... id=r_246
	
	normal! mw
	/id=r_lastid
	normal! $"iyiw
	execute "normal! \<C-A>"
	normal! 'w
	execute "normal! A id=\<esc>"
	normal! "ip
endfunction
command! Id call Id()

function! Id2()
	Id
	CopyNodeRef
endfunction
command! Id2 call Id2()

function! CopyNodeRef2()
	CopyNodeRef
	execute "normal! o\<Tab>"
	normal! p
endfunction
command! CopyNodeRef2 call CopyNodeRef2()

function! CopyNodeRef()
	" copies current node with its id properly formatted
	" install postgre on osx id=r_318
	" >
	" install postgre on osx <url:vim-infoman.vim#r=r_318>
	normal! "xyy
	split
	enew
	set buftype=nofile
	normal! "xP
	/id=\w
	normal! n
	normal! 2w
	CopyLocationId
	normal! 2bP
	normal! ld$
	normal! ^y$
	bd
endfunction
command! CopyNodeRef call CopyNodeRef()

" return-done bookmarking
" assumes:
"	mark source (return place) as s
"	mark destination (done place) as d
function! IdPair()
	normal! 's
	Id2
	execute "normal! o\<Tab>\<c-r>*"
	normal! 't
	execute "normal! o\<Tab>return: \<c-r>*"
	normal! k
	Id2
	execute "normal! o\<Tab>\<c-r>*"
	normal! 's
	execute "normal! jodone: \<c-r>*"
endfunction
command! IdPair call IdPair()

" replace change name
function! SubstituteNameInBufDo(old_name, new_name)
	let cmd = 'silent! bufdo %s' . printf('/\<%s\>/%s/g', a:old_name, a:new_name)
	echom cmd
	exe cmd
endfunction
command! -nargs=+ SubstituteNameInBufDo call SubstituteNameInBufDo(<f-args>)

function! EnewAndPaste()
	split
	enew
	set buftype=nofile
	normal! P
endfunction
command! EnewAndPaste call EnewAndPaste()

function! RemoveInvalidSpace()
	bufdo silent! %s/ / /g
endfunction
command! RemoveInvalidSpace call RemoveInvalidSpace()

function! X(script_filename)
	echo a:script_filename
	exe 'b ' . a:script_filename
	DataflowFromRCode
	"bd
	"EFlowDocumentationPlehn
	"normal! G2k"dpG
endfunction

function! Y()
	"g/^\w*\.R\s*$/call X(getline("."))
	"g/^\w*\.R\s*$/call X('filing_functions.R')
	let files = filter(getline('1','$'), 'v:val =~ "\w*\.R\s*$"')
	for file in files
		call X(file)
	endfor
	"call X('filing_functions.R')
	"b filing_functions.R
	"DataflowFromRCode
endfunction
command! Y call Y()


