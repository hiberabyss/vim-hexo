function! hexo#EnvPrecheck()
    if(! executable('hexo'))
        " echom 'no hexo found!'
        return 1
    endif

    if ( !exists('g:hexoRootPath') )
        let g:hexoRootPath = expand("$HOME/Documents/Blog")
    endif
endfunction

function! hexo#NewPostDir()
    let dir_path = g:hexoPostPath . expand('%:t:r')
    call mkdir(dir_path, "p")
    let @* = dir_path
endfunction

function! hexo#GetPageUrl()
    let lineNum = search('\v^date: \d{4}-\d{2}-\d{2}')
    let day = split(getline(lineNum))[1]

    let YyMmDd = split(day, '-')
    if len(YyMmDd) < 3
        echoerr "[hexo] Fail to extract date from current buffer!"
        return ""
    endif

    let postname = expand('%:t:r')

    let url = printf("%s/%s", join(YyMmDd, '/'), postname)
    return url
endfunction

function! hexo#BrowsePage(...)
    if !exists('g:hexoHosts')
        return
    endif

    let browse_cmd = ""

    for cmd in ["open", "xdg-open"]
        if executable(cmd)
            let browse_cmd = cmd
        endif
    endfor

    if empty(browse_cmd) | return | endif

    let host_cnt = len(g:hexoHosts)
    let host_idx = 0

    if a:0 > 0
        let host_idx = a:1 % host_cnt
    endif

    " echo printf("%s http://%s/%s", browse_cmd, g:hexoHosts[host_idx], hexo#GetPageUrl())
    silent call system(printf("%s http://%s/%s/", browse_cmd, g:hexoHosts[host_idx], hexo#GetPageUrl()))
endfunction
