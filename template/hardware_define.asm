; Sound Controller
; Register: NR52 - Sound ON/OFF
r_NR52 EQU $FF26

; Video Display
; Register: LCD Control Register
r_LCDC EQU $FF40
; Register: LCD Position and Scrolling
r_SCY  EQU $FF42
r_SCX  EQU $FF43
r_LYC  EQU $FF44
; Register: LCD Monochrome Palettes
r_BGP  EQU $FF47

; Define: Screen Size
d_SCREEN_WIDTH  EQU 144
d_SCREEN_HEIGHT EQU 160