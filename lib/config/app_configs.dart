
import 'package:injectable/injectable.dart';

@Singleton(order: -1)
class AppConfigs {
  // 현재는 local host 로 테스트
  String get apiBaseUrl => '10.0.2.2:8080';
  // String get apiBaseUrl => 'localhost:8080';
  // String get apiBaseUrl => '127.0.0.1:8080';
  String get apiUrl => 'http://$apiBaseUrl/api/v1';
}