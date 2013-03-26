function! g:RubyStartingCommand()
  let cmd = "!clear && "

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  return cmd
endfunction

function! g:RubyTestName(prefix, suffix)
  let path_tokens = split(expand("%d"), '/')
  let test_file = ""

  while !filereadable(l:test_file) && len(path_tokens) > 0
    call remove(path_tokens, 0)
    let namespace = substitute(join(path_tokens[0:], '/'), '.rb', '', '')
    let test_file = a:prefix . "/" . namespace . "_" . a:suffix . ".rb"
  endwhile

  if len(path_tokens) > 0
    return test_file
  endif
endfunction
