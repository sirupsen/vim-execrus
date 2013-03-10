# Execrus.vim

Execrus is your universal "run this!"-mapping. It's a framework for running
external commands under different conditions. You control multiple "priority
lanes" which can change their behavior depending on for instance which file
you're in, location within the file and file type. Mappings are created to
execute from a priority lane. Lanes are controled by customizing Execrus.

For instance, if you're in a Ruby file and hit C-E, Execrus could run the
current file with `ruby`. If the file has a test associated with it, it could
run that instead. If it happens to be a Gemfile, it'll run `bundle install` in
lieu of `ruby`. So here running the file with `ruby` has the lowest priority.
Running the test associated with it, has a much higher priority, or running
`bundle install` if it's a Gemfile.

Execrus supports multiple priority lanes. You could have a `documentation` lane
that you map to another key. This could be responsible for documentaiton
lookups, e.g. looking up the word under the cursor in
[Dash](https://itunes.apple.com/us/app/dash-docs-snippets/id458034879?mt=12), or
if a `ctag` exists, jump to that. Execrus is all about making smart choices
depending on context.

Besides the `default` lane there's an `alternative` lane in the default
configuration. For example, in Ruby it runs the test under the cursor.

![](https://raw.github.com/Sirupsen/vim-execrus/master/demo.gif)

## Installation

Install with vanilla Vim, Pathogen or Vundle. 

Add a mapping to your `.vimrc`:

```vim
map <C-E> :call g:Execrus()<CR>
```

Read usage and create some plugins. Send a pull request with the best ones.

If you want to bind another lane, e.g. the alternative lane, that could do
things like run the test under the cursor, do the following:

```vim
map <C-\> :call g:Execrus('alternative')<CR>
```

## Defaults

There's a sane set of detault behavior for the `default` and `alternative` lane.
See the `ftplugin/` directory for these. The behavior for Ruby would be in
`ftplugin/ruby.vim`. This is also where you customize the behavior for Execrus.
Send your best changes upstream.

Examples:
* [Ruby support documentation](https://github.com/Sirupsen/vim-execrus/tree/master/ftplugin/ruby)

## Customization

Execrus is a framework for running external commands in Vim, thus you should
learn to customize it to take full advantage of it. To customize Execrus, you
create and modify the file type in the plugin source you're interested in adding
Execrus functionality to.

For instance, a Ruby plugin could be in `ftplugin/ruby.vim` (see Structure
section below) and might look something like this:

```vim
call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
  \'name': 'Default Ruby',
  \'exec': '!ruby %'
\})
```

It will just execute `ruby {filename}`. Note that the backlashes are required
for the newlines added for readability purposes (`:help line-continuation`). If
you are unsure what the file's name should be, run `:echo &filetype` when
you're in a file of the type you want to create an Execrus plugin for. Your
plugin should be `ftplugin/{whatever that outputs}.vim`.

### Priorities

Priorities are the heart of Execrus. Since Execrus is all about executing the
right thing in the right context, it has a dependency system. It works by
specifying whatever has immediately lower priority. Sort of like a linked list.
The first entry in the chain (i.e. the plugin with the lowest priority) has no
reference to a previous item. Execrus resolves whatever it should execute by
starting from the end of this linked list, when it finds something whose
condition it satisfies, it executes it and stops.

If we were to create another Ruby plugin to execute Gemfiles, it is still a file
of the Ruby filetype. However, it has a higher priority than just executing a
Ruby file with the interpreter. Therefore, we'd add the following to
`ftplugin/ruby.vim`:

```vim
call g:AddExecrusPlugin({
  \'name': 'Ruby Gemfile',
  \'exec': '!bundle install --gemfile=%',
  \'cond': 'Gemfile',
  \'prev': "Default Ruby"
\})
```

Another new option here is `cond`. This is a condition. The current file name
must match this string, otherwise this plugin is simply ignored. You can use Vim
regex here.

The best way to learn more about customizing is to look at some of the existing
plugins in `ftplugin`, and read the rest of this README.

### Structure

All plugins are stored in `ftplugin/`, ordered by filetypes. When you open a
file in Vim, all files matching `ftplugin/<filetype>*` are loaded. Thus
subdirectories can be used to structure the project further. If a subdirectory
is created for a filetype, then `ftplugin/<filetype>.vim` will still exist and
abuse that it will be the first file being loaded. Thus it is responsible for
things like:

* Settings up the environment by calling `call g:InitializeExecrusEnvironment()`.
* Declare shared functions

The documentation for each filetype is found at `ftplugin/<filetype>/README.md`.
If the number of plugins for the filetype is small, see
`ftplugin/<filetype>.vim`.

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
  \'cond': '_test.rb$',
  \'prev': 'Ruby Gemfile'
\})
```

Note your function is required to have the global scope (`g:` prefix, see `:help
internval-variables`) since it will be called from a variety of different
scopes. Also note that `prev` here is set to Ruby Gemfile. Strictly, it doesn't
have a higher priority since the two would never be able trigger at once because
of the file match conditions, but a dependency chain is required anyway.

A condition (`cond`) function is done the same way. It should return `1` for
true and `0` for false. Because your conditions will be traversed a lot when
Execrus figures out what to execute, make sure your condition is fast.

### Priority lanes

Execrus supports an arbitary amount of lanes. When you add a plugin
with `g:AddExecrusPlugin` by default it is added to the `default` lane.
Likewise, when you call `g:Execrus` with no arguments, it defaults to execute
from the `default` lane. However, you can create and bind more lanes, e.g. say
we wanna look up whatever is under the cursor with `ri` in a Ruby file. We want
to add this to another lane, since we might have running the current file in the `default` lane.
We add it to the `walrus` lane:

```vim
call g:AddExecrusPlugin({
  \'name': 'RI lookup',
  \'exec': '!ri <cword>', 
\}, 'walrus')
```

Then we can bind the `walrus` lane, just like the default one:

```vim
map <C-\> :call g:Execrus('walrus')<CR>
```

## Authors

* Simon Hørup Eskildsen
* Teo Ljungberg
