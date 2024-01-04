global hashf_krlose
global hashf_djb2
global hashf_sdbm
global hashf_jenkins_one_at_a_time

section .data
    djb2_seed equ 5381

section .text

;
; uint32_t hashf_rklose(const char *str) {
;     uint32_t hash = 0;
;     while (*str) {
;         hash += *str;
;         str++;
;     }
;     return hash;
; }
;
; store pointer to input data in rdi
; return hash in eax
hashf_krlose:
    xor eax, eax ; hash accum.
    xor ebx, ebx ; current byte
    .hashbyte:
        mov bl, byte[rdi]
        cmp bl, 0 ; end of the data
        jz .ret
        add eax, ebx ; hash += *str
        inc rdi
        jmp .hashbyte
    .ret:
        ret

;
; uint32_t hashf_djb2(const char *str) {
;     uint32_t hash = 5381;
;     while (*str) {
;         hash = ((hash << 5) + hash) + *str;
;         str++;
;     }
;     return hash;
; }
;
; store pointer to input data in rdi
; return hash in eax
hashf_djb2:
    mov eax, djb2_seed ; initialize hash
    xor ebx, ebx ; current byte
    xor edx, edx ; for bitwise shifts
    .hashbyte: ; for each byte of data (until zero is reached)
        mov bl, byte[rdi] ; take 1 byte from input data
        cmp bl, 0 ; end of the data
        jz .ret
        ; hash << 5
        mov edx, eax ; store hash value
        shl edx, 5
        ; + hash
        add eax, edx
        ; + *str
        add eax, ebx
        inc rdi
        jmp .hashbyte
    .ret:
        ret

;
; uint32_t hashf_sdbm(const char *str) {
;     uint32_t hash = 0;
;     while (*str) {
;         hash = *str + (hash << 6) + (hash << 16) - hash;
;         str++;
;     }
;     return hash;
; }
;
; store pointer to input data in rdi
; return hash in eax
hashf_sdbm:
    xor eax, eax ; hash accum.
    xor ebx, ebx ; current byte
    xor edx, edx ; for bitwise shifts
    xor ecx, ecx ; for bitwise shifts
    .hashbyte: ; for each byte of input data (until zero is reached)
        mov bl, byte[rdi]
        cmp bl, 0
        jz .ret
        ; hash << 6
        mov edx, eax
        shl edx, 6
        ; hash << 16
        mov ecx, eax
        shl ecx, 16
        add edx, ebx ; + *str
        add edx, ecx ; (hash << 6) + (hash << 16)
        sub edx, eax ; - hash
        mov eax, edx
        inc rdi
        jmp .hashbyte
    .ret:
        ret

;
; uint32_t hashf_jenkins_one_at_a_time(const char *str) {
;     uint32_t hash = 0;
;     while (*str) {
;         hash += *str;
;         hash += (hash << 10);
;         hash ^= (hash >> 6);
;         str++;
;     }
;     hash += (hash << 3);
;     hash ^= (hash >> 11);
;     hash += (hash << 15);
;     return hash;
; }
;
; store pointer to input data in rdi
; return hash in eax
hashf_jenkins_one_at_a_time:
    xor eax, eax ; hash accum.
    xor ebx, ebx ; current byte
    xor edx, edx ; for bitwise shifts
    .hashbyte:
        mov bl, byte[rdi] ; take 1 byte from input data
        cmp bl, 0
        jz .ret
        add eax, ebx ; hash += *str
        ; hash += (hash << 10)
        mov edx, eax
        shl edx, 10
        add eax, edx
        ; hash ^= (hash >> 6)
        mov edx, eax
        shr edx, 6
        xor eax, edx ; storing result in first argument (eax)
        inc rdi ; str++
        jmp .hashbyte
    .ret:
        ; hash += (hash << 3)
        mov edx, eax
        shl edx, 3
        add eax, edx
        ; hash ^= (hash >> 11)
        mov edx, eax
        shr edx, 11
        xor eax, edx
        ; hash += (hash << 15)
        mov edx, eax
        shl edx, 15
        add eax, edx

        ret
