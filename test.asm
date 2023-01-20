bits 64

; Simple "Hello World" program which will write with our
; Type definitions in 'include/efi/efi.asm'.

%include "include/efi/efi.asm"

global _start

section .text

_start:
    mov    rax, [rdi + EFI_SYSTEM_TABLE.ConOut]                  ; Get the pointer to the EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    mov    rdi, msg  																					   ; Set the message to print with our argument being 'rdi'.
    call   [rax + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]  ; Call the OutputString function of the EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.

    jmp $                                                        ; Looping forver

section .data

msg:
    db "Hello, World!", 0
