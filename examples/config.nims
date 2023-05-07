when defined(emscripten):
  --os:linux
  --cpu:wasm32
  --cc:clang

  when defined(windows):
    --clang.exe:emcc.bat
    --clang.linkerexe:emcc.bat
    --clang.cpp.exe:emcc.bat
    --clang.cpp.linkerexe:emcc.bat
  else:
    --clang.exe:emcc
    --clang.linkerexe:emcc
    --clang.cpp.exe:emcc
    --clang.cpp.linkerexe:emcc

  --mm:orc
  --threads:off
  --panics:on
  --gc:arc
  --exceptions:goto
  --define:noSignalHandler

  --passL:"-o examples/index.html"
  --passL:"--shell-file examples/shell_minimal.html"