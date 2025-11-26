" vim:fileencoding=utf-8:ft=vim:foldmethod=marker
" ((b50e06f3-39e8-4b90-b059-bfa743ebaee4)) || function! GetBlockStartEnd()
" BDocument-List-myr.mdasic commands:
"
" local function gotoDef() -- SPC ffe or İ || ((1348ce1d-805d-431c-a2a2-83d57b7e941f))
	" mapping: İ -> gotoDef || ((283cfd73-703c-4374-a120-067e2ffaf9c2))
	" command! GotoDef || ((d3246cd2-4b88-4427-926e-b75e1817c5c7))
	" local function gotoDef() -- SPC ffe or İ || ((1348ce1d-805d-431c-a2a2-83d57b7e941f))
	" core: function gotoDefArg(line) --  || ((52ee6fa0-f29d-4509-8cb8-a89b1ba01728))
	" pattern-match: function! GetRefArg(line)  || ((c639de96-98d0-4152-8718-62bae2c089ce))
" nnoremap <A-i> :GotoDef<CR> || ((3945064f-e78f-4af6-b62b-b062c45b6236))
" function! GotoDef(...) " SPC fd  || ((5caa9c16-3450-426e-aa81-5b1879e1eb41))
"	function! GotoDefArg(line, nogitignore) "  || ((b92df8f3-0ca4-4977-96ff-944d17e70498))
"	function! GetRefArg(line)  || ((c639de96-98d0-4152-8718-62bae2c089ce))
" function! RefId()  " SPC ru || ((7beea565-31fa-47a9-9d63-6202bfe0b7d4))
" function! RefIdAnywhere()  "  SPC rb || ((2d02c19a-405d-45ba-8b5a-91ed92589e3f))
" function! GotoBlockOrWikilink() " SPC fd || ((5caa9c16-3450-426e-aa81-5b1879e1eb41))
" function! IdPair() || ((a9b3bd34-46d9-4e2a-9b19-984b3d2c853a))
" function GrepInString(pattern, string) || ((254af958-f8a5-48be-8e35-9ea5fa71bdaa))
" CopyUrl <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g_00009>
" SPC ry function! RefIdNewS() <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g12690>
" ((2e0bf50f-3b07-4974-a07e-f7e53441a2f6)) || function! RefIdNewLogseq() " SPC rU
" SPC rj function! RefIdJournal()  <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g13761>
" function! RefIdLogseq() " SPC ru  || ((79383fcf-a034-4592-b4b1-5f78daee66d6))
" function! GotoBlockDefBuffer() " gq g* || ((1494d523-ca2b-47e4-a556-fec429ca1427))
" RefIdS = IdP
" RefLine
" En2
" function! RefIdUtl()  " SPC ri || ((48b0ce88-a69c-4499-8387-5e89090dcf34))
" function! RefIdUtlJournal()  " SPC rj || ((352e0820-99e6-4dc1-bb55-028002a9f6d9))

let g:f = luaeval("require('user.mert-lua')")

" let RefType: Enum for GetRefArg
"   id:: 8d628ea5-0bae-4013-95bc-e4d35a160c89
" rfr: used-in: function! GetRefArg(line)  || ((c639de96-98d0-4152-8718-62bae2c089ce))
let g:RefType = {
      \ 'blocklink': 'blocklink',
      \ 'wikilink': 'wikilink',
      \ 'wikitag': 'wikitag',
      \ 'filepath': 'filepath',
      \ 'utl': 'utl',
      \ 'block_def': 'block_def',
      \ 'require': 'require',
      \ 'script_arg': 'script_arg',
      \ 'quoted_filename': 'quoted_filename',
      \ 'vimhelp': 'vimhelp',
      \ 'unquoted_filename': 'unquoted_filename',
      \ 'url': 'url',
      \}

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
function! RefWord()
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
command! RefWord call RefWord()
command! RefWordRelativePath RefWord

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
function! RefLine()
  " some text
  " ->
	" some text <url:/Users/mertnuhoglu/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#tn=some text>
  "
	" copy current file path
	let path = expand("%:p")
	" /Users/mertnuhoglu/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R
	let path = substitute(path, '/Users/mertnuhoglu', '\~', '')
	let path = substitute(path, ' (Personal)', '', '')
  let path = substitute(path, "Library/CloudStorage/GoogleDrive-mert.nuhoglu@gmail.com/My Drive/", "gdrive/", "")
	" copy current line 
	let line = Strip2(getline("."))
	let url = line . " <url:" . path . "#tn=" . line . ">"
	let @* = url
	return url
endfunction
command! RefLine call RefLine()
nnoremap rl :RefLine<cr>

" copy line with id for use in utl.vim url with full path t	- file
function! CopyUrl()
	" CopyUrl id=g_00009
  " -->
  " <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g_00009>
	"
	" copy current file path
	let path = expand("%:p")
	" /Users/mertnuhoglu/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R
	let path = substitute(path, '/Users/mertnuhoglu', '\~', '')
	let path = substitute(path, ' (Personal)', '', '')
  let path = substitute(path, "Library/CloudStorage/GoogleDrive-mert.nuhoglu@gmail.com/My Drive/", "gdrive/", "")
	" ~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R
	let line = Strip(getline("."))
	"		# id=r_00005
	let id = substitute(line, '.*id=\(\w\+\):\?.*', '\1', '')
	" r_00005
	let url = printf("%s#r=%s", path, id)
	" ~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R#r=r_00005
	let @u = url
	let result = printf("<url:file:///%s>", url)
	" <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_nested_processes.R#r=r_00005>
  let @* = result
	return result
endfunction
command! CopyUrl call CopyUrl()
command! CopyRefId call CopyUrl()

function! Strip2(input_string)
  let a0 = substitute(a:input_string, '^\_s*\(.\{-}\)\_s*$', '\1', '')
	let a1 = substitute(a0, '^#* ', '', '')
	let a2 = substitute(a1, '`', '', 'g')
	return a2
endfunction

function! Strip(input_string)
  let a2 = Strip2(a:input_string)
	let a3 = substitute(a2, ':\s*$', '', 'g')
	return a3
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

command! -range=% IdSwap <line1>,<line2>s/^\\(\\s*\\)\\(\\w\\+[^<]*\\)\\(<.*>\\)/\\1\\3 \\2/

function! Id4()
	PutGlobalId
	let @* = CopyUrl()
endfunction
command! Id4 call Id4()

" function! RefIdNewS() id=g12690
function! RefIdNewS()
	" global ID
	"
	" input:
		" opt5: make it a function 
	" output:
		" opt5: make it a function id=g_00009
		" opt5: make it a function <url:file:///~/Dropbox (BTG)/TEUIS PROJECT 05-ANALYSIS/working_library/requirements_database/scripts/study_trycatch.R#r=g_00009>
	PutGlobalId
	let line = RefIdUtl()
	" let line = RefIdUtlJournal()
  return line
endfunction
command! RefIdNewS call RefIdNewS()
"command! IdG call RefIdNewS()

function! LogseqBlockTitleExtractPure(line)
	let line = a:line

	" <url:...> metnini silelim
	" - #vim #myst function! GotoBlockOrWikilink() " SPC fd <url:file:///~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim#r=g15045>
	let line02 = substitute(line, '\s*<url:file[^>]\+>', '', 'g')
	let line02b = substitute(line02, '##\+ ', '', '')

  " f/log etiketini muhafaza edelim
  " 	- ## #f/log Convert tsv table to pipe separated markdown table + format alignment
  " 	->
  " 	- ## f/log Convert tsv table to pipe separated markdown table + format alignment
	let line03 = substitute(line02b, '#f\/log ', 'f/log ', 'g')
	" TODO kelimesinin başına `#` ekleyelim
	let line03b = substitute(line03, ' TODO', ' #TODO', '')

	" prb: `#tag` handling:
	" a01: Remove `#tag` or `#ns/tag` or `#tag:` or `#ns/tag-word` inside line
	let line04 = substitute(line03b, '#\(\w\|[-\/]\)\+:\?', '', 'g')
	" a02: Wrap with backtick
	"> line03: #stnd #f/qry title
	" let line04a = substitute(line03b, '#\([^: ]\+\)\([: ]\|$\)\@=', '`\1`', 'g')
	"> line04a: `stnd``f/qry` title
	" let line04b = substitute(line04a, '\(\w\)` `\(\w\)', '\1 \2', 'g')
	"> line04b: `stnd f/qry` title
	" let line04 = substitute(line04b, '\(`[^`]\+`\)[: ]\+\(.\+\)', '\2 \1', 'g')
	"> line04: title `stnd f/qry`

  " Remove internal references inside line
	" Ex: Karar hikayesi: ((fc8d3a93-debf-4203-b8aa-f824e5170d10)) Düzenli bir kalite güvence süreci oluşturalım
	let line05 = substitute(line04, '(([^)]\+))\s*', '', 'g')
  " baştaki sembolleri kaldır #:- vs. 
	" Remove `# ` symbols in front of the line
	" # Header Title
	let line06 = substitute(line05, '^\s*-\+\s\+', '', '')
	let line07 = substitute(line06, '^\s*#\+\s\+', '', '')
	" Sondaki `:` sembolünü kaldır
	" Örnek: Yaratıcı ve değerlendirici düşünme biçimleri arasında gidip gelmek:
	let line08 = substitute(line07, ':\s*$', '', '')

	" log kayıtlarına ref verirken, üst maddenin refini silelim
	" 	- ## #f/log ((d90010b0-81ff-4fce-8168-1e4460fffb8c)) || Convert tsv table to pipe separated markdown table + format alignment
	" 	->
	" 	- ## #f/log Convert tsv table to pipe separated markdown table + format alignment
	let line09 = substitute(line08, '(([^)]\+))\s*', '', 'g')
	let line10 = substitute(line09, '\(||\s*\)', '', '')
	" > (defn -main
	" ->
	" > defn -main
	let line11 = substitute(line10, '^\s*(', '', '')
	return line11
endfunction

function! LogseqBlockTitleExtractClipboard()
  " id:: 4a0cafbc-d085-42ab-a1d5-8c7372ac658f
  " date:: 20251124
	let block = getreg('+')

	let rs = LogseqBlockTitleExtractPure(block)
  let @l = rs
  return rs
endfunction
command! LogseqBlockTitleExtractClipboard call LogseqBlockTitleExtractClipboard()

function! LogseqBlockTitleExtract() "  id=g15048
  " id:: 93c08786-6da0-4d2d-be2b-6ec588b05c04
	" global logseq compatible ID
	"
	" input (file):
  " - #dcsn Karar hikayesi: ((fc8d3a93-debf-4203-b8aa-f824e5170d10)) Düzenli bir kalite güvence süreci oluşturalım
  "   id:: c51669bf-833d-4790-b008-29b22f374c9a
	" output (text):
	normal! ^"ly$
	let line = @l

	let rs = LogseqBlockTitleExtractPure(line)
  let @* = rs
  let @l = rs
  return rs
endfunction
command! LogseqBlockTitleExtract call LogseqBlockTitleExtract()

function! LogseqLineExtractWithoutIdString() "  
	" id:: 0d18472a-470d-4f22-9be1-de6a6367c1e1
	" global logseq compatible ID
	"
	" input (file):
  " - #dcsn Karar hikayesi: ((fc8d3a93-debf-4203-b8aa-f824e5170d10)) Düzenli bir kalite güvence süreci oluşturalım
  "   id:: c51669bf-833d-4790-b008-29b22f374c9a
	" output (text):
	let line = LogseqBlockTitleExtract()
	" Remove: id=g... string
	" Ex: #stnd #vim #myst Sürekli düzenlediğim dosyalar: which-key > edit_map altında id=g14521
	let line05 = substitute(line, ' id=g\d\+\s*$', '', '')
	" Remove: url from markdown link
	" 	> [Datascript and Datomic: Data Modeling for Heroes - Mark Bastian - YouTube](https://www.youtube.com/watch?v=tV4pHW_WOrY&t=1s) || ((96d81571-64a4-4420-be93-d5f312d60f2a))
	" 	->
	" 	> Datascript and Datomic: Data Modeling for Heroes - Mark Bastian - YouTube
	let line06 = substitute(line05, '\[\([^\]]\+\)\](https\?:[^)]\+)', '\1', '')

  let @* = line06
  let @l = line06
  return line06
endfunction
command! LogseqLineExtractWithoutIdString call LogseqLineExtractWithoutIdString()

function! LogseqUuidExtract() " 
	" id:: 7562e184-6b4f-4bde-a20e-a6b3e55e6bdd
	" global logseq compatible ID
	"
	" input (file):
	"   id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" output (text):
	"   id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" normal! ^ww"iy$
	let f01 = getline(line('.'))
	let regex_uuid = '[0-9a-f]\{8}-[0-9a-f]\{4}-[0-9a-f]\{4}-[0-9a-f]\{4}-[0-9a-f]\{12}'
	let f02 = matchstr(f01, regex_uuid)
	let uuid = f02

  return uuid
endfunction
command! LogseqUuidExtract call LogseqUuidExtract()

function! LogseqUuidGenerate() " 
	" id:: 28b54720-15de-41f1-959b-04d7d59faa22
	" exmp: [[20250413-exmp-LogseqUuidGenerate.vim]]
	" global logseq compatible ID
	"
	" input (file):
		" - opt5: make it a function 
	" output (file):
	" - opt5: make it a function 
	"   id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" normal! o  id::  
	" Generate uuid
	" normal! $x
	" normal! k^
	" 20250413 exmp LogseqUuidGenerate
	let uuid = GenUuid()
	let ext = g:GetCFileExt()
	let idline = "id:: " . uuid
	if ext == 'md'
		let line01 = idline
	else
		let line01 = Line2Comment4Ext(idline, ext)
	endif
	if ext == 'otl'
		let indentation = repeat("\t", indent('.')/2 + 1)
	else
		let indentation = repeat(' ', indent('.') + 2)
	endif
	let line02 = indentation . line01
	let dateLine01 = "date:: " . GetDt()
	let dateLine02 = indentation . Line2Comment4Ext(dateLine01, ext)
	if ext == 'md'
		call append(line("."), line02)
	else
		call append(line("."), [line02, dateLine02])
	endif
endfunction
command! LogseqUuidGenerate call LogseqUuidGenerate()

function! RefId()  " SPC ru
	" id:: 7beea565-31fa-47a9-9d63-6202bfe0b7d4
	" global logseq compatible ID
	"
	" input (file):
	"   - opt5: make it a function 
	"     id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" output (text):
	"   - opt5: make it a function  || ((xxxxxx-7560-47c5-8f8b-c93e79250e1a))
	"
	if LogseqCheckIdExists()
		let ref = RefIdLogseq()
	else
		let ref = RefIdNewLogseq()
	endif
	return ref
endfunction
command! RefId call RefId()

function! RefId4Otl()  " SPC rou
  " id:: 36950b30-0f21-45d7-9ad9-8bd51f1072b9
	" global logseq compatible ID
  "
	"
	" input (file):
  "
	"   - opt5: make it a function 
	"     id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
  "
	" output (text):
  "
  "   opt5: make it a function
	"     rfr: opt5: make it a function  || ((xxxxxx-7560-47c5-8f8b-c93e79250e1a))
	"
  let ref = RefId()
  let ttl = matchstr(ref, '[^|]\+')
  let result = ttl . "\n" . '  src: ' . ref . "\n"
  let @* = result
	return result
endfunction
command! RefId4Otl call RefId4Otl()

function! RefIdShort()  " SPC rs
	" id:: 851c7dc2-a079-4b67-9c55-7e09281ab540
	" short uuid
	"
	" input (file):
	"   - opt5: make it a function 
	"     id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" output (text): 
	"   ((xxxxxx))
	"
	if LogseqCheckIdExists()
		normal! j
		let uuid = LogseqUuidExtract()
		let regex_uuid = '[0-9a-f]\{8}'
		let f02 = matchstr(uuid, regex_uuid)
		let ref = "((" . f02 . "))"
		normal! k^
		let @r = ref
		let @* = ref
		return ref
	endif
endfunction
command! RefIdShort call RefIdShort()

function! RefIdLogseq() " 
	" id:: 79383fcf-a034-4592-b4b1-5f78daee66d6
	" global logseq compatible ID
	"
	" input (file):
		" - opt5: make it a function 
		"   id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	" output (text):
		" ((xxxxxx-7560-47c5-8f8b-c93e79250e1a)) opt5: make it a function
	let line = LogseqLineExtractWithoutIdString()
	normal! j
	let uuid = LogseqUuidExtract()
	normal! k^
	let uuid_ref = "((" . uuid . "))"
	let ref = uuid_ref . " || " . line
	let ref2 = line . " || " . uuid_ref 

  let fpath = g:GetCFilePath()
  let lnum = line(".")
  call g:f.rhset_refid_fp_lnum(uuid, fpath, lnum)
  " id:: af615167-09dd-4528-98ee-d98e99fd2d33

	let @r = ref2
	let @u = ref
	let @* = ref2
  return ref2
endfunction
command! RefIdLogseq call RefIdLogseq()

function! RefIdNewLogseq() " SPC rU id=g14978
	" id:: 2e0bf50f-3b07-4974-a07e-f7e53441a2f6
	" global logseq compatible ID
	"
	" input:
		" - opt5: make it a function 
	" output:
		" - opt5: make it a function 
		"   id:: xxxxxx-7560-47c5-8f8b-c93e79250e1a
	LogseqUuidGenerate
	let ref = RefIdLogseq()

  return ref
endfunction
command! RefIdNewLogseq call RefIdNewLogseq()

function! Id6()
	" input:
		" opt5: make it a function 
	" output:
		" opt5: make it a function id=g_00009
		" @link: # opt5: make it a function study_trycatch.R#r=g_00009
	RefIdNewS
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
	call RefIdUtl()
endfunction
command! IdR call IdR()

function! ReplaceId2Url(line, url)
  " line: wifi connection issues id=g_10099
  " url: <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=n_085>
	" ->
	" wifi connection issues <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=n_085>

  let line2 = substitute(a:line, 'id=\w*', a:url, '')
	" wifi connection issues 
  return line2
endfunction

function! ReplaceInLineAsFilePath(url)
  " input:
	"   wifi connection issues id=g_10099
  " out:
  "   wifi connection issues <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g_10099>

	" wifi connection issues 
	silent! s/id=\w*//
	" print: <url:file:///~/Dropbox/mynotes/code/cosx/cosx.md#r=g_10099>
  put =a:url
  normal! kJ
  return a:url
endfunction

function! RefIdUtl()  " SPC ri id=g12680
	" id:: 48b0ce88-a69c-4499-8387-5e89090dcf34
	" @deprecated: Replaced with RefId || ((7beea565-31fa-47a9-9d63-6202bfe0b7d4))
	"
  " input:
	"   wifi connection issues id=g_10099
  " out:
  "   wifi connection issues <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g_10099>

	" input:
	"   - # 20240818-Test-Yonetim-Sistemi #f/isfkr #f/tst
	" out:
	"   20240818 Test Yönetim Sistemi #f/isfkr #f/tst
	"
	" <url:file:///~/projects/myrepo/stuff.otl#r=n_085>

	let url = CopyUrl() 
  "> <url:file:///~/projects/myrepo/stuff.otl#r=n_085>

	let line01 = Strip(getline(".")) 
	"> - # 20240818-Test-YOnetim-Sistemi #f/isfkr #f/tst
	" 
	let line02 = substitute(line01, ':\?\s*$', '\1', '')
  "> wifi connection issues id=g_10099

  let line03 = ReplaceId2Url(line02, url) . "\n"
  "> wifi connection issues <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g_10099>

  " remove `{{{` at end such as:
  " <url:file:///~/projects/vim_repos/my-vim-custom/plugin/my-vim-custom.vim#r=g12847 {{{> {{{
  let line04 = substitute(line03, '\s*{{{\s*', '', 'g')

  " remove `#tag` at end such as:
  " Debug: Portal çalıştırma <url:file:///~/prj/myrepo/work/work4.otl#r=g13646> #clj
  let line05 = substitute(line04, '\(\s*#\w\+\)*\s*$', '', 'g')

  " remove `": ` at start such as:
  ": conjure <url:file:///~/projects/vim_repos/my-vim-custom/plugin/my-vim-custom.vim#r=g12847>
  let line06 = substitute(line05, '^": *', '', '')
  let line07 = substitute(line06, '^ *-\+ *#* *', '', '')

  " md linklerini temizle:
  " input:
  " [replikativ / datahike-invoice](https://gitlab.com/replikativ/datahike-invoice) <url:file:///~/projects/study/clj/clojure.otl#r=g13032>
  " output:
  " replikativ / datahike-invoice <url:file:///~/projects/study/clj/clojure.otl#r=g13032>
  let line08 = substitute(line07, '\[\(.*\)\](.*)\s*\(<url:file.*>\)', '\1 \2', '')

	let @t = printf('`%s`', line08)
	let @r = line08
  let @* = line08
	return line08
endfunction
command! RefIdUtl call RefIdUtl()

function! RefIdUtlJournal()  " SPC rj id=g13761
	" id:: 352e0820-99e6-4dc1-bb55-028002a9f6d9
	" Renamed: RefIdJournal to RefIdUtlJournal
  " Logseq Journal uyumlu vim rfr linki oluşturma
  "
  " input:
	"   wifi connection issues id=g_10099
  " out:
  "   [[wifi connection issues]] <url:file:///~/projects/vim_repos/vim-infoman/plugin/vim-infoman.vim#r=g_10099>

  " let rfr01 = RefIdUtl()
  let rfr01 = Strip(RefIdUtl())
	let rfr01b = RemoveHashtags(rfr01)

  " baştaki "-;# gibi sembolleri sil
  let rfr02 = substitute(rfr01b, '^\s*[-;#":>]*', '', '')
  " ShadowCljs:-IntelliJ-ile-REPL-Baglantisi <url:file:///~/prj/collabry/cldocs/cllogseq/pages/ShadowCljs--IntelliJ-ile-REPL-Baglantisi.md#r=g13764>
  " etrafına [[..]] koy
  let rfr03 = substitute(rfr02, '^\(\s*\)\([^< ]*\)\s*\(.*\)', '\1[[\2]] \3', '')
  " [[ShadowCljs:-IntelliJ-ile-REPL-Baglantisi]] <url:file:///~/prj/collabry/cldocs/cllogseq/pages/ShadowCljs--IntelliJ-ile-REPL-Baglantisi.md#r=g13764>
  " sadece [[..]] kalsın
  let rfr04 = Strip(substitute(rfr03, ' <url.file.*', '', ''))

  " let rfr04 = substitute(rfr03, '^\(\s*\)\([^<]*\)', 'x\2x', '')
  " let rfr02 = substitute(rfr01, '^\(\s*\[-;#"\]\+\s*\)\(\[^<\]\+\)', '\1[[\2]]', '')
  " let rfr02 = substitute(rfr01, '^\(\s*[-;#"]\+\s*\)', 'x\1x', '')
  " let rfr02 = substitute(rfr01, '^\(\s*"\+\s*\)', '\1', '')
  " let rfr02 = substitute(rfr01, '"', '', '')
  " let rfr02 = substitute(rfr01, '^\(\s*"\)', '\1', '')
  " let rfr02 = substitute(rfr01, '^\("\)', '\1', '')
  " let rfr02 = substitute(rfr01, '\("\)', '\1', '')
  " let rfr02 = substitute(rfr01, '"', '', '') " +
  " let rfr02 = substitute(rfr01, '\("\)', '', '') " +
  " let rfr02 = substitute(rfr01, '\("\)', '\1', '') " -
  " let rfr02 = substitute(rfr01, '"', '\1', '') " +
  " let rfr02 = substitute(rfr01, '(")', '\1', '') " -
  " let rfr02 = substitute(rfr01, '^\(\s*"\)', '', '') "+
  " let rfr02 = substitute(rfr01, '\(wifi\)', '', '') "+
  " let rfr02 = substitute(rfr01, '\(wifi\)', '\1', '') "+
  " let rfr02 = substitute(rfr01, '\(wifi\)', 'x\1x', '') "+
  " let rfr02 = substitute(rfr01, '\("\)', 'x\1x', '') "+
  " let rfr02 = substitute(rfr01, '^\(\s*[-;#"]\+\s*\)\(\[^<\]\+\)', 'x\1x', '')  " -
  " let rfr02 = substitute(rfr01, '^\(\s*[-;#"]\+\s*\)\(.*\)', 'x\1x\2', '')
  let rfr05 = substitute(rfr04, '.*', 'Bağlamı: \0', '')
	" let @t = printf('`%s`', rfr03)
	let @p = rfr02  " plain old style
  " let @* = rfr03  " standard    [[..]] <url..>
  let @* = rfr04  " rfr         [[..]] 
	let @r = rfr04  " rfr         [[..]]
	let @b = rfr05  " rfr         [[..]]
	return rfr04
endfunction
command! RefIdUtlJournal call RefIdUtlJournal()

function! RefIdAnywhere1()  " SPC rb  id=g13901
	" id:: bc24f871-32df-4214-b4ca-c5cb2a8e30a7
	" Input: (cursor is anywhere in file)
	"
	"   # 20231218-Title id=...
	"
	" Output:
	"
	"   [[20231218-Title]]
	"
	" Rename: RefIdJournalFromAnywhere to RefIdAnywhere1
  " Dosyanın herhangi bir yerindeyken: RefIdUtlJournal() çağırma
  "
  normal! mz
  normal! gg
  /^#\+ 202\d\+-.*id=\w\+\s*$
  let result = RefIdUtlJournal()
  normal! 'z
  return result
endfunction
command! RefIdAnywhere1 call RefIdAnywhere1()

function! RefIdAnywhere2()  "  id=g14477
  " id:: 9d2c95c9-3de9-489b-9822-400a3f16faf9
	" Rename: RefIdJournalFromAnywhere2 to RefIdAnywhere2
	"
	" doc: function! RefIdAnywhere1()  " SPC rb  || ((bc24f871-32df-4214-b4ca-c5cb2a8e30a7))
	"
  " RefIdAnywhere1 ile farkları:
	"
  " 1. Başlıkta 20230326 şeklinde tarih olması kısıtı yok
	" 2. `#` işaretinden önce `-` sembolü olabilir
  "
  normal! mz
  normal! gg
  /^-\?\s*#\+ \w\+-\?.*id=\w\+\s*$
  let result = RefIdUtlJournal()
  normal! 'z
  return result
endfunction
command! RefIdAnywhere2 call RefIdAnywhere2()

function! RefIdAnywhere()  "  SPC rb
  " id:: 2d02c19a-405d-45ba-8b5a-91ed92589e3f
	" Renamed: RefIdJournalFromAnywhere3 to RefIdAnywhere
	"
	" doc: function! RefIdAnywhere2()  "  || ((9d2c95c9-3de9-489b-9822-400a3f16faf9))
	"
  " RefIdAnywhere2 ile farkları:
	"
  " 1. Başlıkta id=... şeklinde bilgi olması kısıtı yok
	" 2. Başlıkta `/` karakterleri olabilir
  "
  normal! mz
  normal! gg
  "
  " regex: match the followings:
  "   # 20231108-twtp
  "   # 20231030-Wordpress-Kurulum id=g15120
	"   # ndx-journal
	"   # ndx/vim/logseq
  "   - # 20231108-twtp
	"   - # 20240818-Test-Yonetim-Sistemi #f/isfkr #f/tst
  "
	try
		/\v^-?\s*#+ [A-Za-z0-9/\-_]+(\s+(\s*#\w+\/\w+)*)?\s*$
		let result = RefIdUtlJournal()
		echo 'Copied: ' . result
		return result
	catch /.*/
    echo "Caught error: " . v:exception
		normal! `z
		return RefIdFromFileName()
	endtry
endfunction
command! RefIdAnywhere call RefIdAnywhere()

function! RefIdFromFileName()  "  SPC rB
  " id:: c944e3f4-27c2-43ef-93cb-aecce7aaa7ea
	" similar: function! RefIdAnywhere()  "  SPC rb || ((2d02c19a-405d-45ba-8b5a-91ed92589e3f))
	"
	" Input: (reads file name)
	"   some-file.x
	" Output:
	"   [[some-file.x]]
	"
	let f01 = expand("%:t")
	" [[f___fkr]] -> f/fkr
  " let f02 = substitute(f01, '___', '\/', 'g')
	let wikilink = substitute(f01, '.*', '[[\0]]', '')
	let @* = wikilink
	echo wikilink
	return wikilink
endfunction
command! RefIdFromFileName call RefIdFromFileName()

function! RefIdSDeprecated() 
	" leiningen konusunu oku id=n_085
	" >
	" wifi connection issues <url:file:///~/Dropbox/mynotes/code/cosx/cosx.md#r=g_10099>

	" <url:file:///~/projects/myrepo/stuff.otl#r=n_085>
	let url = CopyUrl() 
	" leiningen konusunu oku id=n_085
	let line = Strip(getline(".")) 
	let line = substitute(line, ':\?\s*$', '\1', '')
	let @r = line
	execute "normal! o\<Tab>" 
	" print: leiningen konusunu oku id=n_085
	normal! l"rPyy
  call ReplaceInLineAsFilePath(url)
	let line = Strip(getline(".")) 
	let line = substitute(line, ':\?\s*$', '\1', '')
	let @t = printf('`%s`', line)
	return line
endfunction
command! RefIdS call RefIdUtl()

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
	let @* = CopyRefLineAsPath()
	execute "normal! o\<Tab>"
	"let @p = g:refline
	"normal! l"pPyy
	normal! lPyy
endfunction
command! PasteRefLine call PasteRefLine()
command! IdRefline PasteRefLine 

function! CopyRefLineAsPath()
	" copies current node with its id properly formatted
	"
	" read io: 
	" leiningen konusunu oku id=n_085
	" >
	" return string: 
	" leiningen konusunu oku  <url:file:///~/projects/myrepo/stuff.otl#r=n_085>

	" copy current file path
	let filename = expand("%:p")
	let filename2 = substitute(filename, '/Users/mertnuhoglu', '\~', '')

	let line = Strip(getline("."))
	let title = substitute(line, '\s*\(.*\)id=\(\w\+\)', '\1', '')
	let id = substitute(line, '.*id=\(\w\+\)', '\1', '')
	let result = printf("%s <url:file:///%s#r=%s>", title, filename2, id)
	let @r = result
	let @* = result
	return result
endfunction
command! CopyRefLineAsPath call CopyRefLineAsPath()

" return-done bookmarking
" assumes:
"	mark source (return place) as s
"	mark destination (done place) as d
" function! IdPair() id=g12688
function! IdPair() " SPC rp
	" id:: a9b3bd34-46d9-4e2a-9b19-984b3d2c853a
  normal! mt
	normal! 's
	let src = RefId()
  let src_spaces = repeat(' ', indent('.') + 2)
	normal! 't
	let dest = RefId()
  let dest_spaces = repeat(' ', indent('.') + 2)
  let rtrn = dest_spaces . "rtrn:: " . src
	" call append(line("."), [getline(line(".")+1), rtrn])
  normal! j
	call append(line("."), [rtrn])
	normal! 'sj
	" execute "normal! odone: " . dest . "\<Esc>"
  let bdyy = src_spaces . "bdyy:: " . dest
	call append(line("."), [bdyy])
endfunction
command! IdPair call IdPair()

function! IdPair20231216()
	" id:: c46c91e9-66a2-499f-9526-568551c83bc0
  normal! mt
	normal! 's
	let line = trim(RefIdNewS())
	normal! 't
	execute "normal! o\<Tab>return: " . line . "\<Esc>"
	normal! 't
	let line = trim(RefIdNewS())
	normal! 's
	execute "normal! o\<Tab>done: " . line . "\<Esc>"
endfunction

function! Rcf20241021_IdPair8MvTop()
	" id:: b194b94b-ccb4-4a02-9fd5-8eb768e57876
	" code: function! IdPair8MvTop() || ((1be08918-2e40-4be4-8d72-514d378b52f8))
endfunction

function! GetCurrentFoldText()
	" id:: 9edf511a-387b-431e-9890-5094d0c037de
	" Vimscript: How to select all the text in the current closed fold? #f/prompt #prg/vim
	"   id:: 5479baa3-1ee7-42f1-84a0-883be02eab01
	"
	" Usage:
	"   let fold_contents = GetCurrentFoldText()
	"   let fold_contents_string = join(GetCurrentFoldText(), "\n")
	"
	" [Claude](https://claude.ai/chat/3e5d85d9-8e4e-4ad2-b0c2-4590cf4530c2)
	" I want to select this text and assign it to a variable in vimscript.
	"
	" Save the current cursor position
	let l:save_cursor = getcurpos()

	" Move to the start of the current fold
	normal! [z
	let l:start_line = line('.')

	" Move to the end of the current fold
	normal! ]z
	let l:end_line = line('.')

	" Get the text of the fold
	let l:fold_text = getline(l:start_line, l:end_line)

	" Restore the cursor position
	call setpos('.', l:save_cursor)

	" Return the text as a list of lines
	return l:fold_text
endfunction

function! IdPair8MvTop()  " SPC rP
	" id:: 1be08918-2e40-4be4-8d72-514d378b52f8
	" depends-on: function! IdPair() || ((a9b3bd34-46d9-4e2a-9b19-984b3d2c853a))
	"
	" Works in work.otl
	" input: (cursor on trgt line)
	"
	"       src: block 01
	"       ⁁trgt: block 01
	"       	line 02
	"       ...
	"     nxt
	"
	" output:
	"
  "   		src: block 01
  "   		  id:: b05b99ec-7e2a-4fc9-897d-0dd83823833d
  "         bdyy: trgt: block 01 || ((746fc918-7149-4c11-a101-f1b17dffcd29))
  "   		...
  "   trgt: block 01
  "   	id:: 746fc918-7149-4c11-a101-f1b17dffcd29
  "   	rtrn: src: block 01 || ((b05b99ec-7e2a-4fc9-897d-0dd83823833d))
  "   	line 02
	"   nxt
	"
	normal! 's
	let line_s = line(".")
	normal! 't
	IdPair
	normal! 't
	let line_t = line(".")
	foldclose  " zc
	normal! "udd
	let block_t = join(GetCurrentFoldText(), "\n")
	SetLocsInWorkOtl
	GotoLine(g:session.work_otl.nxt)
	normal! "u]P
endfunction
command! IdPair8MvTop call IdPair8MvTop()

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
	RefLine
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
function! ConvertTable2Excel() range
	" id:: cd510874-33b6-431c-83eb-a42ff9572ed6
	" Delete extra tab characters at the end of lines
	" Example:
	" supplier_id	project_id	$
	" 1	1	$
	let my_range = a:firstline.",".a:lastline
	exe my_range . 's/|/,/g'
	exe my_range . 's/^\s*,\s*//'
	exe my_range . 's/\s*,\s*$//'
	exe my_range . 's/ *, */,/g'
	exe my_range . 's/,/\t/g'
	exe my_range . 'g/^\s*[- \t]\+/d'
endfunction
command! -range=% ConvertTable2Excel <line1>,<line2>call ConvertTable2Excel()

function! ConvertTable2Excel2()
	" id:: e2120f1a-a071-4f2f-a7cf-b754744346c5
	let [start, end] = GetBlockStartEnd()
	exe "" . start . "," . end . "ConvertTable2Excel"
endfunction
command! ConvertTable2Excel2 call ConvertTable2Excel2()

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

function! CopyFilePath2()
	let path = expand("%:p")
	let path = substitute(path, "Dropbox (Personal)", "Dropbox", "")
  let path = substitute(path, "Library/CloudStorage/GoogleDrive-mert.nuhoglu@gmail.com/My Drive/", "gdrive/", "")
  let path = substitute(path, "Library\/CloudStorage\/GoogleDrive-mert.nuhoglu@gmail.com\/My Drive\/", "gdrive/", "")
	echom path
	let @* = path
	return path
endfunction
command! CopyFilePath2 call CopyFilePath2()

function! CopyFilePath()
	let path = CopyFilePath2()
	let is_space_exists = matchstr(path, " ")
	if empty(is_space_exists)
		let path = substitute(path, "/Users/mertnuhoglu", "\\~", "")
	endif
	echom path
	let @* = path
	return path
endfunction
command! CopyFilePath call CopyFilePath()
command! Cfp CopyFilePath
nnoremap cpp :CopyFilePath<cr>

function! CopyPathUrl()
	let path = expand("%:p")
	let path = substitute(path, "^\\(.*\\)", "<url:file://\\1>", "")
	let is_space_exists = matchstr(path, " ")
	if empty(is_space_exists)
		let path = substitute(path, "/Users/mertnuhoglu", "\\~", "")
	endif
	echom path
	let @* = path
endfunction
command! CopyPathUrl call CopyPathUrl()
command! Cpu CopyPathUrl<cr>
function! CopyDirectoryPath()
	let path = expand("%:p:h")
	let path = substitute(path, "Dropbox (Personal)", "Dropbox", "")
	let path = substitute(path, "dcwater - Documents", "dcwater", "")
	let path = substitute(path, "TQM - Belgeler", "tqm", "")
	let path = substitute(path, "LAYERMARK - Belgeler", "layermark", "")
  let path = substitute(path, "Library/CloudStorage/GoogleDrive-mert.nuhoglu@gmail.com/My Drive/", "gdrive/", "")
	let is_space_exists = matchstr(path, " ")
	if empty(is_space_exists)
		let path = substitute(path, "/Users/mertnuhoglu", "\\~", "")
	endif
	echom path
	let @* = path
endfunction
command! CopyDirectoryPath call CopyDirectoryPath()
command! Cdp CopyDirectoryPath
nnoremap cpd :CopyDirectoryPath<cr>

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

function! s:ConvertLineEndingsIntoNewlines() range
	exe a:firstline.",".a:lastline."s/$/\\r/"
	RemoveMultipleBlankLines
endfunction

command! -range=% ConvertLineEndingsIntoNewlines <line1>,<line2>call s:ConvertLineEndingsIntoNewlines()

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
command! Utl3 :call Utl3()

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

" nnoremap üis :Utl2<CR>
" nnoremap üiv :call Utl3()<CR>
" nnoremap tks :Utl2<CR>
" nnoremap tkv :call Utl3()<CR>
" open in new tab
" <vimhelp:utl-tutUI>
command! UtlTab :Utl openLink underCursor tabe
" nnoremap üit :UtlTab<CR>
" nnoremap tkt :UtlTab<CR>

" Navigate to prev/next note
" nnoremap sm /^\\(@\\\\|_\\\\|#\\+ \\\\|^\\S\\+ \\(=\\\\|<-\\) function\\\\|^\\s*\\(public\\\\|private\\\\|protected\\)[^)]*)[^{]*{\\s*\\)<CR>
" nnoremap sl ?^\\(@\\\\|_\\\\|#\\+ \\\|^\\S\\+ \\(=\\\\|<-\\) function\\\\|^\\s*\\(public\\\\|private\\\\|protected\\)[^)]*)[^{]*{\\s*\\)<CR>

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

function! ConvertExcel2Table() range  " tsv table to pipe separated markdown table
  " id:: 64bcb3f1-7c9e-4451-ae3f-bac2c465cc26
  " extra: ((6497d736-58d9-4d97-b178-131ec047f43e)) ! ConvertExcel2Table2() " tsv table to pipe separated markdown table + format alignment
  "
  " tsv formatındaki bir tabloyu
  " pipe separated bir tabloya çevirir.
  "
	" input:
  "   
  "   work_product                     	 entered_at 	
  "   20231010-Veri-Modelleme-egzersiz 	 20231102   	
  "   20231010-Veri-Modelleme-egzersiz 	 20231102   	
  "
	" output:
  "
  "   | work_product                     | entered_at |
  "   | 20231010-Veri-Modelleme-egzersiz | 20231102   |
  "   | 20231010-Veri-Modelleme-egzersiz | 20231102   |
  "
	let first = a:firstline
	let last = a:lastline

	let my_range = first.",".last

	" Delete extra tab characters at the end of lines
	" Example:
	" supplier_id	project_id	$
	" 1	1	$
	exe my_range . "s#\\t\\+$##"
	exe my_range."s#^\\(\\s*\\)\\(\\w\\+\\)#\\1| \\2#"

	exe my_range."s/$/ |/"
	exe my_range."left "
	exe my_range."s/\\t/ | /g"
	" exe my_range."left 2"
endfunction
command! -range=% ConvertExcel2Table <line1>,<line2>call ConvertExcel2Table()
command! -range=% Cet <line1>,<line2>call ConvertExcel2Table()

function! GoToEndOfParagraphBlock()
  " Find the end of the first non-blank line.
	/^\s*$
  let end = line(".")
	return end
endfunction

function! GoToStartOfParagraphBlock()
	" id:: 3cf36456-6460-448b-873c-cc5c54c13214
  " Find the beginning of the first non-blank line.
	" Alternative to
  " normal! {)
	"
	?^\s*$
  let start = line(".")
	return start
endfunction

function! GetBlockStartEnd()
	" id:: b50e06f3-39e8-4b90-b059-bfa743ebaee4
  " rfr: related: function! GetBlockNextStartEnd() || ((cfbabc88-9dc7-4999-9309-f0f011a4dbca))
  "
	" Return start and end line numbers of existing block
	" Note: A block is group of lines that are separated from the neighbor
	" blocks by a blank line
	"
	CleanEmptySpaceLines
	let current_line = line(".")
	" Delete space characters in space-only lines
  call append(line('$'), '')
  " There must be a blank line or the `end` variable is not the actual `end`
  " of the block

  let doc_end = line("$")
  normal! {)
	let start = line(".")
	normal! }
	let end = line(".") - 1
	call cursor(current_line, 1)  " goto line and col

	return [start, end]
endfunction

function! GetBlockNextStartEnd()
  " id:: cfbabc88-9dc7-4999-9309-f0f011a4dbca
  " rfr: related: function! GetBlockStartEnd() || ((b50e06f3-39e8-4b90-b059-bfa743ebaee4))
  "
	" Return start and end line numbers of next block
	"
	let [start, end] = GetBlockStartEnd()
	normal! }

  " wip
	return [start, end]
endfunction

function! IsTableTitle(str)
	" id:: 2e15391b-2907-4915-8908-f341a5a5bfb9
	" Check if the given string is a table title
	" Example: [Supplier-Project]		
  "
	let str = a:str

	" [Supplier-Project]		
  let charnum01 = match(str, '^\s*\(\[[^\]]\+\]\)\s*$')
  let res01 = charnum01 > -1
	echo res01

	" Table 1: Call option					
  " let charnum02 = match(str, '^\s*Table\s*.*$')
  let charnum02 = match(str, '^\s*[#-]*\s*Table\s*.*$')
  let res02 = charnum02 > -1
	let result = res01 || res02
  return result
endfunction
command! IsTableTitle call IsTableTitle(getline("."))

function! ConvertExcel2Table2() range  " SPC mT tsv table to pipe separated markdown table + format alignment
  " id:: 6497d736-58d9-4d97-b178-131ec047f43e
  " tsv formatındaki bir tabloyu
  " pipe separated bir tabloya çevirir.
  " Markdown tablonun hizalama formatını düzeltir.
  "
  " Assumption:
  " Tablonun başı ve sonu boş satırlarla ayrılmış olmalı
  "
	" input:
  "   
  "   <blank-line>
  "   work_product                     	 entered_at 	
  "   20231010-Veri-Modelleme-egzersiz 	 20231102   	
  "   20231010-Veri-Modelleme-egzersiz 	 20231102   	
  "   <blank-line>
  "
	" output:
  "
  "   | work_product                     | entered_at |
  "   | 20231010-Veri-Modelleme-egzersiz | 20231102   |
  "   | 20231010-Veri-Modelleme-egzersiz | 20231102   |
  "
	let [start, end] = GetBlockStartEnd()
	" Check if first line is table name in the following form:
	" Example:
	"
	"   [Supplier-Project]		
	"   supplier_id	project_id	
	"   1	1	
	"
	let first_line = getline(start)
  if IsTableTitle(first_line)
		let start = start + 1
  endif

	exe "" . start . "," . end . "ConvertExcel2Table"
	" go to the header
	normal! {j
	let @d = "" . start . "," . end . "ConvertExcel2Table"
	" 2,1ConvertExcel2Table

	TableModeEnable
	"
	" Put separator line above and under header
	exe "".end."G"
	normal o||
	exe "".start."G"
	normal o||
	exe "".start."G"
	normal O||
	TableModeRealign

endfunction
command! ConvertExcel2Table2 call ConvertExcel2Table2()
" command! -range=% ConvertExcel2Table2 <line1>,<line2>call ConvertExcel2Table2()

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
command! -range=% SurroundWordsWithQuotes2 <line1>,<line2>s/\<\w\+\>/'\\0'/g
command! -range=% SurroundLinesWithQuotes <line1>,<line2>s/.*/'\\0'/
command! RemoveLinesStartingWithNumbers g/^\\d/d
command! RemoveROutputVectorIndexes %s/^ *\\[\\d*\\] //
command! -range=% ReplaceEndOfLineWithComma <line1>,<line2>s/$/,/ | exe 'norm G$x'
command! -range=% ReplaceEscapeBackSlashes <line1>,<line2>s/\\\\/\\\\\\\\/g
command! -range=% RemoveEscapeBackSlashes <line1>,<line2>s/\\\\\\\\/\\\\/g
command! -range=% RemoveDoubleBackSlashes <line1>,<line2>s/\\\\\\\\/\\\\/g
command! ReplaceSlashWithBackSlashes s/\\\\/\\/g
command! ReplaceInvisibleSpaces bufdo %s/ / /ge | update

" nnoremap tüo A - opt

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
	Cfp
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

let $study = '~/projects/study'
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
	Cfp
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
hi CSVColumnEven term=bold ctermbg=3 guibg=#000abc
hi CSVColumnOdd  term=bold ctermbg=10 guibg=#4b1009
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
	let @r = printf("id=g%s", new_id)
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
    history : -20,
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
" map tu :call HandleURL()<cr>
" nnoremap ti :!open -a Safari %<CR><CR>

set history=10000

": spacemacs compatible keybindings for reference management id=g_11006 {{{ 
"nnoremap <leader>cpf :CopyFilename<cr>
"nnoremap <leader>cpp :CopyFilePath<cr>
"nnoremap <leader>cpu :CopyPathUrl<cr>
"nnoremap <leader>cpd :CopyDirectoryPath<cr>
"nnoremap <leader>fn :CopyFilename<cr>
"nnoremap <leader>fu :CopyPathUrl<cr>
"nnoremap <leader>fy :CopyFilePath<cr>
"nnoremap <leader>fp :CopyDirectoryPath<cr>

": }}}

function! OpenWikilinkInRegister() " SPC gü
	" id:: a75152f0-3831-4b2c-af30-7a29755bea29
  " Wikilink satırını yank ettiysen (registerdaysa) onu açar
	" Renamed from: OpenFilePathInRegisterAsWikilink -> OpenWikilinkInRegister
  " rfr: possible-duplicate: _G.find_file_from_register = function() -- SPC ffc || ((98de9c7f-8087-45ce-b8ab-5038e20a20fa))
  " 
  " in: 
  "
  " register has line:
  " - [[20230317-PMS-Piyasa-Arastirmasi]]
  "
  " out:
  " navigated to the file
  "
  let line01 = @*
  let line02 = Strip(line01)
  let line03 = substitute(line02, '.*\(\[\[\(.*\)\]\]\)', '\1', '')
  let @p = line03
  Enew2
  normal! "pP
	GotoBlockOrWikilink
  return line03
endfunction
command! OpenWikilinkInRegister call OpenWikilinkInRegister()

function! OpenFilePathInRegisterAsUtl()
  " Wikilink satırını yank ettiysen (registerdaysa) onu açar
  " 
  " in: 
  "
  " register has line:
  " - [[20230317-PMS-Piyasa-Arastirmasi]]
  "
  " out:
  " navigated to the file
  "
  let line01 = @*
  let line02 = Strip(line01)
  let line03 = substitute(line02, '.*\(<url:.*>\)', '\1', '')
  let @p = line03
  Enew2
  normal! "pP
  Utl
  return line03
endfunction
command! OpenFilePathInRegisterAsUtl call OpenFilePathInRegisterAsUtl()

" rfr: mapping: İ -> gotoDef() || ((d3246cd2-4b88-4427-926e-b75e1817c5c7))
" nnoremap İ :Utl<CR>
" nnoremap İ :GotoDefNoignore<CR>
nnoremap <A-i> :GotoDef<CR>
  " id:: 3945064f-e78f-4af6-b62b-b062c45b6236
	" GotoDef || ((5caa9c16-3450-426e-aa81-5b1879e1eb41))
nnoremap gı :GotoDef<CR>
" function! GotoDef(...) " SPC fd  || ((5caa9c16-3450-426e-aa81-5b1879e1eb41))
" replaced with Ü/Sgd
" nnoremap <leader>İ :ObsidianFollowLink<CR>
nnoremap gİ :OpenFilePathInRegisterAsUtl<CR>
nnoremap gÜ :OpenWikilinkInRegister<CR>

": navigating files {{{
" id=g15014

" rfr: [[20231014-Call-a-Lua-Function-from-within-Vimscript]] 

lua << EOF
function _G.find_files_from_wikilink(filename)
	-- id:: dde72887-af77-4e08-b7fa-3808dba1608e
	-- print(vim.inspect("find_files_from_wikilink"))
	local scopes = require("neoscopes")
  scopes.set_current("all")
	require("telescope.builtin").find_files({
    -- rfr: ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope/builtin/__files.lua
		search_dirs = scopes.get_current_dirs(),
		search_file = filename,
    find_command = { "fd", "--type", "f", "--color", "never", "--full-path" },  -- search as full-path
    -- find_command = { "fd" },  
	})
	return 0
end

function _G.find_files_from_wikilink_nogitignore(filename)
  -- id:: 4a45f391-42cb-4edd-af47-1bb5513eb689
	local scopes = require("neoscopes")
  scopes.set_current("all")
	require("telescope.builtin").find_files({
		search_dirs = scopes.get_current_dirs(),
		search_file = filename,
	})
	return 0
end
EOF

function! GetWikilinkArg(filename)
  " id:: fd43e189-c9eb-430c-8148-100a0672bcb2
	" input: 
	"   20231014-rtc-Yatirim101-Videolari
	"   f/fkr
  "   dir/file-with-ext.txt
	"   lua/20240924-Lua--Which-Key-Table-2-Specs-Table-1004-144922.lua
	"
	" result:
	"		20231014-rtc-Yatirim101-Videolari
	"		f___fkr
  "		dir/file-with-ext.txt
	"
  let f01 = a:filename
  let [is_dir, tmp] = GrepInString('\.\w\+$', f01)
	if is_dir
    " echo "dir path"
    let f03 = f01
    " leave `/` in place. they are used as directory separators
	else
    " [[f/fkr]] -> f___fkr
    let f03 = substitute(f01, '\/', '___', 'g')
    " substitute `/` with `___`. they are used as namespace separators
	endif
	return f03
endfunction

function! GetWikilink()
	" id:: 147ef2c8-6835-456c-9b88-58798f983c04
	" input: 
	"   cursor is on top of the following word:
	"
	"   [[20231014-rtc-Yatirim101-Videolari]]
	"
	" result:
	"
	"		20231014-rtc-Yatirim101-Videolari
	"
	normal! "fyi]
  let f01 = @f
  let f02 = substitute(f01, '[\[\]]', '', 'g')
  let f03 = GetWikilinkArg(f02)
	return f03
endfunction
command! GetWikilink call GetWikilink()

function! GotoWikilinkAsArg(wikilink) "
  " id:: df9a3ffd-d644-4797-8224-c5e1d3019383
	" not used anywhere
	"
	" input: 
  "   wikilink as argument
	"
	"   [[20231014-rtc-Yatirim101-Videolari]]
	"
	" result:
	"
	"   open the following file in telescope: 20231014-rtc-Yatirim101-Videolari.md
	"
  let f01 = a:wikilink
  let f02 = substitute(f01, '[\[\]]', '', 'g')
	" [[f/fkr]] -> f___fkr
  let f03 = substitute(f02, '\/', '___', 'g')
  let f04 = substitute(f03, '.*', '\0.md', '')
	echo f04
	call v:lua.find_files_from_wikilink(f04)
  return f04
endfunction

function! GotoWikilink(wikilink, ...) " SPC fn id=g15020
  " id:: a25bbc96-8bc0-41d4-944f-152f01f2a36c
	" input: 
	"   cursor is on top of the following word:
	"
	"   [[20231014-rtc-Yatirim101-Videolari]]
	"
	" result:
	"
	"   open the following file in telescope: 20231014-rtc-Yatirim101-Videolari.md
	"
  let nogitignore = get(a:, 1, 0)
	lua require('neoscopes').set_current('all')
	let wikilink = a:wikilink
	if empty(wikilink)
		let wikilink = GetWikilink() 
	endif
  if (nogitignore == 1)
    call v:lua.find_files_from_wikilink_nogitignore(wikilink)
  else
		" echo "wikilink: " . wikilink
    call v:lua.find_files_from_wikilink(wikilink)
  endif
  return wikilink
endfunction
command! GotoWikilink call GotoWikilink("")

lua << EOF
function _G.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
EOF

lua << EOF
function _G.find_ref_from_logseq_block_ref(search_string)
  -- id:: 9ce6a7fd-0e11-4647-a5a0-d8d283795a7a
	-- rfr: _G.live_grep2 = function() -- <url:file:///~/prj/private_dotfiles/.config/nvimconfigs/lazyvim/init.lua#r=g15021>
	-- local scopes = require("neoscopes")
	local scopes = require("neoscopes")
  scopes.set_current("all")
  -- scopes.set_current("myrepo")
  -- scopes.set_current("sm:std-myr")
  -- print(vim.inspect(scopes.get_current_dirs()))
  require("telescope.builtin").grep_string({
    search_dirs = scopes.get_current_dirs(),
    -- search_dirs = {"/Users/mertnuhoglu/prj"},
		glob_pattern = "*.{md|vim|lua|txt|csv|tsv|otl|clj|cljc|cljs|js}",
		search = search_string
  })
	return 0
end

function _G.find_ref_from_logseq_block_ref_grepper(search_string)
  -- id:: 4e51afc8-ae06-4e78-988c-a08ee1ef8b9d
  -- rfr: prn: function _G.find_ref_from_logseq_block_ref(search_string) || ((9ce6a7fd-0e11-4647-a5a0-d8d283795a7a))
	local scopes = require("neoscopes")
  scopes.set_current("all")
  require("telescope.builtin").grep_string({
    search_dirs = scopes.get_current_dirs(),
    -- search_dirs = {"/Users/mertnuhoglu/prj"},
		glob_pattern = "*.{md|vim|lua|txt|csv|tsv|otl|clj|cljc|cljs|js}",
		search = search_string
  })
	return 0
end

EOF

function! GotoBlockRefFromBlockLink() " 
	" input: 
	"   cursor is on top of the following word:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26
	"
	normal! "fyi)
  let f01 = @f
  let f02 = substitute(f01, '[()]', '', 'g')
	let f03 = "((" . f02 . "))"
	let f03 = f02
	" echo f03
	call v:lua.find_ref_from_logseq_block_ref(f03)

  return f03
endfunction

function! GotoBlockRefFromIdDef() " 
	" id:: 34934eee-b945-47a4-a6b7-87a608ad6950
	" input: 
	"   cursor is on top of the following line:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	" result:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"
	echo "merhaba"
	let f01 = getline(line('.') + 1)
	let regex_uuid = '[0-9a-f]\{8}-[0-9a-f]\{4}-[0-9a-f]\{4}-[0-9a-f]\{4}-[0-9a-f]\{12}'
	let f02 = matchstr(f01, regex_uuid)

	call v:lua.find_ref_from_logseq_block_ref(f02)
  return f02
endfunction
command! GotoBlockRefFromIdDef call GotoBlockRefFromIdDef()

function! GotoRef(grepper) " SPC fD id=g15022
	" id:: 756f4160-3a26-4d36-849b-2dbcdce28fc5
	" input: 
	"   cursor is on top of the following word:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"
	" result:
	"
	"   search the following string in telescope: 
	"     2f128e0f-....-46ad-894a-de3265ae8b26 
	"

  let grepper = a:grepper
	if empty(grepper)
		let grepper = "Telescope"
	endif

	let [ref, refType] = GetRef()
	normal! mI
	if refType == g:RefType.blocklink
		call GotoBlockRef(ref, grepper)
	endif
	if refType == g:RefType.wikilink
		" call GotoWikilink(ref)
		let ref02 = substitute(ref, '___', '\/', 'g')
    call GotoBlockRef(ref02, grepper)
	endif
	if refType == g:RefType.filepath
		" exe "e " . ref
    call GotoBlockRef(ref, grepper)
	endif
	if refType == g:RefType.utl
		" exe "Utl openLink " . ref
    call GotoBlockRef(ref, grepper)
	endif
	if refType == g:RefType.wikitag
		" call GotoWikilink(ref)
    call GotoBlockRef(ref, grepper)
	endif
	if refType == g:RefType.block_def
    call GotoBlockRef(ref, grepper)
	endif
	if ref == ""
		Utl
	endif
  if refType == g:RefType.require
    call GotoBlockRef(ref, grepper)
  endif

endfunction
command! GotoRef call GotoRef("")

function! GetBlockRef() 
	" id:: 008f6037-114b-477d-875d-c4dd29aba1e0
	" input: 
	"   cursor is on top of the following word:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26 ))
	"
	" result:
	"
	"     2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	normal! "fyi)
  let f01 = @f
  let f02 = substitute(f01, '[()]', '', 'g')
	return f02
endfunction
command! GetBlockRef call GetBlockRef()

function! GotoBlockRef(ref, grepper) " SPC fD 
  " id:: ff7c2a40-903e-4c19-93f6-db4ece6cdc84
	" input: 
	"   2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	" result:
	"
	"   search the following string in telescope: 
	"     2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let ref = a:ref
	if empty(ref)
		let ref = GetBlockRef() 
	endif

  let grepper = a:grepper
	if empty(grepper)
		let grepper = "Telescope"
	endif

	let ref02 = ref

	echo ref02
  if grepper == "Telescope"
    call v:lua.find_ref_from_logseq_block_ref(ref02)
  elseif grepper == "live_grep"
		let @* = ref02
		call v:lua.live_grep_all()
	else
    call GrepRef(ref02)
  endif
  return ref02
endfunction
command! GotoBlockRef call GotoBlockRef("", "")

function! GotoBlockDefBufferNoJump()  " gQ
	" id:: d56e5382-6be1-4713-ac85-685b8ce3b7ce
	" rfr: sibling: function! GotoBlockDefBuffer() " gq g* || ((1494d523-ca2b-47e4-a556-fec429ca1427))
	" input: 
	"   some text with ((<uuid>))
	"
	" result:
	"   / register: <uuid>
	"
	let line = Strip2(getline("."))
	let [is_blocklink, ref01] = GrepInString(g:rgx.is_blocklink, line)
	let [is_block_def, ref03] = GrepInString(g:rgx.is_block_def, line)
	let [is_wikilink, ref02] = GrepInString(g:rgx.is_wikilink, line)
	let [is_quoted, ref_quoted] = GrepInString(g:rgx.quoted, line)
	let ref = expand('<cWORD>')
	if is_quoted
		let ref = ref_quoted
	endif
	if is_blocklink
		let ref = ref01
	endif
	if is_block_def
		let ref = ref03
	endif
	if is_wikilink
		let ref = GetWikilinkArg(ref02)
	endif

	let @/ = ref
  return ref
endfunction
command! GotoBlockDefBufferNoJump call GotoBlockDefBufferNoJump()

function! GotoWORD() " g*
	" id:: 2c040e74-ea8d-4384-8e67-e0c1fd678b97
	" input: 
	"   some word-with-parts
	"
	" result:
	"   search the following string in buffer: word-with-parts
	"
	let word = expand('<cWORD>')
	let @/ = word
	normal! n
  return word
endfunction
command! GotoWORD call GotoWORD()

function! GotoBlockDefBuffer() " gq g*
	" id:: 1494d523-ca2b-47e4-a556-fec429ca1427
	" input: 
	"   some text with ((<uuid>))
	"
	" result:
	"   search the following string in buffer: <uuid>
	"
	let ref = GotoBlockDefBufferNoJump()
	normal! N
  return ref
endfunction
command! GotoBlockDefBuffer call GotoBlockDefBuffer()

function! GotoBlockDefBufferInOtherWindow() " g*
	" input: 
	"   some text with ((<uuid>))
	"
	" result:
	"   search the following string in buffer: <uuid>
	"
	let ref = GotoBlockDefBuffer()
	wincmd p
	normal! N
	normal! zv
	normal! V
  return ref
endfunction
command! GotoBlockDefBufferInOtherWindow call GotoBlockDefBufferInOtherWindow()

nnoremap g* :GotoWORD<CR>
nnoremap gq :GotoBlockDefBuffer<CR>
nnoremap gb :GotoBlockDefBufferInOtherWindow<CR>
nnoremap gQ :GotoBlockDefBufferNoJump<CR>

function! GotoLineWSameText() " gS 
	" id:: 1aa8bd57-b350-4472-a805-dcc5ee93c865
	" input: (cursor on some line)
	"   some line
	"   ...
	"   ⁁some line
	"
	" result: (go to the same content by searching that line text)
	"   ⁁some line
	"   ...
	"   some line
	"
	"
	let line = Strip2(getline("."))
	let line02 = substitute(line, "^\s*[-#]* \?", "", "")
	let line03 = substitute(line02, "^- ", "", "")

	let @/ = line03
	" Search backwards 
	normal! N
  return line03
endfunction
command! GotoLineWSameText call GotoLineWSameText()
nnoremap gS :GotoLineWSameText<CR>

function! GotoBlockDef(ref) " SPC fd 
	" id:: 4a07276d-1ed9-40a2-9f12-c816bbf46ecd
	" input: 
	"   2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let ref = a:ref
	if empty(ref)
		let ref = GetBlockRef() 
	endif

	let ref02 = "id:: " . ref

	echo ref02
	call v:lua.find_ref_from_logseq_block_ref(ref02)
  return ref02
endfunction
command! GotoBlockDef call GotoBlockDef("")

function GrepInString(pattern, string)
	" id:: 254af958-f8a5-48be-8e35-9ea5fa71bdaa
	" rfr: [[20231018-Vimscript-Grep-Function]] <url:file:///~/projects/study/logseq-study/pages/20231018-Vimscript-Grep-Function.md#r=g15043>

	let pattern = a:pattern
	let string = a:string
  let matches = matchstr(string, pattern)
  return [!empty(matches), matches]
endfunction

function Rcb20231018_02()
	let string = "This is a sample text."
	let pattern = "sample"

	if GrepInString(pattern, string)
		echo "The pattern '" . pattern . "' was found in the string '" . string . "'."
	else
		echo "The pattern '" . pattern . "' was not found in the string '" . string . "'."
	endif
endfunction

function! GetRef() 
	" id:: 16a647a4-9c2f-4b44-9b6e-3dd1c3e6046f
	" input: 
	"   cursor is on top of the following word:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"   ~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim
	"   ~/projects/myrepo/work/work.otl
	"   #ndx Title
	"
	" result:
	"
	"   2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	" let line = Strip2(getline("."))
	let line = getline(".")
	return GetRefArg(line)
endfunction
command! GetRef call GetRef()

function! RfcRegexLookbehind()
  " id:: e7a31725-d5c9-4f79-83bd-e54df7e71449
  echo substitute("foobar", '\v(foo)\@<!bar', '@@@', '')
  " foobar
  echo substitute("okbar", '\v(foo)\@<!bar', '@@@', '')
  " okbar
  echo substitute("okbar", '\(foo\)\@<!bar', '@@@', '')
  " ok@@@
  " Correct with no-magic mode
  echo substitute("okbar", '\v\(foo\)\@<!bar', '@@@', '')
  " okbar
  echo substitute("okbar", '\v(foo)@<!bar', '@@@', '')
  " ok@@@
  " Correct with magic mode

  echo substitute("foobar", '\v\<foo', '@@@', '')
  " foobar
  echo substitute("foobar", '\v<foo', '@@@', '')
  " @@@bar

  echo substitute("one-two", '\w\+', '@@@', '')
  " @@@-two
  echo substitute("one-two", '\v[-\w]+', '@@@', '')
  " one@@@two

  let line = 'require("20240924-in-tags")'
  let pattern = '\v(<require\(")@<=([^"]+)("\))@='
  echo substitute(line, pattern, '@@@', '')
  " require("@@@")
endfunction

function! OpenWikiLink(line)  
	" id:: 6bd68cb7-2853-46c3-af27-cbfe52e4fe97
	"
	" let line = '[[20241228-fp-in-lua.lua]]'
	" ref02:
	" '20241228-fp-in-lua.lua'
	" :b 20241228-fp-in-lua.lua
	"
	let line = a:line
	let [is_wikilink, ref02] = GrepInString(g:rgx.is_wikilink, line)
	if is_wikilink
		exec "b " . ref02
	endif
endfunction

function! GotoDefFReg()  " SPC ffc
	" id:: 50b0c0cd-24cb-40ad-a7e5-7ac012f2c907
	let line = @*
	call GotoDefArg(line, 0)
endfunction
command! GotoDefFReg call GotoDefFReg()

function! OpenWikiLinkFBuffersFReg()  " SPC ffcb
	" id:: 6ce411c5-5a69-4d06-b2b4-ebc4fedd4aab
	let line = @*
	call OpenWikiLink(line)
endfunction
command! OpenWikiLinkFBuffersFReg call OpenWikiLinkFBuffersFReg()

function! OpenWikiLinkFBuffers()  " SPC ffb
	" id:: 6bd68cb7-2853-46c3-af27-cbfe52e4fe97
	"
	" let line = '[[20241228-fp-in-lua.lua]]'
	" ref02:
	" '20241228-fp-in-lua.lua'
	" :b 20241228-fp-in-lua.lua
	"
	let line = getline(".")
	call OpenWikiLink(line)
endfunction
command! OpenWikiLinkFBuffers call OpenWikiLinkFBuffers()

function! OpenWikiLinkFLine()  " SPC ffb
	" id:: 1757248a-f76b-4517-b8d7-8c4c4a33a2f7
	let quoted_text = GetQuotedTextUnderCursor()
	let cword = expand('<cword>')
	let reg = @*
	let [in_register, ref01] = GrepInString(g:rgx.is_wikilink, reg)
	let line = getline(".")
	let [in_line, ref02] = GrepInString(g:rgx.is_wikilink, line)
	if in_line
		echo line
		call OpenWikiLink(line)
	elseif in_register 
		echo reg
		call OpenWikiLink(reg)
	elseif bufnr(quoted_text) 
		echo quoted_text
		exec "buffer " . bufnr(quoted_text) 
	elseif bufnr(cword)
		echo cword
		exec "buffer " . bufnr(cword)
	endif
endfunction
command! OpenWikiLinkFLine call OpenWikiLinkFLine()

function! GetQuotedTextUnderCursor()
	" id:: 2adb3203-645a-434c-a3fd-994553307ea2
	" Vim: Get quoted text under cursor #f/prmp
	" Vim: Assume that cursor is inside a quoted text. How can I get the text inside quotes? 
	" [Claude](https://claude.ai/chat/674ce6d8-a63a-4a52-b5ce-51e8c946312c)
	"
	" Now it will work correctly in these cases:
	" Cursor inside quoted text: "hello|world"
	" Cursor on closing quote: "hello"|
	" Cursor on opening quote: |"hello"
	"
	let line = getline('.')
	let col = col('.') - 1  " Convert to 0-based index

	" If cursor is on a quote, check if it's closing or opening
	if line[col] ==# '"'
		" Look backward first to determine if it's a closing quote
		let i = col - 1
		let quotes_count = 0
		while i >= 0
			if line[i] ==# '"'
				let quotes_count += 1
			endif
			let i -= 1
		endwhile

		" If odd number of quotes before cursor, this is a closing quote
		" Move cursor one position left
		if quotes_count % 2 == 0
			" This is an opening quote
		else
			let col -= 1
		endif
	endif

	" Find the surrounding quotes
	let start = -1
	let end = -1

	" Search backward for opening quote
	let i = col
	while i >= 0
		if line[i] ==# '"'
			let start = i
			break
		endif
		let i -= 1
	endwhile

	" Search forward for closing quote
	let i = col
	while i < len(line)
		if line[i] ==# '"'
			let end = i
			break
		endif
		let i += 1
	endwhile

	if start != -1 && end != -1
		return line[start+1:end-1]
	endif
	return ''
endfunction

function! OpenBufferFCWord()  " SPC ffbw
	let word = expand('<cword>')
	exec "b " . word
endfunction
command! OpenBufferFCWord call OpenBufferFCWord()

function! OpenBufferFCQuote()  " SPC ffbw
	" "edits_pprv" = "20241121-wk-edits-1121-134809.lua",
	let word = GetQuotedTextUnderCursor()
	exec "b " . word
endfunction
command! OpenBufferFCQuote call OpenBufferFCQuote()

function! OpenBufferFLine()  " SPC ffbb
	" id:: 6bd68cb7-2853-46c3-af27-cbfe52e4fe97
	"
	" a01:
	" let line = '[[20241228-fp-in-lua.lua]]'
	" ref02:
	" '20241228-fp-in-lua.lua'
	" :b 20241228-fp-in-lua.lua
	"
	" a02:
	" --script=20241228-fp-in-lua.lua
	"
	" a02:
	" require("20241228-fp-in-lua.lua")
	"
	let line = getline(".")
	let [ref, refType] = GetRefArg(line)
	if refType == g:RefType.wikilink
		exec "b " . ref
	endif
  if refType == g:RefType.require
		exec "b " . ref
  endif
  if refType == g:RefType.script_arg
		exec "b " . ref
  endif
endfunction
command! OpenBufferFLine call OpenBufferFLine()

function! GetRefArg(line) 
  " id:: c639de96-98d0-4152-8718-62bae2c089ce
	" input: 
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"   ~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim
	"   ~/projects/myrepo/work/work.otl
	"   #ndx Title
	"
	" result:
	"
	"   2f128e0f-....-46ad-894a-de3265ae8b26 
	"
  " debug: [[20250915-debug-GetRefArg.vim]]
  "
	let line = a:line
	let ref = ""
	let [is_blocklink, ref01] = GrepInString(g:rgx.is_blocklink, line)
	" let [is_linelink, ref01] = GrepInString('\(((\)\@<=[^)]\+\())\)\@=', line)
	let [is_wikilink, ref02] = GrepInString(g:rgx.is_wikilink, line)

	let [is_block_def, ref03] = GrepInString(g:rgx.is_block_def, line)
	if !is_block_def
    " echo "inside !is_block_def"
    let next_line = getline(line('.') + 1)
    let [is_block_def, ref03] = GrepInString(g:rgx.is_block_def, next_line)
    " echo ref03
	endif
  " echo "02: " . ref03

	" Error: GotoDef with BlockRef 20241209  `prg/vim f/error` || ((d123a2ba-6b16-4b98-9249-88e77cd7b12f))
	let line02 = substitute(line, '\v`[^` ]+`', '', 'g')
	let [is_filepath, ref04] = GrepInString(g:rgx.is_filepath, line02)
  " > <url:file:///~/projects/study/logbook/log_20220927.md#r=g13408>
	" ~/prj/myrepo/logseq-myrepo/exmp/20241205/20241119_specs.tsv
	" /Users/mertnuhoglu/prj/myrepo/logseq-myrepo/exmp/20241117-setops-ndx-files/20241119-specs.tsv
	" echo matchstr(line, g:rgx.is_utl)
	let [is_utl, ref05] = GrepInString(g:rgx.is_utl_url, line)
	let [is_wikitag, ref06] = GrepInString(g:rgx.is_wikitag, line)
	if is_utl
		let is_filepath = 0
	endif

  " match: 20240924-in-tags
	" pattern1:
	" package.loaded["20241117-wk-edits"] = nil
	" pattern2:
  " local append_map = require("20241117-wk-edits")
	" serialize_cfile("20241225-serialize-in-cfile-dir-data-01.lua", { a = "ali", b = { c = 10 } })
	" pattern3:
	" local specs_lua_fn = "20241022-specs-all"
	let words = '(require|reload|package.loaded|serialize_cfile|write_cfile|write_tsv|read_tsv|readLines|writeLines|read_tsv_cfile|read_file|read_cfile|read_tsv_file_as_tbl|read_tsv_cfile_as_tbl|read_tsv_file|read_tsv_cfile)'
	" let pattern1 = '(<package.loaded\[")@<=([^"]+)("\])@='
	"  let pattern2 = '(<require\(")@<=([^"]+)("\))@='
  let pattern2 = '(<' . words . '\([^)"]*")@<=([^"]+)(".*\))@='
	let pattern3 = '(<local \w{1,20} \= ")@<=([^/"]+)(")@='
	" let pattern = '\v(' . pattern1 . ')|(' . pattern2 . ')'
	" let pattern = '\v(' . pattern1 . ')|(' . pattern2 . ')|(' . pattern3 . ')'
  " id:: ebd0ee1d-76db-48e3-a9df-2d0f53b634d4
	" '\v((<package.loaded\[")@<=([^"]+)("\])@=)|((<require\(")@<=([^"]+)("\))@=)|((<local \w{1,20} *= *")@<=([^"]+)(")@=)'
	" let [is_require, ref07] = GrepInString('\v' . pattern3, line)
	" E871: (NFA regexp) Can't have a multi follow a multi
	" Fix: \w+ *\= * -> \w{1,20} \= 
	" let pattern = '\v(package\.loaded\[")([^"]+)("\])|(require\(")([^"]+)("\))|(local \w{1,20} = ")([^"]+)(")'
	" let [is_require, ref07] = GrepInString(pattern, line)
	" E872: (NFA regexp) Too many '('
	" Fix: Use switch:
	" let [is_require1, ref07a] = GrepInString('\v' . pattern1, line)
	let [is_require2, ref07b] = GrepInString('\v' . pattern2, line)
	let [is_require3, ref07c] = GrepInString('\v' . pattern3, line)
	" if is_require1
	" 	let is_require = is_require1
	" 	let ref07 = ref07a
	"
	" match nushell file paths:
	" let \w\+ = \$"(\$\w\+)\/\([^"]\+\)
	" \v(let \w+ \= \$"\(\$\w+\)\/)@<=([^"]+)
	" matches:
	" let fp_sorted = $"($DATA_DIR)/all-refid-date.json"
	"
	let pattern4 = '\v(let \w+ \= \$"\(\$\w+\)\/)@<=([^"]+)'
	let [is_require4, ref07d] = GrepInString('' . pattern4, line)

  if is_require2
		let is_require = is_require2
		let ref07 = ref07b
  elseif is_require3
		let is_require = is_require3
		let ref07 = ref07c
  elseif is_require4
		let is_require = is_require4
		let ref07 = ref07d
	else
		let is_require = 0
		let ref07 = ''
	endif

	" .. [[--script=20241124-named-arguments-in-command-line-02.R ]]
	" ->
	" 20241124-named-arguments-in-command-line-02.R
  let pattern = '\v(--script\=)@<=([^ ]+)'
	let [is_script_arg, ref08] = GrepInString(pattern, line)

	" tags_pprv = "20241022-specs-all.lua",
	" ->
	" 20241022-specs-all.lua
	let [is_quoted_filename, ref09] = GrepInString(g:rgx.quoted_filename, line)
	let [is_unquoted_filename, ref09b] = GrepInString(g:rgx.unquoted_filename, line)

	" let line = '<vimhelp:fireplace-documentation>'
	let [is_vimhelp, ref10] = GrepInString(g:rgx.is_utl_vimhelp, line)
	"

	let [is_url, ref_url] = GrepInString(g:rgx.is_url, line)

	let debug = {
					\ 'is_block_def': is_block_def,
					\ 'is_wikitag': is_wikitag,
					\ 'is_blocklink': is_blocklink,
					\ 'is_wikilink': is_wikilink,
					\ 'is_filepath': is_filepath,
					\ 'is_utl': is_utl,
					\ 'is_require': is_require,
					\ 'is_script_arg': is_script_arg,
					\ 'is_quoted_filename': is_quoted_filename,
					\ 'is_unquoted_filename': is_unquoted_filename,
					\ 'is_vimhelp': is_vimhelp
					\}
	call WriteRunlogVim("# GetRefArg():")
	call WriteRunlogVim(string(debug))

	let refType = ''
  if is_url
    let ref = ref_url
    let refType = g:RefType.url
  endif
  if is_block_def
    let ref = ref03
    let refType = g:RefType.block_def
  endif
	if is_wikitag
		let ref = ref06
    let refType = g:RefType.wikitag
	endif
	if is_blocklink
		let ref = ref01
    let refType = g:RefType.blocklink
	endif
	if is_wikilink
		let ref = GetWikilinkArg(ref02)
    let refType = g:RefType.wikilink
	endif
	if is_filepath && !is_wikilink
		let ref = ref04
    let refType = g:RefType.filepath
	endif
	if is_utl
    let ref05b = substitute(ref05, ".*<url:file:\/\/\/", "", "")
    let ref = substitute(ref05b, ">\s*", "", "")
    let refType = g:RefType.utl
	endif
  if is_require
    let ref = ref07
    let refType = g:RefType.require
  endif
  if is_script_arg
    let ref = ref08
    let refType = g:RefType.script_arg
  endif
	if empty(refType)
		if is_quoted_filename
			let ref = ref09
			let refType = g:RefType.quoted_filename
		elseif is_unquoted_filename
			let ref = ref09b
			let refType = g:RefType.unquoted_filename
		endif
	endif
	if is_vimhelp
    let ref10b = substitute(ref10, ".*<vimhelp:", "", "")
    let ref = substitute(ref10b, ">", "", "")
    let refType = g:RefType.vimhelp
	endif
	return [ref, refType]
endfunction
command! GetRefArg call GetRefArg()

function! GetRefArg20241011(line) 
  " rfr: replaced-by: function! GetRefArg(line)  || ((c639de96-98d0-4152-8718-62bae2c089ce))
	" input: 
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"   ~/.vim/bundle/vim-infoman/plugin/vim-infoman.vim
	"   ~/projects/myrepo/work/work.otl
	"   #ndx Title
	"
	" result:
	"
	"   2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let line = a:line
	let ref = ""
	let [is_blocklink, ref01] = GrepInString('\(((\)\@<=[^)]\+\())\)\@=', line)
	" let [is_linelink, ref01] = GrepInString('\(((\)\@<=[^)]\+\())\)\@=', line)
	let [is_wikilink, ref02] = GrepInString(g:rgx.wikilink_content, line)

	let [is_block_def, ref03] = GrepInString('\(\<id:: \)\@<=\(.*\)\(\s*$\)\@=', line)
	if !is_block_def
    " echo "inside !is_block_def"
    let next_line = getline(line('.') + 1)
    let [is_block_def, ref03] = GrepInString('\(\<id:: \)\@<=\(.*\)\(\s*$\)\@=', next_line)
    " echo ref03
	endif
  " echo "02: " . ref03

	let [is_filepath, ref04] = GrepInString('\(\~\|\/Users\)\(\/\.\?\w\+[-_]\?\w*\)\+\.\w\+', line)
  " > <url:file:///~/projects/study/logbook/log_20220927.md#r=g13408>
	let [is_utl, ref05] = GrepInString('\s<url:file:\/\/\/[^>]\+>', line)
	let [is_wikitag, ref06] = GrepInString('\(#\)\@<=\([^: ]\+\)', line)
	if is_utl
		let is_filepath = 0
	endif

  " match: 20240924-in-tags
  " local append_map = require("20240924-in-tags")
	let words = 'require|reload'
  let pattern = '\v(<' . words . '\(")@<=([^"]+)("\))@='
  " id:: ebd0ee1d-76db-48e3-a9df-2d0f53b634d4
	let [is_require, ref07] = GrepInString(pattern, line)

  if is_block_def
    let ref = ref03
  endif
	if is_wikitag
		let ref = ref06
	endif
	if is_blocklink
		let ref = ref01
	endif
	if is_wikilink
		let ref = GetWikilinkArg(ref02)
	endif
	if is_filepath
		let ref = ref04
	endif
	if is_utl
    let ref05b = substitute(ref05, ".*<url:file:\/\/\/", "", "")
    let ref = substitute(ref05b, ">\s*", "", "")
	endif
  if is_require
    let ref = ref07
  endif
	return [ref, is_blocklink, is_wikilink, is_wikitag, is_filepath, is_utl, is_block_def, is_require]
endfunction
function! Rcf20241011_EnumType()
  " Vimscript: Is there enum type? #f/prompt #prg/vim
  "   id:: cc68be50-2fbe-4747-8e57-d70dcab5de5f
  let g:Colors = {
      \ 'RED': 0,
      \ 'GREEN': 1,
      \ 'BLUE': 2
      \ }
  if some_color == g:Colors.RED
      " Do something for red
  endif
endfunction

function! GotoDefSplit() " SPC ıv
	only
	SplitVertical
	GotoDef
endfunction
command! GotoDefSplit call GotoDefSplit()

function! GotoDefHorizontal() " SPC ıs
	SplitHorizontal
	GotoDef
endfunction
command! GotoDefHorizontal call GotoDefHorizontal()

command! GotoDef lua require("user.mert-lua-nvim").gotoDef()  
  " id:: d3246cd2-4b88-4427-926e-b75e1817c5c7
	" local function gotoDef() -- SPC ffe or İ || ((1348ce1d-805d-431c-a2a2-83d57b7e941f))
nnoremap İ :GotoDef<CR>

function! GotoDefFfz(...) " SPC fd 
	" id:: 5caa9c16-3450-426e-aa81-5b1879e1eb41
	" input: 
	"   cursor is on top of the following word:
	"
	"   title ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let line = Strip2(getline("."))
	" By default: don't respect gitignore
  let nogitignore = get(a:, 1, 0)
	return GotoDefArg(line, nogitignore)
	" function! GotoDefArg(line, nogitignore) "  || ((b92df8f3-0ca4-4977-96ff-944d17e70498))
endfunction
command! GotoDefFfz call GotoDefFfz()

function! GotoDefFClipboard()  " SPC etc
	" id:: d50c6f85-2c38-4577-898a-2f4a68ea427f
	let line = @*
  let nogitignore = get(a:, 1, 0)
	return GotoDefArg(line, nogitignore)
endfunction
command! GotoDefFClipboard call GotoDefFClipboard()

function! GotoDefArg(line, nogitignore) " 
  " id:: b92df8f3-0ca4-4977-96ff-944d17e70498
	" input: 
	"
	"   title ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"   [[lua/20240924-Lua--Which-Key-Table-2-Specs-Table-1004-144922.lua]]
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let line = a:line
  let nogitignore = a:nogitignore
  let [ref, refType] = GetRefArg(line) " || ((c639de96-98d0-4152-8718-62bae2c089ce))
	" normal! mI
	if refType == g:RefType.blocklink
		call GotoBlockDef(ref)
	endif
	if refType == g:RefType.wikilink
		call GotoWikilink(ref, nogitignore)
	endif
	if refType == g:RefType.filepath
		exe "e " . ref
	endif
	if refType == g:RefType.utl
		exe "Utl openLink " . ref
	endif
	if refType == g:RefType.wikitag
		call GotoWikilink(ref, nogitignore)
	endif
	if refType == g:RefType.block_def
    call GotoBlockRef(ref, "")
	endif
	if refType == g:RefType.vimhelp
		exe "h " . ref
	endif
	if ref == ""
		Utl
	endif
	" Vim: Set containment check function #f/prmp
	"   id:: 49e05fb2-836b-467e-b6fb-97993b42c8c8
	" I have other criteria as well. Instead of or operator, is there a set containment check function?
	" [Claude](https://claude.ai/chat/88fff252-9dac-4d11-94e3-afe17025a284)
	if index([g:RefType.require, g:RefType.script_arg, g:RefType.quoted_filename], refType) >= 0
		call GotoWikilink(ref, nogitignore)
	endif
endfunction
command! GotoDefArg call GotoDefArg()

function! GotoBlockOrWikilink() " SPC fld 
  " id=g15045
	call GotoDef()
endfunction
command! GotoBlockOrWikilink call GotoBlockOrWikilink()

function! GotoDefFromRegister() " 
	" id:: e5644814-1645-4ea0-a93d-cc7e02a0c661
	" Take default register's content
	" Run GotoDef with that content
	" input: Some line is in the register
	"
	"   title ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let line = @*
	return GotoDefArg(line, 0)
endfunction
command! GotoDefFromRegister call GotoDefFromRegister()

function! GotoDefNoignore() " SPC flD
  " id:: b6911bef-e4a2-4fa6-bdbb-3e5ac7da7c80
  " don't respect .gitignore in find_files()
	" call GotoDef(1)
	call GotoDefFfz(1)
endfunction
command! GotoDefNoignore call GotoDefNoignore()

function! GotoBlockOrWikilink20231204() 
	" id:: 040394ed-ed1a-4d11-b26a-5d7bb0054993
	" input: 
	"   cursor is on top of the following word:
	"
	"   ((2f128e0f-....-46ad-894a-de3265ae8b26))
	"   [[20231018-Vimscript-Grep-Function]]
	"
	" result:
	"
	"   search the following string in telescope: 
	"     id:: 2f128e0f-....-46ad-894a-de3265ae8b26 
	"
	let [ref, is_blocklink, is_wikilink] = GetRef()
	if is_blocklink
		call GotoBlockDef(ref)
	endif
	if is_wikilink
		call GotoWikilink(ref)
	endif
endfunction
function! GotoBlockOrWikilinkTab() " SPC ft
	" id:: 7fb64f86-491f-44d8-9087-aa657899006f
	" GotoBlockOrWikilink in a new tab
	" ((5caa9c16-3450-426e-aa81-5b1879e1eb41)) || function! GotoBlockOrWikilink() " SPC fd
	"
  mark c
  tabedit %
  normal! `c
  GotoBlockOrWikilink
endfunction
command! GotoBlockOrWikilinkTab call GotoBlockOrWikilinkTab()

function! GotoBlockOrWikilinkVSplit() " SPC flv
  " id:: a49cfd28-e09b-41ff-b5ad-86c931d5722c
	" GotoBlockOrWikilink in a new vertical split
	" ((5caa9c16-3450-426e-aa81-5b1879e1eb41)) || function! GotoBlockOrWikilink() " SPC fd
	"
  " datomic.otl || ((8361a15c-7452-4dc2-babd-5faf76e3fe47))
  mark c
  wincmd v
  " wincmd l
  normal! `c
  GotoBlockOrWikilink
endfunction
command! GotoBlockOrWikilinkVSplit call GotoBlockOrWikilinkVSplit()

function! GotoBlockOrWikilinkSplit() " SPC fls
	" GotoBlockOrWikilink in a new split
	" ((5caa9c16-3450-426e-aa81-5b1879e1eb41)) || function! GotoBlockOrWikilink() " SPC fd
	"
  " datomic.otl || ((8361a15c-7452-4dc2-babd-5faf76e3fe47))
  mark c
  wincmd s
  " wincmd l
  normal! `c
  GotoBlockOrWikilink
endfunction
command! GotoBlockOrWikilinkSplit call GotoBlockOrWikilinkSplit()

": }}}

": debug: tüm dosyaların listesini çıkartalım {{{ 

" Enter tuşuna basınca o dosyaya gider miyim?
function! Goto2() 
	GotoWikilink
	" normal! <CR>
	execute "normal! \<cr>"
endfunction
command! Goto2 call Goto2()

lua << EOF
function _G.find_note2()
	local util = require "obsidian.util"
	-- local client_dir = "/Users/mertnuhoglu/prj/collabry/cldocs/cllogseq/pages"
	-- local note_file_name = "20230914-pln-Veri-Modellemesi-Egitimi.md"
	-- local client_dir = "/Users/mertnuhoglu/prj/myrepo/logseq-myrepo/pages"
	-- local note_file_name = "20231013-Karar-almanin-beni-korkutan-taraflari-var.md"
	local client_dir = "/Users/mertnuhoglu/prj/myrepo"
	-- local note_file_name = "20231013-Karar-almanin-beni-korkutan-taraflari-var.md"
	local note_file_name = "20230914-pln-Veri-Modellemesi-Egitimi.md"
	local notes = util.find_note(client_dir, note_file_name)
	print(dump(notes))
	return 0
end
EOF

function! FindNote20231015() 
	call v:lua.find_note2()
endfunction
command! FindNote20231015 call FindNote20231015()
" Tam istediğim gibi çalışmıyor.
" Sadece tek bir klasörün altındaki dosyaları buluyor.
" symlink takip etmiyor
" Birden çok klasörle çalışmıyor.
"
": }}}


function! DebugRegex20231231() 
	let line03 = "#stnd title"
	let line04 = substitute(line03, '#\(\w\|[\/]\)\+:\?', '`\1`\0', 'g')
	echo line04
	"> `d`#stnd title
	let line04 = substitute(line03, '#\(.*\):\?', '`\1`\0', 'g')
	echo line04
	"> `stnd title`#stnd title
	let line04 = substitute(line03, '#\([^: ]\+\):\?', '`\1`\0', 'g')
	echo line04
	"> `stnd title`#stnd title
	let line03 = "#stnd: title"
	let line04 = substitute(line03, '#\([^: ]\+\):\?', '`\1`\0', 'g')
	echo line04
	"> `stnd`#stnd: title
	let line03 = "#stnd #f/qry: title"
	let line04 = substitute(line03, '#\([^: ]\+\)[: ]', '`\1`\0', 'g')
	echo line04
	"> `stnd`#stnd `f/qry`#f/qry: title
	let line04 = substitute(line03, '#\([^: ]\+\)[: ]', '`\1`', 'g')
	"> `stnd``f/qry` title
	let line04a = substitute(line03, '#\([^: ]\+\)[: ]', '`\1`', 'g')
	let line04 = substitute(line04a, '\(\w\)``\(\w\)', '\1 \2', 'g')
	"> `stnd f/qry` title
endfunction
command! DebugRegex20231231 call DebugRegex20231231()

": }}}
"
function! Tab3GotoDef() 
	" new tab and GotoDef
	" mnemonics: & -> 8 -> 3
	tab split
	GotoDef
endfunction
command! Tab3GotoDef call Tab3GotoDef()

function! SourceVimWk()  " SPC dvsw
	" id:: b0510cb3-90a6-4772-9ddb-cdf1e7f57ee6
	source /Users/mertnuhoglu/prj/private_dotfiles/vim/my-vim-custom2/plugin/my-vim-custom2.vim
	source /Users/mertnuhoglu/prj/private_dotfiles/.config/lazyvim/lua/user/mert-lua.lua
	" source /Users/mertnuhoglu/prj/private_dotfiles/.config/lazyvim/lua/config/which-key.lua
	lua require('user.mert-lua').reload_which_key()
endfunction
command! SourceVimWk call SourceVimWk()

function! UpdateWk8Source()  " SPC dvsu
  " id:: 715fa587-9ac7-4acf-96dd-e0baca12e23d
	lua require('user.mert-lua').packagePathAdg()
	source /Users/mertnuhoglu/prj/myrepo/logseq-myrepo/exmp/20250319-update-wk-tags/20250508-dfl-root-to-stnd.lua
	source /Users/mertnuhoglu/prj/myrepo/logseq-myrepo/exmp/20250319-update-wk-tags/20250509-dfl-wk-update.lua
	SourceVimWk
endfunction
command! UpdateWk8Source call UpdateWk8Source()

