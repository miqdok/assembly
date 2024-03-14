.model small
.stack 100h

.data
oneChar db ?                             ; Змінна для зберігання одного символу

.code
main PROC
    mov ax, @data                        ; Initialize data segment
    mov ds, ax
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
