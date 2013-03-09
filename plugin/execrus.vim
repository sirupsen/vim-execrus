function! s:PluginMeetsCondition(plugin)
  if has_key(a:plugin, 'condition') 
    if type(a:plugin['condition']) == type(function('tr'))
      return call(a:plugin['condition'], [])
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

functio! s:SanityCheckPlugin(plugin)
  let plug = a:plugin

  if !has_key(plug, 'priority')
    let plug['priority'] = 1
  end

  if !has_key(plug, 'exec')
    throw "Plugin " . plug['name'] . " has no 'exec' property."
  endif

  return plug
endfunctio

function! g:AddExecrusPlugin(plugin, ...)
  let plug = s:SanityCheckPlugin(a:plugin)

  if a:0 > 0
    for lane in a:000
      call s:AddSingleExecerusPlugin(plug, lane)
    endfor
  else
    call s:AddSingleExecerusPlugin(plug, 'default')
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

  if !exists("b:execrus_plugins") || !has_key(b:execrus_plugins, lane)
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

