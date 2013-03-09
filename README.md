# Execrus.vim

Execrus is like clippy for Vim, only he's useful, a walrus and can execute things for you.
Execrus is a framework for running external commands to run under different circumstances.

For instance if you're in a Ruby file and hit C-E, Execrus might run the file, or
if it's a test file it might run the test, if it's a Gemfile it could run bundle
install. Or if you're in a C++ file, pushing C-E might compile and run the
file, or run make. The functionality of execrus is easily customizable, but it
comes with some semi-sane defaults.

![](https://raw.github.com/Sirupsen/vim-execrus/master/demo.gif)

## Installation

Install with vanilla Vim, Pathogen or Vundle. 

Add a mapping to your `.vimrc`:

```vim
map <C-E> :call g:Execrus()<CR>
```

Read usage and create some plugins. Send a pull request with the best ones.

## Defaults

These are the defaults in different environments. See the next section on how to
customize the default behavior.

* Ruby
  - Run script 
  - bundle install for Gemfiles
  - Run Test::Unit-like tests
* C++
  - Compile and run

## Customization

To customize Execrus, you create and modify the file type you're interested in
adding Execrus functionality to, directly in the plugin source.

For instance, a Ruby plugin should be in `ftplugin/ruby.vim` and
might look something like this:

```vim
call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
  \'name': 'Default Ruby', 
  \'exec': '!ruby %', 
  \'priority': 1
\})
```

It will just execute `ruby {filename}`. Note that the backlashes are required
for the newlines added for readability purposes (`:help line-continuation`). If
  you are unsure what the file's name should be, run `:echo &filetype` when
  you're in a file of the type you want to create an Execrus plugin for. Your
  plugin should be `ftplugin/{whatever that outputs}.vim`.
  

Note that the priority for "Default Ruby" is 1. This means it has the lowest
execution priotity. If we were to create another Ruby plugin to execute
Gemfiles, we'd add the following to `ftplugin/ruby.vim`:

```vim
call g:AddExecrusPlugin({
  \'name': 'Ruby Gemfile', 
  \'exec': '!bundle install --gemfile=%', 
  \'condition': 'Gemfile', 
  \'priority': 2
\})
```

The new option here is `condition`. The current file name must match this
string, otherwise this plugin is simply ignored.

Since a Gemfile also has the `ruby` filetype there would normally be a conflict.
Conflicts are resolved by the priority system. In this case, `Ruby Gemfile` has
a higher priority (2 > 1), and thus it is run instead.

### Functions

Execrus shall not limit you. Therefore the execution command (`exec`) and
condition (`condition`) can be functions. If we're in a file that ends with
`_test.rb`, we want to execute the current test. If we find a `Gemfile`, we want
to prepend `bundle exec` to the command. This is easily resolved by writing a
function:

```vim
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
  \'condition': '_test.rb$', 
  \'priority': 2
\})
```

Note your function is required to have the global scope (`g:` prefix, see `:help
internval-variables`) since it will be called from a variety of different
scopes.

### Execution lanes

Execrus supports an arbitary amount of `execution lanes`. When you add a plugin
with `g:AddExecrusPlugin` by default it is added to the `default` lane.
Likewise, when you call `g:Execrus` with no arguments, it defaults to execute
from the `default` lane. However, you can create and bind more lanes, e.g. say
we wanna look up whatever is under the cursor with `ri` in a Ruby file. We want
to add this to another lane, since we might have running the current file in the `default` lane.
We add it to the `walrus` lane:

```vim
call g:AddExecrusPlugin({
  \'name': 'Ruby Lookup',
  \'exec': '!ri <cword>', 
  \'priority': 1
\}, 'walrus')
```

Then we can bind the `walrus` lane, just like the default one:

```vim
map <C-\> :call g:Execrus('walrus')<CR>
```
