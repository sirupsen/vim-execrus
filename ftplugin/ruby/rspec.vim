" NAME: Rspec test
" LANE: default
" If the current file is a spec, then run it with rspec.
function! SpringRubyCommand()
  if empty(system("which spring"))
    return 0
  endif

  let cmd = "!spring rspec "

  return cmd
endfunction

function! g:RunRubySpec()
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec %"

  if filereadable("config/application.rb") && !empty(SpringRubyCommand())
    let cmd = SpringRubyCommand() . '%'
  endif

  exec cmd
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
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec " . a:file

  if filereadable("config/application.rb") && !empty(SpringRubyCommand())
    let cmd = SpringRubyCommand() . '%'
  endif

  exec cmd
endfunction

function! g:RubyRSpecTestName()
  if !isdirectory('./spec')
    return 0
  end

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

" NAME: Spec line
" LANE: alternative
" Runs the spec associated with the current line.
function! g:RubyRspecLineExecute()
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec %:" . line('.')

  if filereadable("config/application.rb") && !empty(SpringRubyCommand())
    let cmd = SpringRubyCommand() . '%:' . line('.')
  endif

  exec cmd
endfunction

call g:AddExecrusPlugin({
  \'name': 'Spec line',
  \'exec': function("g:RubyRspecLineExecute"),
  \'cond': '_spec.rb$',
  \'prev': 'Test line'
\}, 'alternative')

