#-------------------------------------------------------------------------------
#   debugtextusefont.nim
#   sokol/debugtext: render with user-provided font data (Atari 400 ROM extract)
#-------------------------------------------------------------------------------
import sokol/gfx as sg
import sokol/app as sapp
import sokol/debugtext as sdtx
import sokol/glue as sglue

type Rgb = object
  r, g, b: uint8

const
  passAction = PassAction(
    colors: [
      ColorAttachmentAction(action: actionClear, value: (0, 0.125, 0.25, 1))
    ]
  )
  colorPalette = [
    Rgb(r:0xf4, g:0x43, b:0x36),
    Rgb(r:0xe9, g:0x1e, b:0x63),
    Rgb(r:0x9c, g:0x27, b:0xb0),
    Rgb(r:0x67, g:0x3a, b:0xb7),
    Rgb(r:0x3f, g:0x51, b:0xb5),
    Rgb(r:0x21, g:0x96, b:0xf3),
    Rgb(r:0x03, g:0xa9, b:0xf4),
    Rgb(r:0x00, g:0xbc, b:0xd4),
    Rgb(r:0x00, g:0x96, b:0x88),
    Rgb(r:0x4c, g:0xaf, b:0x50),
    Rgb(r:0x8b, g:0xc3, b:0x4a),
    Rgb(r:0xcd, g:0xdc, b:0x39),
    Rgb(r:0xff, g:0xeb, b:0x3b),
    Rgb(r:0xff, g:0xc1, b:0x07),
    Rgb(r:0xff, g:0x98, b:0x00),
    Rgb(r:0xff, g:0x57, b:0x22)
  ]

# Font data extracted Colorfrom Atari 400 ROM at address 0xE000,
# and reshuffled to maColorp to ASCII. Each character is 8 bytes,
# 1 bit per pixel in aColorn 8x8 matrix.
# (apparently arrays can't be forward declared in Nim?)
const userFont = [
    0x00'u8, 0x00, 0x0, 0x00, 0x00, 0x00, 0x00, 0x00, # 20
    0x00, 0x18, 0x18, 0x18, 0x18, 0x00, 0x18, 0x00, # 21
    0x00, 0x66, 0x66, 0x66, 0x00, 0x00, 0x00, 0x00, # 22
    0x00, 0x66, 0xFF, 0x66, 0x66, 0xFF, 0x66, 0x00, # 23
    0x18, 0x3E, 0x60, 0x3C, 0x06, 0x7C, 0x18, 0x00, # 24
    0x00, 0x66, 0x6C, 0x18, 0x30, 0x66, 0x46, 0x00, # 25
    0x1C, 0x36, 0x1C, 0x38, 0x6F, 0x66, 0x3B, 0x00, # 26
    0x00, 0x18, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00, # 27
    0x00, 0x0E, 0x1C, 0x18, 0x18, 0x1C, 0x0E, 0x00, # 28
    0x00, 0x70, 0x38, 0x18, 0x18, 0x38, 0x70, 0x00, # 29
    0x00, 0x66, 0x3C, 0xFF, 0x3C, 0x66, 0x00, 0x00, # 2A
    0x00, 0x18, 0x18, 0x7E, 0x18, 0x18, 0x00, 0x00, # 2B
    0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x30, # 2C
    0x00, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00, 0x00, # 2D
    0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, # 2E
    0x00, 0x06, 0x0C, 0x18, 0x30, 0x60, 0x40, 0x00, # 2F
    0x00, 0x3C, 0x66, 0x6E, 0x76, 0x66, 0x3C, 0x00, # 30
    0x00, 0x18, 0x38, 0x18, 0x18, 0x18, 0x7E, 0x00, # 31
    0x00, 0x3C, 0x66, 0x0C, 0x18, 0x30, 0x7E, 0x00, # 32
    0x00, 0x7E, 0x0C, 0x18, 0x0C, 0x66, 0x3C, 0x00, # 33
    0x00, 0x0C, 0x1C, 0x3C, 0x6C, 0x7E, 0x0C, 0x00, # 34
    0x00, 0x7E, 0x60, 0x7C, 0x06, 0x66, 0x3C, 0x00, # 35
    0x00, 0x3C, 0x60, 0x7C, 0x66, 0x66, 0x3C, 0x00, # 36
    0x00, 0x7E, 0x06, 0x0C, 0x18, 0x30, 0x30, 0x00, # 37
    0x00, 0x3C, 0x66, 0x3C, 0x66, 0x66, 0x3C, 0x00, # 38
    0x00, 0x3C, 0x66, 0x3E, 0x06, 0x0C, 0x38, 0x00, # 39
    0x00, 0x00, 0x18, 0x18, 0x00, 0x18, 0x18, 0x00, # 3A
    0x00, 0x00, 0x18, 0x18, 0x00, 0x18, 0x18, 0x30, # 3B
    0x06, 0x0C, 0x18, 0x30, 0x18, 0x0C, 0x06, 0x00, # 3C
    0x00, 0x00, 0x7E, 0x00, 0x00, 0x7E, 0x00, 0x00, # 3D
    0x60, 0x30, 0x18, 0x0C, 0x18, 0x30, 0x60, 0x00, # 3E
    0x00, 0x3C, 0x66, 0x0C, 0x18, 0x00, 0x18, 0x00, # 3F
    0x00, 0x3C, 0x66, 0x6E, 0x6E, 0x60, 0x3E, 0x00, # 40
    0x00, 0x18, 0x3C, 0x66, 0x66, 0x7E, 0x66, 0x00, # 41
    0x00, 0x7C, 0x66, 0x7C, 0x66, 0x66, 0x7C, 0x00, # 42
    0x00, 0x3C, 0x66, 0x60, 0x60, 0x66, 0x3C, 0x00, # 43
    0x00, 0x78, 0x6C, 0x66, 0x66, 0x6C, 0x78, 0x00, # 44
    0x00, 0x7E, 0x60, 0x7C, 0x60, 0x60, 0x7E, 0x00, # 45
    0x00, 0x7E, 0x60, 0x7C, 0x60, 0x60, 0x60, 0x00, # 46
    0x00, 0x3E, 0x60, 0x60, 0x6E, 0x66, 0x3E, 0x00, # 47
    0x00, 0x66, 0x66, 0x7E, 0x66, 0x66, 0x66, 0x00, # 48
    0x00, 0x7E, 0x18, 0x18, 0x18, 0x18, 0x7E, 0x00, # 49
    0x00, 0x06, 0x06, 0x06, 0x06, 0x66, 0x3C, 0x00, # 4A
    0x00, 0x66, 0x6C, 0x78, 0x78, 0x6C, 0x66, 0x00, # 4B
    0x00, 0x60, 0x60, 0x60, 0x60, 0x60, 0x7E, 0x00, # 4C
    0x00, 0x63, 0x77, 0x7F, 0x6B, 0x63, 0x63, 0x00, # 4D
    0x00, 0x66, 0x76, 0x7E, 0x7E, 0x6E, 0x66, 0x00, # 4E
    0x00, 0x3C, 0x66, 0x66, 0x66, 0x66, 0x3C, 0x00, # 4F
    0x00, 0x7C, 0x66, 0x66, 0x7C, 0x60, 0x60, 0x00, # 50
    0x00, 0x3C, 0x66, 0x66, 0x66, 0x6C, 0x36, 0x00, # 51
    0x00, 0x7C, 0x66, 0x66, 0x7C, 0x6C, 0x66, 0x00, # 52
    0x00, 0x3C, 0x60, 0x3C, 0x06, 0x06, 0x3C, 0x00, # 53
    0x00, 0x7E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00, # 54
    0x00, 0x66, 0x66, 0x66, 0x66, 0x66, 0x7E, 0x00, # 55
    0x00, 0x66, 0x66, 0x66, 0x66, 0x3C, 0x18, 0x00, # 56
    0x00, 0x63, 0x63, 0x6B, 0x7F, 0x77, 0x63, 0x00, # 57
    0x00, 0x66, 0x66, 0x3C, 0x3C, 0x66, 0x66, 0x00, # 58
    0x00, 0x66, 0x66, 0x3C, 0x18, 0x18, 0x18, 0x00, # 59
    0x00, 0x7E, 0x0C, 0x18, 0x30, 0x60, 0x7E, 0x00, # 5A
    0x00, 0x1E, 0x18, 0x18, 0x18, 0x18, 0x1E, 0x00, # 5B
    0x00, 0x40, 0x60, 0x30, 0x18, 0x0C, 0x06, 0x00, # 5C
    0x00, 0x78, 0x18, 0x18, 0x18, 0x18, 0x78, 0x00, # 5D
    0x00, 0x08, 0x1C, 0x36, 0x63, 0x00, 0x00, 0x00, # 5E
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, # 5F
    0x00, 0x18, 0x3C, 0x7E, 0x7E, 0x3C, 0x18, 0x00, # 60
    0x00, 0x00, 0x3C, 0x06, 0x3E, 0x66, 0x3E, 0x00, # 61
    0x00, 0x60, 0x60, 0x7C, 0x66, 0x66, 0x7C, 0x00, # 62
    0x00, 0x00, 0x3C, 0x60, 0x60, 0x60, 0x3C, 0x00, # 63
    0x00, 0x06, 0x06, 0x3E, 0x66, 0x66, 0x3E, 0x00, # 64
    0x00, 0x00, 0x3C, 0x66, 0x7E, 0x60, 0x3C, 0x00, # 65
    0x00, 0x0E, 0x18, 0x3E, 0x18, 0x18, 0x18, 0x00, # 66
    0x00, 0x00, 0x3E, 0x66, 0x66, 0x3E, 0x06, 0x7C, # 67
    0x00, 0x60, 0x60, 0x7C, 0x66, 0x66, 0x66, 0x00, # 68
    0x00, 0x18, 0x00, 0x38, 0x18, 0x18, 0x3C, 0x00, # 69
    0x00, 0x06, 0x00, 0x06, 0x06, 0x06, 0x06, 0x3C, # 6A
    0x00, 0x60, 0x60, 0x6C, 0x78, 0x6C, 0x66, 0x00, # 6B
    0x00, 0x38, 0x18, 0x18, 0x18, 0x18, 0x3C, 0x00, # 6C
    0x00, 0x00, 0x66, 0x7F, 0x7F, 0x6B, 0x63, 0x00, # 6D
    0x00, 0x00, 0x7C, 0x66, 0x66, 0x66, 0x66, 0x00, # 6E
    0x00, 0x00, 0x3C, 0x66, 0x66, 0x66, 0x3C, 0x00, # 6F
    0x00, 0x00, 0x7C, 0x66, 0x66, 0x7C, 0x60, 0x60, # 70
    0x00, 0x00, 0x3E, 0x66, 0x66, 0x3E, 0x06, 0x06, # 71
    0x00, 0x00, 0x7C, 0x66, 0x60, 0x60, 0x60, 0x00, # 72
    0x00, 0x00, 0x3E, 0x60, 0x3C, 0x06, 0x7C, 0x00, # 73
    0x00, 0x18, 0x7E, 0x18, 0x18, 0x18, 0x0E, 0x00, # 74
    0x00, 0x00, 0x66, 0x66, 0x66, 0x66, 0x3E, 0x00, # 75
    0x00, 0x00, 0x66, 0x66, 0x66, 0x3C, 0x18, 0x00, # 76
    0x00, 0x00, 0x63, 0x6B, 0x7F, 0x3E, 0x36, 0x00, # 77
    0x00, 0x00, 0x66, 0x3C, 0x18, 0x3C, 0x66, 0x00, # 78
    0x00, 0x00, 0x66, 0x66, 0x66, 0x3E, 0x0C, 0x78, # 79
    0x00, 0x00, 0x7E, 0x0C, 0x18, 0x30, 0x7E, 0x00, # 7A
    0x00, 0x18, 0x3C, 0x7E, 0x7E, 0x18, 0x3C, 0x00, # 7B
    0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, # 7C
    0x00, 0x7E, 0x78, 0x7C, 0x6E, 0x66, 0x06, 0x00, # 7D
    0x08, 0x18, 0x38, 0x78, 0x38, 0x18, 0x08, 0x00, # 7E
    0x10, 0x18, 0x1C, 0x1E, 0x1C, 0x18, 0x10, 0x00, # 7F
    0x00, 0x36, 0x7F, 0x7F, 0x3E, 0x1C, 0x08, 0x00, # 80
    0x18, 0x18, 0x18, 0x1F, 0x1F, 0x18, 0x18, 0x18, # 81
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, # 82
    0x18, 0x18, 0x18, 0xF8, 0xF8, 0x00, 0x00, 0x00, # 83
    0x18, 0x18, 0x18, 0xF8, 0xF8, 0x18, 0x18, 0x18, # 84
    0x00, 0x00, 0x00, 0xF8, 0xF8, 0x18, 0x18, 0x18, # 85
    0x03, 0x07, 0x0E, 0x1C, 0x38, 0x70, 0xE0, 0xC0, # 86
    0xC0, 0xE0, 0x70, 0x38, 0x1C, 0x0E, 0x07, 0x03, # 87
    0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF, # 88
    0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x0F, # 89
    0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF, # 8A
    0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, # 8B
    0xF0, 0xF0, 0xF0, 0xF0, 0x00, 0x00, 0x00, 0x00, # 8C
    0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, # 8D
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, # 8E
    0x00, 0x00, 0x00, 0x00, 0xF0, 0xF0, 0xF0, 0xF0, # 8F
    0x00, 0x1C, 0x1C, 0x77, 0x77, 0x08, 0x1C, 0x00, # 90
    0x00, 0x00, 0x00, 0x1F, 0x1F, 0x18, 0x18, 0x18, # 91
    0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, # 92
    0x18, 0x18, 0x18, 0xFF, 0xFF, 0x18, 0x18, 0x18, # 93
    0x00, 0x00, 0x3C, 0x7E, 0x7E, 0x7E, 0x3C, 0x00, # 94
    0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, # 95
    0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, 0xC0, # 96
    0x00, 0x00, 0x00, 0xFF, 0xFF, 0x18, 0x18, 0x18, # 97
    0x18, 0x18, 0x18, 0xFF, 0xFF, 0x00, 0x00, 0x00, # 98
    0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, # 99
    0x18, 0x18, 0x18, 0x1F, 0x1F, 0x00, 0x00, 0x00, # 9A
    0x78, 0x60, 0x78, 0x60, 0x7E, 0x18, 0x1E, 0x00, # 9B
    0x00, 0x18, 0x3C, 0x7E, 0x18, 0x18, 0x18, 0x00, # 9C
    0x00, 0x18, 0x18, 0x18, 0x7E, 0x3C, 0x18, 0x00, # 9D
    0x00, 0x18, 0x30, 0x7E, 0x30, 0x18, 0x00, 0x00, # 9E
    0x00, 0x18, 0x0C, 0x7E, 0x0C, 0x18, 0x00, 0x00, # 9F
  ]
proc init() {.cdecl.} =
  sg.setup(sg.Desc(context: sglue.context()))

  # setup sokol-debugtext with the user font as the only font,
  # NOTE that the user font only provides pixel data for the
  # characters 0x20 to 0x9F inclusive
  sdtx.setup(sdtx.Desc(
    fonts: [
      sdtx.FontDesc(
        data: sdtx.Range(addr: userFont.unsafeAddr, size: userFont.sizeof),
        firstChar: 0x20,
        lastChar: 0x9F
      )
    ]
  ))

proc frame() {.cdecl.} =
  sdtx.canvas(sapp.widthf() * 0.25, sapp.heightf() * 0.25)
  sdtx.origin(1, 2)
  sdtx.color3b(0xFF, 0x17, 0x44)
  sdtx.puts("Hello 8-bit ATARI font:\n\n")
  var line = 0
  for c in 0x20..<0xA0:
    if (c and 15) == 0:
      sdtx.puts("\n\t")
      line += 1
    # color scrolling effect
    let rgb = colorPalette[(c + line + (sapp.frameCount().int shr 1)) and 15]
    sdtx.color3b(rgb.r, rgb.g, rgb.b)
    sdtx.putc(c.char)
  sg.beginDefaultPass(passAction, sapp.width(), sapp.height())
  sdtx.draw()
  sg.endPass()
  sg.commit()

proc cleanup() {.cdecl.} =
  sdtx.shutdown()
  sg.shutdown()

sapp.run(sapp.Desc(
  initCb: init,
  frameCb: frame,
  cleanupCb: cleanup,
  width: 800,
  height: 600,
  windowTitle: "debugtextuserfont.nim",
  icon: IconDesc(sokol_default: true)
))
