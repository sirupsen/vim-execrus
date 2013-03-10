
" NAME: Spring rspec
" LANE: Default
" If the current file is a spec, then run it with spring rspec.
function! RubySpringRspecExecute()
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec %"

      exec cmd
    endif
  endif
endfunction

" NAME: Spring rspec
" LANE: Alternate
" If the current file is a spec, then run it with spring rspec.
function! RubySpringRspecLineExecute()
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec %:" . line('.')

      exec cmd
    endif
  endif
endfunction

" NAME: Associated spring rspec spec
" LANE: Default
" Same as "Associated test" but instead of looking for a Test::Unit-like test,
" it will look for specs.
function! g:RubyRunSingleSpringRspecSpec(file)
  if filereadabe("./config/application.rb")
    let output = system("which spring")

    if !empty(output)
      let cmd = "!"
      let cmd .= "spring rspec " . a:file

      exec cmd
    endif
  endif
endfunction

function! g:RubyExecuteSpringRspec()
  let test_name = g:RubyRSpecTestName()
  call g:RubyRunSingleSpringRspecSpec(test_name)
endfunction

call g:AddExecrusPlugin({
  \'name': 'Associated spec',
  \'exec': function("g:RubyExecuteSpringRspec"),
  \'condition': function("g:RubyRSpecTestName"),
  \'priority': 8
\})

call g:AddExecrusPlugin({
  \'name': 'Spring Rspec test',
  \'exec': function("RubySpringRspecExecute"),
  \'cond': 'spec.rb$',
  \'priority': 10
\})

call g:AddExecrusPlugin({
  \'name': 'Spring Rspec test line',
  \'exec': function("RubySpringRspecLineExecute"),
  \'cond': 'spec.rb$',
  \'priority': 3
\}, 'alternative')
