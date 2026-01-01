import 'package:dio/dio.dart';
import 'package:nexus_frontend/services/tokenStorage.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.read(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: "http://https://backend-production-3488.up.railway.app/api",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
      },
      // 🔥 IMPORTANT: allow 400 responses without throwing
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options);
      },

      onError: (error, handler) async {
        // 🔐 Only handle expired token case
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains("auth/refresh")) {

          final refreshToken = await tokenStorage.getRefreshToken();

          if (refreshToken == null) {
            await tokenStorage.clear();
            return handler.reject(error);
          }

          try {
            final response = await dio.post(
              "auth/refresh",
              options: Options(
                headers: {
                  "Authorization": "Bearer $refreshToken",
                },
              ),
            );

            final newAccessToken = response.data["accessToken"];
            await tokenStorage.saveAccessToken(newAccessToken);

            final requestOptions = error.requestOptions;
            requestOptions.headers["Authorization"] =
                "Bearer $newAccessToken";

            final retryResponse = await dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            await tokenStorage.clear();
            return handler.reject(error);
          }
        }

        // ✅ For 400/422 validation errors, pass response forward
        if (error.response != null &&
            error.response!.statusCode! < 500) {
          return handler.resolve(error.response!);
        }

        handler.reject(error);
      },
    ),
  );

  return dio;
});
