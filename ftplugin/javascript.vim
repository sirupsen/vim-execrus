" Name: Default node
" Lane: default
" Default execution of javascript file. Runs the file with node.
call g:AddExecrusPlugin({
  \'name': 'Default Node',
  \'exec': '!node %',
\})

" Name: Node REPL
" Lane: repl
" Runs node repl
call g:AddExecrusPlugin({
  \'name': 'Node REPL',
  \'exec': '!node',
\}, 'repl')

" Check if index.html is present in the public dir
function! g:ExecutePublicIndexCondition()
  return filereadable("public/index.html")
endfunction

" Name: PublicIndex
" Lane: default
" Runs if a index.html file is present in the public dir in the root of the
" project. Opens public/index.html in a browser.
call g:AddExecrusPlugin({
  \'name': 'PublicIndex',
  \'exec': '!open public/index.html',
  \'cond': function('g:ExecutePublicIndexCondition'),
  \'prev': 'Default Node'
\})

" Check if a index.html is in the root dir
function! g:ExecuteRootIndexCondition()
  return filereadable("index.html")
endfunction

" Name: RootIndex
" Lane: default
" Runs if a index.html file is present in the root of the project. Opens
" index.html in a browser
call g:AddExecrusPlugin({
  \'name': 'RootIndex',
  \'exec': '!open index.html',
  \'cond': function('g:ExecuteRootIndexCondition'),
  \'prev': 'PublicIndex'
\})

" Check if a package.json is in the root of the project
function! g:ExecuteNpmCondition()
  return filereadable("package.json")
endfunction

" Name: Npm
" Lane: default
" Runs if a package.json is in the root of the project. Runs npm test on the
" project - assumes test-script has been setup in package.json (otherwise
" nothing will happen)
call g:AddExecrusPlugin({
  \'name': 'Npm',
  \'exec': '!npm test',
  \'cond': function('g:ExecuteNpmCondition'),
  \'prev': 'RootIndex'
\})

" Check if a grunt.js file is in the root of the project
function! g:ExecuteGruntCondition()
  return filereadable("grunt.js")
endfunction

" Name: Grunt
" Lane: default
" Runs if a grunt.js file is in the root of the project. Runs grunt on the
" project. A default task should be set in the grunt file.
call g:AddExecrusPlugin({
  \'name': 'Grunt',
  \'exec': '!grunt',
  \'cond': function('g:ExecuteGruntCondition'),
  \'prev': 'Npm'
\})

" Check if a Gruntfile.js is in the root of the project
function! g:ExecuteYeomanCondition()
  return filereadable("Gruntfile.js")
endfunction

" Name: Yeoman
" Lane: default
" Runs if a Gruntfile.js is in the root of the project. Runs yeoman on the
" project. A default task should be set in the grunt file.
call g:AddExecrusPlugin({
  \'name': 'Yeoman',
  \'exec': '!yeoman',
  \'cond': function('g:ExecuteYeomanCondition'),
  \'prev': 'Grunt'
\})
