[org 0x7E00]
use16

jmp enter_protected_mode

%include "gdt.asm"

enter_protected_mode:
	call enablea20
	cli
	lgdt [gdt_desc]

	mov eax, cr0
	or eax, 1
	mov cr0, eax
	
	jmp codeseg:start_pm

enablea20:
	in al, 0x92
	or al, 0x02
	out 0x92, al
	ret

[bits 32]

%include "cpuid.asm"
%include "simple_paging.asm"

start_pm:
	mov ax, dataseg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov [0xb8000], byte 'H'	

	call detect_cpuid
	call detect_long_mode
	call set_up_id_paging
	call EditGDT
	jmp codeseg:start_long

[bits 64]
start_long:
	mov edi, 0xb8000
	mov rax, 0x1f201f201f201f20
	mov ecx, 500
	rep stosq
	jmp $

times 2048 - ($ - $$) db 0
