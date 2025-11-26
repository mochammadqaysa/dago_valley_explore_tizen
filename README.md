# dago_valley_explore

A new Flutter project.

## Cara Running

### 1. Cek Device Tizen

Pertama, pastikan device Tizen Anda sudah terhubung dengan menjalankan perintah:

```bash
sdb devices
```

Outputnya akan menampilkan device yang tersedia, contoh:

```
emulator-26101          device          T-samsung-9.0-x86
```

### 2. Jalankan Aplikasi

Setelah mengetahui device ID (misalnya `emulator-26101`), jalankan aplikasi dengan perintah:

```bash
flutter-tizen run -d emulator-26101
```

Ganti `emulator-26101` dengan device ID yang muncul di hasil `sdb devices` Anda.
