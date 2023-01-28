bits 64

; Simple "Hello World!" program which will write with our
; Type definitions in 'include/efi/efi.asm'. 64

; To produce a '.efi' PIE file
; nasm -f win64 -o test.obj test.asm
; lld-link -subsystem:efi_application -entry:_start \ 
; -dll -nodefaultlib test.obj -out:test.efi
; From here you can copy to a fat filesystem image.

%include "include/efi/efi.asm"

global _start

section .text

_start:
        sub    rsp, [4 * 8]                                          ; Reserving four arguments.
        ; RDX = EFI_SYSTEM_TABLE
        mov    rcx, [rdx + EFI_SYSTEM_TABLE.ConOut]                  ; Moving 'ConOut' to our system table structure.
        lea    rdx, [rel message]                                    ; Loading our string register onto register 'RDX'.
        call   [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]  ; Calling 'OutputString' by the value of register 'RDX'.

        jmp $                                                        ; Jumping to this instruction, this will allow us to see output.

section .data
    message dw __utf16__ "Hello, World!",13,10,0
