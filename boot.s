[org 0x7C00]
use16

cli
mov bp, 0x7C00
mov sp, bp
sti

mov [boot_disk], dl

mov ax, 0x07E0
mov es, ax
xor bx, bx

mov ah, 0x02
mov al, 0x04
mov ch, 0x0
mov cl, 0x02
mov dh, 0x00
mov dl, [boot_disk]
int 0x13

jc failure

jmp 0x0:0x7E00

jmp $

failure:
	mov si, failed
	call print

	hlt

print:
	mov ah, 0x0e
.loop:
	mov al, [si]
	cmp al, 0x0
	je .pend

	int 0x10

	inc si
	jmp .loop
.pend:
	ret

failed: db 'Error reading disk', 0x0
boot_disk: db 0

times 510 - ($ - $$) db 0
dw 0xaa55
