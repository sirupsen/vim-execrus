call g:InitializeExecrusEnvironment()

function! s:DefaultCPlusPlusCompile()
  let s:executeable = substitute(expand('%'), ".cpp", "", "")
  let s:compile_command = "!clang++ " . expand('%') . " -o " . s:executeable . " -O2 -std=c++0x -stdlib=libc++ -pedantic"
endfunction

function! g:DefaultCPlusPlusExecute()
  call s:DefaultCPlusPlusCompile()
  execute s:compile_command . ' && ' . s:executeable
endfunction

call g:AddExecrusPlugin({
      \'name': 'Default C++', 
      \'exec': function("g:DefaultCPlusPlusExecute"), 
      \'priority': 1
\})

function! g:InformaticsCPlusPlusExecute()
  call s:DefaultCPlusPlusCompile()
  execute s:compile_command . ' && time ' . s:executeable
endfunction

function! g:InformaticsCPlusPlusCondition()
  return match(expand('%:p'), 'informatics') != -1
endfunction

call g:AddExecrusPlugin({
      \'name': 'Informatics C++', 
      \'exec': function("g:InformaticsCPlusPlusExecute"), 
      \'condition': function('g:InformaticsCPlusPlusCondition'), 
      \'priority': 2
\})
