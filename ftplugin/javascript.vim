call g:AddExecrusPlugin({
  \'name': 'Default Node',
  \'exec': '!node %',
\})

call g:AddExecrusPlugin({
  \'name': 'Node REPL',
  \'exec': '!node',
\}, 'repl')

function! g:ExecutePublicIndexCondition()
  return filereadable("public/index.html")
endfunction

call g:AddExecrusPlugin({
  \'name': 'PublicIndex',
  \'exec': '!open public/index.html',
  \'cond': function('g:ExecutePublicIndexCondition'),
  \'prev': 'Default Node'
\})

function! g:ExecuteRootIndexCondition()
  return filereadable("index.html")
endfunction


call g:AddExecrusPlugin({
  \'name': 'RootIndex',
  \'exec': '!open index.html',
  \'cond': function('g:ExecuteRootIndexCondition'),
  \'prev': 'PublicIndex'
\})

function! g:ExecuteNpmCondition()
  return filereadable("package.json")
endfunction

call g:AddExecrusPlugin({
  \'name': 'Npm',
  \'exec': '!npm test',
  \'cond': function('g:ExecuteNpmCondition'),
  \'prev': 'RootIndex'
\})
function! g:ExecuteGruntCondition()
  return filereadable("grunt.js")
endfunction

call g:AddExecrusPlugin({
  \'name': 'Grunt',
  \'exec': '!grunt',
  \'cond': function('g:ExecuteGruntCondition'),
  \'prev': 'Npm'
\})

function! g:ExecuteYeomanCondition()
  return filereadable("Gruntfile.js")
endfunction

call g:AddExecrusPlugin({
  \'name': 'Yeoman',
  \'exec': '!yeoman',
  \'cond': function('g:ExecuteYeomanCondition'),
  \'prev': 'Grunt'
\})
