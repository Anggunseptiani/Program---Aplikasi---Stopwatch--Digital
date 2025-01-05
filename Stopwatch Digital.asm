org 100h  ; Mengatur titik awal program untuk COM file

.data
msg_start db 'Stopwatch Started...', 0Dh, 0Ah, '$'
msg_stop db 'Stopwatch Stopped...', 0Dh, 0Ah, '$'
msg_reset db 'Stopwatch Reset.', 0Dh, 0Ah, '$'
msg_menu db '1. Start  2. Stop  3. Reset  4. Exit', 0Dh, 0Ah, '$'
msg_time db 'Elapsed Time (seconds): ', '$'
elapsed_time dw 0  ; Variabel untuk menyimpan waktu yang berlalu

.code
start:
    mov ah, 09h           ; Tampilkan menu utama
    lea dx, msg_menu
    int 21h

    mov ah, 01h           ; Ambil input dari pengguna
    int 21h
    sub al, '0'           ; Ubah input ASCII ke angka
    cmp al, 1             ; Pilihan 1: Start Stopwatch
    je start_stopwatch
    cmp al, 2             ; Pilihan 2: Stop Stopwatch
    je stop_stopwatch
    cmp al, 3             ; Pilihan 3: Reset Stopwatch
    je reset_stopwatch
    cmp al, 4             ; Pilihan 4: Exit
    je exit_program
    jmp start             ; Kembali ke menu jika input tidak valid

start_stopwatch:
    lea dx, msg_start     ; Tampilkan pesan start
    mov ah, 09h
    int 21h

simulate:
    inc word ptr elapsed_time  ; Tambahkan waktu
    lea dx, msg_time           ; Tampilkan waktu yang berjalan
    mov ah, 09h
    int 21h

    ; Konversi waktu menjadi angka dan cetak
    mov ax, elapsed_time
    call print_number

    ; Tunggu beberapa saat (simulasi delay)
    mov cx, 5000
delay_loop:
    loop delay_loop

    ; Kembali ke simulasi jika tidak dihentikan
    jmp simulate

stop_stopwatch:
    lea dx, msg_stop       ; Tampilkan pesan stop
    mov ah, 09h
    int 21h
    jmp start

reset_stopwatch:
    lea dx, msg_reset      ; Tampilkan pesan reset
    mov ah, 09h
    int 21h
    mov word ptr elapsed_time, 0 ; Reset waktu ke nol
    jmp start

exit_program:
    mov ah, 4Ch            ; Keluar dari program
    int 21h

print_number:
    ; Cetak angka desimal
    push ax
    push bx
    push cx
    xor cx, cx
    mov bx, 10
convert_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_loop
print_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_digits
    pop cx
    pop bx
    pop ax
    ret

end start