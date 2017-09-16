" ============================================================================
" File:        hexo.vim
" Description: 这是一个跟hexo配合的插件
" Maintainer:  
" ============================================================================
if ( !exists('g:hexoRootPath') )
    echom "plugin vim-hexo error! please add g:hexoRootPath in .vimrc~~"
    fini
endif

"let g:hexoRootPath="/home/lizy/hexo/"
let g:hexoPostPath = g:hexoRootPath . "source/_posts/"
let g:hexoDraftPath = g:hexoRootPath . "source/_drafts/"

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
    if(!executable('hexo'))
        echom 'no hexo found!'
        return
    endif

    call OpenHexoRootPath()
    let filename = GenerateFileName(g:hexoDraftPath, a:name)

    execute "!hexo new draft " . filename 

    call OpenHexoDraftFile(filename)
endfun

function! HexoReadLayout(layout)
	execute(printf("silent 0r !jinja2 %sscaffolds/%s.md -D date='%s'", g:hexoRootPath, a:layout, strftime("%F %T")))
endfunction

function! s:replaceSpaces(name)
	return substitute(a:name, ' ', '-', 'g')
endfunction

fun! NewHexoPost(name)
    if(!executable('hexo'))
        echom 'no hexo found!'
        return
    endif

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

fun! HexoPublish(...)
    if(executable('hexo'))
        call OpenHexoRootPath()
        if (a:0 == 1)
            execute "!hexo publish " . a:1 
        elseif (a:0 == 2)
            execute "!hexo publish " . a:1 . a:2 
        else
            echom "Arguments Error!  HexoPublish [layout] <title>"
        endif
    elseif
        echom 'no hexo found!'
    endif
endfun

fun! HexoC()
    if(executable('hexo'))
        call OpenHexoRootPath()
        execute "!hexo clean"
    elseif
        echom 'no hexo found!'
    endif
endfun

fun! HexoG()
    if(executable('hexo'))
        call OpenHexoRootPath()
        execute "!hexo clean"
        execute "!hexo g"
    elseif
        echom 'no hexo found!'
    endif
endfun

fun! HexoD()
    if(executable('hexo'))
        call OpenHexoRootPath()
        execute "!hexo clean"
        execute "!hexo g"
        execute "!hexo d"
    elseif
        echom 'no hexo found!'
    endif
endfun

command! HexoOpen :call OpenHexoPostPathAndNERDTree()
command! HexoOpenDraft :call OpenHexoDraftPathAndNERDTree()
command! -nargs=+ HexoNew :call NewHexoPost("<args>")
command! -nargs=+ HexoNewDraft :call NewHexoDraft("<args>")
command! -nargs=+ HexoPublish :call HexoPublish("<args>")
command! HexoC :call HexoC()
command! HexoG :call HexoG()
command! HexoD :call HexoD()
