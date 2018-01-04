""" Global variables

if !exists("g:xi_repl")
  let g:xi_repl = get(g:, 'xi_repl', '/usr/bin/xi')
endif

if !exists("g:xi_preserve_curpos")
  let g:xi_preserve_curpos = 1
endif

if !exists("g:xi_flash_duration")
  let g:xi_flash_duration = 150
end

""" Bindings

if !exists("g:xi_no_mappings") || !g:xi_no_mappings
  nnoremap <buffer> <localleader>b :call xi#plugin#Start()<cr>
  nnoremap <buffer> <localleader>q :call xi#plugin#Stop()<cr>

  nnoremap <buffer> <localleader>ee :call xi#plugin#EvalParagraph()<cr>
  nnoremap <buffer> <c-e> :call xi#plugin#EvalParagraph()<cr>
  inoremap <buffer> <c-e> <esc>:call xi#plugin#EvalParagraph()<cr><right>i
  xnoremap <buffer> <localleader>e :call xi#plugin#EvalSelection()<cr>
  xnoremap <buffer> <c-e> :call xi#plugin#EvalSelection()<cr>

  nnoremap <buffer> <localleader>h :call xi#plugin#Hush()<cr>
  nnoremap <buffer> <c-h> :call xi#plugin#Hush()<cr>
  inoremap <buffer> <c-h> <esc>:call xi#plugin#Hush()<cr><right>i

  let i = 1
  while i <= 9
    execute 'nnoremap <buffer> <localleader>'.i.'  :call xi#plugin#Silence('.i.')<cr>'
    execute 'nnoremap <buffer> <c-'.i.'>  :call xi#plugin#Silence('.i.')<cr>'
    execute 'nnoremap <buffer> <localleader>e'.i.' :call xi#plugin#Play('.i.')<cr>'
    let i += 1
  endwhile
endif
