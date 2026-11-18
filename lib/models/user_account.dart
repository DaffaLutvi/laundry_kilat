import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Lapisan Model: Mewakili data akun pengelola untuk login & keamanan (FR-7.1, FR-7.2, FR-7.3).
/// Kata sandi tidak disimpan sebagai teks biasa, melainkan menggunakan SHA-256 hash.
class UserAccount {
  final String username;
  final String namaLengkap;
  final String passwordHash;
  final bool isLoggedIn;

  const UserAccount({
    required this.username,
    required this.namaLengkap,
    required this.passwordHash,
    this.isLoggedIn = true,
  });

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  bool verifikasiPassword(String plainPassword) {
    return hashPassword(plainPassword) == passwordHash;
  }

  UserAccount copyWith({
    String? username,
    String? namaLengkap,
    String? passwordHash,
    bool? isLoggedIn,
  }) {
    return UserAccount(
      username: username ?? this.username,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      passwordHash: passwordHash ?? this.passwordHash,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
