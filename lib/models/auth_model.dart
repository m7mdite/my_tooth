class AuthModel {
  final String firstName;
  final String lastName;
  final String fatherName;
  final String email;
  final String gender;
  final String password;
  final String? universityNumber;
  final String role;

  AuthModel(
      {required this.firstName,
      required this.lastName,
      required this.fatherName,
      required this.email,
      required this.gender,
      required this.password,
      this.universityNumber,
      required this.role});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(gender: json['gender']??'male',
      password: json['password'] ?? 'password',
      email: json['email'],
      firstName: json['first_name'] ?? 'first_name',
      fatherName: json['father_name'] ?? 'father_name',
      lastName: json['last_name'] ?? 'last_name',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      'password': password,
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
      'gender': gender,
      "role":role,
      if(role=="student")'university_number':universityNumber,
    };
  }

  @override
  String toString() {
    return "";
  }
}
