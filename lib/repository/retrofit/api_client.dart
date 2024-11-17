import 'package:dio/dio.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/retrofit/apis.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: "https://dev-api.kumpulpay.com")
// const String flavor = String.fromEnvironment('app.flavor');
// @RestApi(baseUrl: flavor.name)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.test)
  Future<dynamic> getTest();

  @POST(Apis.auth)
  Future<AuthRes> postAuth(@Body() Map<String, dynamic> params);

  @POST(Apis.register)
  Future<dynamic> postRegister(@Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.home)
  Future<dynamic> getHome(@Header('Authorization') String authorization);

  @GET(Apis.productCategory)
  Future<dynamic> getProductCategory(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // Future<dynamic> getProduct(String body, {Map<String, dynamic>? queries}) async {
  //   return await handleApiRequest(() async => await _getProduct(body, queries: queries));
  // }

  // @GET(Apis.product)
  // Future<dynamic> getProduct(String authorization, {Map<String, dynamic>? queries}) async {
  //   return await handleApiRequest(() async => await _getProduct(authorization, queries: queries));
  // }

  @GET(Apis.product)
  Future<dynamic> getProduct(@Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.productProvider)
  Future<dynamic> getProductProvider(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.historyTransaction)
  Future<dynamic> getHistoryTransaction(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @POST(Apis.ppobTransaction)
  Future<dynamic> postPpobTransaction(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @POST(Apis.ppobCheckBill)
  Future<dynamic> postCheckBill(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // paylater
  @GET(Apis.paylaterPeriod)
  Future<dynamic> getPaylaterPeriod(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.paylaterInvoice)
  Future<dynamic> getPaylaterInvoice(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // pin transaction
  @POST(Apis.pinCreate)
  Future<dynamic> postPinCreate(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // password change
  @POST(Apis.passwordChange)
  Future<dynamic> postPasswordChange(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // start master
  @GET(Apis.companyBank)
  Future<dynamic> getCompanyBank(@Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});
  // end master

  // start wallet
  @POST(Apis.walletDeposit)
  Future<dynamic> postWalletDeposit(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.walletDeposit)
  Future<dynamic> getWalletDeposit(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.walletTransaction)
  Future<dynamic> getWalletTransaction(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});
  // end wallet

  // start user
  @POST(Apis.updateFcm)
  Future<dynamic> postUpdateFcm(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});
  // end user

  // start company faq
  @GET(Apis.companyFaq)
  Future<dynamic> getCompanyFaq(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});
  // end company faq
}

// Future<T?> handleApiRequest<T>(Future<T> Function() apiCall) async {
//   try {
//     final response = await apiCall();
//     return response;
//   } on DioError catch (e) {
//     if (e.response != null) {
//       if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
//         // Jika sesi kedaluwarsa, tangani di sini
//         print("Session expired. Redirecting to login...");
//         await handleSessionExpired(); // Fungsi untuk mengatasi sesi kedaluwarsa
//         return null;
//       } else {
//         // Menangani kesalahan lain yang dihasilkan oleh server
//         print('DioError response data: ${e.response?.data}');
//         print('DioError response status: ${e.response?.statusCode}');
//       }
//     } else {
//       // Kesalahan jaringan atau kesalahan konfigurasi lainnya
//       print('DioError message: ${e.message}');
//     }
//     return null;
//   } catch (e) {
//     // Menangani kesalahan tak terduga lainnya
//     print('Unexpected error: $e');
//     return null;
//   }
// }

// Future<void> handleSessionExpired() async {
//   // Contoh logika: Arahkan pengguna ke halaman login atau perbarui token
//   // Misalnya, dengan menggunakan Navigator atau memberikan event logout pada aplikasi.

//   // Misal: Navigator.pushReplacementNamed(context, '/login');
//   print("Redirecting user to login page...");

//   // Jika menggunakan token refresh, panggil logika refresh token di sini.
// }

// Future<T?> __handleApiRequest<T>(Future<T> Function() apiCall) async {
//   try {
//     final response = await apiCall();
//     return response;
//   } on DioError catch (e) {
//     if (e.response != null) {
//       if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
//         // Coba refresh token terlebih dahulu
//         final tokenRefreshed = await refreshToken();
//         if (tokenRefreshed) {
//           // Jika berhasil, ulangi permintaan API dengan token baru
//           try {
//             final retryResponse = await apiCall();
//             return retryResponse;
//           } on DioError catch (retryError) {
//             print(
//                 "Retry error after refreshing token: ${retryError.message}");
//             return null;
//           }
//         } else {
//           // Jika refresh token gagal, arahkan pengguna ke halaman login
//           print(
//               "Session expired and refresh token failed. Redirecting to login...");
//           await handleSessionExpired();
//           return null;
//         }
//       } else {
//         print('DioError response data: ${e.response?.data}');
//         print('DioError response status: ${e.response?.statusCode}');
//       }
//     } else {
//       print('DioError message: ${e.message}');
//     }
//     return null;
//   } catch (e) {
//     print('Unexpected error: $e');
//     return null;
//   }
// }

// Future<bool> refreshToken() async {
//   try {

//     final storedRefreshToken = SharedPrefs().refreshToken;

//     if (storedRefreshToken == null) {
//       print("No refresh token available.");
//       return false;
//     }

//     // Kirim permintaan refresh token
//     final dio = Dio();
//     final response = await dio.post(
//       'https://dev-api.kumpulpay.com/refresh', // Ganti dengan endpoint refresh token yang benar
//       data: {'refresh_token': storedRefreshToken},
//       options: Options(headers: {
//         'Content-Type': 'application/json',
//       }),
//     );

//     if (response.statusCode == 200) {
//       final newAccessToken = response.data['access_token'];
//       final newRefreshToken = response.data['refresh_token'];

//       // Simpan access token dan refresh token yang baru
//       SharedPrefs().token = newAccessToken;
//       SharedPrefs().refreshToken = newRefreshToken;

//       print("Token refreshed successfully.");
//       return true;
//     } else {
//       print("Failed to refresh token. Status code: ${response.statusCode}");
//       return false;
//     }
//   } catch (e) {
//     print("Error refreshing token: $e");
//     return false;
//   }
// }

// Future<dynamic> getProtectedResource() async {
//   final accessToken = SharedPrefs().refreshToken;

//   final dio = Dio();
//   dio.options.headers['Authorization'] = 'Bearer $accessToken';

//   final response = await handleApiRequest(
//       () => dio.get('https://dev-api.kumpulpay.com/protected'));
//   return response;
// }
