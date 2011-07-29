" Add untracked machine-local vim path
let &rtp = "~/.vim.local,".&rtp

" pathogen setup
 filetype on
 filetype off 
 call pathogen#helptags()
 call pathogen#runtime_append_all_bundles()

"see vim-rails plugin doc [rails.txt]
set nocompatible
syntax on
filetype plugin indent on

"ack current word in command mode
function! AckGrep()
  let command = "ack ".expand("<cword>")
  cexpr system(command)
  cw
endfunction

function! AckVisual()
  normal gv"xy
  let command = "ack ".@x
  cexpr system(command)
  cw
endfunction

" SHORTCUT KEY MAPPINGS """""""""""""""""""

"prev/next in quickfix file listing (e.g. search results)
map <M-D-Down> :cn<CR>
map <M-D-Up> :cp<CR>

"opt-cmd-arrows [next & previous open files]
map <M-D-Left> :bp<CR>
map <M-D-Right> :bn<CR>

"indent/unindent visual mode selection with tab/shift+tab
vmap <tab> >gv
vmap <s-tab> <gv

"Undo/Redo using undo tree with cmd-z/cmd-shift-z
map <D-z> :earlier 1<CR>
map <D-Z> :later 1<CR>

" File tree browser - backslash
map \ :NERDTreeToggle<CR>

" File tree browser showing current file - pipe (shift-backslash)
map \| :NERDTreeFind<CR>

"strip trailing whitespace on save for code files
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction
"cocoa
autocmd BufWritePre *.m,*.h,*.c,*.mm,*.cpp,*.hpp call StripTrailingWhitespace()
"rails
autocmd BufWritePre *.rb,*.yml,*.js,*.css,*.less,*.sass,*.scss,*.html,*.xml,*.erb,*.haml call StripTrailingWhitespace()
"misc
autocmd BufWritePre *.java,*.php,*.feature call StripTrailingWhitespace()

"highlight JSON files as javascript
autocmd BufRead,BufNewFile *.json set filetype=javascript

"highlight jasmine_fixture files as HTML
autocmd BufRead,BufNewFile *.jasmine_fixture set filetype=html

" SETTINGS """"""""""""""""""""""""""""""""

" Colors
if &t_Co == 256
  let g:solarized_termcolors=256
endif
set background=dark
colorscheme solarized

"Show whitespace, fullstops for trailing whitespace
set list
if has("gui_running")
  set listchars=trail:·
else
  set listchars=trail:~
endif

"Swapfiles
set swapfile

"Keep swap and backup files somewhere else
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp

"no toolbar
set guioptions-=T

"no gui tab bar
set guioptions-=e

"no scrollbars
set guioptions-=rL

"font
set guifont=Inconsolata:h24

"history size
set history=1024

"incremental search
set incsearch

"no wrapping
set nowrap

"line numbers
set number

"always show statusline
set laststatus=2

"show matching brackets
set showmatch

"tab settings
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab

" Allow backspace to work more flexibly.
set backspace=2


" Rayban & Peter
let mapleader = ","

" FuzzyFinder and switchback commands
map <leader>e :e#<CR>
map <leader>b :FufBuffer<CR>
map <leader>f <Plug>PeepOpen
map <leader><C-N> :FufFile **/<CR>
map <D-e> :FufBuffer<CR>
map <D-N> :FufFile **/<CR>

" search
nmap <leader>s :%s/
vmap <leader>s :s/

" Split screen vertically and move between screens.
map <leader>v :vsp<CR>
map <leader>w ^Ww
map <leader>= ^W=

" Move between horizontally split screens.
map <leader>j ^Wj
map <leader>k ^Wk

" Add new windows towards the right and bottom.
set splitbelow splitright

" AckGrep current word
map <leader>a :call AckGrep()<CR>
" AckVisual current selection
vmap <leader>a :call AckVisual()<CR>

" set question mark to be part of a VIM word. in Ruby it is!
autocmd FileType ruby set iskeyword=@,48-57,_,?,!,192-255
autocmd FileType scss set iskeyword=@,48-57,_,-,?,!,192-255

" Insert ' => '
autocmd FileType ruby imap  <Space>=><Space>

" Open all folds in Markdown.
autocmd FileType mkd normal zR

" reload .vimrc
map <leader>rv :source ~/.vimrc<CR>

" refresh the FuzzyFinder cache
map <leader>rf :FufRenewCache<CR>

" ctags with rails load path
map <leader>t :!rails runner 'puts $LOAD_PATH.join(" ")' \| xargs /usr/local/bin/ctags -R public/javascripts<CR>
map <leader>T :!rails runner 'puts $LOAD_PATH.join(" ")' \| xargs rdoc -f tags<CR>

" git blame
map <leader>g :Gblame<CR>

" F7 reformats the whole file and leaves you where you were (unlike gg)
map <silent> <F7> mzgg=G'z :delmarks z<CR>:echo "Reformatted."<CR>

" Write all writeable buffers when changing buffers or losing focus.
autocmd BufLeave,FocusLost * silent! wall
set autowriteall

" Let unsaved buffers exist in the background.
set hidden

" Show typed command prefixes while waiting for operator.
set showcmd

" In insert mode, use Cmd-<CR> to jump to a new line in insert mode, a la
" TextMate.
imap <D-CR> <ESC>o

" Change background color when inserting.
" (Broken in terminal Vim: Solarized has a bug which makes it reload poorly.)
" http://www.reddit.com/r/vim/comments/ggbcp/solarized_color_scheme/
if has("gui_running")
  let g:insert_mode_background_color = "#18434E"
end

" Run a test tool with the current file and line number
" The test tool is run in the last Terminal window
function! RunTestTool(tool_cmd)
  let dir = system('pwd')
  let applescript = "osascript -e '".'tell application "Terminal"'
  let applescript .= "\n"
  let applescript .= 'do script "cd '.dir.'" in last window'
  let applescript .= "\n"
  let applescript .= 'do script "'.a:tool_cmd.'" in last window'
  let applescript .= "\n"
  let applescript .= 'end tell'."'"
  let foo = system(applescript)
endfunction

" If the file ends with _spec.rb, RunTestTool with rspec
" If the file ends with .feature, RunTestTool with cuke
command! RunFocusedTest :call RunFocusedTest()
function! RunFocusedTest()
  let filename = expand("%")
  if filename =~ '_spec\.rb$'
    call RunTestTool("bundle exec rspec ".expand("%").":".line("."))
  endif
  if filename =~ '\.feature$'
    call RunTestTool("cuke ".expand("%").":".line("."))
  endif
endfunction

command! RunTests :call RunTests()
function! RunTests()
  let filename = expand("%")
  if filename =~ '_spec\.rb$'
    call RunTestTool("bundle exec rspec ".expand("%"))
  elseif filename =~ '.rb'
    let splitFilename = split(filename, '\/')
    let folders = splitFilename[1:-2]
    let shortenedName = split(splitFilename[-1], '\.rb')[0]

    let testFilename = "spec/"
    for folder in folders
      let testFilename = testFilename.folder."/"
    endfor
    let testFilename = testFilename.shortenedName."_spec.rb"
    call RunTestTool("bundle exec rspec ".testFilename)
  endif

  if filename =~ '\.feature$'
    call RunTestTool("cuke ".expand("%"))
  endif
endfunction

" Run test at cursor
map <leader><D-R> :w<CR>:RunFocusedTest<CR>
" Run all tests in file
map <leader><D-r> :w<CR>:RunTests<CR>

" Find unused cucumber steps.
command! CucumberFindUnusedSteps :call CucumberFindUnusedSteps()
function! CucumberFindUnusedSteps()
  let olderrorformat = &l:errorformat
  try
    set errorformat=%m#\ %f:%l
    cexpr system('bundle exec cucumber --no-profile --no-color --format usage --dry-run features \| grep "NOT MATCHED BY ANY STEPS" -B1 \| egrep -v "(--\|NOT MATCHED BY ANY STEPS)"')
    cwindow
  finally
    let &l:errorformat = olderrorformat
  endtry
endfunction

" Open .vimrc file.  (Think Cmd-, [Preferences...] but with Shift.)
map <D-<> :tabedit ~/.vimrc<CR>

" Make command completion act more like bash
set wildmode=list:longest
cmap <C-A> <C-B>

" Start scrolling when the cursor is within 3 lines of the edge.
set scrolloff=3

" Scroll faster.
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Pad comment delimeters with spaces.
let NERDSpaceDelims = 1

" Comment/uncomment lines.
map <leader>/ <plug>NERDCommenterToggle

" Copy current file path to system pasteboard.
map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>

" Disable middle mouse button (which is easy to hit by accident).
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

" Make Y consistent with D and C.
map Y y$

" Don't time out during commands.
set notimeout

" Turn off <F1> and double-click for new tab.
map <F1> <Nop>
imap <F1> <Nop>
map <2-LeftMouse> <Nop>

" Don't prompt for file changes outside MacVim
set autoread

" Highlight current row.
set cursorline

" Command-T
let g:CommandTMaxHeight=20
map <D-N> :CommandTFlush<CR>:CommandT<CR>
map <Leader>f :CommandTFlush<CR>:CommandT<CR>

" Easy access to the shell.
map <Leader><Leader> :!

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

set showtabline=1

highlight link TabNum Special


" surround.vim: Add $ as a jQuery surround, _ for Underscore.js
autocmd FileType javascript let b:surround_36 = "$(\r)"
                        \ | let b:surround_95 = "_(\r)"

" To use:
" let g:i = 0
" %s/foo/\="id: ".AutoincrementI()
"
" foo  -> id: 1
" foo  -> id: 2
function! AutoincrementI()
  let g:i = g:i + 1
  return g:i
endfunction

" Map Cmd-S to <F12> in iTerm2 for Save.
map <F12> :w<CR>
map! <F12> <C-o>:w<CR>

map <F11> :q<CR>
map! <F11> <C-o>:q<CR>

map <Esc>[A <Up>

