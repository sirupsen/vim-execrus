call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
      \'name': 'Default Ruby',
      \'exec': '!ruby %',
      \'priority': 1
\})

function! g:RubyTestExecute()
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "ruby -Itest %"

  exec cmd
endfunction

call g:AddExecrusPlugin({
      \'name': 'Ruby Test',
      \'exec': function('g:RubyTestExecute'),
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

function! RubyRspecExecute()
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "rspec %"

  exec cmd
endfunction

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
      \'exec': function("RubyRspecExecute"),
      \'cond': 'spec.rb$',
      \'priority': 3
\})

call g:AddExecrusPlugin({
      \'name': 'Rspec test line',
      \'exec': function("RubyRspecLineExecute"),
      \'cond': 'spec.rb$',
      \'priority': 2
\}, 'walrus')
