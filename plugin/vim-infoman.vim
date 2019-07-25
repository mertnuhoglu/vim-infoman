command! -bar Enew2 enew | set buftype=nofile
command! Enew3 split | enew | set buftype=nofile
command! En2 Enew2 
cnoremap En2 Enew2
cnoremap En3 Enew3
function! Enew4()
	norm gg"fyG
	Enew3
	norm "fP
endfunction
command! Enew4 call Enew4()
function! EnewFile()
	norm gg"syG
	split
	lcd %:h
	pwd
	enew
	normal "sP
endfunction
command! EnewFile call EnewFile()

" sort words in a line
command! SortWords call setline('.', join(sort(split(getline('.'), ' ')), " "))

function! SortParagraphs()
	%s/\\(.\\+\\)\\n/\\1™/
	sort
	%s/™/\\r/g
endfunction
command! SortParagraphs call SortParagraphs()

" copies the whole text t	- a scratch win
function! CopyToScratch()
	norm ggyG
	split
	Enew2
	norm P
endfunction
command! CopyToScratch call CopyToScratch(ku_rdb/scripts/deprecated.R)

" copies the whole text t	- a scratch win
function! CopyToScratchNoSplit()
	norm ggyG
	Enew2
	norm P
endfunction
command! CopyToScratchNoSplit call CopyToScratchNoSplit()

" searches for given words in a given text
" copies the found lines t	- a scratch win
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

" Move current note t	- the end of fku_rdb/scripts/deprecated.Rile 
" A note is a part of file that starts with "_"ku_rdb/scripts/deprecated.R.
command! MoveCurrentNoteToEnd .,/^_/- m$<cr>

function! SortRequirements()
	" Input:
	" Keynote text
	" Output:
	" moves lines with DTR/FUN/ISS t	- end
	exe 'g/^DTR\\d\\+\\>/,/^$/mo$' 
	exe 'g/^FUN\\d\\+\\>/,/^$/mo$' 
endfunction	
command! SortRequirements call SortRequirements()

function! ExtractListRequirements()
	" Input:
	" Keynote tku_rdb/scripts/deprecated.Rext
	" Output:
	" lines with DTR/FUN/ISS
	silent! exe 'normal Go---List---'
	silent! exe 'g/^DTR\\d\\+\\>:/co$' 
	normal G2o
	silent! exe 'g/^FUN\\d\\+\\>:/co$' 
	normal G2o
	silent! exe 'g/^ISS\\d\\+\\>:/co$' 
	/---List---
	silent! normal dG
	Enew3
	normal P
	g/file:\\/\\/\\//d
	g/\\s*>>\\s*$/d
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
	%s/ \\+$//
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
	%s/ \\+$//
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
    silent! v/DTR\\|FUN/d
    silent! g/related/d
	sort
endfunction
command! ExtractReqsWithLinks call ExtractReqsWithLinks()

function! ConvertTagsToVimList()
	" Convert a list of tags(ids) t	- a list for use in vimscript:
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
	s/.*/[\\0]/
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
	ech	- words
	e text_to_search.in
	call FindWordsInText(words)
endfunction
command! ExtractLinesWithSearchWords call ExtractLinesWithSearchWords()

" fold current note in notes.otl 
function! FoldCurrentNote()
	" Replace blank lines with tabs
	?^_
	normal 2jVnNkk
	silent! '<,'>s/^$/\\t/
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

" yank folded current note in notes.otl t	- paste t	- keynote
function! YankFoldedCurrentNote()
	" Input:
	" _sss
	" 
	" t3
	" t4
	" 
	" _end
	" Output:
	" 
	" t3
	" t4
	" 
	" Explain: copy between two markers that start with underscore `_` char
	"
	" Replace tabbed blank lines with blanks
	?^_
	normal 2jVnNkk
	silent! '<,'>s/^\\t$//
	normal V
	" Decrease Indent current note except its header
	?^_
	normal jjVNkk<
	" Yank
	?^_
	normal jVNkky
endfunction
command! YankFoldedCurrentNote call YankFoldedCurrentNote()

command! SaveAndSource exe 'w'|exe 'source %'
noremap <S-F12> SaveAndSource

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
	'p,'qs/\\d\\+\\.* *//
	normal 'pV'q20<
	'p,'qs/id=\\(r_\\d\\+\\)/<url:#r=\\1>/
	'p,'qs/id=\\(last\\d*\\)/\\1/
endfunction
command! ReportLastIds call ReportLastIds()

" ^\\\\(\\\\t*\\\\)\\\\(> *\\\\)*
command! -range=% RemovePreSymbols  <line1>,<line2>s/^\\(\\t*\\)\\(> *\\)*/\\1/
command! -range=% RemovePreSymbols2  <line1>,<line2>s/^\\\\(\\\\t*\\\\)\\\\(> *\\\\)*/\\\\1/

" Sort all tags starting with '_' and move them t	- the end
function! SortNoteTagsSingle()
	normal ggyG
	let text = @"
	silent! ExtractTagsWithUnderlineSymbolSingle
	file sorted_notes
	silent! let words = ReadWordsInFile()
	"ech	- words
	%d _
	put = text
	for word in words
		exe 'g/^'.word.'\\>/,/^_/-1 m$ '
	endfor
	set ft=vo_base
endfunction
command! SortNoteTagsSingle call SortNoteTagsSingle()

function! SortNoteTags()
	normal ggyG
	let text = @"
	silent! ExtractTagsWithUnderlineSymbol
	file sorted_notes
	silent! let words = ReadLinesInFile()
	"ech	- words
	%d _
	put = text
	for word in words
		exe 'g/^'.word.'\\>/,/^_/-1 m$ '
	endfor
	set ft=vo_base
endfunction
command! SortNoteTags call SortNoteTags()

" Inp:	a list of words
" word1
" word2
" Out:   read int	- a vimscript variable
function! ReadLinesInFile()
	SurroundLinesWithQuotes
	ReplaceEndOfLineWithComma
	%join
	%s/.*/[\\0]/
	exe 'let words='.getline('.')
	return words
endfunction

" Inp:	a list of words
" word1
" word2
" Out:   read int	- a vimscript variable
function! ReadWordsInFile()
	ReplaceEndOfLineWithComma
	%join
	SurroundWordsWithQuotes
	%s/.*/[\\0]/
	exe 'let words='.getline('.')
	return words
endfunction

function! TestReadWordsIntoVariable()
	let words = ReadWordsInFile()
	ech	- words
endfunction
 
function! ConvertKeynoteFile()
	g/^--- \\d/ s/\\(^--- \\)\\(\\d\\)\\(.*\\)/\\1\\2\\3{{{\\2/
	set foldmethod=marker
  set noignorecase
  silent! %s/ý/ı/g
  silent! %s/Ý/İ/g 
  silent! %s/ţ/ş/g
  silent! %s/đ/ğ/g
  set ignorecase
	silent! %s/^## 7-/####### /
	silent! %s/^## 6-/###### /
	silent! %s/^## 5-/##### /
	silent! %s/^## 4-/#### /
	silent! %s/^## 3-/### /
	g/^===/-1,. le 2 | norm o
	g/^---/-1,. le 2 | norm o
	g/^^^^/-1,. le 2 | norm o
	RemoveMultipleBlankLines
	w
endfunction
command! ConvertKeynoteFile call ConvertKeynoteFile() 

function! CodePostgreImportFromListOfDataFiles()
	" convert flow.otl data input/output descriptions int	- postgre copy_t	- code
	" < company_exchange_from_10k_filings
	" >
	" pg = copy_to(db, read_company_exchange_from_10k_filings(), name = 'company_exchange_from_10k_filings', temporary = FALSE)
	v/<\\|>/d
	%s/^.*\<//
	sort u
	%s/\\w*/pg = copy_to(db, read_\\0(), name = "\\0", temporary = FALSE)/
endfunction
command! CodePostgreImportFromListOfDataFiles call CodePostgreImportFromListOfDataFiles()

" copy location for use in utl.vim url
function! CopyLocation()
  " put cursor on this word_x
  " ->
  " <url:vim-infoman.vim#word_x>
	" copy current file
	let filename = expand("%")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#" . word . ">"
	let @* = url
endfunction
command! CopyLocation call CopyLocation()
command! RefWordRelativePath CopyLocation

" copy location with absolute path for use in utl.vim url
function! CopyLocation2()
  " put cursor on this word_x
  " ->
  " <url:/Users/mertnuhoglu/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#word_x>
  "
	" copy current file
	let filename = expand("%:p")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#" . word . ">"
	let @* = url
endfunction
command! CopyLocation2 call CopyLocation2()
command! RefWord CopyLocation2
                                
" copy line with relative path for use in utl.vim url
function! CopyLineAsUrl()
  " some text
  " ->
	" some text <url:/Users/mertnuhoglu/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#tn=some text>
  "
	" copy current file path
	let filename = expand("%:p")
	" copy current line 
	let line = Strip(getline("."))
	let url = line . " <url:" . filename . "#tn=" . line . ">"
	let @* = url
	return url
endfunction
command! CopyLineAsUrl call CopyLineAsUrl()
command! RefLine CopyLineAsUrl
nnoremap rl :RefLine<cr>

" copy line with id for use in utl.vim url with full path t	- file
function! CopyRefId()
	" CopyRefId id=g_00009
  " -->
  " <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g_00009>
	"
	" copy current file path
	let filename = expand("%:p")
	" /Users/mertnuhoglu/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R
	let filename2 = substitute(filename, '/Users/mertnuhoglu', '\~', '')
	let filename3 = substitute(filename2, ' (Personal)', '', '')
	" ~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R
	let line = Strip(getline("."))
	"		# id=r_00005
	let id = substitute(line, '.*id=\(\w\+\)', '\1', '')
	" r_00005
	let result = printf("<url:file:///%s#r=%s>", filename3, id)
	" <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R#r=r_00005>
  let @* = result
	return result
endfunction
command! CopyRefId call CopyRefId()
command! RefId CopyRefId 

function! Strip(input_string)
  let a0 = substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
	let a1 = substitute(a0, '^#* ', '', '')
	let a2 = substitute(a1, '`', '', 'g')
	return a2
endfunction

" copy location under cursor
function! CopyLocationUnderCursor()
	" copy current file
	let filename = expand("%")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#r=" . word . ">"
	let @* = url
endfunction
command! CopyLocationUnderCursor call CopyLocationUnderCursor()

function! Id()
	" puts id t	- the end of current line. eg:
	"
	" task ... 
	" >
	" task ... id=r_246
	normal! mw
	/id=r_lastid
	normal! $
	execute "normal! \<C-A>"
	normal! "iyiw
	normal! 'w
	execute "normal! A id=\<esc>"
	normal! "ip
endfunction
command! Id call Id()

function! Id3()
	Id
	PasteRefLine
endfunction
command! Id3 call Id3()
command! -range=% IdSwap <line1>,<line2>s/^\\(\\s*\\)\\(\\w\\+[^<]*\\)\\(<.*>\\)/\\1\\3 \\2/

function! Id4()
	PutGlobalId
	let @* = CopyRefId()
endfunction
command! Id4 call Id4()

function! Id5()
	" global ID
	"
	" input:
		" opt5: make it a function 
	" output:
		" opt5: make it a function id=g_00009
		" opt5: make it a function <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_trycatch.R#r=g_00009>
	PutGlobalId
	PasteRefLineAsFilePath
	normal yy
endfunction
command! Id5 call Id5()
command! IdG call Id5()

function! Id7()
	" lokal id already exists use it as global ID
	"
	" input:
		" opt5: make it a function id=g_00009
	" output:
		" opt5: make it a function <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_trycatch.R#r=g_00009>
	call PasteRefLineAsFilePath()
endfunction
command! Id7 call Id7()
command! IdX call Id7()

function! Id6()
	" input:
		" opt5: make it a function 
	" output:
		" opt5: make it a function id=g_00009
		" @link: # opt5: make it a function study_trycatch.R#r=g_00009
	Id5
	RemoveUrlTag
	left 2
endfunction
command! Id6 call Id6()

function! IdR()
	" global id for R code
	"
	" input:
		" update_new_fields = function() {
	" output:
		" # update_new_fields = function() { # id=g_0009
		" # update_new_fields = function() { <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/prepare_rdb_data_operations.R#r=g_0009>
	norm! A # 
	PutGlobalId
	call PasteRefLineAsFilePath()
endfunction
command! IdR call IdR()

function! ReplaceInLineAsFilePath(refid)
	" wifi connection issues id=g_10099
	" >
	" wifi connection issues <url:file:///~/Dropbox/mynotes/code/cosx/cosx.md#r=g_10099>
	silent! s/id=\w*//
  "normal "=&a:refid<C-M>p
  "put =&sessionoptions
  put =a:refid
  normal! kJ
  return a:refid
endfunction
function! PasteRefLineAsFilePath() 
	" wifi connection issues id=g_10099
	" >
	" wifi connection issues <url:file:///~/Dropbox/mynotes/code/cosx/cosx.md#r=g_10099>
	let refid = CopyRefId()
	"normal! ^y$
	let line = Strip(getline("."))
	let @* = line
	execute "normal! o\<Tab>"
	normal! lPyy
  call ReplaceInLineAsFilePath(refid)
	" silent! s/id=\w*//
	" let @* = refid
	" normal! $p
endfunction
command! PasteRefLineAsFilePath call PasteRefLineAsFilePath()
command! RefLineId PasteRefLineAsFilePath 

function! PasteRefLineALink() 
	" Build java modules <a name="build_java_module"></a>
	" >
	" [Build java modules](#build_java_module) <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#tn=build_java_module>
	let filename0 = expand("%:p")
	let filename = substitute(filename0, '/Users/mertnuhoglu', '\~', '')
	let line0 = Strip(getline("."))
	let line1 = substitute(line0, '^\s*["#/]*\s*', '', '')
	let line = substitute(line1, '\s*<a name=.*>', '', '')
	let id = substitute(line1, '.*<a name="\(\w\+\)">.*<.a>', '\1', '')
	let result = printf("[%s](#%s) <url:file:///%s#tn=%s>", line, id, filename, id)
	let @* = result
	return result
endfunction
command! PasteRefLineALink call PasteRefLineALink()
command! RefLineA PasteRefLineALink 

command! RemoveUrlTag s#<url:.*/## | s#>## | s#^#@link: # | silent! s#klimka##

if !exists("g:refline")
  let g:refline = ""
endif
function! PasteRefLine()
	" data innovations online course project  id=dat_011
	" >
	" data innovations online course project  <url:#r=dat_011>
	let @* = CopyRefLine()
	"let g:refline = CopyRefLine()
	execute "normal! o\<Tab>"
	"let @p = g:refline
	"normal! l"pPyy
	normal! lPyy
endfunction
command! PasteRefLine call PasteRefLine()
command! IdRefline PasteRefLine 

function! CopyRefLine()
	" copies current node with its id properly formatted
	" install postgre on osx id=r_318
	" >
	" install postgre on osx <url:vim-infoman.vim#r=r_318>
	normal! "xyy
	Enew3
	normal! "xP
	/id=\w
	normal! n
	normal! 2w
	CopyLocationUnderCursor
	normal! 2bP
	normal! ld$
	normal! ^y$
	bd
	return @*
endfunction
command! CopyRefLine call CopyRefLine()

" return-done bookmarking
" assumes:
"	mark source (return place) as s
"	mark destination (done place) as d
function! IdPair()
	normal! 's
	Id
	CopyRefLine
	execute "normal! o\<Tab>\<c-r>*"
	normal! 't
	execute "normal! o\<Tab>return: \<c-r>*"
	normal! k
	Id
	CopyRefLine
	execute "normal! o\<Tab>\<c-r>*"
	normal! 's
	execute "normal! jodone: \<c-r>*"
endfunction
command! IdPair call IdPair()

function! IdPairNotWorking()
	normal! 's
	Id
	CopyRefLine
	execute "normal! o\<Tab>"
	normal! lP
	normal! 't
	execute "normal! o\<Tab>return: "
	normal! lP
	normal! k
	Id
	CopyRefLine
	execute "normal! o\<Tab>"
	normal! lP
	normal! 's
	execute "normal! jodone: "
	normal! lP
endfunction
command! IdPair call IdPair()

" replace change name
function! SubstituteNameInBufDo(old_name, new_name)
	let cmd = 'silent! bufd	- %s' . printf('/\<%s\\>/%s/g', a:old_name, a:new_name)
	echom cmd
	exe cmd
endfunction
command! -nargs=+ SubstituteNameInBufD	- call SubstituteNameInBufDo(<f-args>)

function! EnewAndPaste()
	Enew3
	normal! P
endfunction
command! EnewAndPaste call EnewAndPaste()

function! RemoveInvalidSpace()
	bufd	- silent! %s/ / /g
endfunction
command! RemoveInvalidSpace call RemoveInvalidSpace()

function! X(script_filename)
	ech	- a:script_filename
	exe 'b ' . a:script_filename
	DataflowFromRCode
	"bd
	"EFlowDocumentationPlehn
	"normal! G2k"dpG
endfunction

function! Y()
	" ## this is title
	" >
	" <url:filename.txt#tn=## this is title>
	normal! "xyy
	Enew3
	normal! "xP
	CopyLineAsUrl
	normal! 2bP
	normal! ld$
	normal! ^y$
	bd
endfunction
command! Y call Y()

function! ReplaceClass()
%s/noise/6.0/
%s/class5/5.0/
%s/class4/4.0/
%s/class3/3.0/
%s/class2/2.0/
%s/class1/1.0/
endfunction
command! ReplaceClass call ReplaceClass()

" reverse: RemoveBlankLines
function! ConvertOtl2Md()
	" put a new line after each non-bullet line
	v/\\s*-/ s/$/\r/
	" put a new line when a bullet line is succeeded with a non-bullet line
	g/^\\s*-\\_[^-]*\\_^\\w/ s/$/\r/
	" remove multiple blank lines
	g/^\\s*$/,/./-j
endfunction
command! ConvertOtl2Md call ConvertOtl2Md()
command! Comd call ConvertOtl2Md()

" http://stackoverflow.com/questions/11807713/multiple-g-and-v-commands-in-one-statement
command! -nargs=* -range=% G <line1>,<line2>call MultiG(<f-args>)
fun! MultiG(...) range
	 let pattern = ""
	 let command = ""
	 for i in a:000
			if i[0] == "-"
				 let pattern .= "\\(.*\<".strpart(i,1)."\\>\\)\\@!"
			elseif i[0] == "+"
				 let pattern .= "\\\\(.*\\<".strpart(i,1)."\\\\>\\\\)\\\\@="
			else
				 let command = i
			endif
	 endfor
	 exe a:firstline.",".a:lastline."g/".pattern."/".command
endfun

function! ConvertCsv2Excel()
	%s/,/\t/g
endfunction
command! ConvertCsv2Excel call ConvertCsv2Excel()
command! CCsv2Excel call ConvertCsv2Excel()

" convert ascii tables t	- tabbed csv
function! ConvertTable2Excel()
	g/---|/d
	%s/|/,/g
	%s/^\s*,\s*//
	%s/\s*,\s*$//
	%s/ *, */,/g
	%s/,/\t/g
endfunction
command! ConvertTable2Excel call ConvertTable2Excel()

function! ConvertTable2Csv()
	ConvertTable2Excel
	%s/\t/,/g
endfunction
command! ConvertTable2Csv call ConvertTable2Csv()

function! ConvertEmailRtf2Md()
	%s/^· \+/- /
	%s/^o \+/\t- /
endfunction
command! ConvertEmailRtf2Md call ConvertEmailRtf2Md()

command! CopyFilename let @* = expand("%:t")
command! Cpf CopyFilename
function! CopyPath()
	let path = expand("%:p")
	let path = substitute(path, "/Users/mertnuhoglu", "\\~", "")
	let path = substitute(path, "Dropbox (Personal)", "Dropbox", "")
	echom path
	let @* = path
endfunction
command! CopyPath call CopyPath()
command! Cpp CopyPath
nnoremap cp :CopyPath<cr>
function! CopyPathu()
	let path = expand("%:p")
	let path = substitute(path, "/Users/mertnuhoglu", "\/\\~", "")
	let path = substitute(path, "^\\(.*\\)", "<url:file://\\1>", "")
	echom path
	let @* = path
endfunction
command! Cpu call CopyPathu()

command! ConvertHomePaths2Tilda silent %s#/Users/mertnuhoglu#\\~#g
"command! ConvertHomePaths2Tilda %s#/Users/mertnuhoglu#/\\\\~#g
command! Chpt ConvertHomePaths2Tilda
command! ArgsConvertHomePaths2Tilda silent! argdo %s#/Users/mertnuhoglu#/\\\\~#g

function! SurroundWithUrl() range
	silent! ConvertHomePaths2Tilda
	"let match = "^\\(\\s*\\)/"
	"let regex = "s#" . match "#\\1<url:file:///# | s#$#>#"
	"let lines = "#^\\s*[/.~]#"
	"exe a:firstline.",".a:lastline."g" . lines . regex
	silent! exe a:firstline.",".a:lastline."g#^\\s*/# s#^\\(\\s*\\)/#\\1<url:file:///# | s#$#># | s#Dropbox (Personal)#s#Dropbox# "
	silent! exe a:firstline.",".a:lastline."g#^\\s*[.~]# s#^\\(\\s*\\)#\\1<url:file:///# | s#$#># | s#Dropbox (Personal)#s#Dropbox# "
	"exe a:firstline.",".a:lastline."g#^\\s*/# s#^\\\\(\\\\s*\\\\)/#\\\\1<url:file:///# | s#$#>#"
	"exe a:firstline.",".a:lastline."g#^\\s*<url# s#$#>#"
endfunction
command! -range=% SurroundWithUrl <line1>,<line2>call SurroundWithUrl()
command! -range=% Swu <line1>,<line2>call SurroundWithUrl()

function! s:RemoveBlankLines() range
    let cpt = 0
    silent exe a:firstline.','.a:lastline.'g/^\\s*$/d_|let cpt+=1'
    exe a:firstline
    normal! V
    exe (a:lastline-cpt)
endfunction
command! -range=% RemoveBlankLines <line1>,<line2>call s:RemoveBlankLines()
command! -range=% Rbl <line1>,<line2>call s:RemoveBlankLines()
"command! -range=% RemoveBlankLines <line1>,<line2>v/^./d
command! Rbl :g/^\\s*$/d

function! s:RemoveMultipleBlankLines3() range
	exe a:firstline.",".a:lastline."g/^\\s*$/,/./-j"
endfunction

command! -range=% RemoveMultipleBlankLines <line1>,<line2>g/^\s*$/,/./-j
command! SqueezeMultipleBlankLines RemoveMultipleBlankLines
command! -range=% Smbl <line1>,<line2>call s:RemoveMultipleBlankLines3()
command! -range=% RemoveMultipleBlankLines2 <line1>,<line2>g/^\\s*$/,/./-j

function! Utl2()
	split
	wincmd j
	Utl
endfunction
command! Utl2 call Utl2()
function! Utl3()
	vsplit
	wincmd l
	Utl
endfunction
function! Utl4()
	vsplit
	wincmd l
	Utl
endfunction
function! Utl5()
	normal mP
	normal mp
	Utl
	normal mN
	normal mn
endfunction
nnoremap İ :call Utl5()<CR>
nnoremap <Leader>is :Utl2<CR>
nnoremap <Leader>iv :call Utl3()<CR>
" open in new tab
" <vimhelp:utl-tutUI>
nnoremap <Leader>it :Utl openLink underCursor tabe<CR>

" Navigate to prev/next note
nnoremap sm /^\\(@\\\\|_\\\\|#\\+ \\\\|^\\S\\+ \\(=\\\\|<-\\) function\\\\|^\\s*\\(public\\\\|private\\\\|protected\\)[^)]*)[^{]*{\\s*\\)<CR>
nnoremap sl ?^\\(@\\\\|_\\\\|#\\+ \\\|^\\S\\+ \\(=\\\\|<-\\) function\\\\|^\\s*\\(public\\\\|private\\\\|protected\\)[^)]*)[^{]*{\\s*\\)<CR>

" utl.vim creating urls quickly
imap %u <url:			">
imap %uh <url:http://		">
imap %umi <url:mail:///Inbox?	">
imap %uh <url:file:////c:/stb/home/	">

function! ConvertSimplenoteGtd2Otl() range
	exe a:firstline.",".a:lastline."g/^\\w/ +>"
	exe a:firstline.",".a:lastline." RemoveBlankLines"
endfunction
command! -range=% ConvertSimplenoteGtd2Otl <line1>,<line2>call ConvertSimplenoteGtd2Otl()

function! PutLines2Otl()
	norm mt
	Enew3
	norm P
	g/^\\w/ +>
	RemoveBlankLines
	norm gg"tyG
	bd
	norm 't
	norm "tp
endfunction
command! PutLines2Otl call PutLines2Otl()

function! ConvertVideoFiles2ConcatWFfmpeg()
	%s#^#file './#
	%s#$#'#
endfunction
command! ConvertVideoFiles2ConcatWFfmpeg call ConvertVideoFiles2ConcatWFfmpeg()

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! ConvertOtl2Email() range
	let lines = s:get_visual_selection()
	echom lines
	let @* = lines
	Enew3
	norm "*P
	%le
	norm ggyG
	bd
endfunction
command! -range=% ConvertOtl2Email <line1>,<line2>call ConvertOtl2Email()
command! -range=% Coem <line1>,<line2>call ConvertOtl2Email()

function! ConvertDos2Unix()
	%s/\\r/\\r/g
	set ff=unix
endfunction
command! ConvertDos2Unix call ConvertDos2Unix()
command! Cdu call ConvertDos2Unix()

function! ConvertTitle2IndexFormat() range
	" input:
	"<url:file:///~/dropbox (btg)/teuis project 30-dev/plans/suggested_readings.md>
	"## suggested readings (functional and reactive programming)
	" output:
	"- suggested readings (functional and reactive programming)
	"	<url:file:///~/dropbox (btg)/teuis project 30-dev/plans/suggested_readings.md>
	let lines = s:get_visual_selection()
	let @* = lines
	Enew3
	norm "*P
	/^#
	norm cw-
	norm dd
	norm ggP
	"norm j>>
	norm ggyG
	bd
endfunction
command! -range=% ConvertTitle2IndexFormat <line1>,<line2>call ConvertTitle2IndexFormat()
command! -range=% Ctif <line1>,<line2>call ConvertTitle2IndexFormat()

function! ConvertTable2Youtrack()
	%s/| \\+/|/g	
	%s/ \\+|/|/g
	1,1s/|/||/g
	%left
endfunction
command! ConvertTable2Youtrack call ConvertTable2Youtrack()
command! Ct2y call ConvertTable2Youtrack()

function! ConvertDomainModel2ExcelReady() range
	" input:
	" output:
	let lines = s:get_visual_selection()
	let @* = lines
	split
	Enew2
	norm "*P
	v/|/d
	sort u
	%left
	%s/\\[//g
	%s/[|] */\\rid; /g
	%s/]/\\r/g
	%s/; */\\t/g
endfunction
command! -range=% ConvertDomainModel2ExcelReady <line1>,<line2>call ConvertDomainModel2ExcelReady()
command! -range=% Cdmer <line1>,<line2>call ConvertDomainModel2ExcelReady()

function! ConvertDownloadUrls2CurlCommands() range
	" input:
	" https://.../x.mp4
	" output:
	" curl 'https://.../x.mp4' > x.mp4
	exe a:firstline.",".a:lastline."s#^#curl '#"
	exe a:firstline.",".a:lastline."s#\\([^/?]\\+\\.mp4\\).*#\\0' > \\1#"
endfunction
command! -range=% ConvertDownloadUrls2CurlCommands <line1>,<line2>call ConvertDownloadUrls2CurlCommands()
command! -range=% Cducc <line1>,<line2>call ConvertDownloadUrls2CurlCommands()

function! ConvertExcel2Table() range
	" input:
	" output:
	let my_range = a:firstline.",".a:lastline
	exe my_range."s#^\\(\\s*\\)\\(\\w\\+\\)#\\1| \\2#"

	exe my_range."s/$/ |/"
	exe my_range."left "
	exe my_range."s/\\t/ | /g"
	exe my_range."left 2"
endfunction
command! -range=% ConvertExcel2Table <line1>,<line2>call ConvertExcel2Table()
command! -range=% Cet <line1>,<line2>call ConvertExcel2Table()

" convert2 commands
command! ConvertHtmlSymbolsToHumanReadable call ConvertHtmlSymbolsToHumanReadable()
command! ConvertSECidxfile call ConvertSECidxfile()
command! ConvertVimeoLinks call ConvertVimeoLinks()
command! ConvertMindMup call ConvertMindMup()
command! ConvertXMLTagsToPipedList call ConvertXMLTagsToPipedList()
command! ConvertPipeCsvToCommaWithQuotes call ConvertPipeCsvToCommaWithQuotes()
"command! ConvertHepsiBuradaXML call ConvertHepsiBuradaXML()
"command! ConvertErsaXML call ConvertErsaXML()
"command! ConvertVestelXML call ConvertVestelXML()
"command! ConvertPentaXML call ConvertPentaXML()
"command! ConvertPentaCSVUrunDetay call ConvertPentaCSVUrunDetay()
"command! ConvertPazarzReviewExcelToCsv call ConvertPazarzReviewExcelToCsv()
command! ConvertKeynoteExportTurkishChars call ConvertKeynoteExportTurkishChars()
command! ConvertEmailListToGmailAddresses call ConvertEmailListToGmailAddresses()
command! ConvertGDocsLinksToWget call ConvertGDocsLinksToWget()
command! ConvertCodeForRepl call ConvertCodeForRepl()
command! ConvertROutput call ConvertROutput()
command! ConvertRCombineRemoveColumns call ConvertRCombineRemoveColumns()

function! ConvertTabbedWords2QuotedArray () range
	exe a:firstline.",".a:lastline."s#\\>\\t\\<#, #g"
	exe a:firstline.",".a:lastline."SurroundWordsWithDQuotes"
endfun
command! -range ConvertTabbedWords2QuotedArray <line1>,<line2>call ConvertTabbedWords2QuotedArray()

" Replace2 Convert
command! -range=% SurroundCSVWithQuotes <line1>,<line2>s/\\(^\\|, \\)\\?\\([^,]*\\)/\\1'\\2'/g
command! -range=% SurroundWordsWithDQuotes <line1>,<line2>s/\\<\\w\\+\\>/"\\0"/g
command! -range=% SurroundWordsWithQuotes <line1>,<line2>s/\\<\\w\\+\\>/'\\0'/g
command! -range=% SurroundLinesWithQuotes <line1>,<line2>s/.*/'\\0'/
command! RemoveLinesStartingWithNumbers g/^\\d/d
command! RemoveROutputVectorIndexes %s/^ *\\[\\d*\\] //
command! -range=% ReplaceEndOfLineWithComma <line1>,<line2>s/$/,/ | exe 'norm G$x'
command! -range=% ReplaceEscapeBackSlashes <line1>,<line2>s/\\\\/\\\\\\\\/g
command! -range=% RemoveEscapeBackSlashes <line1>,<line2>s/\\\\\\\\/\\\\/g
command! -range=% RemoveDoubleBackSlashes <line1>,<line2>s/\\\\\\\\/\\\\/g
command! ReplaceSlashWithBackSlashes s/\\\\/\\/g
command! ReplaceInvisibleSpaces bufdo %s/ / /ge | update

nnoremap <Leader>üo A - opt

function! ConvertYuml2Summary()
	norm! Go## Summary
	norm! o
	norm! mz
	g/^\s*\[\w\+[|\]]/ co$
	'z,$ s/^\s\+/    # /
endfunction
command! ConvertYuml2Summary call ConvertYuml2Summary()

function! ConvertYuml2TableList()
	" no need now: R script: 
	" <url:/Users/mertnuhoglu/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/prepare_rdb_data_operations.R#tn=build_data_dictionary_01 = function() {>
	/^\s*\[\w\+[|\]]
	MatchesOnly
	%s/[|\]].*//
	%s/\[//
	sort u
endfunction
command! ConvertYuml2TableList call ConvertYuml2TableList()
command! CYuml2TableList call ConvertYuml2TableList()

function! ConvertYuml2TableList4Table()
	CopyToScratch
	ConvertYuml2TableList
	ConvertExcel2Table	
	TableModeEnable
	TableModeRealign
endfun
command! ConvertYuml2TableList4Table call ConvertYuml2TableList4Table()

function! ConvertYuml2DataDictionary()
	lcd %:h
	norm! ggyG
	enew
	norm! P
	ConvertYumlMarkdown2CleanYuml
	%s/\s*PK\|FK//g
	%s/(\d\+)//g
	v/|/d
	%s/\(\w\+\)\s*]/\1;]/g
	%s/;/\r/g
	%s/|/\r/g
	g/\<shape\>/d
	g/\<objectid\>/d
	g/^$/d
	g/^voidable\>/d
	%left
	v/[[\]]/le 1
	norm! gg0
	let @s = 'ma/]mb''awye0j''bkI*nj'
	"norm! @s
	"norm! 100@s
	"g/^]\|\[/d
	"%s/ /\t/g
	"norm! ggOentity_name	data_field_name	type
	"%s/\t/,/g
	"%s/,$//
	"sav! view/dd_00.csv
endfun
command! ConvertYuml2DataDictionary call ConvertYuml2DataDictionary()
command! CYuml2DataDictionary call ConvertYuml2DataDictionary()
command! CYDataDictionary call ConvertYuml2DataDictionary()

function! ConvertYumlFixFormat()
	" fix cardinalities
	silent! %s#]\s*\(\S*.*\S\)\s*\[#] \1 [#
	silent! g/[[^\]]*\]/ %s/-\+/-/g
	silent! %s#\*-#n-#
	silent! %s#-\*#-n#

	" fix pipe symbols
	silent! %s#|\s*]#]#
	" spacing between elements
	silent! %s#;\s*#; #g
	" spacing between class name and its attributes
	silent! %s#|\(\w\+\)#| \1#

	" put ; at the end of attributes
	silent! g/\s*\[\w*|/ s/\(\w\+\)\s*]/\1; ]/

	" fix attributes
  " id -> id LONG PK
	silent! g/\s*\[\w*|/ s#\<id\s*;#id LONG PK;#
  " entity_id -> entity_id LONG FK
	silent! g/\s*\[\w*|/ s#_id\s*;#_id LONG FK;#g
  " point_gisid -> point_gisid LONG FK
	silent! g/\s*\[\w*|/ s#_gisid\s*;#_gisid LONG FK;#g
  " VARCHAR -> TEXT
	silent! g/\s*\[\w*|/ s#\<VARCHAR\>#TEXT#g
  " NUMBER -> LONG
	silent! g/\s*\[\w*|/ s#\<NUMBER\>#LONG#g
  " DOUBLE -> DOUBLE
	silent! g/\s*\[\w*|/ s#\<DOUBLE\>#DOUBLE#g
  " objectid -> objectid LONG PK
	silent! g/\s*\[\w*|/ s#\<objectid\>\s*;#objectid LONG PK;#g
  " , -> ;
	silent! g/\s*\[\w*|/ s#,#;#g
  " | -> | id LONG PK
	silent! v/\(\<id\>\|_id\>\|\<objectid\>\)/ s#|#| id LONG PK;#
endfunction
command! ConvertYumlFixFormat call ConvertYumlFixFormat()
command! Cyff call ConvertYumlFixFormat()

function! ConvertYumlMarkdown2CleanYuml()  
	" ConvertYumlMarkdown2CleanYuml()  <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g_10001>
	" remove all non yuml lines
	" ed script:
	" <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 80-SUPPORT/system_admin/scripts/convert_yuml_markdown_2_clean_yuml>
	g/[:#]/d
	" if no bracket, then delete
	v/\[[^\]]*\]/d
	v/^\s*\[.*\]\s*$/d

	"ConvertYumlFixFormat
	%left 4

	" sorting
	sort u
	"norm! Go
	"norm! mz
	g/|/ m0
	"norm! 'z
	"norm! "kdG
	"norm! gg
	"norm! "kP
endfunction
command! ConvertYumlMarkdown2CleanYuml call ConvertYumlMarkdown2CleanYuml()
command! CYumlMarkdown2CleanYuml ConvertYumlMarkdown2CleanYuml

function! ConvertGithubPage2ProjectList()
	" projects/stuff/text/list_github_projects
	EnewFile
	Cpp
	w output.txt
	norm gg2O
	norm P

	g/forked/-2 d
	g/forked/+2 d
	g/ /d
	g/^\s*$/d
	%s#\(.\+\)#\1\thttps://github.com/mertnuhoglu/\1#
	sort
endfunction
command! ConvertGithubPage2ProjectList call ConvertGithubPage2ProjectList()

function! ConvertMdUrlsWithSpaces2Escaped()
	g/^\[\w\+\]:\s*/ s/: /:@@/ | s/ /%20/g | s/:@@/: /
endfunction
comman! ConvertMdUrlsWithSpaces2Escaped call ConvertMdUrlsWithSpaces2Escaped()

let $study = '~/Dropbox/projects/study'
command! CdStudy cd $study
function! NewStudy()
	split
	CdStudy
	enew
  call inputsave()
  let name = input('Enter name: ')
  call inputrestore()
	let date = strftime("%Y%m%d")
	let filename = 'study_' . name . '_' . date . '.md'
	exe 'sav ' . filename
	Cpp
	norm gg
	norm O
	norm P
	norm 2o
	call setline('.', '# Study ' . name . ' ' . date)
	norm 2o
	w
endfun
command! NewStudy call NewStudy()

" üüy to copy utl and then open it somewhere else
function! CopyUtlAsPath()
	" <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 00-BTG TEAM FOLDER/reviews/review_feride_rdb_screens_20160301.md>
	" >>
	" ~/Dropbox (BTG)/TEUIS PROJECT 00-BTG TEAM FOLDER/reviews/review_feride_rdb_screens_20160301.md
	"normal! "uyy
	let line = getline('.')
	let url = substitute(line, ".*<url:file:\/\/\/", "", "")
	let url = substitute(url, ">\s*", "", "")
	let @* = url
endfunction
command! CopyUtlAsPath call CopyUtlAsPath()

" csv coloring
hi CSVColumnEven term=bold ctermbg=0 guibg=#fbfcfc
hi CSVColumnOdd  term=bold ctermbg=17 guibg=#e5e7e9
let g:csv_no_column_highlight = 0

function! CleanRCode()
  # converts R console code from RStudio
  # to clean R code
  g/^>/s/> //
  g/^\[/s/^/# 
  g/View/d
endfun
command! CleanRCode call CleanRCode()

function! PutRCode()
	norm! o msi*mt'sj^kxi 'tI# 
endfunction
command! PutRCode call PutRCode()
command! Prc call PutRCode()
function! PutRCode2()
	norm! o msi*mt's'tI# 
endfunction
command! Prd call PutRCode2()

fun! GetFileLine(fn,ln)
    return readfile(a:fn,'',a:ln)[a:ln-1]
endfun

function! PutGlobalId()
	" PutGlobalId id=g_00008
	let global_refid = '/Users/mertnuhoglu/.vim/.global_refid'
	" let id = GetFileLine(global_refid, 1)
	let line = readfile(global_refid, 1)[0]
	let id = line + 1
	echo id
	let new_id = printf("%05d", id)
	let line2 = [new_id]
	call writefile(line2, global_refid, '')
	let @r = printf("id=g_%s", new_id)
	normal! $A 
	normal! "rp
endfunction
command! PutGlobalId call PutGlobalId()
command! Pgi call PutGlobalId()

function! PutGlobalProblemId()
	" PutGlobalProblemId 
	let global_refid = '/Users/mertnuhoglu/.vim/.global_problemid'
	" let id = GetFileLine(global_refid, 1)
	let line = readfile(global_refid, 1)[0]
	let id = line + 1
	echo id
	let new_id = printf("%03d", id)
	let line2 = [new_id]
	call writefile(line2, global_refid, '')
	let @r = printf("id=p%s", new_id)
	normal! $A 
	normal! "rp
endfunction
command! PutGlobalProblemId call PutGlobalProblemId()
command! Pgpi call PutGlobalProblemId()

function! ConvertSqlInsert2Excel()
	" converts:
	" INSERT INTO T_COMMON_ENUM_VALUE (id,name,category_id) values(800,'şirin',9);
	" ->
	" 800	şirin	9
	" Ex2:
	" INSERT INTO T_COMMON_ENUM_VALUE (id,name,category_id) values(1043,'Tam su çekim analizi: CO3, HCO3, Cl, SO4, Mg⁺⁺, Na⁺,Quru kalık(madde)',33);
	" ->
	/\d\+.*\();\)\@=
	MatchesOnly
endfunction
command! ConvertSqlInsert2Excel call ConvertSqlInsert2Excel()

function! FormatSqlInsert()
	silent! %s/Insert into/INSERT INTO/
	silent! %s/Values\>/VALUES/
	silent! %s/)\s*VALUES\s*(/) VALUES (/
	silent! g/INSERT/,/INSERT/-j
endfunction
command! FormatSqlInsert call FormatSqlInsert()

function! PutRedirLs()
    redir @l>
		ls
    redir END
    norm "lp
endfunction
command! PutRedirLs call PutRedirLs()

function! ConvertUtlUrl2MdUrl()
	norm! 2fTd0f>d$
	norm! I[link]: 
	ConvertMdUrlsWithSpaces2Escaped
	norm! ci]
endfunction
command! ConvertUtlUrl2MdUrl call ConvertUtlUrl2MdUrl()

function! ScrapeApiServices() 
	" id=g_10021 
	" function! ScrapeApiServices() <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g_10021>
	g/^\d\+.*/co$

	g/^\s*$/d
	g/<url/d
	
	" list only service titles
	v/^\d/d
	%s/^\d\+\.*\s*//
	sort u

	" delete all redundant lines
	g/^\s\+/d
	%s/^#\+//
	" unify multiple tabs
	%s/\t\+/\t/g
endfunction
command! ScrapeApiServices call ScrapeApiServices()

function! TransliterateAzeriChars()
	silent! %s/ı/i/g
	silent! %s/ş/s/g
	silent! %s/Ş/S/g
	silent! %s/ı/i/g 
	silent! %s/İ/I/g 
	silent! %s/ş/s/g 
	silent! %s/Ş/S/g 
	silent! %s/ü/u/g 
	silent! %s/Ü/U/g 
	silent! %s/ö/o/g 
	silent! %s/Ö/O/g 
	silent! %s/ç/c/g 
	silent! %s/Ç/C/g 
	silent! %s/ğ/g/g 
	silent! %s/Ğ/G/g 
	silent! %s/ə/e/g 
endfunction
command! TransliterateAzeriChars call TransliterateAzeriChars()

function! ConvertDatabaseTableNames2RFunctions()
	%s#\(\w\+\)#\L\1 = function(db) tbl(db, "\U\1")#
endfunction
command! ConvertDatabaseTableNames2RFunctions call ConvertDatabaseTableNames2RFunctions()

function! ConvertJoinLinesWithComma()
	SurroundWordsWithDQuotes
	%s/\n/, /
	s/,\s*$//
endfunction
command! ConvertJoinLinesWithComma call ConvertJoinLinesWithComma()

" convert escaped html symbols to readable characters
function! ConvertHtmlSymbolsToHumanReadable()
	%s/&lt;/</g
	%s/&quot;/"/g
	%s/&amp;/&/g
	%s/&amp;/\&/g
	%s/&gt;/>/g
endfunction

" convert SEC idx file to csv file
function! ConvertSECidxfile()
    %s/  \+/\t/g
    %s/\t*$//
    set ft=csv
endfunction

" extract vimeo links
function! ConvertVimeoLinks()
    href="\/\d\+"
    MatchesOnly
    %s/href="//
    %s/"//
    %s,^,http://vimeo.com
endfunction

" Convert MindMup To Indented Text
function! ConvertMindMup()
    v/title/d
    %s/"title": "//
    %s/".*//
    %s/^  //
endfunction

function! ConvertXMLTagsToPipedList()
    /<[^>]*>
    MatchesOnly
    %s/>//g
    %s/<//g
    %s/$/|/
    %join!
endfunction

function! ConvertHepsiBuradaXML()
    silent! g/<rss/.,/<description>/d
    silent! %s/<!\[CDATA\[//g
    silent! %s/]]>//g
    silent! %s/\t//g
    silent! v/^./d
    silent! g/<item>/.,/<\/item>/join
    " replace all pipes with >>> temporarily
    silent! %s/|/>>>/g
    " put pipes between tags
    silent! %s:>\s*<\(\w\+\):>|<\1:g
    " remove all tags
    silent! %s/<[^>]*>//g 
    silent! norm ggOid|title|description|link|image_link|condition|availability|price|sale_price|sale_price_effective_date|brand|shipping|country|service|price|adwords_labels
    silent! %s/^ *|// 
    silent! %s/,""$//
    silent! g/^"$/d
    silent! set ft=csv
    ConvertPipeCsvToCommaWithQuotes
    " replace >>> back to pipes 
    silent! %s/>>>/|/g
endfunction

function! ConvertErsaXML()
    silent! %s/\t//g
    silent! g/EKALANLAR/d
    silent! v/^./d
    silent! g/<URUN>/.,/<\/URUN>/join
    silent! %s:>\s*<\(\w\+\):>|<\1:g
    silent! %s/<[^>]*>//g 
    silent! norm ggOUrunID|UrunAdi|KDV|Kur|StokAdedi|indirimli|ListeFiyat|KategoriAdi|AltKategori|Marka_Adi|Urun_Resmi|Marka_Resmi|Cinsiyet|Kadran_Rengi|Kordon_Cinsi|Kordon_Rengi|Kasa_Sekli|Seri_Adi|Kasa_Cinsi|Kasa_Capi|Cam_Cinsi|Agirlik|Takvim|Kasa_Yuksekligi|Kasa_Kalinligi|Su_Gecirmezlik|Ek_Alan15
    silent! %s/^ *|// 
    silent! %s/,""$//
    silent! g/^"$/d
    silent! set ft=csv
    ConvertPipeCsvToCommaWithQuotes
endfunction

function! ConvertVestelXML()
    silent! g/<category /d
    silent! g/category>/d
    silent! g/<url>\//d
    silent! g/<categorylist/.,/<\/categorylist/join
    silent! %s:</name> <name>:;:g
    silent! g/<products>/.,/<\/products>/join
    silent! %s/> </>|</g
    silent! %s/<[^>]*>//g 
    silent! norm ggOSKU|Name|Price|DiscountPrice|Info|URL|CategoryList
    silent! %s/^ *|// 
    silent! %s/|||/||/
    silent! %s/||$//
    silent! v/^./d
    silent! set ft=csv
    ConvertPipeCsvToCommaWithQuotes
endfunction

function! ConvertPipeCsvToCommaWithQuotes()
    silent! %s/"/""/g
    silent! %s/^\|$/"/g
    silent! %s/|/"|"/g
    silent! %s/"|"/","/g
endfunction

function! ConvertPentaXML()
    g/^</d
    %s/<stok//
    %s/ \w\+="\([^"]*\)"/\1|/g
    %s/ \/>//
    %s/^  //
    %s/|/\t/g
    set bomb | set fileencoding=utf-8 
endfunction

" go to 5. column then run it
function! ConvertPentaCSVUrunDetay()
    Column
    enew
    put
    %s/\t//g
    %s:^\(.*\)\>:wget -O \1.xml http://xml.bayinet.com.tr/urun_detay.aspx?kod=\1:
    set ff=unix
endfunction

command! ConvertPipes2Tabs %s/|/\\t/g

function! ConvertPazarzReviewExcelToCsv()
    %s/\t/|/g
    %s/"/""/g
    %s/^\|$/"/g
    %s/|/"|"/g
    %s/"|"/","/g
    set ft=csv
    norm gg
    DeleteColumn
    MoveColumn 1 3
    MoveColumn 1 3
    %s/^/"post","baslanmadi",/g
endfunction

function! ConvertKeynoteExportTurkishChars()
    set noignorecase
    silent! %s/ý/ı/g
    silent! %s/Ý/İ/g 
    silent! %s/ţ/ş/g
    silent! %s/đ/ğ/g
    set ignorecase
endfunction

" convert list of email addresses to gmail email address. for example:
" Ali Niyazi, ali@gmail.com
" Mehmet Ali, mehmetali@gmail.com
" to
" Ali Niyazi <ali@gmail.com>, Mehmet Ali <mehmetali@gmail.com>
function! ConvertEmailListToGmailAddresses()
    %s/,\s*/ </
    %s/$/>,/
    %join
    %s/,\s*$//
endfunction

function! ConvertGDocsLinksToWget()
    %s/^.*: //
    %s/^/'
    %s/\t/' 
    %s/^/wget -O 
endfunction

function! PutHistory()
    redir @a>
    history : -10,
    redir END
    norm "ap
endfunction
command! PutHistory call PutHistory()

" Convert code for R/REPL r2
function! ConvertCodeForRepl()
	%s/^\s*//g
	v/^>/d
	%s/^> //g
	norm ggyG
endfunction

" Convert output of R into csv like list
function! ConvertROutput()              
    %s/^ *\[\d\+\] *//
    %s/ \+/,\r/g
	v/./d
	"%join
endfunction

" Convert R output for combine.remove.columns
"ADR.TSO", "ADR.TSO.g", "ADR.TSO.h"
"Caveat.Emptor"
"IPOyear", "IPOyear.g", "IPOyear.h"
">
"merged.data = combine.remove.columns(merged.data, 'ADR.TSO', 'ADR.TSO', 'ADR.TSO.g', 'ADR.TSO.h')
"merged.data = combine.remove.columns(merged.data, 'IPOyear', 'IPOyear', 'IPOyear.g', 'IPOyear.h')
function! ConvertRCombineRemoveColumns()
    "ConvertROutput
    "sort
	" satırları birleştir
    %s/,$//
    v/,/m$
    %s/"/'/g
    %s/^'\(.\{-}\)\(\.\w\)\?', /'\1', \0/
    %s/.*/merged.data = combine.remove.columns(merged.data, \0)/
endfunction

function! ConvertTree2Otl()
		%s/[└├─│]/ /g
		%s/ / /g
		%<<
endfunction
command! ConvertTree2Otl call ConvertTree2Otl()

function! ConvertYoutrackIssueTitles()
	g/^×.*/d
	g/^T-\d\+$/norm A:
	g/^T-\d\+:$/j
	v/^T-\d\+: .*$/d
	%s/^/yt:/
endfunction
command! ConvertYoutrackIssueTitles call ConvertYoutrackIssueTitles()

" custom shortcuts 
nnoremap <Leader>ç :CopyLocation<CR>
nnoremap <Leader>Ç :CopyLineAsUrl<CR>

function! ExtractTitleFromUrl()
	silent! s#/\s*$##
	norm! $F/l"ty$>>
	execute "norm! O\<C-R>t"
	norm! <<
	silent! s#-# #g
	silent! s#?.*##
	silent! s#%20# #g
endfunction
command! ExtractTitleFromUrl call ExtractTitleFromUrl()
command! ExTitleFromUrl ExtractTitleFromUrl 

function! ConvertRmd2HandoutNotes()
	" remove <div> tags and @annotation tags from Rmd docs to prepare handout notes for end users
	"
	" <div class="notes">
	" There are too many different data mining algorithms. But there are only a small set of problem types.  @mp3=p000_01
	" </div>
	" -->>
	" There are too many different data mining algorithms. But there are only a small set of problem types.  
	"
	g/<div\|div>/d
	%s/@\w\+\S*\s*$//
endfunction
command! ConvertRmd2HandoutNotes call ConvertRmd2HandoutNotes()

function! CGtd2Rdb()
	" 1: clean headers
	" primary
	" ->
	" (blank line)
	" # primary
	" (blank line)
	g/^\w/norm I## 
endfunction
command! CGtd2Rdb call CGtd2Rdb()

function! SurroundQuotesForIndentedLines()
	" Input:
	" line1
	" line2
	" 	indent1
	" 	indent2
	" line3
	" line4
	" 	indent3
	" line5
	" -->>
	" Output:
	" line1
	" line2 "indent1
	" 	indent2"
	" line3
	" line4 "indent3"
	" line5
	" 
	" Explain: surround indented lines with quotes
	" You need to call it multiple times for each paragraph
	" Purpose: to convert otl file to relational table file
	" Assumes: 
	" all lines except indented ones are left aligned
	" all left aligned lines start with alphabetical char
	"
	/^\s\+
	s/^\s\+/"/
	/^\w
	norm! bA"
	norm! N
	join
	norm! n
endfunction
command! SurroundQuotesForIndentedLines call SurroundQuotesForIndentedLines()

function! ConvertTable2Yaml()
	%s/|/-
	ConvertTable2Excel
	%s/\t/  /
	g/^\w/norm A:
	%s/\t/,/g
endfunction
command! ConvertTable2Yaml call ConvertTable2Yaml()

function! ConvertInlinedTable2Excel()
	" tüm tablo tek satırda
	%s/\( \d\+\)/\t\1/g
	%s/\(\d\+\w\? \)/\1\r/g
	ConvertExcel2Table
	%left
endfunction
command! ConvertInlinedTable2Excel call ConvertInlinedTable2Excel()

function! ConvertPairLines2Table()
	%s/\(js\|py\|java\)$/\1\t/
	g//join
	ConvertExcel2Table
	%left
endfunction
command! ConvertPairLines2Table call ConvertPairLines2Table()

function! ConvertPairLines2Table2()
	" birinci satır kelimeyle bitiyor
	" ikinci satır rakamla başlıyor
	" diğer kolonlar ikinci satırda sıralanmış
	g/^ \+\w\+/ s/$/\t/
	g/^ \+\w\+/join
	ConvertExcel2Table
	%left
endfunction
command! ConvertPairLines2Table2 call ConvertPairLines2Table2()

function! ConvertLinePerCell2Table()
	" input:
	"
	"Tesis
	"ID_1
	"Kalite_Kodu_1
	"
	" output:
	g/^\s*$/d
	%s/$/\t/
endfunction
command! ConvertLinePerCell2Table call ConvertLinePerCell2Table()

function! ConvertRNames2SelectColumns()
  %s/^[^"]*//
  %join
  %s/\s\+/, /g
  s/"//g
endfunction
command! ConvertRNames2SelectColumns call ConvertRNames2SelectColumns()

function! ExtractFilePaths()
	norm ggyG
	split
	Enew2
	norm P
  /[^ "`'()=]*\.\w\{1,3}\>
  MatchesOnly
  sort u
endfunction
command! ExtractFilePaths call ExtractFilePaths()

function! FixHyperscript()
  %s/"attributes":/"attrs":/g
  g/^ *"id": {/norm d3j
  g/^ *"className": /d
  %s/`/"/g
  g/^ *",\?$/d
endfunction
command! FixHyperscript call FixHyperscript()
command! ConvertHyperscriptToCyclejs call FixHyperscript()

function! HandleURL()
  " https://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser#9459366
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURL()<cr>
nnoremap <leader>i :!open -a Safari %<CR><CR>

set history=10000
