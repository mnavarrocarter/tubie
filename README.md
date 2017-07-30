# Tubie
A simple YouTube uploader app for Elementary OS.

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.mnavarrocarter.tubie)

![Torrential Screenshot](https://github.com/davidmhewitt/torrential/raw/master/data/com.github.davidmhewitt.torrential.screenshot.png)

## Building, Testing, and Installation

You'll need the following dependencies to build:
* cmake
* libgtk-3-dev
* valac
* webkit
* libgranite-dev
* libarchive-dev
* libunity-dev
* libcurl4-openssl-dev
* libssl-dev
* automake
* libtool

## How To Build

    git clone https://github.com/mnavarro/tubie
    cd tubie
    mkdir build && cd build 
    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make
    sudo make install