;Restart address
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

; Interrupt start address
SECTION "VBlank", rom0[$0040]
    jp VBLANK
SECTION "LCDC", rom0[$0048]
    reti 
SECTION "TIMER_OVERFLOW", rom0[$0050]
    reti 
SECTION "SERIAL", rom0[$0058]
    reti 
SECTION "JOYPAD", rom0[$0060]
    reti 

SECTION "BAKN0", rom0[$0061]

SECTION "HEADER", rom0[$0100]
    nop 
    jp START

SECTION "GAME_PROGRAM", rom0[$0150]
START:
.loop
    halt 
    jr .loop

VBLANK:
    reti