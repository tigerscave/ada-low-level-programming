; .dataセクション、グローバル変数のため
section .data
; codeラベル（アドレス）にdbディレクティブでデータを作成
codes:  db '0123456789ABCDEF'

; .textセクションには命令を
section .text
; 最初に実行する命令にはglobal宣言を
global _start
; _mainラベル、またはアドレス
_start:
  ; rax : 一種のアキュムレーターとして算術命令で使われる
  ; アキュムレーターとは、CPUの演算回路を構成するレジスタの一種で、
  ; 論理演算や四則演算などによるデータの入出力と結果の保持に用いられるレジスタのこと
  ; raxに16進数のデータを格納、これはアドレスではない
  mov rax, 0x1122334455667788   ; 8 bytes

  ;mov rdi, 1    ; stdout
  ;mov rdx, 1

  ; rcx ループの回数に使われる
  mov rcx, 64   ; 16 * 4bit = 64bits

; ローカルラベル
; .loopのラベルのフルネームは
; _main.loop
; これを使えば、どこからでもアドレッシング可能

.loop:
  push rax  ; raxアドレスの値がスタックに積まれる
            ; rspにはそのスタックのアドレスが記録される
  sub rcx, 4  ; rcxから4引く
  sar rax, cl ; shift arithmetic right
              ; clはrcxの最下位バイト
              ; sarの第二オペランドには8bitしか指定できない
              ; rcx(64) => ecx(32) => cx(16) = ch + cl
              ; 0x1122334455667788
              ; 0x0000000000000001
              ; 0x0000000000000011
              ; 0x0000000000000112
  and rax, 0xf ; 0xf = 1111
              ; 

  lea rsi, [codes+rax] ;load effective address
                      ; codesアドレス+上のraxの一桁分アドレスがずれる（メモリセルのアドレスを計算）
                      ; rsiにそのアドレスを入れる
                      ; 下記のコマンドと同じ
  ; mov rsi, codes
  ; add rsi, rax

  mov rax, 1  ; write system call
  mov rdx, 1  ; argument stdout

  push rcx    ; rcxの値をメモリのスタックに保存、そのアドレスをrspに保存
              ; ; syscall leaves rcx and r11 changed
  syscall     ; writeのsystemcall
  pop rcx     ; rspには保存した内容をrcxに書き込み、rspアドレスはひとつ前に戻る

  pop rax     ; rspに最初にpushしてスタックに積んだデータのアドレスをraxに書き込み、rspは空に
  
  test rcx, rcx ;rcxとrcxの論理積の値をrflagsに格納

  jnz .loop   ; 条件ジャンプ
              ; rflagsレジスタの内容に依存する
              ; rflagsがゼロでなかったら実行
              
  mov rax, 60
  xor rdi, rdi
  syscall

; nasm -felf64 print_rax.asm -o print_rax.o
; ld -o print_rax print_rax.o
; ./print_rax