call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
      \'name': 'Default Ruby',
      \'exec': '!ruby %',
      \'priority': 1
\})

call g:AddExecrusPlugin({
      \'name': 'Ruby Test',
      \'exec': 'bundle exec ruby -Itest %',
      \'condition': '_test.rb$', 'priority': 2
\})

call g:AddExecrusPlugin({
      \'name': 'Ruby Gemfile',
      \'exec': '!bundle install --gemfile=%',
      \'condition': 'Gemfile',
      \'priority': 3
\})

call g:AddExecrusPlugin({
      \'name': 'Ruby Lookup',
      \'exec': '!ri <cword>',
      \'priority': 1
\}, 'walrus')

function! RubyRspecLineExecute()
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "rspec %:" . line('.')

  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Rspec test',
      \'exec': "!bundle exec rspec %",
      \'cond': 'spec.rb$',
      \'priority': 3
\})

call g:AddExecrusPlugin({
      \'name': 'Rspec test line',
      \'exec': function("RubyRspecLineExecute"),
      \'cond': 'spec.rb$',
      \'priority': 2
\}, 'walrus')

function! g:RubyRunSingleTest(path)
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "ruby -Itest " . a:path

  execute cmd
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

function! g:RubyTestUnitTestName()
  return g:RubyTestName("test", "test")
endfunction

function! g:RubyExecuteTestUnit()
  let test_name = g:RubyTestUnitTestName()
  call g:RubyRunSingleTest(test_name)
endfunction

call g:AddExecrusPlugin({
      \'name': 'Run associated unit test',
      \'exec': function("g:RubyExecuteTestUnit"),
      \'condition': function("g:RubyTestUnitTestName"),
      \'priority': 4
\})

function! g:RubyRunSingleSpec(file)
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "rspec " . a:file

  exec cmd
endfunction

function! g:RubyRSpecTestName()
  return g:RubyTestName("spec", "spec")
endfunction

function! g:RubyExecuteRspec()
  let test_name = g:RubyRSpecTestName()
  call g:RubyRunSingleSpec(test_name)
endfunction

call g:AddExecrusPlugin({
      \'name': 'Run associated spec',
      \'exec': function("g:RubyExecuteRspec"),
      \'condition': function("g:RubyRSpecTestName"),
      \'priority': 5
\})
