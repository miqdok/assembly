.MODEL small

.386

.STACK 100h

.DATA

helpMessage db "This program compares two files and outputs their differences", 10, "Enter the file names in this format: [file1].txt [file2].txt [result].txt", 10, "File names can not be longer than 20 symbols$"

buffer1 db 10 dup("0"); 0 0 0 0 0 0 0 0 0 0
buffer2 db 10 dup("0")
bufferw db ':', ' ', ?, ' ', ?, 10
buffern db 10 dup("0")

failas1 dw 20 dup (0)
failas2 dw 20 dup (0)
failasw dw 20 dup (0)

fhandle1 dw ?
fhandle2 dw ?
fhandlew dw ?

diffCount dw 0
index dw 1
numSize dw 0
buffSize1 dw ?
buffSize2 dw ?
buffSizeHighest dw ? ; jei buffSizeHighest mazesnis uz 10, tai jmp i galutini nuskaityma
buffSizeLowest dw ?
buffSizeDiff dw ?

.CODE
start:
	mov ax, @data
	mov ds, ax
	mov ax, 0
	
	mov bx, 82h ;ES konstanta
	mov si, offset failas1
	
check_1:
	mov ax, es:[bx]
	inc bx
	cmp al, ' '
	je check_1_end
	cmp al, 13
	je help
	cmp ax, "?/"
	je help
	mov byte ptr [si], al
	inc si
	jmp check_1
	
check_1_end:
	mov si, offset failas2
	
check_2:
	mov ax, es:[bx]
	inc bx
	cmp al, ' '
	je check_2_end
	cmp al, 13
	je help
	cmp ax, "?/"
	je help
	mov byte ptr [si], al
	inc si
	jmp check_2
	
check_2_end:
	mov si, offset failasw

check_3:
	mov ax, es:[bx]
	inc bx
	cmp al, 13
	je continue
	cmp al, ' '
	je help
	cmp ax, "?/"
	je help
	mov byte ptr [si], al
	inc si
	jmp check_3
	
help:
	mov dx, offset helpMessage
	mov ah, 09h
	int 21h
	jmp program_end
	
continue:
	;Atidaryti failas1
	mov dx, offset failas1
	call open_file
	mov fhandle1, ax
	
	;Atidaryti failas2
	mov dx, offset failas2
	call open_file
	mov fhandle2, ax
	
	;Sukurti faila
	mov al, 0
	mov ah, 3Ch
	mov cx, 0
	mov dx, offset failasw
	int 21h
	mov fhandlew, ax

read:
	;Skaityti is failas1 i buffer1
	mov bx, fhandle1
	mov dx, offset buffer1
	call read_to_buffer
	mov buffSize1, ax
	
	;Skaityti is failas2 i buffer2
	mov bx, fhandle2
	mov dx, offset buffer2
	call read_to_buffer
	mov buffSize2, ax
	
	jmp different
	
different_end:
	;jei pasiekta failo pabaiga
	cmp buffSizeHighest, 0
	je compare_end
	
	;Lyginimo buffer1 ir buffer2 pradzia
	mov si, offset buffer1 ;Bufferiu adresai
	mov bx, offset buffer2
	mov cx, buffSizeHighest ;Ciklu kartojimo skaicius
	
compare:
	push cx ;Idedam ciklku kartojimo sk. i stacka, nes cx naudosime kaip buffer2 reiksme
	cmp buffSizeLowest, 0
	je fillWithSpace_start
fillWithSpace_end:
	mov ax, [si] ;Buffer1 reiksme
	mov cx, [bx] ;Buffer2 reiksme
	cmp al, cl ;al/cl yra pirmoji reiksme, ah/ch - antroji
	jne write_diff
after_write_diff:
	pop cx ;Po irasymo i cx grazinam ciklu sk. reiksme
	inc si
	inc bx
	inc index ;Padidinam failo pozicijos indeksa
	dec buffSizeLowest
	loop compare
	jmp compare_end ;Pasibaigus ciklui sokame i palyginimo pabaiga
	
write_diff:
	inc diffCount
	;Reiksmes irasom i bufferw
	mov di, offset bufferw ;Rasymo bufferis
	push bx ;buffer2 adresa idedam i stacka, nes bx naudojamas kaip failo deskriptorius
	call indexNumber
	mov byte ptr [di+2], al
	mov byte ptr [di+4], cl
	;bufferw uzrasom i failasw
	mov bx, fhandlew
	mov cx, 6 ;Kiek baitu irasyti
	mov dx, di ;Kokius duomenis irasyti
	mov ah, 40h
	mov al, 0
	int 21h
	pop bx ;Grazinam bx pradine reiksme
	jmp after_write_diff
	
fillWithSpace_start:
  mov cx, buffSizeDiff
  push si
	push bx
	mov ax, buffSize1
	cmp ax, buffSize2
	jg buffSize1_greater
buffSize2_greater:
	mov byte ptr [si], ' '
	inc si
	loop buffSize2_greater
	pop bx
	pop si
	jmp fillWithSpace_end
buffSize1_greater:
	mov byte ptr [bx], ' '
	inc bx
	loop buffSize1_greater
	pop bx
	pop si
	jmp fillWithSpace_end
	
different:
	mov ax, buffSize2
	cmp buffSize1, ax
	jg greater
	mov buffSizeHighest, ax
	mov ax, buffSize1
	mov buffSizeLowest, ax
	jmp different_continue
greater:
	mov ax, buffSize1
	mov buffSizeHighest, ax
	mov ax, buffSize2
	mov buffSizeLowest, ax
different_continue:
	mov ax, buffSizeHighest
	sub ax, buffSizeLowest
	mov buffSizeDiff, ax
	jmp different_end
	
compare_end:
	;Tikriname, ar baitu buvo nuskaityta maziau, nei bufferio dydis
	mov ax, buffSizeHighest
	cmp ax, 10
	je read

	;Uzdaryti failas1
	mov bx, fhandle1
	call close_file
	
	;Uzdaryti failas2
	mov bx, fhandle2
	call close_file

program_end:
	mov ah, 4Ch
	mov al, 0
	cmp diffCount, 0
	je program_end_files_equal
	mov al, 1
program_end_files_equal:	
	int 21h
	
open_file proc 
	mov al, 0
	mov ah, 3Dh
	int 21h
	jc help
	ret
open_file endp

read_to_buffer proc 
	mov ah, 3Fh
	mov al, 0
	mov cx, 10
	int 21h
	ret
read_to_buffer endp

close_file proc 
	mov ah, 3Eh
	int 21h
	ret
close_file endp

indexNumber proc 
	push ax ;Idedam registru reiksmes i stacka, kad ju nepamestume
	push bx
	push cx
	push dx
	push si
	
	mov ax, index
	mov bx, 0
	mov cx, 10
	mov dx, 0
	
conversion:
	div cx ;DX:AX, DX - liekana
	push dx
	mov dx, 0
	inc bx ;Didiname po 1, kad surasti skaiciaus ilgi
	cmp ax, 0
	jne conversion
	
	mov si, offset buffern ;I si idedam skaiciu rasymo bufferio adresa
	mov numSize, bx
	mov cx, numSize ;numSize - kiek skaiciu simboliu
	
output:
	pop ax ;Is stacko isimam gauta liekana
	add al, 48
	mov byte ptr [si], al
	inc si
	loop output
	
	;Irasom skaiciu bufferi i faila
	mov cx, numSize
	mov ah, 40h
	mov bx, fhandlew
	mov dx, offset buffern
	int 21h
	
	pop si ;Registrams graziname ju pradines reiksmes
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp indexNumber 
	
end start