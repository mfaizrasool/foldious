class ApiResponse<T> {
  final dynamic rawData;
  final int? statusCode;
  final String? error;
  final String? message;
  final T? data;
  final bool _isSuccess;

  ApiResponse({
    this.rawData,
    this.data,
    this.statusCode,
    this.error,
    this.message,
    required bool isSuccess,
  }) : _isSuccess = isSuccess;

  ///
  ///
  ///
  ApiResponse.success({
    this.rawData,
    this.data,
    this.statusCode,
  })  : _isSuccess = true,
        error = null,
        message = null;

  ///
  ///
  ///
  ApiResponse.error({
    this.statusCode,
    this.error,
    this.message,
  })  : _isSuccess = false,
        data = null,
        rawData = null;

  ApiResponse<T> copyWith({
    dynamic rawData,
    int? statusCode,
    String? error,
    String? message,
    T? data,
  }) {
    return ApiResponse<T>(
      rawData: rawData ?? this.rawData,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      error: error ?? this.error,
      message: message ?? this.message,
      isSuccess: this._isSuccess,
    );
  }

  bool get isSuccess => _isSuccess;

  @override
  String toString() {
    return 'status: ${_isSuccess ? 'success' : 'failed'}, message: ${message ?? ''}, statusCode: $statusCode, error: $error';
  }
}
