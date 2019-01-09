macmenu &File.Close key=<nop>
macmenu &File.Save key=<nop>
macm File.New\ Tab key=<nop>
nmap <D-s> :w<CR>
imap <D-s> <esc>:w<cr>
nmap <D-w> :call CleanClose()<CR>

nmap <D-1> :call OpenBuf(1)<CR>
nmap <D-2> :call OpenBuf(2)<CR>
nmap <D-3> :call OpenBuf(3)<CR>
nmap <D-4> :call OpenBuf(4)<CR>
nmap <D-5> :call OpenBuf(5)<CR>
nmap <D-6> :call OpenBuf(6)<CR>
nmap <D-7> :call OpenBuf(7)<CR>

imap <D-1> :call OpenBuf(1)<CR>
imap <D-2> :call OpenBuf(2)<CR>
imap <D-3> :call OpenBuf(3)<CR>
imap <D-4> :call OpenBuf(4)<CR>
imap <D-5> :call OpenBuf(5)<CR>
imap <D-6> :call OpenBuf(6)<CR>
imap <D-7> :call OpenBuf(7)<CR>
