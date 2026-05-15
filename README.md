# <img src="https://user-images.githubusercontent.com/4319621/36906314-e3f99680-1e35-11e8-90fd-f959c9641f36.png" alt="Notepadqq" width="32" height="32" /> Notepadqq

> [!NOTE]
> This fork modernizes Notepadqq with Qt 6 and CMake, and adds cross-platform CI builds for **Linux**, **macOS** (Apple Silicon), and **Windows**.

### What's changed in this fork

- **Qt 6** — migrated from Qt 5 to Qt 6 (WebEngine, WebChannel, WebSockets, Core5Compat)
- **CMake build system** — replaced qmake with CMake 3.16+; the `./configure` && `make` workflow still works
- **macOS support** — native Apple Silicon (arm64) builds, DMG packaging via `macdeployqt`
- **Windows support** — MSVC x64 builds with vcpkg for dependencies, ZIP packaging via `windeployqt`
- **Linux AppImage** — built with `linuxdeploy` + Qt plugin (Qt6-compatible)
- **GitHub Actions CI** — separate workflows for each platform, plus a combined release workflow
- **Cleanup** — removed obsolete Travis CI config, Dockerfile, and qmake project files

### Links

* [What is it?](#what-is-it)
* [Build it yourself](#build-it-yourself)
* [Download it](#download)

#### What is it?

Notepadqq is a text editor designed by developers, for developers. 

![screenshot_20180302_163505](https://notepadqq.com/s/images/snapshot1.png)

Please visit our [Wiki](https://github.com/notepadqq/notepadqq/wiki) for more screenshots and details.

Build it yourself
-----

#### Dependencies

| Build dependencies         | Runtime dependencies    |
|----------------------------|-------------------------|
| CMake 3.16+                | Qt 6                    |
| Qt 6 (Core, Gui, Widgets, WebEngine, WebChannel, WebSockets, Svg, PrintSupport, Core5Compat) | libuchardet |
| pkg-config (Linux/macOS)   |                         |
| libuchardet-dev            |                         |
| C++17 compiler             |                         |

#### Get the source

    $ git clone --recursive https://github.com/notepadqq/notepadqq.git
    $ cd notepadqq

#### Build (Linux / macOS)

    notepadqq$ ./configure --prefix /usr
    notepadqq$ make

##### Ubuntu / Debian

    sudo apt-get install build-essential cmake pkg-config \
      qt6-base-dev qt6-base-dev-tools qt6-tools-dev qt6-tools-dev-tools \
      qt6-webengine-dev qt6-webengine-dev-tools qt6-l10n-tools \
      libqt6websockets6-dev libqt6svg6-dev libqt6core5compat6-dev \
      libqt6webchannel6-dev libqt6opengl6-dev \
      libuchardet-dev libgl1-mesa-dev

##### macOS (Homebrew)

    brew install qt cmake uchardet pkg-config

#### Build (Windows)

Use CMake directly with MSVC and vcpkg:

    vcpkg install uchardet:x64-windows
    cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="%VCPKG_INSTALLATION_ROOT%\scripts\buildsystems\vcpkg.cmake"
    cmake --build build --config Release

#### Install (Linux)

    notepadqq$ sudo make install

Download
--------

Pre-built binaries for each platform are available from [GitHub Releases](https://github.com/notepadqq/notepadqq/releases) and CI artifacts.

#### Snap (Linux)

    sudo snap install notepadqq
