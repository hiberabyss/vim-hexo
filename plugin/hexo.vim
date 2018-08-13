" ============================================================================
" File:        hexo.vim
" Description: 这是一个跟hexo配合的插件
" Maintainer:  
" ============================================================================
call hexo#EnvPrecheck()

let g:hexoPostPath = g:hexoRootPath . "source/_posts/"
let g:hexoDraftPath = g:hexoRootPath . "source/_drafts/"
let g:hexoHosts = ['localhost:4000', 'hiberabyss.github.io', 'hbliu.coding.me']

fun! OpenHexoRootPath()
    execute "cd " . g:hexoRootPath
endfun

fun! OpenHexoPostPath()
    execute "cd " . g:hexoPostPath
endfun

fun! OpenHexoDraftPath()
    execute "cd " . g:hexoDraftPath
endfun

fun! OpenHexoPostPathAndNERDTree()
    call OpenHexoPostPath()
    if exists(':NERDTree')
        execute 'NERDTree'
    endif
endfun

fun! OpenHexoDraftPathAndNERDTree()
    call OpenHexoDraftPath()
    if exists(':NERDTree')
        execute 'NERDTree'
    endif
endfun

fun! OpenHexoPostFile(filename)
    call OpenHexoPostPath()
    execute "e " . a:filename . ".md"
endfun

fun! OpenHexoDraftFile(filename)
    call OpenHexoDraftPath()
    execute "e " . a:filename . ".md"
endfun

fun! NewHexoDraft(name)
    call OpenHexoRootPath()
    let filename = GenerateFileName(g:hexoPostPath, s:replaceSpaces(a:name))

    call OpenHexoDraftFile(filename)
	call HexoReadLayout("draft")
endfun

function! HexoReadLayout(layout)
	execute(printf("silent 0r !jinja2 %sscaffolds/%s.md -D date='%s'", g:hexoRootPath, a:layout, strftime("%F %T")))
endfunction

function! s:replaceSpaces(name)
	return substitute(a:name, ' ', '-', 'g')
endfunction

fun! NewHexoPost(name)
    call OpenHexoRootPath()
    let filename = GenerateFileName(g:hexoPostPath, s:replaceSpaces(a:name))

    call OpenHexoPostFile(filename)
	call HexoReadLayout("post")
endfun

fun! GenerateFileName(path, filename)
    let fileList = split(globpath(a:path, a:filename . "*.md"), "\n")

    let max = 0
    for name in fileList
        let filenames = split(fnamemodify(name, ":t:r"), "-")
        if (len(filenames) == 2)
            if (filenames[0] != a:filename)
                continue
            endif
            let index = filenames[1] + 0
            if (max < index)
                let max = index
            endif
        endif
    endfor

    return max == 0 ? a:filename : a:filename . "-" . (max + 1)
endfun

command! -nargs=0 HexoNewPostDir :call hexo#NewPostDir()
command! -nargs=? HexoBrowse :call hexo#BrowsePage('<args>')
command! HexoOpen :call OpenHexoPostPathAndNERDTree()
command! HexoOpenDraft :call OpenHexoDraftPathAndNERDTree()
command! -nargs=+ HexoNew :call NewHexoPost("<args>")
command! -nargs=+ HexoNewDraft :call NewHexoDraft("<args>")
