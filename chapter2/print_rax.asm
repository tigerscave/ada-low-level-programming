; .dataセクション、グローバル変数のため
section .data
; codeラベル（アドレス）にdbディレクティブでデータを作成
codes:  db '0123456789ABCDEF'

; .textセクションには命令を
section .text
; 最初に実行する命令にはglobal宣言を
global _main
; _mainラベル、またはアドレス
_main:
  ; rax : 一種のアキュムレーターとして算術命令で使われる
  ; アキュムレーターとは、CPUの演算回路を構成するレジスタの一種で、
  ; 論理演算や四則演算などによるデータの入出力と結果の保持に用いられるレジスタのこと
  ; raxに16進数のデータを格納
  mov rax, 0x1122334455667788   ; 8 bytes

  mov rdi, 1    ; stdout
  mov rdx, 1
  mov rcx, 64   ; 16 * 4bit = 64bits

; ローカルラベル
; .loopのラベルのフルネームは
; _main.loop
; これを使えば、どこからでもアドレッシング可能

.loop:
  push rax  ; raxの値がrspにpushされる
  sub rcx, 4  ; rcxから4bit引く
  sar rax, cl ; arithmetic shift
  and rax, 0xf 

  ;lea rsi, [codes+rax]
  mov rsi, codes
  add rsi, rax

  mov rax, 0x2000004
  mov rdx, 1

  push rcx
  syscall
  pop rcx

  pop rax
  
  test rcx, rcx

  jnz .loop   ; 条件ジャンプ
              ; rflagsレジスタの内容に依存する
              ; rflagsがゼロでなかったら実行
              
  mov rax, 0x2000001
  xor rdi, rdi
  syscall

; nasm -f macho64 print_rax.asm
; ld print_rax.o -L /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib -lSystem -o print_rax
; ./print_rax