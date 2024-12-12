import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/flavors.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SharedPrefs sharedPrefs = SharedPrefs();
  final BuildContext? context;

  AuthInterceptor({required this.dio, this.context});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {

        // Refresh token
        final newToken = await _refreshToken();

        // Update header Authorization dengan token baru
        final updatedHeaders = {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer $newToken',
        };

        // Ulangi permintaan dengan token baru
        final retryRequest = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: updatedHeaders,
            sendTimeout: err.requestOptions.sendTimeout,
            receiveTimeout: err.requestOptions.receiveTimeout,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        handler.resolve(retryRequest);
      } on DioError catch (e) {
        // print('DioError saat refresh token atau retry request: ${e.message}');
        // Jika gagal refresh token, logout user
        _handleSessionExpire();
        handler.reject(err); // Forward error awal ke handler
      } catch (e) {
        // print('Error tak terduga: ${e.toString()}');
        _handleSessionExpire();
        handler.reject(err); // Forward error awal ke handler
      }
    } else {
      // Tangani error selain 401
      super.onError(err, handler);

      Fluttertoast.showToast(
        msg: err.response != null
            ? err.response?.data["message"] ?? "Terjadi kesalahan pada server."
            : "Koneksi gagal, periksa jaringan Anda.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }


  Future<String> _refreshToken() async {
    try {
      // Meminta token baru dari backend
      final response = await ApiClient(AppConfig().dio).postRefreshToken(
        authorization: 'Bearer ${sharedPrefs.token}',
      );

      // Periksa apakah respons berhasil dan token baru tersedia
      if (response.success && response.data.containsKey('token')) {
        final newToken = response.data['token'];

        // Simpan token baru di SharedPrefs
        sharedPrefs.token = newToken;

        // Kembalikan token baru
        return newToken;
      } else if (!response.success && response.message == "Token expired") {
        // Jika token refresh sudah expired
        // print('Refresh token expired, sesi akan diakhiri.');
        _handleSessionExpire(); // Navigasi ke login
        throw Exception('Refresh token expired');
      } else {
        throw Exception('Gagal memperbarui token: Respons tidak valid');
      }
    } on DioError catch (e) {
      // print('DioError: ${e.response?.data ?? e.message}');
      if (e.response?.statusCode == 401) {
        // Jika refresh token expired dari respons backend
        _handleSessionExpire(); // Navigasi ke login
        throw Exception('Refresh token expired: ${e.response?.data}');
      } else {
        throw Exception('Gagal refresh token: ${e.message}');
      }
    } catch (e) {
      // print('Error: ${e.toString()}');
      _handleSessionExpire(); // Navigasi ke login
      throw Exception("Error refreshing token: ${e.toString()}");
    }
  }


  void _handleSessionExpire() {
    if (context != null) {
      Fluttertoast.showToast(
        msg: "Sesi Anda telah kedaluwarsa. Silakan login kembali.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
        toastLength: Toast.LENGTH_LONG,
      );

      Navigator.pushNamedAndRemoveUntil(
        context!,
        Login.routeName,
        (route) => false,
      );
    } else {
      print("Context tidak tersedia, tidak dapat navigasi.");
    }
  }
}
