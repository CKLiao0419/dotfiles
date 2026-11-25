" ~/.vimrc —— 給 R50e、eeePC 這種跑不動 nvim 外掛的老機器
" 不裝任何外掛；按鍵盡量和 nvim 那份一致

set nocompatible
syntax on
filetype plugin indent on

let mapleader = " "
set number relativenumber cursorline
set tabstop=4 shiftwidth=4 expandtab smartindent
set ignorecase smartcase incsearch hlsearch
set splitright splitbelow scrolloff=8 nowrap
set mouse=a backspace=indent,eol,start
set laststatus=2 wildmenu
set encoding=utf-8

" 透明背景：不畫背景色，讓終端的顏色透出來
set background=dark
silent! colorscheme default
highlight Normal ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE ctermfg=8
highlight CursorLine cterm=NONE ctermbg=0
highlight CursorLineNr cterm=bold ctermfg=6 ctermbg=0

" 內建的檔案樹（netrw）：空白+e 在左邊打開
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
nnoremap <leader>e :Lexplore<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-s> :w<CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

" F5 右邊 / F6 下面：編譯並執行（vim 8.1 以上才有 :terminal）
function! s:Run(dir) abort
  write
  let l:f = shellescape(expand('%:p'))
  let l:o = shellescape('/tmp/' . expand('%:t:r'))
  let l:cmds = {
        \ 'c':      'cc -std=c99 -Wall -O2 ' . l:f . ' -o ' . l:o . ' -lm && ' . l:o,
        \ 'cpp':    'c++ -Wall -O2 ' . l:f . ' -o ' . l:o . ' && ' . l:o,
        \ 'python': 'python3 ' . l:f,
        \ 'sh':     'sh ' . l:f,
        \ }
  if !has_key(l:cmds, &filetype)
    echo 'F5 不支援 ' . &filetype | return
  endif
  if has('terminal')
    execute (a:dir ==# 'v' ? 'vertical ' : '') . 'terminal sh -c ' . shellescape(l:cmds[&filetype])
  else
    execute '!' . l:cmds[&filetype]
  endif
endfunction
nnoremap <F5> :call <SID>Run('v')<CR>
nnoremap <F6> :call <SID>Run('h')<CR>

if filereadable(expand('~/.vimrc.local')) | source ~/.vimrc.local | endif
