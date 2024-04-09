
import 'package:injectable/injectable.dart';

@Singleton(order: -1)
class AppConfigs {
  // 현재는 local host 로 테스트
  String get apiBaseUrl => 'localhost:8080';
  String get apiUrl => 'http://$apiBaseUrl/api/v1';
}