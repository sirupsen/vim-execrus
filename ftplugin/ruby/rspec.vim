" NAME: Rspec test
" LANE: default
" If the current file is a spec, then run it with rspec.
function! g:RunRubySpec()
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec " . a:file

      exec cmd
    endif
  else
    let cmd = g:RubyStartingCommand()
    let cmd .= "rspec %"

    exec cmd
  endif
endfunction

call g:AddExecrusPlugin({
  \'name': 'Rspec test',
  \'exec': function("g:RunRubySpec"),
  \'cond': '_spec.rb$',
  \'prev': 'Ruby test'
\})

" NAME: Associated spec
" LANE: default
" Same as "Associated test" but instead of looking for a Test::Unit-like test,
" it will look for specs.
function! g:RubyRunSingleSpec(file)
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec " . a:file

      exec cmd
    endif
  else
    let cmd = g:RubyStartingCommand()
    let cmd .= "rspec " . a:file

    exec cmd
  endif
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
  \'cond': function("g:RubyRSpecTestName"),
  \'prev': 'Associated test'
\})

" NAME: Associated unit spec
" LANE: default
" Same as "Associated test", but looks in the test/unit directory instead.
function! g:RubyTestUnitRailsTestNameSpec()
  return g:RubyTestName("spec/unit", "spec")
endfunction

function! g:RubyExecuteTestUnitRailsSpec()
  let test_name = g:RubyTestUnitRailsTestNameSpec()
  call g:RubyRunSingleSpec(test_name)
endfunction

call g:AddExecrusPlugin({
  \'name': 'Associated unit spec',
  \'exec': function("g:RubyExecuteTestUnitRailsSpec"),
  \'cond': function("g:RubyTestUnitRailsTestNameSpec"),
  \'prev': 'Associated unit test'
\})

" NAME: Spec line
" LANE: alternative
" Runs the spec associated with the current line.
function! g:RubyRspecLineExecute()
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec %:" . line('.')

      exec cmd
    endif
  else
    let cmd = g:RubyStartingCommand()
    let cmd .= "rspec %:" . line('.')

    exec cmd
  endif
endfunction

call g:AddExecrusPlugin({
  \'name': 'Spec line',
  \'exec': function("g:RubyRspecLineExecute"),
  \'cond': '_spec.rb$',
  \'prev': 'Test line'
\}, 'alternative')
