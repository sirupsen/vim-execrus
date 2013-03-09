function! s:PluginMeetsCondition(plugin)
  if has_key(a:plugin, 'condition') 
    if type(a:plugin['condition']) == type(function('tr'))
      if call(a:plugin['condition'], [])
        return 1
      endif
    elseif type(a:plugin['condition']) == type("")
      return match(expand('%'), a:plugin['condition']) != -1
    endif
  else
    return 1
  endif
endfunction

function! s:FindMaximumPriorityPlugin(plugins)
  let max_plugin = {'priority': -1}

  for plugin in a:plugins
    if plugin['priority'] > max_plugin['priority'] && s:PluginMeetsCondition(plugin)
      let max_plugin = plugin
    endif
  endfor

  if max_plugin['priority'] != -1
    return max_plugin
  endif

  return 0
endfunction

function! s:ExecutePlugin(plugin)
  if type(a:plugin) != type({})
    return
  endif

  if type(a:plugin['exec']) == type(function('tr'))
    call call(a:plugin['exec'], [])
  elseif type(a:plugin['exec']) == type("")
    exec a:plugin['exec']
  end
endfunction

function! s:AddSingleExecerusPlugin(plugin, lane)
  if has_key(b:execrus_plugins, a:lane)
    let b:execrus_plugins[a:lane] += [a:plugin]
  else
    let b:execrus_plugins[a:lane] = []
    let b:execrus_plugins[a:lane] += [a:plugin]
  endif
endfunction

function! g:AddExecrusPlugin(plugin, ...)
  if a:0 > 0
    for lane in a:000
      call s:AddSingleExecerusPlugin(a:plugin, lane)
    endfor
  else
    call s:AddSingleExecerusPlugin(a:plugin, 'default')
  end
endfunction

function! g:InitializeExecrusEnvironment()
  let b:execrus_plugins = {}
endfunction

function! g:Execrus(...)
  let lane = "default"

  if a:0 > 0
    let lane = a:000[0]
  end

  if !has_key(b:execrus_plugins, lane)
    echo "No plugins in lane '" . lane . "' for '" . &filetype . "'!"
    return
  endif

  let plugin = s:FindMaximumPriorityPlugin(b:execrus_plugins[lane])

  if type(plugin) == type({})
    call s:ExecutePlugin(plugin)
  else
    echo "No plugins in lane '" . lane . "' meet conditions for this '" . &filetype . "' file!"
  end
endfunction

