SECTION "START", ROM[$0100]
    nop
    jp PROGRAM
; rgbfixするため，$FFで初期化
REPT $0150 - $0104
    db $FF
ENDR

SECTION "PROGRAM", ROM[$0150]
PROGRAM:
    nop
    di
    ld sp, $FFFF

INITIALIZE:
    ; BGP
    ld a, %11100100
    ld [$FF47], a
    ; POSITION
    ld a, 0
    ld [$FF42], a
    ld [$FF43], a