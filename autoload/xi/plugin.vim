""" Helpers

function! s:StoreCurPos()
  if g:xi_preserve_curpos == 1
    if exists("*getcurpos")
      let s:cur = getcurpos()
    else
      let s:cur = getpos('.')
    endif
  endif
endfunction

function! s:RestoreCurPos()
  if g:xi_preserve_curpos == 1
    call setpos('.', s:cur)
  endif
endfunction

function! s:FlashVisualSelection(msg)
  " Redraw to show current visual selection, and sleep
  redraw
  execute "sleep " . g:xi_flash_duration . " m"
  " Then leave visual mode
  silent execute "normal! vv"
endfunction

" Guess correct number of spaces to indent
" (tabs are not allowed)
function! s:GetIndentString()
  return repeat(" ", 4)
endfunction

" Teplace tabs by spaces
function! s:TabToSpaces(text)
  return substitute(a:text, "	", s:GetIndentString(), "g")
endfunction

" Check if line is commented out
function! s:IsComment(line)
  return (match(a:line, "^[ \t]*#.*") >= 0)
endfunction

" Remove commented out lines
function! s:RemoveLineComments(lines)
  let l:i = 0
  let l:len = len(a:lines)
  let l:ret = []
  while l:i < l:len
    if !s:IsComment(a:lines[l:i])
      call add(l:ret, a:lines[l:i])
    endif
    let l:i += 1
  endwhile
  return l:ret
endfunction

" Change string into array of lines
function! s:Lines(text)
  return split(a:text, "\n")
endfunction

" Change lines back into text
function! s:Unlines(lines)
  return join(a:lines, "\n") . "\n"
endfunction

function! s:EscapeText(text)
  let l:lines = s:Lines(s:TabToSpaces(a:text))
  let l:lines = s:RemoveLineComments(l:lines)
  let l:result  = s:Unlines(l:lines)
  echom l:result

  " return an array, regardless
  if type(l:result) == type("")
    return [l:result]
  else
    return l:result
  end
endfunction

function! s:Truncate(string, num)
  let letters = split(a:string, '\zs')
  return join(letters[:a:num], "")
endfunction

""" Main Functions

let g:xi_out_buffer = []

function! xi#plugin#OutHandler(_job_id, data, event) dict
  " Do nothing
  "echom join(a:data, "\n")
endfunction

function! xi#plugin#ErrHandler(_job_id, data, event)
  echohl ErrorMsg
  echom join(a:data, "\n")
  echohl None
endfunction

function! xi#plugin#Start()
  if exists("g:xi_job") && g:xi_job > 0
    echo 'Xi already started.'
  else
    let g:xi_job = xi#job#start([g:xi_repl], {
      \'on_stdout': function('xi#plugin#OutHandler'),
      \'on_stderr': function('xi#plugin#ErrHandler'),
    \})
    if g:xi_job == -2
      echoerr "No support for async jobs. Cannot start Xi :("
    elseif g:xi_job > 0
      echom 'Xi started'
    else
      echom 'Xi failed to start'
      unlet g:xi_job
    endif
  endif
endfunction

function! xi#plugin#Stop()
  if exists("g:xi_job")
    call xi#job#stop(g:xi_job)
    unlet g:xi_job
    echom "Xi stopped"
  else
    echo "Xi is not running"
  endif
endfunction

function! xi#plugin#Eval(message)
  if !exists("g:xi_job")
    call xi#plugin#Start()
  endif

  let trunc_msg = s:Truncate(a:message, 20)
  echo trunc_msg

  let l:lines = s:EscapeText(a:message)
  for line in l:lines
    call xi#job#send(g:xi_job, line . "\n")
  endfor
endfunction

function! xi#plugin#EvalSimple(message)
  if !exists("g:xi_job")
    call xi#plugin#Start()
  endif

  echom a:message
  call xi#job#send(g:xi_job, a:message . "\n")
endfunction

function! xi#plugin#EvalParagraph()
  call s:StoreCurPos()

  silent execute "normal! vipy<cr>"
  let l:content = getreg('')
  call xi#plugin#Eval(l:content)

  silent execute "normal! '[V']"
  call s:FlashVisualSelection(l:content)
  call s:RestoreCurPos()
endfunction

function! xi#plugin#EvalSelection() range
  silent execute a:firstline . ',' . a:lastline . 'yank'
  let l:content = getreg('')
  call xi#plugin#Eval(l:content)
endfunction

function! xi#plugin#Hush()
  if exists("g:xi_job")
    call xi#plugin#EvalSimple("hush")
  else
    echo "Xi is not running"
  endif
endfunction
