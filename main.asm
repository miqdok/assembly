.model small
.stack 100h

.data
substring db 255 dup(0)                  ; Змінна для зберігання командного рядка
substringLength db ?                     ; Змінна для зберігання довжини командного рядка
mainString db 255 dup(0)                 ; Змінна для зберігання одного символу

.code
main PROC
    mov ax, ds
    mov es, ax                           ; Збереження сегменту PSP в ES для доступу до аргументів командного рядка
    
    mov ax, @data                        ; Ініціалізування сегменту даних
    mov ds, ax

    xor ah, ah
    mov al, es:[80h]                     
    mov substringLength, al              ; Збереження довжини аргументу командного рядка

    mov si, 82h                          ; Початок аргументу командного рядка
    mov di, offset substring             ; Призначення(місце) аргументу командного рядка
    mov cl, substringLength

copy_substring:
    mov al, es:[si]                      ; Копіювання аргументу командного рядка до параметра 
    mov [di], al                         ; Копіювання аргументу до масиву параметрів
    inc si
    inc di
    dec cl
    cmp cl, 0
    jne copy_substring                   ; Повторення циклу, поки не буде скопійовано всі аргументи

    xor ax, ax
    mov di, offset substring
    mov cl, substringLength

    mov ah, 3Fh
    lea dx, mainString                   ; Завантаження адреси основного рядка в DX
    mov cx, 255                          ; Завантаження довжини основного рядка в CX
    int 21h


end_program:
    mov ax, 4C00h                        ; Завершення програми
    int 21h                              ; Виклик DOS interrupt

main ENDP
end main
