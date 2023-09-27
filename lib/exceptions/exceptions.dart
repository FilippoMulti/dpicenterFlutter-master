class FetchDataException implements Exception {
  final dynamic message;

  FetchDataException([this.message]);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
