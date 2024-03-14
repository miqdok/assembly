.model small
.stack 100h

.data
substring db 255 dup(0)                  ; Змінна для зберігання командного рядка
substringLength db ?                     ; Змінна для зберігання довжини командного рядка
oneChar db ?                             ; Змінна для зберігання одного символу

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
print_substring:
    mov ah, 02h                          ; Функція виводу символу
    mov dl, [di]                         ; Завантаження символу для виводу
    int 21h                              ; Виклик DOS interrupt
    inc di
    dec cl
    cmp cl, 0
    jne print_substring

    mov dl, 0Ah                          ; Новий рядок
    int 21h

read_next:
    mov ah, 3Fh                          ; Зчитування символа з stdin
    mov bx, 0h                           ; stdin handle
    mov cx, 1                            ; 1 byte to read
    mov dx, offset oneChar               ; read to ds:dx 
    int 21h                              ; ax = number of bytes read
    
    ; Перевірка на кінець файлу (EOF)
    or ax, ax
    jz end_program

    ; Виведення зчитаного символу на stdout
    mov ah, 02h                          ; Функція виводу символу
    mov dl, [oneChar]                    ; Завантаження символу для виводу
    int 21h                              ; Виклик DOS interrupt

    jmp read_next                        ; Повторення процесу зчитування

end_program:
    mov ax, 4C00h                        ; Завершення програми
    int 21h                              ; Виклик DOS interrupt

main ENDP
end main
