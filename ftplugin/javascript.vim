call g:AddExecrusPlugin({
  \'name': 'Default Node',
  \'exec': '!node %',
\})

call g:AddExecrusPlugin({
  \'name': 'Node REPL',
  \'exec': '!node',
\}, 'repl')
