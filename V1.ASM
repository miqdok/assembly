.model tiny
.code   
ORG 0100h
start:


    mov ah, 02h
    mov dl, '1'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '1'
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, '3'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '0'
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ax, 4C00h
    int 21h


end start

