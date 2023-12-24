.global _start

.data
printbuf:
    .ascii "\n"
    plen = . - printbuf
txtfilebuf:
    .ascii "txt\n"
    tlen = . - txtfilebuf
filename:
    .ascii "database.txt"
    flen = . - filename

.text
_start:
	mov $0x32, %rdi
	callq println
	callq write_to_txt_file
	callq exit

write_to_txt_file:
	#open file:
	mov $0x2, %rax
	mov $filename, %rdi
	mov $0x2f2, %rdx
	syscall

	#write to file:
	mov $0x1, %rax
	mov $0x1, %rdi
	mov $txtfilebuf, %rsi
	mov $tlen, %rdx
	syscall

	#close file:
	mov $0x3, %rax
	syscall

	ret

println:
	callq print
	mov $0x0a, %rdi
	callq print
	ret

print:
	#make system call. $0x1 is system call number for write
	mov %rdi, printbuf

	mov $0x1, %rdi
	mov $printbuf, %rsi
	mov $plen, %rdx
	mov $0x1, %rax
	syscall
	ret

exit:
	mov $0x3c, %rax
	mov $0x0, %rdi
	syscall
