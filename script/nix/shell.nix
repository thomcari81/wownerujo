let

  nixpkgs = import <nixpkgs> {}

; android-studio-deps = with nixpkgs;
  [
    coreutils
    findutils
    file
    git
    glxinfo
    gn
    gnused
    gnutar
    gtk3
    gnome3.gvfs
    glib
    gnome3.gconf
    # gnome3.libsecret
    gzip
    fontconfig
    freetype
    libpulseaudio
    libGL
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.setxkbmap
    pciutils
    unzip
    which
    xkeyboard_config
    zlib
    ncurses5
  ]

; in

with nixpkgs;

(buildFHSUserEnv {
  name = "wownerojo-env"
; targetPkgs = pkgs: (with pkgs;
  [
    bash
    git
    curl
    unzip
    libGLU
    which

    zsh
    jdk
    cmake
    python
    wget
    perl
    gnumake
    binutils
    gcc
    doxygen
    graphviz
    pkgconfig

    androidsdk

    vim
  ]
  ++ android-studio-deps
  )

; multiPkgs = pkgs: (with pkgs;
  [
  ])

; profile = ''
    export ANDROID_HOME=~/Android/Sdk
    export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk-bundle

    PATH=~/sdk/android/android-studio/bin/:$PATH
    PATH=$ANDROID_NDK_ROOT/build/tools/:$PATH
    export PATH

    export _JAVA_AWT_WM_NONREPARENTING=1

    export app_version=1050
    export gradle_app_version=1x5x10x5
    export release_key=~/.android/fuwa-release-key.jks

    exec zsh
  ''

; }).env