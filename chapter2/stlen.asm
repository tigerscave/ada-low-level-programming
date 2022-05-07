global _start

section .data
test_string: db 'adawarp', 0

process_exit:
  mov rax, 60
  syscall
  ret

section .text

strlen:
  push r13
  xor r13, r13

.loop:
  cmp byte[rdi+r13], 0
  je .end
  inc r13
  jmp .loop

.end:
  mov rax, r13
  pop r13
  ret

_start:
  mov rdi, test_string
  
  call strlen

  mov rdi, rax

  call process_exit

; nasm -felf64 stlen.asm -o stlen.o
; ld -o stlen stlen.o
; ./stlen