syntax on

set backup
set backupdir=~/.vim/backup,.,~/

set directory=/tmp,.

set incsearch

set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full

au BufRead,BufNewFile *.scala set filetype=scala
2
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

