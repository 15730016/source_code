import 'package:json_annotation/json_annotation.dart';

/// Base class for all models that provides common functionality
abstract class BaseModel {
  /// Converts the model to a JSON Map
  Map<String, dynamic> toJson();

  /// Creates a copy of the model with updated fields
  BaseModel copyWith();

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseModel && toString() == other.toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Mixin to handle JSON keys that might be returned as different types
mixin JsonHelperMixin {
  /// Safely converts a dynamic value to int
  int? asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  /// Safely converts a dynamic value to double
  double? asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Safely converts a dynamic value to String
  String? asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  /// Safely converts a dynamic value to bool
  bool? asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return null;
  }

  /// Safely converts a dynamic value to List<T>
  List<T>? asList<T>(dynamic value, T Function(dynamic) converter) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) => converter(item)).toList();
    }
    return null;
  }

  /// Safely converts a dynamic value to Map<String, T>
  Map<String, T>? asMap<T>(dynamic value, T Function(dynamic) converter) {
    if (value == null) return null;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), converter(val)));
    }
    return null;
  }

  /// Converts DateTime to ISO 8601 string
  String? dateTimeToJson(DateTime? date) {
    return date?.toIso8601String();
  }

  /// Parses ISO 8601 string to DateTime
  DateTime? dateTimeFromJson(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  /// Formats price values consistently
  String formatPrice(num? price) {
    if (price == null) return '0.00';
    return price.toStringAsFixed(2);
  }

  /// Validates email format
  bool isValidEmail(String? email) {
    if (email == null) return false;
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  /// Validates phone number format
  bool isValidPhone(String? phone) {
    if (phone == null) return false;
    return RegExp(r'^\+?[\d\s-]+$').hasMatch(phone);
  }
}
