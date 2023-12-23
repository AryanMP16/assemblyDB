.global _start

.data
printbuf:
    .ascii "\n"
    len = . - printbuf

.text
_start:
	mov $0x32, %rdi
	callq println
	callq exit

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
	mov $len, %rdx
	mov $0x1, %rax
	syscall
	ret

exit:
	mov $0x0, %rdi
	mov $0x3c, %rax
	syscall
