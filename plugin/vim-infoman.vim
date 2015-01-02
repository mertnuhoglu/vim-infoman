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
noremap <Leader>i :YankFoldedCurrentNote<CR>

command! SaveAndSource exe 'w'|exe 'source %'
noremap <S-F12> SaveAndSource

function! TestDelete()
	/id=reportlast
	"norm V
	"/id=ref
	"norm d
endfunction
command! TestDelete call TestDelete()

function! ReportLastIds() 
	norm gg
	/^_ref
	/id=reportlast
	norm V
	/^_ref
	norm kd
	norm O_ref id=reportlast
	"norm i_ref id=reportlast
	norm mp
	norm o
	norm mq
	g/id=last/co'p
	"norm Gmq
	'p,'qs/\d\+\.* *//
	norm 'pV'q20<
	'p,'qs/id=\(r_\d\+\)/<url:#r=\1>/
	'p,'qs/id=\(last\d*\)/\1/
endfunction
command! ReportLastIds call ReportLastIds()

" ^\\(\\t*\\)\\(> *\\)*
command! -range=% RemovePreSymbols  <line1>,<line2>s/^\(\t*\)\(> *\)*/\1/
command! -range=% RemovePreSymbols2  <line1>,<line2>s/^\\(\\t*\\)\\(> *\\)*/\\1/

" Sort all tags starting with '_' and move them to the end
function! SortNoteTags()
	norm ggyG
	let text = @"
	ExtractTagsWithUnderlineSymbolSingle
	file sorted_notes
	let words = ReadWordsInFile()
	echo words
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
	let line=getline('.')
	exe 'let words='.line
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

function! DataflowFromRCode()
	let @f = expand('%')
	norm! gg"0yG
	split
	enew
	set buftype=nofile
	file dataflow
	norm! "0p
	" retain only i/o keywords
	g/#/d
	v/\(single\|process\|read\|write\|function\|download\|unzip\|convert\|main\).*(/d
	" filter function calls/documentary uses of io keywords
	g/write \|read \|log(\|@todo\|^\s*#/d
	" filter out read/write function definitions
	g/^read\|^write/d
	g/read_\|\./ s/.*read./\t< /
	%s/(.*)//g
	g/write_\|\./ s/.*write./\t> /
	%s/ = function.*//
	" keep process function calls
	g/=\s*process_.*/ s/^.*=\s*/\t/
	g/=/d
	g/print$/d
	" now remove functions without anything below
	g/^\(\w\|\.\).*\n^\(\w\|\.\)\@=/d
	execute 'norm! ggO'
	norm! "fP
	norm! j>G
	norm! gg"dyG
endfunction
command! DataflowFromRCode call DataflowFromRCode()

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
	/id=r
	normal! n
	normal! 2w
	CopyLocationId
	normal! 2bP
	normal! ld$
	normal! ^y$
	bd
endfunction
command! CopyNodeRef call CopyNodeRef()

function! SubstituteNameInBufDo(old_name, new_name)
	let cmd = 'silent! bufdo %s' . printf('/\<%s\>/%s/g', a:old_name, a:new_name)
	echom cmd
	exe cmd
endfunction
command! -nargs=+ SubstituteNameInBufDo call SubstituteNameInBufDo(<f-args>)

function! DataflowScript(script_filename)
	exe 'b ' . a:script_filename
	DataflowFromRCode
	bd
	EFlowDocumentationPlehn
	norm! G"dp
endfunction

function! DataflowAllScripts()
	" run on a buffer list of R script filenames such as:
	" index_controller.R
	" index_download_functions.R
	let files = filter(getline('1','$'), 'v:val =~ "\w*\.R\s*$"')
	for file in files
		call DataflowScript(file)
	endfor
endfunction
command! DataflowAllScripts call DataflowAllScripts()

function! X(script_filename)
	echo a:script_filename
	exe 'b ' . a:script_filename
	DataflowFromRCode
	"bd
	"EFlowDocumentationPlehn
	"norm! G2k"dpG
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

