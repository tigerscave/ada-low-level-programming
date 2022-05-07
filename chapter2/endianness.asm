section .data
demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
      ; BE: 複数のバイトの数値は、最上位バイトを先頭としてメモリに置かれる
      ; 1122334455667788
      ; LE: 複数のバイトの数値は、最下位バイトを先頭としてメモリに置かれる
      ; 8877665544332211
      ; 強みは、数値を8バイトから4バイトに変換する時に、空の上位バイト列を無視できる
      ; Intel64はリトルエンディアン

newline_char: db 10
codes: db '0123456789abcdef'

process_exit:
  mov rax, 60
  xor rdi, rdi
  syscall
  ret

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

section .text
global _start

_start:
  mov rdi, [demo1]  ; demo1のアドレスではなく中身の連続した8バイト
  call print_hex
  call print_newline

  mov rdi, [demo2]  ; demo2のアドレスではなく中身の連続した8バイト
  call print_hex
  call print_newline

  call process_exit

; nasm -felf64 endianness.asm -o endianness.o
; ld -o endianness endianness.o
; ./endianness