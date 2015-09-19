#!/bin/sh

# Builds and runs tests for a particular target passed as an argument to this
# script.

set -ex

TARGET=$1
cargo build --manifest-path libc-test/Cargo.toml --target $TARGET

case "$TARGET" in
  arm-linux-androideabi)
    emulator @test -no-window &
    adb wait-for-device
    adb push /root/target/$TARGET/debug/libc-test /data/libc-test
    adb shell /data/libc-test
    ;;

  arm-unknown-linux-gnueabihf)
    qemu-arm -L /usr/arm-linux-gnueabihf libc-test/target/$TARGET/debug/libc-test
    ;;

  mips-unknown-linux-gnu)
    qemu-mips -L /usr/mips-linux-gnu libc-test/target/$TARGET/debug/libc-test
    ;;

  aarch64-unknown-linux-gnu)
    qemu-aarch64 -L /usr/aarch64-linux-gnu/ \
      libc-test/target/$TARGET/debug/libc-test
    ;;

  *)
    cargo run --manifest-path libc-test/Cargo.toml --target $TARGET
    ;;
esac
