class AuthService {
  static String? _token;

  static Future<String> getToken() async {
    if (_token != null) {
      return _token!;
    }

    // In a real app, you would implement token refresh logic here
    throw Exception('No valid token found. Please login again.');
  }

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }
}
