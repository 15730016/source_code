/// Configuration for API endpoints and settings
class ApiConfig {
  /// Base URL for the API
  static const String baseUrl = 'https://sint.vn/api';

  /// API version
  static const String apiVersion = 'v1';

  /// Timeout duration for API calls
  static const Duration timeout = Duration(seconds: 30);

  /// Endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String profile = 'user/profile';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String flashDeals = 'flash-deals';
  static const String cart = 'cart';
  static const String orders = 'orders';
  static const String brands = 'brands';
  static const String refund = 'refund-requests';
  
  /// Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Build full URL for an endpoint
  static String buildUrl(String endpoint) {
    return '$baseUrl/$apiVersion/$endpoint';
  }
}
