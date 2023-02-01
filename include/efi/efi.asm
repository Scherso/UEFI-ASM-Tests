; Author: Scherso (https://github.com/scherso)
; MIT License, take what u want :)
; Based on Darwins 'efi.h'. Repository location, 'darwin-xnu/pexpert/pexpert/i386/efi.h'
; Based on FASM's 'UEFI.inc'.

; Following structure is in accordance with
; UEFI Specifications Version 2.10 § 2.3.1
; Found in Table 2.3 "Common UEFI Data Types".

%macro UINT8 0      ; 8-bit integer, unsigned.
    RESB 1          ; Reserve 1 byte, which is 8 bits. 
    alignb 1
%endmacro

%macro UINT16 0     ; 16-bit integer, unsigned.
    RESW 1          ; Reserve 1 word, which is 16 bits, or 2 bytes.
    alignb 2
%endmacro

%macro UINT32 0     ; 32-bit integer, unsigned.
    RESD 1          ; Reserve a single precision real, which is 32 bits, or 4 bytes.
    alignb 4
%endmacro

%macro UINT64 0     ; 64-bit integer, unsigned.
    RESQ 1          ; Reserve a double precision real, which is 64 bits, or 8 bytes.
    alignb 8
%endmacro

%macro UINTN 0      ; Mnemonic for the native integer size of AMD64, 64-bits, unsigned.
    RESQ 1          ; Reserve a double precision real, which is 64 bits, or 8 bytes.
    alignb 8
%endmacro

%macro CHAR8 0      ; 8-bit character.
    RESB 1          ; Reserve one byte, which is 8 bits.
    alignb 1
%endmacro

%macro CHAR16 0     ; 16-bit character.
    RESW 1          ; Reserve one word, which is 16 bits, or 2 bytes.
    alignb 2
%endmacro

%macro PTR 0        ; 64-bit data pointer.
    RESQ 1          ; Reserve a double precision real, which is 64 bits, or 8 bytes.
    alignb 8
%endmacro

; Following mneumonics are in accordance with
; UEFI Specification Version 2.10 Appendix D
; Found in Table 238 "EFI_STATUS Code Ranges".
; 64-bit ranges in use, 32-bit ranges are not used.
EFI_ERROR equ 0x8000000000000000 ; Max: 0x9FFFFFFFFFFFFFFF 
EFI_WARN  equ 0x0000000000000000 ; Max: 0x1FFFFFFFFFFFFFFF 

; Following mneumonics are in accordance with
; UEFI Specification Version 2.10 Appendix D
; Found in Table D.3 "EFI_STATUS Error Codes (High Bit Set)".
EFI_SUCCESS                equ 0
EFI_LOAD_ERROR             equ EFI_ERROR | 1
EFI_INVALID_PARAMETER      equ EFI_ERROR | 2
EFI_UNSUPPORTED            equ EFI_ERROR | 3
EFI_BAD_BUFFER_SIZE        equ EFI_ERROR | 4
EFI_BUFFER_TOO_SMALL       equ EFI_ERROR | 5
EFI_NOT_READY              equ EFI_ERROR | 6
EFI_DEVICE_ERROR           equ EFI_ERROR | 7
EFI_WRITE_PROTECTED        equ EFI_ERROR | 8
EFI_OUT_OF_RESOURCES       equ EFI_ERROR | 9
EFI_VOLUME_CORRUPTED       equ EFI_ERROR | 10
EFI_VOLUME_FULL            equ EFI_ERROR | 11
EFI_NO_MEDIA               equ EFI_ERROR | 12
EFI_MEDIA_CHANGED          equ EFI_ERROR | 13
EFI_NOT_FOUND              equ EFI_ERROR | 14
EFI_ACCESS_DENIED          equ EFI_ERROR | 15
EFI_NO_RESPONSE            equ EFI_ERROR | 16
EFI_NO_MAPPING             equ EFI_ERROR | 17
EFI_TIMEOUT                equ EFI_ERROR | 18
EFI_NOT_STARTED            equ EFI_ERROR | 19
EFI_ALREADY_STARTED        equ EFI_ERROR | 20
EFI_ABORTED                equ EFI_ERROR | 21
EFI_ICMP_ERROR             equ EFI_ERROR | 22
EFI_TFTP_ERROR             equ EFI_ERROR | 23
EFI_PROTOCOL_ERROR         equ EFI_ERROR | 24
EFI_INCOMPATIBLE_VERSION   equ EFI_ERROR | 25
EFI_SECURITY_VIOLATION     equ EFI_ERROR | 26

; Following mneumonics are in accordance with
; UEFI Specification Version 2.10 Appendix D 
; Found in Table D.4 "EFI_STATUS Warning Codes (High Bit Clear)".
EFI_WARN_UNKNOWN_GLYPH     equ  EFI_WARN | 1
EFI_WARN_DELETE_FAILURE    equ  EFI_WARN | 2
EFI_WARN_WRITE_FAILURE     equ  EFI_WARN | 3
EFI_WARN_BUFFER_TOO_SMALL  equ  EFI_WARN | 4
EFI_WARN_STALE_DATA        equ  EFI_WARN | 5
EFI_WARN_FILE_SYSTEM       equ  EFI_WARN | 6
EFI_WARN_RESET_REQUIRED    equ  EFI_WARN | 7

; Value derived from UEFI Specifications Version 2.10 § 4.3.1
EFI_SYSTEM_TABLE_SIGNATURE equ 0x5453595320494249 

; Value derived from UEFI Specifications Version 2.10 § 12.9.2
EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID   db 0xDE, 0xA9, 0x42, 0x90, 0xDC, 0x23, 0x38, 0x4A 
                                    db 0x96, 0xFB, 0x7A, 0xDE, 0xD0, 0x80, 0x51, 0x6A

; Value derived from UEFI Specifications Version 2.10 § 12.3.1
EFI_SIMPLE_TEXT_INPUT_PROTOCOL_GUID db 0xC1, 0x77, 0x74, 0x38, 0xC7, 0x69, 0xD2, 0x11
                                    db 0x8E, 0x39, 0x00, 0xA0, 0xC9, 0x69, 0x72, 0x3B

; Value derived from UEFI Specifications Version 2.10 § 4.2.1
; "Data structure that precedes all of the standard EFI table types."
struc EFI_TABLE_HEADER
    .Signature                           UINT64
    .Revision                            UINT32
    .HeaderSize                          UINT32
    .CRC32                               UINT32
    .Reserved                            UINT32
endstruc

; Value derived from UEFI Specifications Version 2.10 § 4.3.1
; "Contains pointers to the runtime and boot services tables."
struc EFI_SYSTEM_TABLE
    .Hdr                                 RESB EFI_TABLE_HEADER_size
    .FirmwareVendor                      PTR
    .FirmwareRevision                    UINT32
    .ConsoleInHandle                     PTR
    .ConIn                               PTR
    .ConsoleOutHandle                    PTR
    .ConOut                              PTR
    .StandardErrorHandle                 PTR
    .StdErr                              PTR
    .RuntimeServices                     PTR
    .BootServices                        PTR
    .NumberOfTableEntries                UINTN
    .ConfigurationTable                  PTR
endstruc

; Value derived from UEFI Specifications Version 2.10 § 4.4.1
; "Contians a table header and pointers to all the boot services."
struc EFI_BOOT_SERVICES
    .Hdr                                 RESB EFI_TABLE_HEADER_size
    .RaiseTPL                            PTR
    .RestoreTPL                          PTR
    .AllocatePages                       PTR
    .FreePages                           PTR
    .GetMemoryMap                        PTR
    .AllocatePool                        PTR
    .FreePool                            PTR
    .CreateEvent                         PTR
    .SetTimer                            PTR
    .WaitForEvent                        PTR
    .SignalEvent                         PTR
    .CloseEvent                          PTR
    .CheckEvent                          PTR
    .InstallProtocolInterface            PTR
    .ReinstallProtocolInterface          PTR
    .UninstallProtocolInterface          PTR
    .HandleProtocol                      PTR
    .Reserved                            PTR
    .RegisterProtocolNotify              PTR
    .LocateHandle                        PTR
    .LocateDevicePath                    PTR
    .InstallConfigurationTable           PTR
    .LoadImage                           PTR
    .StartImage                          PTR
    .Exit                                PTR
    .UnloadImage                         PTR
    .ExitBootServices                    PTR
    .GetNextMonotonicCount               PTR
    .Stall                               PTR
    .SetWatchdogTimer                    PTR
    .ConnectController                   PTR
    .DisconnectController                PTR
    .OpenProtocol                        PTR
    .CloseProtocol                       PTR
    .OpenProtocolInformation             PTR
    .ProtocolsPerHandle                  PTR
    .LocateHandleBuffer                  PTR
    .LocateProtocol                      PTR
    .InstallMultipleProtocolInterfaces   PTR
    .UninstallMultipleProtocolInterfaces PTR
    .CalculateCrc32                      PTR
    .CopyMem                             PTR
    .SetMem                              PTR
    .CreateEventEx                       PTR
endstruc

; Value derived from UEFI Specifications Version 2.10 § 4.5.1
; "Contains a table header and pointers to all the runtime services."
struc EFI_RUNTIME_SERVICES
    .Hdr                                 RESB EFI_TABLE_HEADER_size
    .GetTime                             PTR
    .SetTime                             PTR
    .GetWakeupTime                       PTR
    .SetWakeupTime                       PTR
    .SetVirtualAddressMap                PTR
    .ConvertPointer                      PTR
    .GetVariable                         PTR
    .GetNextVariableName                 PTR
    .SetVariable                         PTR
    .GetNextHighMonotonicCount           PTR
    .ResetSystem                         PTR
    .UpdateCapsule                       PTR
    .QueryCapsuleCapabilities            PTR
    .QueryVariableInfo                   PTR
endstruc

; Value derived from UEFI Specifications Version 2.10 § 12.3.1
; "This protocol is used to obtain input from the ConsoleIn device."
struc EFI_SIMPLE_TEXT_INPUT_PROTOCOL
    .Reset                               PTR
    .ReadKeyStroke                       PTR
    .WaitForKey                          PTR
endstruc

; Value derived from UEFI Specifications Version 2.10 § 12.4.1
; "This protocol is used to control text-based output devices."
struc EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    .Reset                               PTR
    .OutputString                        PTR
    .TestString                          PTR
    .QueryMode                           PTR
    .SetMode                             PTR
    .SetAttribute                        PTR
    .ClearScreen                         PTR
    .SetCursorPosition                   PTR
    .EnableCursor                        PTR
    .Mode                                PTR
endstruc

; Value derived from UEFI Specifications Version 2.10 § 12.9.
; "The EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE is read-only and values \
; are only changed by using the appropriate interface functions."
struc EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE
    .MaxMode                             UINT32
    .Mode                                UINT32
    .Info                                PTR
    .SizeOfInfo                          UINTN
    .FrameBufferBase                     PTR
    .FrameBufferSize                     UINTN
endstruc

; Value derived from UEFI Specifications Version 2.10 § 12.9.2
; "Provides a basic abstraction to set video modes and copy pixels \
; to and from the graphics controller's frame buffer. The linear \
; address of the hardware frame buffer is also exposed so software \
; can write directly to the video hardware."
struc EFI_GRAPHICS_OUTPUT_PROTOCOL
    .QueryMode                           PTR
    .SetMode                             PTR
    .Blt                                 PTR
    .Mode                                PTR
endstruc
