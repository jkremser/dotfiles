"syntax highlighting
syntax on

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

"backup
"set backup
"set backupdir=~/.vim/backup,.,~/
"Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"Set to auto read when a file is changed from the outside
set autoread

"temp
set directory=/tmp,.

"incremental search
set incsearch

"completion of commands
set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full

"highlight the second bracket
set showmatch
"How many tenths of a second to blink when matching brackets
set mat=2

"Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
"Remember info about open buffers on close
set viminfo^=%

"spaces instead of tab
set expandtab
set tabstop=2
set shiftwidth=2 

"F10 for switching between paste and nopaste mode
set pastetoggle=<F10>

"Always show current position
set ruler

"Ignore case when searching
set ignorecase

"Always show the status line
set laststatus=2

"Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"scala
au BufRead,BufNewFile *.scala set filetype=scala
au! Syntax scala source ~/.vim/syntax/scala.vim


" Wrap visual selection in an XML comment
 vmap <Leader>c <Esc>:call CommentWrap()<CR>
 function! CommentWrap()
   normal `>
   if &selection == 'exclusive'
     exe "normal i-->"
   else
     exe "normal a-->"
   endif
   normal `<
   exe "normal i<!--"
   normal `<
 endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction
