let b:execrus_plugins = []

let b:execrus_plugins += [{'name': 'Default Ruby', 'exec': '!ruby %', 'priority': 1}]

function! g:RubyTestExecute()
  let cmd = "!"

  if filereadable("./Gemfile")
    let cmd .= "bundle exec "
  endif

  let cmd .= "ruby -Itest %"

  exec cmd
endfunction

let b:execrus_plugins += [{'name': 'Ruby Test', 'exec': function('g:RubyTestExecute'), 'condition': '_test.rb$', 'priority': 2}]

let b:execrus_plugins += [{'name': 'Ruby Gemfile', 'exec': '!bundle install --gemfile=%', 'condition': 'Gemfile', 'priority': 3}]
