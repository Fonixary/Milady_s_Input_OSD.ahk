;  Milady's Input on Screen Display - a light weight plug-script to showing the current input status for mouse and keyboard.
;    Copyright (C) 2026  Fonixary / fnxr.org
;
;    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
;
;    This program is distributed in the hope that it will be useful and for share the fun, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

#Requires AutoHotkey v2.0
#SingleInstance Force
A_MaxHotkeysPerInterval := 1000  ; Increase the allowed hotkey firing limit to prevent warning popups


; ==============================================================================
; 🎛️ CONFIGURATION CONSTANTS (EDIT FREELY HERE)
; ==============================================================================
global CFG_KEY_TIMEOUT   := 400   ; Full brightness duration per block (ms)
global CFG_FADE_DURATION := 2000  ; Fade duration per block (ms)
global TRANSPARENT_COLOR := "000000"  ; Magenta chroma key for background transparency

global BLOCK_SIZE        := 60    ; Width and height of each square block (50x50)
global BLOCK_SPACING     := 10    ; Horizontal spacing/gap between blocks in the queue
global CORNER_RADIUS     := 2     ; Rounded corner radius in pixels (2 px)
global TEXT_TOP_OFFSET   := 6     ; Vertical offset for text from the top border
global TEXT_LEFT_OFFSET  := 6     ; Left margin offset for text so it matches single blocks nicely

; --- Extra Manual Padding for Multiplier Expansion ---
global EXTRA_WIDTH_PADDING := 24  ; Extra pixels added to width per extra character when multiplied (expands rightward)

; --- Positioning & Alignment Configuration ---
global EDGE_OFFSET_Y     := 20    ; Space in px from the top or bottom window edge
global EDGE_OFFSET_X     := 20    ; Space in px from the left or right window edge
global VERTICAL_ALIGN    := 1     ; 0 = Align to Top, 1 = Align to Bottom
global HORIZONTAL_ALIGN  := 0     ; 0 = Align to Left, 1 = Align to Right (grows right-to-left)

; --- Hold Background Colors (Keyboard vs Mouse) ---
global HOLD_BG_COLOR_KEY   := "49434C"  ; Red background fill when holding a keyboard key
global HOLD_BG_COLOR_MOUSE := "49434C"  ; Blue background fill when holding a mouse button

; --- Text Colors (Keyboard vs Mouse) ---
global TEXT_COLOR_KEY      := "F9C9DB"  ; White text for keyboard labels
global TEXT_COLOR_MOUSE    := "BDEBFF"  ; Yellow-tinted text for mouse labels

global FONT_NAME         := "XiQueGuZiDianTiJFT"   ; Editable font family name
global FONT_SIZE         := 20    ; Font size fitted for 50x50 square
global FONT_SIZE_F_KEYS  := 16    ; Font size specifically for F10-F24 keys


; --- Editable Display Labels ---

; --- Letters (A-Z) ---
global LABEL_A := "欸"
global LABEL_B := "闭"
global LABEL_C := "西"
global LABEL_D := "地"
global LABEL_E := "亿"
global LABEL_F := "挨斧"
global LABEL_G := "记"
global LABEL_H := "诶取"
global LABEL_I := "埃"
global LABEL_J := "街"
global LABEL_K := "开"
global LABEL_L := "哀藕"
global LABEL_M := "按"
global LABEL_N := "嗯"
global LABEL_O := "鸥"
global LABEL_P := "批"
global LABEL_Q := "抠"
global LABEL_R := "啊"
global LABEL_S := "诶死"
global LABEL_T := "替"
global LABEL_U := "优"
global LABEL_V := "微"
global LABEL_W := "达彼"
global LABEL_X := "诶呲"
global LABEL_Y := "外"
global LABEL_Z := "仄"

; --- Numbers (0-9) ---
global LABEL_0 := "〇"
global LABEL_1 := "壹"
global LABEL_2 := "贰"
global LABEL_3 := "叁"
global LABEL_4 := "肆"
global LABEL_5 := "伍"
global LABEL_6 := "陆"
global LABEL_7 := "柒"
global LABEL_8 := "捌"
global LABEL_9 := "玖"

; --- Function Keys (F1-F24) ---
global LABEL_F1  := "F1"
global LABEL_F2  := "F2"
global LABEL_F3  := "F3"
global LABEL_F4  := "F4"
global LABEL_F5  := "F5"
global LABEL_F6  := "F6"
global LABEL_F7  := "F7"
global LABEL_F8  := "F8"
global LABEL_F9  := "F9"
global LABEL_F10 := "F10"
global LABEL_F11 := "F11"
global LABEL_F12 := "F12"
global LABEL_F13 := "F13"
global LABEL_F14 := "F14"
global LABEL_F15 := "F15"
global LABEL_F16 := "F16"
global LABEL_F17 := "F17"
global LABEL_F18 := "F18"
global LABEL_F19 := "F19"
global LABEL_F20 := "F20"
global LABEL_F21 := "F21"
global LABEL_F22 := "F22"
global LABEL_F23 := "F23"
global LABEL_F24 := "F24"

; --- Symbols & Punctuation ---
global LABEL_DASH        := "杠"
global LABEL_EQUALS      := "等"
global LABEL_LBRACKET    := "左方"
global LABEL_RBRACKET    := "右方"
global LABEL_BACKSLASH   := "斜反"
global LABEL_SEMICOLON   := "分"
global LABEL_QUOTE       := "撇"
global LABEL_COMMA       := "逗"
global LABEL_PERIOD      := "句"
global LABEL_SLASH       := "斜"
global LABEL_BACKTICK    := "后撇"
global LABEL_TILDE       := "到"
global LABEL_EXCLAM      := "叹"
global LABEL_AT          := "在"
global LABEL_HASH        := "井"
global LABEL_DOLLAR      := "刀"
global LABEL_PERCENT     := "啪"
global LABEL_CARET       := "上"
global LABEL_AMPERSAND   := "和"
global LABEL_ASTERISK    := "星"
global LABEL_LPAREN      := "左括"
global LABEL_RPAREN      := "右括"
global LABEL_UNDERSCORE  := "下划"
global LABEL_PLUS        := "加"
global LABEL_LCURLY      := "左弧"
global LABEL_RCURLY      := "右弧"
global LABEL_PIPE        := "棍"
global LABEL_COLON       := "冒"
global LABEL_DQUOTE      := "引"
global LABEL_LT          := "小"
global LABEL_GT          := "大"
global LABEL_QUESTION    := "问"

; --- Special & Mouse Keys ---
global LABEL_SPACE       := "空"
global LABEL_ENTER       := "换"
global LABEL_BKSP        := "退"
global LABEL_DEL         := "删"
global LABEL_TAB         := "图"
global LABEL_ESC         := "跑"
global LABEL_UP          := "上"
global LABEL_DOWN        := "下"
global LABEL_LEFT        := "左"
global LABEL_RIGHT       := "右"
global LABEL_CTRL        := "控"
global LABEL_SHIFT       := "档"
global LABEL_ALT         := "助"
global LABEL_LMB         := "左鼠"
global LABEL_RMB         := "右鼠"
global LABEL_MMB         := "轮"
global LABEL_X1          := "姆一"
global LABEL_X2          := "姆二"
global LABEL_WIN        := "窗"
global LABEL_CAPS_ON   := "锁"
global LABEL_CAPS_OFF  := "解"


; ==============================================================================
; 🚀 APPLICATION LOGIC
; ==============================================================================
global TargetWindow  := ""
global ActiveBlocks  := []        ; Queue array holding active block objects

; Automatically register full keyboard keys & mouse buttons
keysToTrack := [
    ; Letters
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    ; Numbers & Row Symbols
    "0","1","2","3","4","5","6","7","8","9",
    ; Punctuation & Special Characters (Safely escaped)
    "-", "=", "[", "]", "\", ";", "'", ",", ".", "/", "``",
    ; Shifted Row Symbols / Extra Keys
    "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "{", "}", "|", ":", "`"", "<", ">", "?",
    ; Function Keys F1 - F24
    "F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",
    "F13","F14","F15","F16","F17","F18","F19","F20","F21","F22","F23","F24",
    ; Action & Navigation Keys
    "Space", "Enter", "Backspace", "Delete", "Tab", "Escape",
    "Up", "Down", "Left", "Right",
    ; Modifier Keys
    "LCtrl", "RCtrl", "LShift", "RShift", "LAlt", "RAlt", "LWin", "RWin", "CapsLock",
    ; 5-Key Mouse Support
    "LButton", "RButton", "MButton", "XButton1", "XButton2"
]

for k in keysToTrack {
    try Hotkey("~*" k, HandleKey.Bind(k))
}

; Main Render & Position Tracking Loop (runs every 20ms for smooth 50 FPS updates)
SetTimer(OverlayTick, 20)

OverlayTick() {
    global TargetWindow, ActiveBlocks
    
    if (ActiveBlocks.Length = 0)
        return
        
    if (!WinExist(TargetWindow)) {
        DestroyAllBlocks()
        return
    }
    
    ; Get target window coordinates
    WinGetPos(&outX, &outY, &outW, &outH, TargetWindow)
    if (outX = -32000)
        return
        
    totalDuration := CFG_KEY_TIMEOUT + CFG_FADE_DURATION
    totalItems := ActiveBlocks.Length
    
    ; Safely iterate backwards using a while loop to prevent index out-of-bounds errors
    i := totalItems
    while (i > 0 && i <= ActiveBlocks.Length) {
        block := ActiveBlocks[i]
        
        ; Check if the key/mouse button is currently physically held down
        isHeld := GetKeyState(block.rawKey, "P")
        
        if (isHeld) {
            ; If it's held, continuously refresh startTime so it NEVER fades while held down!
            block.startTime := A_TickCount
            block.wasReleased := false  ; Mark that it is currently being held down
            
            if (block.holdStartTime = 0) {
                block.holdStartTime := A_TickCount
            }
            holdDuration := A_TickCount - block.holdStartTime
            showFill := (holdDuration > 100)
        } else {
            block.holdStartTime := 0
            showFill := false
            block.wasReleased := true  ; Mark that the key has been physically released
            
            ; Once released, check regular elapsed timeout against the last release time
            elapsed := A_TickCount - block.startTime
            if (elapsed >= totalDuration) {
                try block.gui.Destroy()
                ActiveBlocks.RemoveAt(i)
                i--
                continue
            }
        }
        
        ; Calculate opacity (if held, opacity stays locked at full 255 brightness)
        if (isHeld || (A_TickCount - block.startTime < CFG_KEY_TIMEOUT)) {
            opacity := 255
        } else {
            fadeElapsed := (A_TickCount - block.startTime) - CFG_KEY_TIMEOUT
            opacity := Integer(255 * (1 - (fadeElapsed / CFG_FADE_DURATION)))
        }
        
        ; Toggle background fill visibility cleanly
        block.fillCtrl.Visible := showFill
        
        ; Calculate vertical position (Y)
        if (VERTICAL_ALIGN = 1) {
            yOffset := outH - BLOCK_SIZE - EDGE_OFFSET_Y
        } else {
            yOffset := EDGE_OFFSET_Y
        }
        
        currWidth := block.currentWidth
        
        ; Calculate horizontal position (X) and stack direction with dynamic widths
        if (HORIZONTAL_ALIGN = 1) {
            ; Right-aligned, growing leftwards: oldest item (i=1) sits at right edge
            rightAnchor := outW - EDGE_OFFSET_X
            cumulativeWidth := 0
            Loop i {
                j := A_Index
                cumulativeWidth += ActiveBlocks[j].currentWidth + (j > 1 ? BLOCK_SPACING : 0)
            }
            xOffset := rightAnchor - cumulativeWidth
        } else {
            ; Left-aligned: oldest item anchors to left edge, newer items stack to the right
            xOffset := EDGE_OFFSET_X
            Loop i - 1 {
                j := A_Index
                xOffset += ActiveBlocks[j].currentWidth + BLOCK_SPACING
            }
        }
        
        try {
            block.gui.Show("X" (outX + xOffset) " Y" (outY + yOffset) " W" currWidth " H" BLOCK_SIZE " NoActivate")
            WinSetTransColor(TRANSPARENT_COLOR " " opacity, block.gui)
        }
        
        i--
    }
}

GetDisplayLabel(keyName) {
    global LABEL_A, LABEL_B, LABEL_C, LABEL_D, LABEL_E, LABEL_F, LABEL_G, LABEL_H
    global LABEL_I, LABEL_J, LABEL_K, LABEL_L, LABEL_M, LABEL_N, LABEL_O, LABEL_P
    global LABEL_Q, LABEL_R, LABEL_S, LABEL_T, LABEL_U, LABEL_V, LABEL_W, LABEL_X
    global LABEL_Y, LABEL_Z
    global LABEL_0, LABEL_1, LABEL_2, LABEL_3, LABEL_4, LABEL_5, LABEL_6, LABEL_7, LABEL_8, LABEL_9
    global LABEL_F1, LABEL_F2, LABEL_F3, LABEL_F4, LABEL_F5, LABEL_F6, LABEL_F7, LABEL_F8
    global LABEL_F9, LABEL_F10, LABEL_F11, LABEL_F12, LABEL_F13, LABEL_F14, LABEL_F15, LABEL_F16
    global LABEL_F17, LABEL_F18, LABEL_F19, LABEL_F20, LABEL_F21, LABEL_F22, LABEL_F23, LABEL_F24
    global LABEL_DASH, LABEL_EQUALS, LABEL_LBRACKET, LABEL_RBRACKET, LABEL_BACKSLASH
    global LABEL_SEMICOLON, LABEL_QUOTE, LABEL_COMMA, LABEL_PERIOD, LABEL_SLASH, LABEL_BACKTICK
    global LABEL_TILDE, LABEL_EXCLAM, LABEL_AT, LABEL_HASH, LABEL_DOLLAR, LABEL_PERCENT
    global LABEL_CARET, LABEL_AMPERSAND, LABEL_ASTERISK, LABEL_LPAREN, LABEL_RPAREN
    global LABEL_UNDERSCORE, LABEL_PLUS, LABEL_LCURLY, LABEL_RCURLY, LABEL_PIPE
    global LABEL_COLON, LABEL_DQUOTE, LABEL_LT, LABEL_GT, LABEL_QUESTION
    global LABEL_SPACE, LABEL_ENTER, LABEL_BKSP, LABEL_DEL, LABEL_TAB, LABEL_ESC
    global LABEL_UP, LABEL_DOWN, LABEL_LEFT, LABEL_RIGHT
    global LABEL_CTRL, LABEL_SHIFT, LABEL_ALT, LABEL_WIN
    global LABEL_CAPS_ON, LABEL_CAPS_OFF
    global LABEL_LMB, LABEL_RMB, LABEL_MMB, LABEL_X1, LABEL_X2

    switch Format("{:L}", keyName) {
        ; --- Letters ---
        case "a": return LABEL_A
        case "b": return LABEL_B
        case "c": return LABEL_C
        case "d": return LABEL_D
        case "e": return LABEL_E
        case "f": return LABEL_F
        case "g": return LABEL_G
        case "h": return LABEL_H
        case "i": return LABEL_I
        case "j": return LABEL_J
        case "k": return LABEL_K
        case "l": return LABEL_L
        case "m": return LABEL_M
        case "n": return LABEL_N
        case "o": return LABEL_O
        case "p": return LABEL_P
        case "q": return LABEL_Q
        case "r": return LABEL_R
        case "s": return LABEL_S
        case "t": return LABEL_T
        case "u": return LABEL_U
        case "v": return LABEL_V
        case "w": return LABEL_W
        case "x": return LABEL_X
        case "y": return LABEL_Y
        case "z": return LABEL_Z

        ; --- Numbers ---
        case "0": return LABEL_0
        case "1": return LABEL_1
        case "2": return LABEL_2
        case "3": return LABEL_3
        case "4": return LABEL_4
        case "5": return LABEL_5
        case "6": return LABEL_6
        case "7": return LABEL_7
        case "8": return LABEL_8
        case "9": return LABEL_9

        ; --- Function Keys ---
        case "f1":  return LABEL_F1
        case "f2":  return LABEL_F2
        case "f3":  return LABEL_F3
        case "f4":  return LABEL_F4
        case "f5":  return LABEL_F5
        case "f6":  return LABEL_F6
        case "f7":  return LABEL_F7
        case "f8":  return LABEL_F8
        case "f9":  return LABEL_F9
        case "f10": return LABEL_F10
        case "f11": return LABEL_F11
        case "f12": return LABEL_F12
        case "f13": return LABEL_F13
        case "f14": return LABEL_F14
        case "f15": return LABEL_F15
        case "f16": return LABEL_F16
        case "f17": return LABEL_F17
        case "f18": return LABEL_F18
        case "f19": return LABEL_F19
        case "f20": return LABEL_F20
        case "f21": return LABEL_F21
        case "f22": return LABEL_F22
        case "f23": return LABEL_F23
        case "f24": return LABEL_F24

        ; --- Symbols & Punctuation ---
        case "-":   return LABEL_DASH
        case "=":   return LABEL_EQUALS
        case "[":   return LABEL_LBRACKET
        case "]":   return LABEL_RBRACKET
        case "\":   return LABEL_BACKSLASH
        case ";":   return LABEL_SEMICOLON
        case "'":   return LABEL_QUOTE
        case ",":   return LABEL_COMMA
        case ".":   return LABEL_PERIOD
        case "/":   return LABEL_SLASH
        case "``":  return LABEL_BACKTICK
        case "~":   return LABEL_TILDE
        case "!":   return LABEL_EXCLAM
        case "@":   return LABEL_AT
        case "#":   return LABEL_HASH
        case "$":   return LABEL_DOLLAR
        case "%":   return LABEL_PERCENT
        case "^":   return LABEL_CARET
        case "&":   return LABEL_AMPERSAND
        case "*":   return LABEL_ASTERISK
        case "(":   return LABEL_LPAREN
        case ")":   return LABEL_RPAREN
        case "_":   return LABEL_UNDERSCORE
        case "+":   return LABEL_PLUS
        case "{":   return LABEL_LCURLY
        case "}":   return LABEL_RCURLY
        case "|":   return LABEL_PIPE
        case ":":   return LABEL_COLON
        case "`""`: return LABEL_DQUOTE
        case "<":   return LABEL_LT
        case ">":   return LABEL_GT
        case "?":   return LABEL_QUESTION

        ; --- Special & Mouse Keys ---
        case "space":          return LABEL_SPACE
        case "enter":          return LABEL_ENTER
        case "backspace":     return LABEL_BKSP
        case "delete":         return LABEL_DEL
        case "tab":             return LABEL_TAB
        case "escape":         return LABEL_ESC
        case "up":             return LABEL_UP
        case "down":          return LABEL_DOWN
        case "left":            return LABEL_LEFT
        case "right":           return LABEL_RIGHT
        case "lctrl", "rctrl":   return LABEL_CTRL
        case "lshift", "rshift": return LABEL_SHIFT
        case "lalt", "ralt":     return LABEL_ALT
        case "lwin", "rwin":  return LABEL_WIN
        case "capslock":       return GetKeyState("CapsLock", "T") ? LABEL_CAPS_ON : LABEL_CAPS_OFF
        case "lbutton":        return LABEL_LMB
        case "rbutton":        return LABEL_RMB
        case "mbutton":       return LABEL_MMB
        case "xbutton1":      return LABEL_X1
        case "xbutton2":      return LABEL_X2
        case "&":              return "&&"  ; Escapes the ampersand so it doesn't draw an underline
        default:               return Format("{:U}", keyName)
    }
}

HandleKey(keyName, *) {
    global TargetWindow, ActiveBlocks, FONT_SIZE, FONT_NAME, TRANSPARENT_COLOR, HOLD_BG_COLOR_KEY, HOLD_BG_COLOR_MOUSE, TEXT_COLOR_KEY, TEXT_COLOR_MOUSE, BLOCK_SIZE, CORNER_RADIUS, TEXT_TOP_OFFSET, TEXT_LEFT_OFFSET, EXTRA_WIDTH_PADDING
    
    activeWin := WinExist("A")
    if (!activeWin)
        return
        
    ; If the focused window changed, clear old blocks from the previous window
    if (TargetWindow != activeWin) {
        DestroyAllBlocks()
        TargetWindow := activeWin
    }
    
    ; Check if an active block for this key already exists
    for block in ActiveBlocks {
        if (block.rawKey = keyName) {
            ; Only increment counter if the block was previously released (true physical repress)
            if (block.wasReleased) {
                block.startTime := A_TickCount
                block.count++
                block.wasReleased := false  ; Reset release tracking until it's let go again
                
                baseLabel := GetDisplayLabel(keyName)
                if (block.count > 1) {
                    newText := baseLabel " x" block.count
                    block.textCtrl.Value := newText
                    
                    ; Expand width strictly to the right side, keeping left margin intact
                    charExtra := StrLen(newText) - StrLen(baseLabel)
                    newWidth := BLOCK_SIZE + (charExtra * EXTRA_WIDTH_PADDING)
                    block.currentWidth := newWidth
                    
                    block.fillCtrl.Move(0, 0, newWidth, BLOCK_SIZE)
                    block.textCtrl.Move(TEXT_LEFT_OFFSET, TEXT_TOP_OFFSET, newWidth - TEXT_LEFT_OFFSET, BLOCK_SIZE - TEXT_TOP_OFFSET)
                    
                    hRgn := DllCall("gdi32\CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", newWidth, "Int", BLOCK_SIZE, "Int", CORNER_RADIUS * 2, "Int", CORNER_RADIUS * 2, "Ptr")
                    DllCall("user32\SetWindowRgn", "Ptr", block.gui.Hwnd, "Ptr", hRgn, "Int", True)
                }
            } else {
                ; Just refresh timer if it's an auto-repeat burst while the key is held down
                block.startTime := A_TickCount
            }
            return
        }
    }
    
    ; Determine if this specific input is a mouse button or keyboard key
    lowerKey := Format("{:L}", keyName)
    isMouse := (lowerKey = "lbutton" || lowerKey = "rbutton" || lowerKey = "mbutton" || lowerKey = "xbutton1" || lowerKey = "xbutton2")
    currentHoldColor := isMouse ? HOLD_BG_COLOR_MOUSE : HOLD_BG_COLOR_KEY
    currentTextColor := isMouse ? TEXT_COLOR_MOUSE : TEXT_COLOR_KEY
    
    ; Create a new independent GUI window for this key
    g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    g.BackColor := TRANSPARENT_COLOR
    
    ; Apply 2px rounded corners to the window region via Win32 API
    hRgn := DllCall("gdi32\CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", BLOCK_SIZE, "Int", BLOCK_SIZE, "Int", CORNER_RADIUS * 2, "Int", CORNER_RADIUS * 2, "Ptr")
    DllCall("user32\SetWindowRgn", "Ptr", g.Hwnd, "Ptr", hRgn, "Int", True)
    
    bs := BLOCK_SIZE
    
    ; Add a dedicated background fill control using the correct color (hidden by default)
    fillCtrl := g.Add("Text", "x0 y0 w" bs " h" bs " Background" currentHoldColor)
    fillCtrl.Visible := false
    
; Add a dedicated background fill control using the correct color (hidden by default)
    fillCtrl := g.Add("Text", "x0 y0 w" bs " h" bs " Background" currentHoldColor)
    fillCtrl.Visible := false
    
    ; Add text label left-aligned with a clean left margin and independent text color
    displayLabel := GetDisplayLabel(keyName)
    
    if RegExMatch(Format("{:L}", keyName), "^f[1-9][0-9]$") {
        currentFontSize := FONT_SIZE_F_KEYS
    } else {
        currentFontSize := (StrLen(displayLabel) > 1) ? 14 : FONT_SIZE
    }

    g.SetFont("S" currentFontSize " Bold", FONT_NAME)
    textCtrl := g.Add("Text", "x" TEXT_LEFT_OFFSET " y" TEXT_TOP_OFFSET " w" (bs - TEXT_LEFT_OFFSET) " h" (bs - TEXT_TOP_OFFSET) " Left c" currentTextColor " BackgroundTrans", displayLabel)
    
    ; Show window initially at full transparency key
    g.Show("NoActivate")
    try WinSetTransColor(TRANSPARENT_COLOR " 255", g)
    
    ; Create the block object
    newBlock := {
        gui: g,
        rawKey: keyName,
        fillCtrl: fillCtrl,
        textCtrl: textCtrl,
        count: 1,
        currentWidth: BLOCK_SIZE,
        startTime: A_TickCount,
        holdStartTime: A_TickCount,
        wasReleased: false
    }
    
    ; Push to the end of the horizontal queue stack
    ActiveBlocks.Push(newBlock)
}

DestroyAllBlocks() {
    global ActiveBlocks, TargetWindow
    for block in ActiveBlocks {
        try block.gui.Destroy()
    }
    ActiveBlocks := []
    TargetWindow := ""
}