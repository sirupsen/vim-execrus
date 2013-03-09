call g:InitializeExecrusEnvironment()

call g:AddExecrusPlugin({
      \'name': 'Default Markdown', 
      \'exec': '!markdown % > /tmp/markdown.html && open /tmp/markdown.html', 
\})
