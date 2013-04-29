u Execrus.vim/Javascript

Execrus.vim/Javascript has two lanes by default: `default` and `repl`. Their
behavior is described in their corresponding section, ordered by priority with
the lowest priority plugin first.

## Default

1. Default Node
  - Run the current file with `node`.
2. PublicIndex
  - Opens index.html in a public dir under project root in the default browser, if it exists.
3. RootIndex
  - Opens index.html in the project root in the default browser, if it exists.
3. Npm
  - Runs `npm test` if a package.json file exists in the project root.
5. Grunt
  - Runs `grunt` on the project, if a Gruntfile.js file exists in the project root.
    This requires [grunt](http://gruntjs.com) to be installed.

## Repl

1. Node REPL
  - Runs node without parameters, effectively opening a node repl
