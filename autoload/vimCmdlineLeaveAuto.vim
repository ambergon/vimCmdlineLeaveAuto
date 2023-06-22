python3 << EOF
# -*- coding: utf-8 -*-
from ctypes import *
from ctypes import wintypes as w

KEYEVENTF_SCANCODE = 0x8
KEYEVENTF_UNICODE = 0x4
KEYEVENTF_KEYUP = 0x2
INPUT_KEYBOARD = 1
ULONG_PTR = c_ulong if sizeof(c_void_p) == 4 else c_ulonglong

class KEYBDINPUT(Structure):
    _fields_ = [('wVk' ,w.WORD),
                ('wScan',w.WORD),
                ('dwFlags',w.DWORD),
                ('time',w.DWORD),
                ('dwExtraInfo',ULONG_PTR)]

class MOUSEINPUT(Structure):
    _fields_ = [('dx' ,w.LONG),
                ('dy',w.LONG),
                ('mouseData',w.DWORD),
                ('dwFlags',w.DWORD),
                ('time',w.DWORD),
                ('dwExtraInfo',ULONG_PTR)]

class HARDWAREINPUT(Structure):
    _fields_ = [('uMsg' ,w.DWORD),
                ('wParamL',w.WORD),
                ('wParamH',w.WORD)]

class DUMMYUNIONNAME(Union):
    _fields_ = [('mi',MOUSEINPUT),
                ('ki',KEYBDINPUT),
                ('hi',HARDWAREINPUT)] 

class INPUT(Structure):
    _anonymous_ = ['u']
    _fields_ = [('type',w.DWORD),
                ('u',DUMMYUNIONNAME)]


class vimCmdlineLeaveSendKey:
    lib = ""
    def __init__( self ):
        self.lib = WinDLL('user32')
        self.lib.SendInput.argtypes = w.UINT,POINTER(INPUT),c_int
        self.lib.SendInput.restype = w.UINT

    def Key( self , code ):
        i = INPUT()
        i.type = INPUT_KEYBOARD
        i.ki.wVk = int( code )
        self.lib.SendInput(1,byref(i),sizeof(INPUT))
        i.ki.dwFlags |= KEYEVENTF_KEYUP
        self.lib.SendInput(1,byref(i),sizeof(INPUT))

vimCmdlineLeaveSendKeyInst = vimCmdlineLeaveSendKey()
EOF

let s:vimCmdlineLeaveSendKey = "vimCmdlineLeaveSendKeyInst"
function! s:d( )
    "22 全角
    "26 半角
    let s:x = py3eval( s:vimCmdlineLeaveSendKey . ".Key(26)" )
endfunction
autocmd! CmdlineLeave   : call s:d()








