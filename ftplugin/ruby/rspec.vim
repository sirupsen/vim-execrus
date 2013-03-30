" NAME: Rspec test
" LANE: default
" If the current file is a spec, then run it with rspec.
function! SpringRubyCommand()
  if !filereadable("config/application.rb") || empty(system("which spring"))
    return 0
  endif

  let cmd = "!spring rspec "

  return cmd
endfunction

function! g:RunRubySpec(path)
  let cmd = g:RubyStartingCommand()
  let cmd .= "rspec " . a:path

  if !empty(SpringRubyCommand())
    let cmd = SpringRubyCommand() . a:path
  endif

  return cmd
endfunction

function! g:RubySpec()
  exec g:RunRubySpec(expand("%"))
endfunction

call g:AddExecrusPlugin({
  \'name': 'Rspec test',
  \'exec': function("g:RubySpec"),
  \'cond': '_spec.rb$',
  \'prev': 'Ruby test'
\})

" NAME: Associated spec
" LANE: default
" Same as "Associated test" but instead of looking for a Test::Unit-like test,
" it will look for specs.
function! g:RubyRSpecTestName()
  if !isdirectory('./spec')
    return 0
  end

  return g:RubyTestName("spec", "spec")
endfunction

function! g:RubyExecuteRspec()
  let test_name = g:RubyRSpecTestName()
  exec g:RunRubySpec(test_name)
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
  let cmd = g:RunRubySpec(expand("%"))
  let cmd .= ":" . line('.')

  exec cmd
endfunction

call g:AddExecrusPlugin({
  \'name': 'Spec line',
  \'exec': function("g:RubyRspecLineExecute"),
  \'cond': '_spec.rb$',
  \'prev': 'Test line'
\}, 'alternative')

