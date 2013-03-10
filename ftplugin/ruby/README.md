# Execrus.vim/Ruby

Execrus.vim/Ruby has two lanes by default: `default` and `alternative`. Their
behavior is described in their corresponding section, ordered by priority with
the lowest priority plugin first.

## Default

1. Default Ruby
  - Run the current file with `ruby`.
2. Run Test::Unit test
  - If the current file is a test (matching `/_test.rb/`) it will execute it as
    a test.
3. Run RSpec spec
  - If the current file is a spec (matching `/_spec.rb/`) it will execute it as
    a spec with `spec`.
4. Run associated Test::Unit test
  - If the current file has a test associated with it, it will run that test.
    For instance, if you're in `lib/foo/bar/term.rb` it will look for a test
    named `test/lib/foo/bar/term_test.rb`. If that test doesn't exist, it will
    pop the namespace queue and try `test/foo/bar/term_test.rb`. It keeps
    popping until it reaches `test/term_test.rb`. If that file doesn't exist, it
    gives up and hands it off to something of lower priority.
5. Run associated RSpec spec
  - Same as "Run associated Test::Unit test" only it searches in `spec/`
    instead.
6. Run associated Test::Unit unit test
  - Inside Rails and other environments your tests might exist in the
    `test/unit` directory. This basically does the same as "Run associated
    Test::Unit test" only its prefix directory is `test/unit` instead of `test`.
7. Run assoicated RSpec unit test
  - Just like "Run associated Test::Unit unit test", but for RSpec.

## Alternative

1. Run Test::Unit test under cursor
  - Runs the test under the cursor. If your cursor is inside a test, it will
    run only that test.
2. Run RSpec spec under cursor
  - Same as "Run Test::Unit test under cursor", but for rspec specs.
