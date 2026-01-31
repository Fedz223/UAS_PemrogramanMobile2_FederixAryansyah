# 🌟 Lumière
Mood Tracker & Reflective Journaling Application

📌 Deskripsi aplikasi
Lumière adalah aplikasi mood tracker berbasis refleksi diri yang dirancang untuk membantu pengguna meningkatkan kesadaran emosional (self-awareness) melalui pencatatan perasaan dan journaling singkat secara rutin.
Aplikasi ini memungkinkan pengguna untuk:
Memilih emosi yang sedang dirasakan
Menuliskan refleksi atau curahan perasaan
Menyimpan dan meninjau kembali catatan emosi
Melihat ringkasan pola perasaan dari waktu ke waktu
Lumière tidak berfungsi sebagai alat diagnosis kesehatan mental, melainkan sebagai media refleksi pribadi yang bersifat preventif dan suportif.

#✨ Fitur Utama
🔐 Autentikasi Pengguna
Login & Register menggunakan Firebase Authentication
Akun tersimpan aman dan dapat digunakan di berbagai perangkat
😊 Pemilihan Emosi
Pengguna memilih emosi yang paling menggambarkan perasaan saat ini
Contoh: senang, tenang, sedih, cemas, dll
📝 Refleksi & Journaling
Pertanyaan reflektif singkat sebagai pemicu penulisan
Pengguna bebas menuliskan curahan perasaan
Data disimpan per tanggal dan emosi
🕒 Timeline Refleksi
Menampilkan riwayat refleksi pengguna
Dilengkapi informasi tanggal dan emosi
📊 Insight Emosi
Ringkasan sederhana dari data refleksi
Membantu pengguna melihat pola emosi secara umum
💡 Daily Light (Quote Harian)
Kutipan singkat yang bersifat menenangkan dan suportif
Data diambil dari REST API
Mendukung fallback ke data lokal jika API tidak tersedia
👤 Profil Pengguna
Menampilkan informasi akun
Mengubah nama tampilan
Logout dari aplikasi

#🛠️ Teknologi yang Digunakan
• Frontend
  - Flutter
  - Dart
• Backend & Services
  - Firebase Authentication
  - Firebase Firestore
• API
  - REST API
  - Fallback ke local data jika API gagal

#🗂️ Arsitektur Sistem
1. User login/register melalui Firebase Authentication
2. Data refleksi disimpan ke Firebase Firestore
3. Pertanyaan refleksi & quote diambil dari REST API
4. Jika API tidak tersedia, sistem menggunakan data lokal
5. Data ditampilkan kembali dalam bentuk timeline dan insight
