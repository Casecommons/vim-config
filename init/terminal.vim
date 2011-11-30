if !has("gui_running")
  " Map Cmd-S to <F12> in iTerm2 for Save.
  map <F12> :w<CR>
  map! <F12> <C-o>:w<CR>

  " Makes Command-T work again with arrow keys.  Not clear why.
  map <Esc>[A <Up>
end
