import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:foldious/common/network_client/api_response.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/error_handler.dart';
import 'package:image_picker/image_picker.dart';

typedef GetUserAuthTokenCallback = Future<String?> Function();

class NetworkClient {
  static const contentTypeJson = 'application/json';
  static const contentTypeMultipart = 'multipart/form-data';

  final Dio _restClient;
  final Dio _fileClient;
  final GetUserAuthTokenCallback _getUserAuthToken;

  ///
  ///
  ///
  NetworkClient({
    required GetUserAuthTokenCallback getUserAuthToken,
  })  : _getUserAuthToken = getUserAuthToken,
        _restClient = _createDio(ApiUrls.baseUrl),
        _fileClient = _createDio(ApiUrls.baseUrl);

  ///
  ///
  ///
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.get(
        path,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool? sendUserAuth,
  }) async {
    try {
      final resp = await _restClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _createDioOptions(
          contentType: contentTypeJson,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required XFile file,
    bool? sendUserAuth,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final resp = await _fileClient.post(
        path,
        data: formData,
        options: await _createDioOptions(
          contentType: contentTypeMultipart,
          sendUserAuth: sendUserAuth,
        ),
      );

      final jsonData = resp.data;
      return ApiResponse<T>.success(
        statusCode: resp.statusCode,
        rawData: jsonData,
      );
    } on DioException catch (e) {
      return _createResponse<T>(e);
    }
  }

  ///
  ///
  ///
  ///

  Future<ApiResponse<T>> uploadChunk<T>(
    String path, {
    required XFile file,
    required String folderId,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final fileLength = await file.length(); // Get file size in bytes
      const int chunkSize = 1 * 1024 * 1024; // Chunk size: 1 MB
      final int totalChunks = (fileLength / chunkSize).ceil();
      int chunkIndex = 0;

      final String uniqueFileName =
          "${math.Random().nextInt(90000000) + 10000000}_${file.name}";

      // Stream file data for chunking
      final fileStream = file.openRead();
      List<int> buffer = [];
      int bytesUploaded = 0;

      // Iterate through file stream
      await for (final data in fileStream) {
        buffer.addAll(data);

        while (buffer.length >= chunkSize ||
            bytesUploaded + buffer.length == fileLength) {
          final int currentChunkSize =
              buffer.length >= chunkSize ? chunkSize : buffer.length;
          final List<int> currentChunk = buffer.sublist(0, currentChunkSize);
          buffer = buffer.sublist(currentChunkSize);
          bytesUploaded += currentChunkSize;

          final bool isLastChunk = chunkIndex + 1 == totalChunks;

          // Form data for the chunk
          final formData = FormData.fromMap({
            "chunkIndex": chunkIndex,
            "totalChunks": totalChunks,
            "folderId": folderId,
            "fileName": uniqueFileName,
            "fileChunk": MultipartFile.fromBytes(
              currentChunk,
              filename: "${uniqueFileName}_chunk_$chunkIndex",
            ),
          });

          await _fileClient.post(
            path,
            data: formData,
            options: Options(contentType: "multipart/form-data"),
            onSendProgress: (sent, total) {
              if (onSendProgress != null) {
                onSendProgress(sent, total);
              }
            },
          );

          chunkIndex++;
          if (isLastChunk) break;
        }
      }

      // Return success response
      return ApiResponse<T>.success(
        statusCode: 200,
        rawData: {
          "message": "File uploaded successfully",
          "fileName": uniqueFileName,
        },
      );
    } catch (e) {
      return ApiResponse<T>.error(message: e.toString());
    }
  }

  ///
  ///
  ///
  ApiResponse<T> _createResponse<T>(DioException error) {
    print("Error type: ${error.type}");
    print("Error message: ${error.message}");

    String errorStr = 'Unknown error';
    String message = 'Unknown error message';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Connection timed out'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 501,
          message: 'Connection timed out',
        );
      case DioExceptionType.connectionError:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Connection Error'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 502,
          message: 'Connection Error',
        );
      case DioExceptionType.unknown:
        ErrorHandler().handleError(
          ErrorHandler.networkError(
              'Something went wrong, check your internet connection and try again later'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 503,
          message:
              'Something went wrong, check your internet connection and try again later',
        );
      case DioExceptionType.receiveTimeout:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Receive timed out'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 502,
          message: 'Receive timed out',
        );
      case DioExceptionType.sendTimeout:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Failed to connect to server'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Failed to connect to server',
        );
      case DioExceptionType.badResponse:
        if (error.response?.data is Map<String, dynamic>) {
          errorStr = error.response?.data['error'] ?? errorStr;
          message = error.response?.data['message'] ?? message;
        } else {
          log("Unexpected response format: ${error.response?.data}");
          errorStr = 'Invalid response format';
          message = 'Unable to parse error message';
        }
        print("errorStr == $errorStr");
        print("message == $message");

        // Handle different HTTP status codes
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          ErrorHandler().handleError(
            ErrorHandler.authenticationError(message),
            showSnackbar: false,
          );
        } else if (statusCode == 403) {
          ErrorHandler().handleError(
            ErrorHandler.permissionError(message),
            showSnackbar: false,
          );
        } else if (statusCode! >= 500) {
          ErrorHandler().handleError(
            ErrorHandler.serverError(message),
            showSnackbar: false,
          );
        } else {
          ErrorHandler().handleError(
            ErrorHandler.validationError(message),
            showSnackbar: false,
          );
        }

        return ApiResponse<T>.error(
          statusCode: statusCode,
          error: errorStr,
          message: message,
        );
      case DioExceptionType.cancel:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Request canceled'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Request canceled',
        );
      case DioExceptionType.badCertificate:
        ErrorHandler().handleError(
          ErrorHandler.networkError('Bad Certificate'),
          showSnackbar: false,
        );
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Bad Certificate',
        );
    }
  }

  ///
  ///
  ///
  Future<Options> _createDioOptions({
    required String contentType,
    bool? sendUserAuth,
  }) async {
    final headers = Map<String, String>();
    if (sendUserAuth != null && sendUserAuth == true) {
      final authToken = await _getUserAuthToken();
      if (authToken != null) {
        headers['authorization'] = '$authToken';
      }
    }

    final options = Options(
      headers: headers,
      contentType: contentType,
    );
    return options;
  }
  // Future<Options> _createDioOptions({
  //   required String contentType,
  //   bool? sendUserAuth,
  // }) async {
  //   final headers = Map<String, String>();

  //   final options = Options(
  //     headers: headers,
  //     contentType: contentType,
  //   );
  //   return options;
  // }

  ///
  ///
  ///
  static Dio _createDio(String baseUrl) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    );
    final dio = Dio(options);
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        responseBody: true,
        requestBody: true,
        logPrint: (message) {
          log(message.toString());
        },
      ),
    );
    return dio;
  }
}
