import 'package:bloc_weather2/product/enum/ServiceEnum.dart';

extension ServiceExtensions on ServicePath {
  String get rawValue {
    switch (this) {
      case ServicePath.CURRENT:
        return "/v1/current.json?key=";
    }
  }
}
