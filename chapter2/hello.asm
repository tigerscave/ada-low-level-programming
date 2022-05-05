; 最初に実行するべき命令にはglobal宣言が必要
; globalはディレクティブ（変換処理を制御するためのもの）
global _main

; フォンノイマンのマシンでは、メモリがコードとデータの両方に使われている
; プログラマはコードとデータを区切りたい

; .dataセクションはグローバル変数のためにある
; プログラムを実行している間はいつでも利用できるデータ
; sectionもディレクティブ
section .data
; dbもディレクティブ
; dbディレクティブはバイトデータを作るのに使う
; データは４つのディレクティブ　db, dw, dd, dqがある
; データはどのセクションの内側でも作ることができる
; 10は改行を示すのに必要
message:   db  'Hello, world!', 10
; messageというラベルに対応するアドレス

; .textセクションには命令を入れる
section .text

; ラベル、またはアドレス
_main:
		; mov命令はある値をレジスタまたはメモリに書き込む
		; 値は他のレジスタ、メモリから取るか、直接の数値でもいい
		; ただし、movではメモリからメモリのコピーができない
		; 両方のオペランドが同じサイズでなければならない
    mov rax, 0x2000004      ; writeシステムコールの番号をraxに入れる
                            ; The actual syscall number for write is 4
                            ; but in order to make it work under Mac OS X
                            ; we have to add 0x2000000 to it before copying
                            ; into rax.

    mov rdi, 1              ; stdout
		; rdi ストリング操作コマンドのdestination側インデックス
    mov rsi, message   
		; rsi ストリング操作コマンドのソース側インデックス
    mov rdx, 14
		; rdx 入出力の間、データを格納する
    syscall

    ; exit
    mov rax, 0x2000001      ; exit syscall number
    xor rdi, rdi            ; exit status
    syscall

; アドレスは64ビット
; 汎用レジスタも64ビット 

; システムコールの実行手順
; raxレジスタにシステムコールの番号を入れる
; 引数は以下のレジスタに入れる
; rdi, rsi, rbx, r10, r8, r9
; システムコールは6個を超える引数を受け取ることができない
; syscall命令を実行する

; nasm -f macho64 hello.asm
; ld hello.o -L /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib -lSystem -o hello
; ./hello