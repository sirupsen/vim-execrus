# Execrus.vim/Ruby

Execrus.vim/Ruby has two lanes by default: `default` and `alternative`. Their
behavior is described in their corresponding section, ordered by priority with
the lowest priority plugin first.

## Default

1. Default Ruby
  - Run the current file with `ruby`.
2. Bundler
  - Run the current file with `bundle install` if it is a Gemfile.
3. Run Test::Unit test
  - If the current file is a test (matching `/_test.rb/`) it will execute it as
    a test. If in a Rails environment and Spring is installed, it will run with
    Spring.
3. Run RSpec spec
  - If the current file is a spec (matching `/_spec.rb/`) it will execute it as
    a spec. If in a Rails environment and Spring is installed, it will run with
    Spring.
5. Run associated Test::Unit test
  - If the current file has a test associated with it, it will run that test.
    For instance, if you're in `lib/foo/bar/term.rb` it will look for a test
    named `test/lib/foo/bar/term_test.rb`. If that test doesn't exist, it will
    pop the namespace queue and try `test/foo/bar/term_test.rb`. It keeps
    popping until it reaches `test/term_test.rb`. If that file doesn't exist, it
    will try things like `test/unit/<namespaces>` and
    `test/functional/<namespaces>`. Though, at some point it will give up and
    hand it off to the next link in the chain.
6. Run associated RSpec spec
  - Same as "Run associated Test::Unit test" only it searches in `spec/`
    instead.

## Alternative

1. Run Test::Unit test under cursor
  - Runs the test under the cursor. If your cursor is inside a test, it will
    run only that test.
2. Run RSpec spec under cursor
  - Same as "Run Test::Unit test under cursor", but for rspec specs.
