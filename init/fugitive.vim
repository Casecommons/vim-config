" Automatically delete Fugitive buffers that are no longer being used.
" Otherwise, they tend to fill up the buffer list.
"
" Credit to Drew Neil of Vimcasts:
" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/

autocmd BufReadPost fugitive://* set bufhidden=delete

" Unset 'list' in :Gstatus window (which usually contains tab characters).
autocmd BufReadPost .git/index set nolist
