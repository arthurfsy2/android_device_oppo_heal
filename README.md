# LineageOS 21.0 — OPPO Find X2 Pro (heal)

Unofficial LineageOS 21 (Android 14) device tree for **OPPO Find X2 Pro** (PDEM30, board `OP4A7A`, codename **heal**) — Qualcomm SM8250 (Snapdragon 865, kona).

Adapted from MomoYuuki's Find X3 (horee) device tree, with board configuration supplemented from the LineageOS 18.1 `android_device_oppo_OP4A7A` tree.

## ⚠️ Status: UNTESTED

The tree produces a clean, complete build, but **it has never been booted on any device** (the maintainer's unit is bootloader-locked). Testers are very welcome — please report your results (boot / no boot) in the [release comments](https://github.com/arthurfsy2/android_device_oppo_heal/releases).

Ready-made ROM: [Releases](https://github.com/arthurfsy2/android_device_oppo_heal/releases)

## Building from source

### 1. Sync the LineageOS 21.0 source

Follow the official [LineageOS build guide](https://wiki.lineageos.org/dev/build) up to and including the initial sync:

```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
repo sync -c -j8
```

### 2. Add a local manifest

Create `.repo/local_manifests/heal.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="arthurfsy2" fetch="https://github.com/arthurfsy2" />
  <remote name="provasish" fetch="https://github.com/provasish" />
  <project name="android_device_oppo_heal" path="device/oppo/heal" remote="arthurfsy2" revision="main" />
  <project name="android_device_realme_sm8250-common" path="device/realme/sm8250-common" remote="provasish" revision="lineage-21" />
</manifest>
```

Then sync again:

```bash
repo sync -c -j8
```

Notes:

- `hardware/oplus` is provided by the official LineageOS manifest ([LineageOS/android_hardware_oplus](https://github.com/LineageOS/android_hardware_oplus), branch `lineage-21`). After syncing, verify `hardware/oplus` exists; if it does not, add a matching `<project>` entry for it.
- Other forks of `android_device_realme_sm8250-common` with a `lineage-21` branch should also work (e.g. ObsidianMaximus, Dragon-s-Playground) — pick whichever builds cleanly for you.

### 3. Extract vendor blobs

Blobs are extracted from a **stock ColorOS 13.1.0.195(CN)** full OTA package:

1. Download the PDEM30 CN 13.1.0.195 full OTA, dump `payload.bin` to raw partition images (`payload-dumper-go`), then split `super.img` with `lpunpack`.
2. Run the extractor (LineageOS extract-utils 2.0 — extracts for both `oppo/heal` and `oppo/sm8250-common`; camera/NFC/charger blob fixups are already defined in the script):

```bash
./extract-files.py <path-to-extracted-partitions>
```

### 4. Build

```bash
source build/envsetup.sh
breakfast heal
mka bacon
```

Output lands in `out/target/product/heal/`: `lineage-21.0-*.zip`, `boot.img`, `recovery.img`.

### Build notes

- **Kernel is prebuilt** — `Image` and `kona.dtb` were extracted from the stock boot image; no kernel source tree is attached. If you want a custom kernel, OPPO publishes kernel sources on its official support site.
- **AVB is disabled in the build** (the boot partition is too tight with the stock dtbo); flash stock vbmeta with `--disable-verity --disable-verification` instead.
- **Do not flash dtbo** — the stock dtbo is kept as a prebuilt; leave that partition untouched.

## Flashing (summary)

1. **Unlock the bootloader** (wipes all data). Known issue on this device: with a locked bootloader the fastboot USB function enumerates as a silent "MIDI function" (`18D1:4EE8`) and ignores fastboot commands — a 9008/EDL (Qualcomm emergency mode) hard-unlock is the known workaround. Bring your own tools; none are provided here.
2. `fastboot flash boot boot.img && fastboot flash recovery recovery.img`
3. `fastboot flash vbmeta vbmeta.img --disable-verity --disable-verification` (stock vbmeta)
4. Boot into recovery → **Apply update → Apply from ADB** → `adb sideload lineage-21.0-*.zip`
5. **Format data / factory reset** in recovery, then reboot (first boot takes several minutes).

## Credits

- [MomoYuuki](https://github.com/MomoYuuki) — the Find X3 (horee) tree this adaptation is based on
- The LineageOS team and the authors of the `OP4A7A` (Find X2 Pro, 18.1) tree
- Maintainers of [LineageOS/android_hardware_oplus](https://github.com/LineageOS/android_hardware_oplus)

License: see SPDX headers in-tree (Apache-2.0 for device tree portions).
