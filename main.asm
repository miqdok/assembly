.model small
.stack 100h

.data
substring db 255 dup(0)                      ; Змінна для зберігання командного рядка
substringLength db ?                         ; Змінна для зберігання довжини командного рядка
mainString db 255 dup(0)                     ; Змінна для зберігання одного символу
count dw ?                                   ; Змінна для зберігання кількості входжень підрядка

.code
main PROC
    mov ax, ds
    mov es, ax                               ; Збереження сегменту PSP в ES для доступу до аргументів командного рядка
    
    mov ax, @data                            ; Ініціалізування сегменту даних
    mov ds, ax

    xor ah, ah
    mov al, es:[80h]  
    dec al                   
    mov substringLength, al                  ; Збереження довжини аргументу командного рядка

    mov si, 82h                              ; Початок аргументу командного рядка
    mov di, offset substring                 ; Призначення(місце) аргументу командного рядка
    mov cl, substringLength

copy_substring:
    mov al, es:[si]                          ; Копіювання аргументу командного рядка до параметра 
    mov [di], al                             ; Копіювання аргументу до масиву параметрів
    inc si
    inc di
    dec cl
    cmp cl, 0
    jne copy_substring                       ; Повторення циклу, поки не буде скопійовано всі аргументи

    mov ah, 3Fh
    lea dx, mainString                       ; Завантаження адреси основного рядка в DX
    mov cx, 255                              ; Завантаження довжини основного рядка в CX
    int 21h                                  ; Виклик DOS interrupt для зчитування рядка

    call CountSubstring                      ; Виклик підпрограми для підрахунку підрядків

end_program:
    mov ax, 4C00h                            ; Завершення програми
    int 21h                                  ; Виклик DOS interrupt

main ENDP

CountSubstring proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov count, 0                             ; Ініціалізація каунтера

    mov si, offset mainString                ; Завантаження адреси рядка в SI
    mov di, offset substring                 ; Завантаження адреси підрядка в DI

    mov cl, substringLength                  ; Завантаження довжини підрядка в CL

    mov bx, 0                                ; Ініціалізація індексу BX

    find_substring: 
        mov dx, si                           ; Збереження поточної позиції в основному рядку

    compare_chars:  
        mov al, [si]                         ; Завантаження символу з рядка в AL
        mov ah, [di]                         ; Завантаження символу з підрядка в AH
        inc si                               ; Збільшуємо на 1 індекс основного рядка
        inc di                               ; Інкрементуємо індекс підрядка
        cmp al, ah                           ; Порівняння символів
        jne reset_substring                  ; Якщо не рівні, скидаємо індекс підрядка
        dec cl                               ; Зменшуємо на 1 каунтер довжини підрядка
        jnz compare_chars                    ; Якщо каунтер довжини підрядка не дорівнює 0, продовжуємо порівняння

        inc count                            ; Збільшуємо на 1 лічильник збігів підрядка
        mov cl, substringLength              ; Перезавантаження каунтера довжини підрядка
        mov di, offset substring             ; Перезавантаження індексу підрядка

        add bx, cx                           ; Переміщення індексу BX на наступний елемент після знайденого підрядка
        jmp continue_search                  ; Продовжуємо пошук з наступного елементу

    reset_substring:
        mov si, dx                           ; Відновлення позиції в основному рядку
        inc si                               ; Перехід до наступного символу в основному рядку
        mov di, offset substring             ; Перезавантаження індексу підрядка
        mov cl, substringLength              ; Перезавантаження каунтера довжини підрядка

        inc bx                               ; Збільшуємо на 1 індекс BX
    continue_search:
        cmp [byte ptr mainString + bx], 0    ; Перевірка, чи досягнуто кінця основного рядка
        jne find_substring                   ; Якщо ні, продовжуємо пошук підрядка

        mov ah, 02h                          ; Код функції stdout
        mov dx, count                        ; Кількість збігів підрядка
        add dl, 30h                          ; Конвертація кількості входжень в ASCII
        int 21h                              ; Виклик DOS interrupt для виведення символів

        pop di                               ; Відновлення значень реєстрів
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret                                  ; Повернення з підпрограми
CountSubstring endp

end main
