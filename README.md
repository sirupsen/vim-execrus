# Execrus.vim

Execrus is like clippy for Vim, only he's useful and can execute things for you.
For instance if you're in a Ruby file and hit ctrl-E, he might run the file, or
if it's a test file he'll run the test, if it's a Gemfile he'll run bundle
install. The functionality of execrus is easily customizable.

Execrus works by having a hierachy of commands to run under
different circumstances.

## Usage

For instance, a Ruby plugin should be in `ftplugin/ruby.vim` and
might look something like this:

```vim
let b:execrus_plugins += [{'name': 'Default Ruby', 'exec': '!ruby %', 'priority': 1}]
```

Basically it will execute `ruby {filename}`. The priority here is 1, which means
it has the lowest priority. If we were to create another Ruby plugin to execute
Gemfiles, we'd add the following to `ftplugin/ruby.vim`:

```vim
let b:execrus_plugins += [{'name': 'Ruby Gemfile', 'exec': '!bundle install --gemfile=%', 'condition': 'Gemfile', 'priority': 2}]
```

The new option here is `condition`. The current file name must match this
string, otherwise it is simply ignored for this plugin.

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

let b:execrus_plugins += [{'name': 'Ruby Test', 'exec': function('g:RubyTestExecute'), 'condition': '_test.rb$', 'priority': 2}]
```
