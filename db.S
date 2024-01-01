.global _start

.data
filename:
    .ascii "database.txt\0"
    flen = . - filename
nl:
    .ascii "\n"
    nlen = . - nl
printbuf:
    .ascii "\n"
    plen = . - printbuf
inputbuf:
    .ascii "\n"
    ilen = . - inputbuf
input_instruction:
    .ascii "Please enter a database instruction: w, r, u, d -- followed by your desired input (if applicable). For example, wARYAN123 would write ARYAN123 to the database.\n"
    inst_len = . - input_instruction

.text
_start:
	#mov $0x30, %rdi
	#callq println

	callq db_prompt_handler

	callq exit

db_prompt_handler:
	callq print_instructions

	mov $0x1, %rdi
	callq read_std_input
	mov $inputbuf, %r12
	cmpb $0x77, (%r12)	#0x77 is the value for the letter 'w'
	jne db_prompt_not_w

	movq $0x0, (%r12)	#reset buffer
	mov $0x8, %rdi
	callq read_std_input

	mov $inputbuf, %rdi
	mov $0x8, %rsi
	callq writeln

    db_prompt_not_w:
	ret

read_std_input:
#uses %rdi as length, like mov $0x9, %rdi
	mov %rdi, %rdx
	mov $inputbuf, %rsi
	mov $0x0, %rdi
	mov $0x0, %rax
	syscall
	ret

writeln:
	callq write_to_txt_file
	mov $nl, %rdi
	mov $nlen, %rsi
	callq write_to_txt_file
	ret

write_to_txt_file:
#%rdi must hold an address to a character array, like mov $buf, %rdi
#%rsi must hold %rdi's length, like mov $tlen, %rsi

	push %rdi
	push %rsi

	#open file:
	mov $0x2, %rax
	mov $filename, %rdi
	mov $0x61, %rdx
	mov $0x441, %rsi
	syscall

	mov %rax, %r8

	#write to file:
	mov $0x1, %rax
	mov %r8, %rdi
	pop %r13	#contents of %rdi which were pushed onto the stack get popped into %r12
	pop %r12	#^^same but with length
	mov %r12, %rsi
	mov %r13, %rdx
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

print_instructions:
	mov $input_instruction, %rsi
	mov $0x1, %rdi
	mov $inst_len, %rdx
	mov $0x1, %rax
	syscall
	ret

exit:
	mov $0x3c, %rax
	mov $0x0, %rdi
	syscall
