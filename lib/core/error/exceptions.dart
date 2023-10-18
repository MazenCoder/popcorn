import '../usecases/enums.dart';


class ServerException implements Exception {
  final String message;
  final RequestState state;
  const ServerException({
    required this.message,
    required this.state,
  });
}

class CacheException implements Exception {
  final String message;
  const CacheException({
    required this.message,
  });
}