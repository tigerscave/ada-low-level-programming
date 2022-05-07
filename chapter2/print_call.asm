section .data
newline_char: db 10
codes: db '0123456789abcdef'

section .text
global _start

print_newline:
  mov rax, 1
  mov rdi, 1
  mov rsi, newline_char
  mov rdx, 1
  syscall
  ret

print_hex:
  mov rax, rdi
  mov rdi, 1
  mov rdx, 1
  mov rcx, 64

iterate:
  push rax
  sub rcx, 4
  sar rax, cl
  and rax, 0xf

  lea rsi, [codes+rax]

  mov rax, 1
  push rcx
  syscall

  pop rcx
  pop rax

  test rcx, rcx
  jnz iterate
  ret     ; ルーチンの終わり。pop ripと完全に等しい

_start:

  mov rdi, 0x1122334455667788
  call print_hex    ; callは下記と全く同じ
  ; push rip
  ; jmp <address>
  ; 引数を無制限に受け取れる。rdi, rsi, rbx, rcx, r8, r9に入れて渡される

  call print_newline

  mov rax, 60
  xor rdi, rdi
  syscall

; 呼び出し先退避レジスタは
; rbx, rbp, rsp, r12-r15

; nasm -felf64 print_call.asm -o print_call.o
; ld -o print_call print_call.o
; ./print_call