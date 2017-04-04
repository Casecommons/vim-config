" Whitespace & highlighting & language-specific config
" ----------------------------------------------------

" Strip trailing whitespace for code files on save
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

autocmd BufWritePre *.m,*.h,*.c,*.mm,*.cpp,*.hpp call StripTrailingWhitespace()
autocmd BufWritePre *.rb,*.yml,*.js,*.jsx,*.css,*.less,*.sass,*.scss,*.html,*.xml,*.erb,*.haml call StripTrailingWhitespace()
autocmd BufWritePre *.java,*.php,*.feature call StripTrailingWhitespace()

" JSON
autocmd BufRead,BufNewFile *.json set filetype=javascript

" Ruby
autocmd FileType ruby imap  <Space>=><Space>

" Markdown
autocmd FileType markdown,mkd normal zR

" SQL
autocmd FileType sql set filetype=sqlanywhere
let g:sql_type_default="postgresql"

" Prose-like
autocmd FileType gitcommit,mail,markdown,mkd,text set spell
autocmd FileType mail,markdown,mkd,text setlocal wrap linebreak nolist
