" NAME: Default Ruby
" LANE: default
" This plugin runs the current file with Ruby.
call g:AddExecrusPlugin({
      \'name': 'Default Ruby',
      \'exec': '!ruby %',
      \'priority': 1
\})

" NAME: Ruby Gemfile
" LANE: default
" If the current file is a Gemfile, then run bundle install against
" it.
call g:AddExecrusPlugin({
      \'name': 'Ruby Gemfile',
      \'exec': '!bundle install --gemfile=%',
      \'condition': 'Gemfile',
      \'priority': 3
\})
