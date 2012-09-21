syntax on

set backup
set backupdir=~/.vim/backup,.,~/

set directory=/tmp,.

set incsearch

set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full

"https://raw.github.com/vim-scripts/scala.vim/master/syntax/scala.vim
au BufRead,BufNewFile *.scala set filetype=scala
au! Syntax scala source ~/.vim/syntax/scala.vim

