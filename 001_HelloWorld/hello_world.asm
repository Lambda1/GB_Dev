SECTION "Header", rom0[$100]

EntryPoint:
    di
    jp Start

rept $150 - $104
    db 0
endr

SECTION "Game Code", rom0

Start:
    
.waitVBlank
    ld a, [$ff44]
    cp 144
    jr c, .waitVBlank

    xor a
    ld [$ff40], a

    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyFont

    ld hl, $9800
    ld de, HelloWorldStr
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString

    ld a, %11100100
    ld [$ff47], a

    xor a
    ld [$ff42], a
    ld [$ff43], a

    ld [$ff26], a
    ld a, %10000001
    ld [$ff40], a
.lockup
    jr .lockup

SECTION "Font", rom0

FontTiles:
    INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello World string", rom0

HelloWorldStr:
    db "HELLO, WORLD!", 0