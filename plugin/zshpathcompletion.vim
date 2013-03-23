" zshpathcompletion.vim
"
" Author: Jim Stewart <http://https://github.com/fweep>
" Version: 0.1

if exists('g:loaded_zsh_path_complation') || &cp || v:version < 700
  finish
endif

let g:loaded_zsh_path_complation = 1

function! s:expand_path_component(path_component)
  let matches = glob(a:path_component . '*')
  return split(matches, '\n')
endfunction

function! s:index_of_longest_match(matches)
  let baseline = a:matches[0]
  if baseline[-1:] == '/'
    return baseline
  endif
  let index_of_first_filename = strridx(baseline, '/') + 1
  let offset_index = 0
  for path in a:matches[1:]
    let total_index = index_of_first_filename + offset_index
    if total_index >= len(path)
      break
    endif
    if path[total_index] != baseline[total_index]
      break
    endif
    let offset_index += 1
  endfor
  return index_of_first_filename + offset_index
endfunction

function! s:expand_path(path_components)
  let current_path = ''
  for path_component in a:path_components
    let matches = s:expand_path_component(current_path . path_component)
    let number_of_matches = len(matches)
    if number_of_matches == 0
      break
    elseif number_of_matches > 1
      let index_of_longest_match = s:index_of_longest_match(matches)
      let current_path = matches[0][0:index_of_longest_match]
    else
      let current_path = matches[0]
      if isdirectory(current_path)
        let current_path .= '/'
      endif
    endif
  endfor
  return current_path
endfunction

function! s:ZshExpandPath()
  let command_line = getcmdline()
  let cursor_position = getcmdpos()
  let last_space_index = strridx(command_line, ' ')
  if last_space_index == -1
    return ''
  endif
  let last_word = command_line[(last_space_index + 1):]
  let path_components = split(last_word, '/')
  let full_path = s:expand_path(path_components)
  let new_command_line = command_line
  if strlen(full_path) != 0
    let command_prefix = command_line[0:last_space_index]
    let new_command_line = command_prefix . full_path
    call setcmdpos(strlen(new_command_line) + 1)
  endif
  return new_command_line
endfunction

function! s:has_key_map()
  return hasmapto('<Plug>ZshPathComplete', 'c') || mapcheck('<C-s>', 'c') != ''
endfunction

function! s:suppress_key_map()
  return exists('g:zsh_path_completion_suppress_mappings') && g:zsh_path_completion_suppress_mappings
endfunction

function! s:should_map_key()
  return !s:suppress_key_map() && !s:has_key_map()
endfunction

if s:should_map_key()
  cmap <C-s> <Plug>ZshPathComplete
endif

cmap <Plug>ZshPathComplete <C-\>e<Sid>ZshExpandPath()<CR>
