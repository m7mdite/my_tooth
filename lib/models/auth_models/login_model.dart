class LoginModel {
 
  final String email;
  final String password;

  LoginModel(
      {
      required this.email,
      required this.password,
      });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      password: json['password'] ?? 'password',
      email: json['email'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      'password': password,
      
    };
  }

  @override
  String toString() {
    return "";
  }
}
