; ヘッダ構成
SECTION "Header", rom0[$0100] ; ROMバンク0のカートリッジヘッダ
EntryPoint:
    di       ; 割り込み無効
    jp Start ; スタート処理へ
; nintendoロゴ: $0104~$0133
db $CE, $ED, $66, $66, $CC, $0D, $00, $0B
db $03, $73, $00, $83, $00, $0C, $00, $0D
db $00, $08, $11, $1F, $88, $89, $00, $0E
db $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
db $BB, $BB, $67, $63, $6E, $0E, $EC, $CC
db $DD, $DC, $99, $9F, $BB, $B9, $33, $3E
; タイトル: $0134~$013E
; 古いカートリッジだと$0134~0143までタイトル(15バイト)
db "HELLO_WORLD" ; 適当に決めた
; メーカーコード: $013F~$0142
db "LMDA"        ; 適当に決めた
; CGBフラグ: $0143 
db $00
; 新しいライセンスコード: $0144~$0145
db "XX"          ; 適当に決めた
; SGBフラグ: $0146 (非対応: 00h，対応: 03h)
db $03
; カートリッジタイプ: $0147
db $00
; ROMサイズ: $0148
db $00
; RAMサイズ: $0149
db $00
; 発売国コード: $014A
db $00
; 古いライセンスコード: $014B
db $33
; マスクROMバージョン: $014C
db $00
; チェックサム: $014D
db $88
; グローバルチェックサム: $014E~$014F
dw $ae01

SECTION "Game Code", rom0[$150]
Start:
    ; VRAMにアクセスするため，LCDをオフにする
.waitVBlank
    ; ゲームボーイ画面サイズは「160*144」
    ; LCDC-Yは「0~143」
    ld a, [$FF44] ; $FF44は「LCDC Y座標」
    cp a, 144     ; LCDC-Y座標が144ならば，VBLANK中
    jr c, .waitVBlank

    xor a, a      ; アキュームレータをリセット
    ; $FF40は「LCD制御(LCDC)」
    ld [$FF40], a ; $FF40の7bit目を0にする(LCD表示オフ)

    ; フォント取得処理
    ld hl, $9000                    ; CHR-ROM位置?
    ld de, FontTiles                ; フォント格納番地
    ld bc, FontTilesEnd - FontTiles ; フォント数
.copyFont
    ld a, [de]       ; メモリから1バイト取得
    ld [hli], a      ; VRAMに配置して，インクリメント 
    inc de           ; 次のメモリへ
    dec bc           ; 残り文字数のカウント
    ld a, b          ; decはフラグを更新しないので，bcのZフラグチェックを行う
    or a, c          ; a = b | c
    jr nz, .copyFont ; Zフラグがセットされるまで格納処理

    ; $9800~$9BFFはBG Map Data1
    ; 「32*32=1024」，「$9800-$9BFF=$3FF=1023」より1024バイト分ある
    ld hl, $9800         ; 画面左上を指定
    ld de, HelloWorldStr ; 文字列格納番地を指定
.copyString
    ; $9800番地に文字列を転送
    ld a, [de]
    ld [hli], a
    inc de
    and a, a           ; コピーした文字列のバイトが「0」であるかチェック
    jr nz, .copyString

    ; 各種レジスタの初期化
    ; 色指定
    ld a, %11100100 ; 黒，濃グレー，薄グレー，白
    ld [$FF47], a   ; $FF47は「背景パレットデータ(BGP)」
    ; 画面位置
    xor a, a      ; アキュームレータのクリア
    ld [$FF42], a ; LCDC-Yを0
    ld [$FF43], a ; LCDC-Xを0
    ; サウンド設定
    ; $FF26は「サウンドオン・オフ切り替え」
    ld [$FF26], a   ; サウンドオフ(bit-7が0)
    ; LCDC
    ld a, %10000001 ; LCD表示有効，背景表示
    ld [$FF40], a
.lockup
    ; 無限ループ
    jr .lockup

SECTION "Font", rom0
FontTiles:
    INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello World string", rom0
HelloWorldStr:
    db "HELLO, WORLD!", 0 ; 表示文字列＋終端文字(今回は0)

; 残りのROMを0埋めする
SECTION "PADDING", romx
rept $7fff - $4000
    db 0
endr