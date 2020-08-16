; Include
include "hardware_define.asm"

; ROM Bank 0
; $0000~$3FFF
; -----
; Restart and Interrupt Vector Table
; $0000~$00FF
SECTION "RST00", rom0[$0000]
    ret 
SECTION "RST08", rom0[$0008]
    ret 
SECTION "RST10", rom0[$0010]
    ret 
SECTION "RST18", rom0[$0018]
    ret 
SECTION "RST20", rom0[$0020]
    ret 
SECTION "RST30", rom0[$0030]
    ret 
SECTION "RST38", rom0[$0038]
    ret
SECTION "VBlank", rom0[$0040]
    reti
SECTION "LCDC", rom0[$0048]
    reti 
SECTION "TIMER_OVERFLOW", rom0[$0050]
    reti 
SECTION "SERIAL", rom0[$0058]
    reti 
SECTION "JOYPAD", rom0[$0060]
    reti

; Cartridge Header
; $0100~$014F
SECTION "CARTRIDGE_HEADER", rom0[$0100]
ENTRY_POINT:       ; $0100-$0103
    nop 
    jp START
.NintendoLogo     ; $0104-$0133
    db $CE, $ED, $66, $66, $CC, $0D, $00, $0B
    db $03, $73, $00, $83, $00, $0C, $00, $0D
    db $00, $08, $11, $1F, $88, $89, $00, $0E
    db $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
    db $BB, $BB, $67, $63, $6E, $0E, $EC, $CC
    db $DD, $DC, $99, $9F, $BB, $B9, $33, $3E
; Uppercase ASCII 11 character
.CartridgeName    ; $0134-$0143
    db "TEMPLATEROM"
; Uppercase ASCII 4 character
.ManufacturerCode ; $013F-$0142
    db "MNCD"
; Support CGB: $80
;    CGB Only: $C0
;         DMG: $00
.CGBFlag          ; $0143
    db $00
; 2Byte ASCII
.NewLicenseeCode  ; $0144-$0145
    dw $0000
;      NO SGB: $00
; Support SGB: $03
.SGBFlag          ; $0146
    db $00
; Specifies Memory Bank Controller
.CartridgeType    ; $0147
    db $00
; 32KB shift "N"
.ROMSize          ; $0148
    db $00
; Size of external RAM
.RAMSize          ; $0149
    db $00
; Japanese: $00
;   Non-JP: $01
.DestinationCode  ; $014A
    db $00
; Range $00-$FF
.OldLicenseeCode  ; $014B
    db $33
; Usually $00
.MaskROM          ; $014C
    db $00
; Header checksum
.HeaderChecksum   ; $014D
    db $48 ; calculate checksum
.GlobalChecksum   ; $014E-$014F
    dw $8726 ; calculate checksum

; Program code
; $0150~$3FFF
SECTION "GAME_PROGRAM", rom0[$0150]
START:
.wait_vblank
    ld a, [r_LYC]
    cp d_SCREEN_WIDTH
    jr c, .wait_vblank
.clear_LCDC
    xor a
    ld [r_LCDC], a
.copy_tile_data
    ld hl, $9000
    ld de, TileData
    ld bc, TileDataEnd - TileData
.copy_tile_loop
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copy_tile_loop

    ld hl, $9800
    ld de, Tile+1
    ld bc, 32*32
    call COPY_TAILE

    ld hl, $9800
    ld de, Tile
    ld bc, 32*17
    call COPY_TAILE
.initialize
    ld a, %11100100
    ld [r_BGP], a

    xor a
    ld [r_SCY], a
    ld [r_SCX], a

    xor a
    ld [r_NR52], a

    ld a, %10000001
    ld [r_LCDC], a
.loop
    jr .loop

COPY_TAILE:
.copy_tile_label
    ld a, [de]
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, .copy_tile_label
    ret

; Tile Data
TileData:
    db $7C, $7C, $82, $82, $82, $82, $82, $82
    db $82, $82, $82, $82, $82, $82, $7C, $7C
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
TileDataEnd:

Tile:
    db $00, $01

; ROM Bank n
; $4000~$7FFF
; -----
SECTION "ROM_BANK_N", romx[$4000]
rept $7FFF-$4000
    db $00
endr

