call g:AddExecrusPlugin({
  \'name': 'Default Python',
  \'exec': '!python %',
\})

call g:AddExecrusPlugin({
  \'name': 'Python REPL',
  \'exec': '!python',
\}, 'repl')
