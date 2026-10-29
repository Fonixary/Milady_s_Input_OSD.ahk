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

; ==============================================================================
; 🎛️ CONFIGURATION CONSTANTS (EDIT FREELY HERE)
; ==============================================================================
global CFG_KEY_TIMEOUT   := 400   ; Full brightness duration per block (ms)
global CFG_FADE_DURATION := 2000  ; Fade duration per block (ms)
global TRANSPARENT_COLOR := "FFF7E8"  ; Magenta chroma key for background transparency

global BLOCK_SIZE        := 60    ; Width and height of each square block (50x50)
global BLOCK_SPACING     := 10    ; Horizontal spacing/gap between blocks in the queue
global CORNER_RADIUS     := 2     ; Rounded corner radius in pixels (2 px)
global TEXT_TOP_OFFSET   := 6     ; Vertical offset for text from the top border
global TEXT_LEFT_OFFSET  := 8     ; Left margin offset for text so it matches single blocks nicely

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

global FONT_NAME         := "Mezalia Black"   ; Editable font family name
global FONT_SIZE         := 20    ; Font size fitted for 50x50 square

; --- Editable Display Labels for Special & Mouse Keys ---
global LABEL_SPACE       := "⎵"
global LABEL_ENTER       := "¶"
global LABEL_BKSP        := "⌫"
global LABEL_DEL         := "⌦"
global LABEL_TAB         := "🗺"
global LABEL_ESC         := "🐾"
global LABEL_UP          := "⍲"
global LABEL_DOWN        := "⍱"
global LABEL_LEFT        := "⦓"
global LABEL_RIGHT       := "⦔"
global LABEL_CTRL        := "🦘"
global LABEL_SHIFT       := "🪄"
global LABEL_ALT         := "🛡"
global LABEL_LMB         := "🎆"
global LABEL_RMB         := "🎇"
global LABEL_MMB         := "☸"
global LABEL_X1          := "⭮"
global LABEL_X2          := "📜"

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
    "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/", "``",
    ; Shifted Row Symbols / Extra Keys
    "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "{", "}", "|", ":", "`"", "<", ">", "?",
    ; Function Keys F1 - F24
    "F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",
    "F13","F14","F15","F16","F17","F18","F19","F20","F21","F22","F23","F24",
    ; Action & Navigation Keys
    "Space", "Enter", "Backspace", "Delete", "Tab", "Escape",
    "Up", "Down", "Left", "Right",
    ; Modifier Keys
    "LCtrl", "RCtrl", "LShift", "RShift", "LAlt", "RAlt",
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
    global LABEL_SPACE, LABEL_ENTER, LABEL_BKSP, LABEL_DEL, LABEL_TAB, LABEL_ESC
    global LABEL_UP, LABEL_DOWN, LABEL_LEFT, LABEL_RIGHT
    global LABEL_CTRL, LABEL_SHIFT, LABEL_ALT
    global LABEL_LMB, LABEL_RMB, LABEL_MMB, LABEL_X1, LABEL_X2

    switch Format("{:L}", keyName) {
        case "space":          return LABEL_SPACE
        case "enter":          return LABEL_ENTER
        case "backspace":      return LABEL_BKSP
        case "delete":         return LABEL_DEL
        case "tab":            return LABEL_TAB
        case "escape":         return LABEL_ESC
        case "up":             return LABEL_UP
        case "down":           return LABEL_DOWN
        case "left":           return LABEL_LEFT
        case "right":          return LABEL_RIGHT
        case "lctrl", "rctrl": return LABEL_CTRL
        case "lshift", "rshift": return LABEL_SHIFT
        case "lalt", "ralt":   return LABEL_ALT
        case "lbutton":        return LABEL_LMB
        case "rbutton":        return LABEL_RMB
        case "mbutton":        return LABEL_MMB
        case "xbutton1":       return LABEL_X1
        case "xbutton2":       return LABEL_X2
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
    
    ; Add text label left-aligned with a clean left margin and independent text color
    displayLabel := GetDisplayLabel(keyName)
    currentFontSize := (StrLen(displayLabel) > 3) ? 14 : FONT_SIZE
    
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