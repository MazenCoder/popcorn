import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'injection.config.dart';


final getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureInjection(String env) => getIt.init(environment: env);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}