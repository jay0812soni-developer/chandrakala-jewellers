import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

class CustomerSession {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String token;

  const CustomerSession({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.token,
  });
}

class CustomerAuthService {
  static const _tokenKey = 'cj_customer_token';
  static const _idKey = 'cj_customer_id';
  static const _nameKey = 'cj_customer_name';
  static const _phoneKey = 'cj_customer_phone';
  static const _emailKey = 'cj_customer_email';

  final ApiClient _client = ApiClient();

  Future<CustomerSession?> current() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';
    final id = prefs.getInt(_idKey) ?? 0;
    final name = prefs.getString(_nameKey) ?? '';
    final phone = prefs.getString(_phoneKey) ?? '';
    if (token.isEmpty || id <= 0 || phone.isEmpty) {
      return null;
    }
    _client.setAuthToken(token);
    return CustomerSession(
      id: id,
      name: name,
      phone: phone,
      email: prefs.getString(_emailKey) ?? '',
      token: token,
    );
  }

  Future<CustomerSession> login({required String phone, required String password}) async {
    final response = await _client.dio.post('/auth/login', data: {
      'phone': phone,
      'password': password,
    });
    return _persist(response.data);
  }

  Future<CustomerSession> register({
    required String name,
    required String phone,
    required String password,
    String email = '',
  }) async {
    final response = await _client.dio.post('/auth/register', data: {
      'name': name,
      'phone': phone,
      'password': password,
      'email': email,
    });
    return _persist(response.data);
  }

  Future<List<Map<String, dynamic>>> orderHistory() async {
    final session = await current();
    if (session == null) return [];
    _client.setAuthToken(session.token);
    final response = await _client.dio.get('/orders/mine');
    if (response.statusCode == 200 && response.data['ok'] == true) {
      final List list = response.data['data'] as List? ?? [];
      return list.map((row) => Map<String, dynamic>.from(row as Map)).toList();
    }
    return [];
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_emailKey);
    _client.clearAuthToken();
  }

  Future<CustomerSession> _persist(dynamic data) async {
    if (data is! Map || data['ok'] != true || data['token'] == null) {
      throw Exception((data is Map ? data['message'] : null) ?? 'Could not sign in.');
    }
    final customer = Map<String, dynamic>.from(data['customer'] as Map);
    final token = data['token'].toString();
    final session = CustomerSession(
      id: int.tryParse(customer['id'].toString()) ?? 0,
      name: customer['name']?.toString() ?? '',
      phone: customer['phone']?.toString() ?? '',
      email: customer['email']?.toString() ?? '',
      token: token,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, session.token);
    await prefs.setInt(_idKey, session.id);
    await prefs.setString(_nameKey, session.name);
    await prefs.setString(_phoneKey, session.phone);
    await prefs.setString(_emailKey, session.email);
    _client.setAuthToken(session.token);
    return session;
  }
}
