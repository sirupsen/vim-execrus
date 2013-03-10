" NAME: Rspec test
" If the current file is a spec, then run it with rspec.

function! g:RunRubySpec()
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec %"
  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Rspec test',
      \'exec': function("g:RunRubySpec"),
      \'condition': '_spec.rb$',
      \'priority': 3
\})

" NAME: Associated spec
" Same as "Associated test" but instead of looking for a Test::Unit-like test,
" it will look for specs.
function! g:RubyRunSingleSpec(file)
  let cmd = g:RubyStartingCommand()
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
      \'name': 'Associated spec',
      \'exec': function("g:RubyExecuteRspec"),
      \'condition': function("g:RubyRSpecTestName"),
      \'priority': 5
\})

" NAME: Associated unit spec
" Same as "Associated test", but looks in the test/unit directory instead.
function! g:RubyTestUnitRailsTestNameSpec()
  return g:RubyTestName("spec/unit", "spec")
endfunction

function! g:RubyExecuteTestUnitRailsSpec()
  let test_name = g:RubyTestUnitRailsTestNameSpec()
  call g:RubyRunSingleSpec(test_name)
endfunction

call g:AddExecrusPlugin({
      \'name': 'Associated test',
      \'exec': function("g:RubyExecuteTestUnitRailsSpec"),
      \'condition': function("g:RubyTestUnitRailsTestNameSpec"),
      \'priority': 7
\})

" NAME: Spec line
" Runs the spec associated with the current line.
function! g:RubyRspecLineExecute()
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec %:" . line('.')

  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Spec line',
      \'exec': function("g:RubyRspecLineExecute"),
      \'condition': '_spec.rb$',
      \'priority': 2
\}, 'alternative')
