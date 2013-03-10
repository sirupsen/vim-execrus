call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
  \'name': 'Default Node',
  \'exec': '!node %',
\})
