call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
  \'name': 'Default Coffee',
  \'exec': '!coffee %'
\})

call g:AddExecrusPlugin({
  \'name': 'Compile Coffee',
  \'exec': '!coffee -c %',
  \'prev': 'Default Coffee'
\})

call g:AddExecrusPlugin({
  \'name': 'Coffee Help',
  \'exec': '!coffee -h',
  \'cond': 'lolol.coffee',
  \'prev': 'Compile Coffee'
\})
