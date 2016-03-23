command! Enew2 enew | set buftype=nofile
command! Enew3 split | enew | set buftype=nofile
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
command! CopyToScratch call CopyToScratch()

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

" Move current note t	- the end of file 
" A note is a part of file that starts with "_".
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
	" Keynote text
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
	split
	enew
	set buftype=nofile
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
	" copy current file
	let filename = expand("%")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#" . word . ">"
	let @* = url
endfunction
command! CopyLocation call CopyLocation()

" copy location with absolute path for use in utl.vim url
function! CopyLocation2()
	" copy current file
	let filename = expand("%:p")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#" . word . ">"
	let @* = url
endfunction
command! CopyLocation2 call CopyLocation2()
                                
" copy line with relative path for use in utl.vim url
function! CopyLineAsUrl()
	" copy current file path
	let filename = expand("%:p")
	" copy current line 
	let word = Strip(getline("."))
	let url = "<url:" . filename . "#tn=" . word . ">"
	let @* = url
endfunction
command! CopyLineAsUrl call CopyLineAsUrl()

" copy line with id for use in utl.vim url with full path t	- file
function! CopyIdAsUrl()
	" copy current file path
	let filename = expand("%:p")
	" copy current line 
	let @* = filename
	normal! $F#P
	let line = Strip(getline("."))
	normal! u
	let @* = line
endfunction
command! CopyIdAsUrl call CopyIdAsUrl()

function! Strip(input_string)
    return substitute(a:input_string, '^\\s*\\(.\\{-}\\)\\s*$', '\\1', '')
endfunction

" copy location with id
function! CopyLocationId()
	" copy current file
	let filename = expand("%")
	" copy word under cursor
	let word = expand('<cword>')
	let url = "<url:" . filename . "#r=" . word . ">"
	let @* = url
endfunction
command! CopyLocationId call CopyLocationId()

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

function! Id2()
	Id
	CopyNodeRef
endfunction
command! Id2 call Id2()

function! Id3()
	Id2
	execute "normal! o\<tab>"
	normal! lPyy
endfunction
command! Id3 call Id3()
command! -range=% IdSwap <line1>,<line2>s/^\\(\\s*\\)\\(\\w\\+[^<]*\\)\\(<.*>\\)/\\1\\3 \\2/

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
	let cmd = 'silent! bufd	- %s' . printf('/\<%s\\>/%s/g', a:old_name, a:new_name)
	echom cmd
	exe cmd
endfunction
command! -nargs=+ SubstituteNameInBufD	- call SubstituteNameInBufDo(<f-args>)

function! EnewAndPaste()
	split
	enew
	set buftype=nofile
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
	split
	enew
	set buftype=nofile
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
	v/\\s*-/ s/$/\\r/
	" put a new line when a bullet line is succeeded with a non-bullet line
	g/^\\s*-\\_[^-]*\\_^\\w/ s/$/\\r/
	" remove multiple blank lines
	g/^\\s*$/,/./-j
endfunction
command! ConvertOtl2Md call ConvertOtl2Md()

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

function! ConvertEmailRtf2Md()
	%s/^· \+/- /
	%s/^o \+/\t- /
endfunction
command! ConvertEmailRtf2Md call ConvertEmailRtf2Md()

command! CopyFilename let @* = expand("%:t")
command! CopyPath let @* = expand("%:p")
function! CopyPath()
	let path = expand("%:p")
	let path = substitute(path, "/Users/mertnuhoglu", "\/\\~", "")
	let path = substitute(path, "^\\(.*\\)", "<url:file://\\1>", "")
	let @* = path
endfunction
command! Cpp call CopyPath()

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
nnoremap İ :Utl<CR>
nnoremap üi :Utl2<CR>

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
	split
	Enew2
	set buftype=nofile
	norm P
	g/^\\w/ +>
	RemoveBlankLines
	norm gg"tyG
	bd
	norm 't
	norm "tp
endfunction
command! PutLines2Otl call PutLines2Otl()

function! ConvertFiles2Concat()
	%s#^#file './#
	%s#$#'#
endfunction
command! ConvertFiles2Concat call ConvertFiles2Concat()

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
	split
	Enew2
	set buftype=nofile
	norm "*P
	%le
	norm ggyG
	bd
endfunction
command! -range=% ConvertOtl2Email <line1>,<line2>call ConvertOtl2Email()
command! -range=% COtl2Email <line1>,<line2>call ConvertOtl2Email()

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
	split
	Enew2
	set buftype=nofile
	norm "*P
	/^#
	norm cw-
	norm dd
	norm ggP
	norm j>>
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
	set buftype=nofile
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

" Replace2 Convert
command! -range=% SurroundCSVWithQuotes <line1>,<line2>s/\\(^\\|, \\)\\?\\([^,]*\\)/\\1'\\2'/g
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

function! ConvertYuml2TableList()
	v/^\s*\[\w*|/d
	%s/|.*//
	%s/\[//
	"MatchesOnly
	"%s/\[//g
	sort u
endfunction
command! ConvertYuml2TableList call ConvertYuml2TableList()

function! ConvertYuml2DataDictionary()
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
	 norm gg0
	 let @s = 'ma/]mb''awye0j''bkI*nj'
	 norm! 30@s
	 g/^]\|\[/d
	 %s/ /\t/g
endfun
command! ConvertYuml2DataDictionary call ConvertYuml2DataDictionary()

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

function! SurroundMdImage() range
	exe a:firstline.",".a:lastline."g/\\(\\.jpg\\>\\)\\|\\(\\.png\\)/ s#\\(^\\)\\(.*/\\)\\([^/]\\+\\)\\(\\..*$\\)#![\\3](\\2\\3\\4)#"
endfunction
command! -nargs=* -range=% SurroundMdImage <line1>,<line2>call SurroundMdImage()

" convert word -> `word`
command! SurroundWithBackQuotes normal viwS`e
command! Swq SurroundWithBackQuotes 
nmap <Leader>sq viwS`e

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
nnoremap <Leader>üy :CopyUtlAsPath<Cr>

" csv coloring
hi CSVColumnEven term=bold ctermbg=0 guibg=DarkGreen
hi CSVColumnOdd  term=bold ctermbg=17 guibg=DarkBlue
let g:csv_no_column_highlight = 0

function! PutRCode()
	norm! o msi*mt'sj^kxi 'tI# 
endfunction
command! PutRCode call PutRCode()
command! Prc call PutRCode()
function! PutRCode2()
	norm! o msi*mt's'tI# 
endfunction
command! Prd call PutRCode2()

function! Test2()
endfunction
command! Test2 call Test2()

