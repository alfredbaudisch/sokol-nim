[![build](https://github.com/floooh/sokol-nim/actions/workflows/main.yml/badge.svg)](https://github.com/floooh/sokol-nim/actions/workflows/main.yml)

Auto-generated Nim bindings for the [sokol headers](https://github.com/floooh/sokol).

## Build and run samples

First install sokol as local module:

```sh
nimble install
```
Remember to do this each time you update the bindings.

Then to build and run the samples with the platform's default 3D backend
(D3D11 on Windows, Metal on macOS, GL on Linux):

```sh
nimble clear
nimble triangle
nimble quad
nimble bufferoffsets
nimble cube
nimble noninterleaved
nimble texcube
nimble shapes
nimble offscreen
nimble instancing
nimble mrt
nimble blend
nimble debugtext
nimble debugtextprintf
nimble debugtextuserfont
nimble sgl
nimble sglcontext
nimble sglpoints
nimble saudio
```

NOTE: on Windows, the MSVC C compiler will be used by all Nimble tasks. To build
with Clang or GCC on Windows, invoke the nim compiler directly with ```--cc```:

```sh
nim r --cc:clang examples/clear
nim r --cc:gcc examples/clear
```

To force the GL backend (on Windows or Mac) use ```-d:gl``` before the target:

```sh
nimble -d:gl clear
```

To build all samples into the ```build/``` subdirectory:

```sh
# with debug info
nimble build_debug
# in release mode:
nimble build_all
# ...or with forced GL backend:
nimble -d:gl build_debug
nimble -d:gl build_all
```

### Emscripten

Currently only the "cube" and "clear" examples works for WebAssembly.

The compiled shaders of the other examples must be updated for GLES3 before they work for WebAssembly, example:

```sh
sokol-shdc -i examples/shaders/cube.glsl -o examples/shaders/cube.nim -l glsl330:metal_macos:hlsl4:glsl300es -f sokol_nim
```

To compile run:

```sh
nim c -d:emscripten examples/cube
```

Then open `examples/index.html` from a webserver, example:

```sh
cd examples
python -m http.server
# go to localhost:8000
```