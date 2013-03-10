" NAME: Ruby Test
" LANE: default
" If the current file is a test, then run it.
function! g:RunRubyTest()
  let cmd = g:RubyStartingCommand()
  let cmd .= "ruby -Itest %"
  exec cmd
endfunction

call g:AddExecrusPlugin({
  \'name': 'Ruby Test',
  \'exec': function("g:RunRubyTest"),
  \'condition': '_test.rb$',
  \'prev': "Ruby Gemfile"
\})

" NAME: Associated test
" LANE: default
" Will look for an associated test. It will favor a deep namespace. For
" instance, if you run this from `lib/something/input/file.rb` it will try
" `test/lib/something/input/file_test.rb` first. If that file doesn't exist,
" it'll pop from the namespace and try `test/something/input/file_test.rb` until
" it eaches `test/file_test.rb`. If that file doesn't exist, it gives up.
function! g:RubyRunSingleTest(path)
  let cmd = g:RubyStartingCommand()
  let cmd .= "ruby -Itest " . a:path

  execute cmd
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
  \'cond': function("g:RubyTestUnitTestName"),
  \'prev': 'Rspec test'
\})

" NAME: Associated unit test
" LANE: default
" Same as "Associated test", but looks in the test/unit directory instead.
function! g:RubyTestUnitRailsTestName()
  return g:RubyTestName("test/unit", "test")
endfunction

function! g:RubyExecuteTestUnitRails()
  let test_name = g:RubyTestUnitRailsTestName()
  call g:RubyRunSingleTest(test_name)
endfunction

call g:AddExecrusPlugin({
  \'name': 'Associated unit test',
  \'exec': function("g:RubyExecuteTestUnitRails"),
  \'cond': function("g:RubyTestUnitRailsTestName"),
  \'prev': 'Associated spec'
\})

" NAME: Test line
" LANE: alternative
" Run the Test::Unit test that is associated with the current line, e.g. for the
" test (where | is the cursor):
"
" def test_something
"   assert_equal 4, 2 + 2|
" end
"
" It will run the "test_something" test. It also supports the syntax offered by
" newer versions of Test::Unit:
"
" test 'something else' do
"   |assert_equal 9, 6 + 3
" end
"
" It will run this test.
"
" It works by just searching upwards. The first one it finds, it executes.
"
function! g:GetTestName()
  let vanilla = line('.')
  let test_name = ""

  while vanilla > 0 && match(getline(vanilla), 'test_') == -1
    let vanilla -= 1
  endwhile

  let dsl = line('.')

  while dsl > 0 && match(getline(dsl), 'test.*do') == -1
    let dsl -= 1
  endwhile

  if dsl == 0 && vanilla == 0
    return 0
  endif

  if vanilla > dsl
    let test_name = substitute(getline(vanilla), '.*def ', "", "")
  else
    let test_name = substitute(substitute(getline(dsl), "test ['\"]", "", ""), "['\"] do", "", "")
    let test_name = substitute(test_name, '^\s*\(.\{-}\)\s*$', '\1', '')
    let test_name = substitute(test_name, ' ', '\\ ', 'g')
  end

  return test_name
endfunction

function! g:RubyTestLineExecute()
  let cmd = g:RubyStartingCommand()
  let cmd .= "ruby -Itest -Ilib % -n /" . g:GetTestName()  . '/'

  exec cmd
endfunction

call g:AddExecrusPlugin({
  \'name': 'Test line',
  \'exec': function("g:RubyTestLineExecute"),
  \'cond': '_test.rb$'
\}, 'alternative')
