call g:InitializeExecrusEnvironment()

" LANE: DEFAULT
"
" Sorted by priority (lowest priority first)
"
"   * Default Ruby
"   * Run Test::Unit test file
"   * Run RSpec test file
"   * Run associated Test::Unit test file
"   * Run associated RSpec test file
"
" See each plugin for an in-depth description of each plugin.
"

" Generic functions for use in the plugins.

function! s:StartingCommand()
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  return cmd
endfunction

" NAME: Default Ruby
" This plugin runs the current file with Ruby.
call g:AddExecrusPlugin({
      \'name': 'Default Ruby',
      \'exec': '!ruby %',
      \'priority': 1
\})

" NAME: Ruby Test
" If the current file is a test, then run it.

function! g:RunRubyTest()
  let cmd = s:StartingCommand()
  let cmd .= "ruby -Itest %"
  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Ruby Test',
      \'exec': function("g:RunRubyTest"),
      \'condition': '_test.rb$',
      \'priority': 2
\})

" NAME: Ruby Gemfile
" If the current file is a Gemfile, then run bundle install against
" it.
call g:AddExecrusPlugin({
      \'name': 'Ruby Gemfile',
      \'exec': '!bundle install --gemfile=%',
      \'condition': 'Gemfile',
      \'priority': 3
\})

" NAME: Rspec test
" If the current file is a spec, then run it with rspec.

function! g:RunRubySpec()
  let cmd = s:StartingCommand()
  let cmd .= "rspec %"
  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Rspec test',
      \'exec': function("g:RunRubySpec"),
      \'condition': 'spec.rb$',
      \'priority': 3
\})

" NAME: Associated test
" Will look for an associated test. It will favor a deep namespace. For
" instance, if you run this from `lib/something/input/file.rb` it will try
" `test/lib/something/input/file_test.rb` first. If that file doesn't exist,
" it'll pop from the namespace and try `test/something/input/file_test.rb` until
" it eaches `test/file_test.rb`. If that file doesn't exist, it gives up.
function! g:RubyRunSingleTest(path)
  let cmd = s:StartingCommand()
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
      \'name': 'Associated test',
      \'exec': function("g:RubyExecuteTestUnit"),
      \'condition': function("g:RubyTestUnitTestName"),
      \'priority': 4
\})

function! g:RubyRunSingleSpec(file)
  let cmd = s:StartingCommand()
  let cmd .= "rspec " . a:file

  exec cmd
endfunction

" NAME: Associated spec
" Same as "Associated test" but instead of looking for a Test::Unit-like test,
" it will look for specs.
function! g:RubyRSpecTestName()
  return g:RubyTestName("spec", "spec")
endfunction

function! g:RubyExecuteRspec()
  let test_name = g:RubyRSpecTestName()
  call g:RubyRunSingleSpec(test_name)
endfunction

call g:AddExecrusPlugin({
      \'name': 'Associated spec',
      \'exec': function("g:RubyExecuteRspec"),
      \'condition': function("g:RubyRSpecTestName"),
      \'priority': 5
\})


" LANE: ALTERNATIVE
"
" Sorted by priority (lowest priority first)
"
"   * Run spec associated with the current line
"
" See each plugin for an in-depth description of each plugin.
"

" NAME: Spec line
" Runs the spec associated with the current line.
function! RubyRspecLineExecute()
  let cmd = s:StartingCommand()
  let cmd .= "rspec %:" . line('.')

  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Spec line',
      \'exec': function("RubyRspecLineExecute"),
      \'cond': 'spec.rb$',
      \'priority': 1
\}, 'alternative')
