call g:AddExecrusPlugin({
  \'name': 'Default HTML',
  \'exec': '!open %',
\})

call g:AddExecrusPlugin({
  \'name': 'Default Markdown',
  \'exec': '!markdown % > /tmp/markdown.html && open /tmp/markdown.html',
  \'cond': '\(md\|markdown\)',
  \'prev': 'Default HTML'
\})
