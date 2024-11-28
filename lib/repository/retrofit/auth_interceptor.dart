import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/data/shared_prefs.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final String refreshTokenEndpoint;
  final SharedPrefs sharedPrefs = SharedPrefs();

  AuthInterceptor({required this.dio, required this.refreshTokenEndpoint});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      // Status 401 menunjukkan sesi kedaluwarsa
      _handleSessionExpire();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Coba refresh token
        await _refreshToken();

        // Ulangi permintaan yang gagal
        final retryRequest = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        handler.resolve(retryRequest);
      } catch (e) {
        // Gagal refresh token, logout user
        _handleSessionExpire();
        handler.reject(err);
      }
    } else {
      super.onError(err, handler);
      Fluttertoast.showToast(
        msg: err.response != null
            ? err.response?.data["message"] ?? "Terjadi kesalahan pada server."
            : "Koneksi gagal, periksa jaringan Anda.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
        toastLength: Toast.LENGTH_LONG
      );
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _getStoredRefreshToken();
    Map<String, dynamic> header = {
      'Authorization': 'Bearer ${sharedPrefs.token}'
    };
    // dio = Dio(BaseOptions(headers: header));
    final response = await dio.post(
      refreshTokenEndpoint,
      data: {'refresh_token': refreshToken},
      options: Options(headers: header )
    );

    if (response.statusCode == 200) {
      final newAccessToken = response.data['access_token'];
      await _storeAccessToken(newAccessToken);

      // Tambahkan token ke header Dio
      dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
    } else {
      throw Exception('Refresh token failed');
    }
  }

  Future<void> _handleSessionExpire() async {
    // Hapus token dari storage
    await _clearStoredTokens();

    // Navigasi ke layar login
    _navigateToLogin();
  }

  Future<String?> _getStoredRefreshToken() async {
    // Implementasi untuk mendapatkan refresh token dari secure storage
    return 'stored_refresh_token';
  }

  Future<void> _storeAccessToken(String token) async {
    // Implementasi untuk menyimpan token ke secure storage
  }

  Future<void> _clearStoredTokens() async {
    // Implementasi untuk menghapus semua token dari secure storage
  }

  void _navigateToLogin() {
    // Implementasi navigasi ke layar login
  }
}
