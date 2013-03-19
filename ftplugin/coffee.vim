call g:AddExecrusPlugin({
  \'name': 'Default Coffee',
  \'exec': '!coffee %'
\})

call g:AddExecrusPlugin({
  \'name': 'Coffee REPL',
  \'exec': '!coffee'
\}, 'repl')
