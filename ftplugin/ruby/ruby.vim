" LANE: DEFAULT
"
" Sorted by priority (lowest priority first)
"
"   * Default Ruby
"   * Run Test::Unit test file
"   * Run RSpec test file
"   * Run associated Test::Unit test
"   * Run associated RSpec test
"   * Run associated Test::Unit unit test
"   * Run associated Rspec unit test
"
" See each plugin for an in-depth description of each plugin.
"

" Generic functions for use in the plugins.

" NAME: Default Ruby
" This plugin runs the current file with Ruby.
call g:AddExecrusPlugin({
      \'name': 'Default Ruby',
      \'exec': '!ruby %',
      \'priority': 1
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
