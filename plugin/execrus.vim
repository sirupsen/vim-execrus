function! s:PluginMeetsCondition(plugin)
  if has_key(a:plugin, 'cond')
    if type(a:plugin['cond']) == type(function('tr'))
      return !empty(call(a:plugin['cond'], []))
    elseif type(a:plugin['cond']) == type("")
      return match(expand('%'), a:plugin['cond']) != -1
    endif
  else
    return 1
  endif
endfunction

function! g:CreateExecutionPlan(plugs, lane)
  if exists("b:parsed_execrus_plugins") && has_key(b:parsed_execrus_plugins, a:lane)
    return b:parsed_execrus_plugins[a:lane]
  end

  let top = {}
  let sorted = []
  let plugins = deepcopy(a:plugs)

  for i in range(len(plugins))
    let plugin = plugins[i]

    if !has_key(plugin, 'prev')
      if len(sorted) == 1
        throw 'More than one starting point: "' . plugin['name'] . '" and "' . top['name'] . '"'
      endif

      let top = plugin
      let sorted += [top]
      let top_index = i
    endif
  endfor

  if empty(sorted)
    throw "No starting point found.."
  endif

  call remove(plugins, top_index)

  while !empty(plugins)
    let good = 0

    for i in range(len(plugins))
      let plugin = plugins[i]

      if plugin['prev'] == top['name']
        let sorted += [plugin]
        let top = plugin
        let good = 1
        call remove(plugins, i)
        break
      endif
    endfor

    if !good
      throw "Bad directions given.."
    endif
  endwhile

  if !exists("b:parsed_execrus_plugins")
    let b:parsed_execrus_plugins = {}
  endif

  let b:parsed_execrus_plugins[a:lane] = reverse(sorted)

  return b:parsed_execrus_plugins[a:lane]
endfunction

function! s:FindMaximumPriorityPlugin(plugins, lane)
  let plugs = g:CreateExecutionPlan(a:plugins, a:lane)

  for plugin in plugs
    if s:PluginMeetsCondition(plugin)
      return plugin
    endif
  endfor
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
  if !exists("b:execrus_plugins")
    let b:execrus_plugins = {}
  endif

  if !has_key(b:execrus_plugins, a:lane)
    let b:execrus_plugins[a:lane] = []
  endif

  for other_plugin in b:execrus_plugins[a:lane]
    if other_plugin['name'] == a:plugin['name']
      return
    endif
  endfor

  let b:execrus_plugins[a:lane] += [a:plugin]
endfunction

functio! s:SanityCheckPlugin(plugin)
  let plug = a:plugin

  if !has_key(plug, 'exec')
    throw "Plugin " . plug['name'] . " has no 'exec' property."
  endif

  return plug
endfunctio

function! g:AddExecrusPlugin(plugin, ...)
  let plug = s:SanityCheckPlugin(a:plugin)

  if a:0 > 0
    call s:AddSingleExecerusPlugin(plug, a:000[0])
  else
    call s:AddSingleExecerusPlugin(plug, 'default')
  end
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

  let plugin = s:FindMaximumPriorityPlugin(b:execrus_plugins[lane], lane)

  if type(plugin) == type({})
    call s:ExecutePlugin(plugin)
  else
    echo "No plugins in lane '" . lane . "' meet conditions for this '" . &filetype . "' file!"
  end
endfunction

