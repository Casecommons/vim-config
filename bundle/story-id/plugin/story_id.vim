" inserts [#SID] into your commit message,
" assuming your branches match the regex: (?<team>\w+)[-_](?<storyid>\w+)[-_](?<description>\w+)
function! InsertStoryId()
  let sid_command = "mi"                           " mark current position

  let sid_command = sid_command."\/On branch\<CR>" " move to line with branch name
  let sid_command = sid_command."WW/\\v[-_]\<CR>l" " move to first char of story #
  let sid_command = sid_command."y/\\v[-_]\<CR>"   " yank the story #
  let sid_command = sid_command."\/^#\<CR>ggn"     " move to first #... line
  let sid_command = sid_command."O"                " add blank line in insert mode
  let sid_command = sid_command."[#\<esc>pA]"      " insert [#SID]
  let sid_command = sid_command."\<esc>"           " switch to normal mode

  let sid_command = sid_command."`i"               " return to previous position
  let sid_command = sid_command.":delmarks i\<CR>" " delete mark

  exec "normal! ".sid_command
endfunction

command! Sid :call InsertStoryId()
