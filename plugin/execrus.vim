function! s:PluginMeetsCondition(plugin)
  if has_key(a:plugin, 'condition')
    if type(a:plugin['condition']) == type(function('tr'))
      return !empty(call(a:plugin['condition'], []))
    elseif type(a:plugin['condition']) == type("")
      return match(expand('%'), a:plugin['condition']) != -1
    endif
  else
    return 1
  endif
endfunction

function! g:CreateExecutionPlan(plugs)
  let top = {}
  let sorted = []
  let plugins = deepcopy(a:plugs) " TODO
  let top_index = 0

  for i in range(len(plugins))
    let plugin = plugins[i]

    if !has_key(plugin, 'prev') || empty(plugin['prev'])
      if len(sorted) == 1
        throw "More than one starting point"
      endif

      let top = plugin
      let sorted += [top]
      let top_index = i
    endif
  endfor

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

  return reverse(sorted)
endfunction

function! s:FindMaximumPriorityPlugin(plugins)
  let first_plugin = {}

  let plugs = g:CreateExecutionPlan(a:plugins)

  for plugin in plugs
    if s:PluginMeetsCondition(plugin)
      let first_plugin = plugin
      break
    endif
  endfor

  if first_plugin != {}
    return first_plugin
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
  if !has_key(b:execrus_plugins, a:lane)
    let b:execrus_plugins[a:lane] = []
  endif

  let b:execrus_plugins[a:lane] += [a:plugin]
endfunction

functio! s:SanityCheckPlugin(plugin)
  let plug = a:plugin

  if !has_key(plug, 'priority')
    let plug['priority'] = 1
  end

  if has_key(plug, 'cond') && !has_key(plug, 'condition')
    let plug['condition'] = plug['cond']
  endif

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
  if !exists("b:execrus_plugins")
    let b:execrus_plugins = {}
  endif
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

