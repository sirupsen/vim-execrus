# Execrus.vim

Execrus is like clippy for Vim, only he's useful, a walrus and can execute things for you.
Execrus works by having a hierachy of commands to run under different circumstances.
For instance if you're in a Ruby file and hit ctrl-E, he might run the file, or
if it's a test file he'll run the test, if it's a Gemfile he'll run bundle
install. Or if you're in a C++ file, pushing ctrl-E might compile and run the
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

## Usage

To customize Execrus, you create and modify the file type you're interested in
adding Execrus functionality to, directly in the plugin source.

For instance, a Ruby plugin should be in `ftplugin/ruby.vim` and
might look something like this:

```vim
let b:execrus_plugins = []

let b:execrus_plugins += [{
  \'name': 'Default Ruby', 
  \'exec': '!ruby %', 
  \'priority': 1
\}]
```

It will just execute `ruby {filename}`.

Note that the priority for "Default Ruby" is 1. This means it has the lowest
execution priotity. If we were to create another Ruby plugin to execute
Gemfiles, we'd add the following to `ftplugin/ruby.vim`:

```vim
let b:execrus_plugins += [{
  \'name': 'Ruby Gemfile', 
  \'exec': '!bundle install --gemfile=%', 
  \'condition': 'Gemfile', 
  \'priority': 2
\}]
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

let b:execrus_plugins += [{
  \'name': 'Ruby Test',
  \'exec': function('g:RubyTestExecute'), 
  \'condition': '_test.rb$', 
  \'priority': 2
\}]
```
