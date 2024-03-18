class SignupRequest {
  final String login_id; // 사용할 아이디
  final String password; // 사용할 비밀번호
  final String confirmpassword; // 비밀번호 확인
  final String username; // 사용자 실명
  final String birthdate; // 주민번호 앞 6자리
  final String rr_number; // 주민번호 뒤 7자리

  SignupRequest({
    required this.login_id,
    required this.password,
    required this.confirmpassword,
    required this.username,
    required this.birthdate,
    required this.rr_number,
  });

  Map<String, dynamic> toJson() => {
    'login_id': login_id,
    'password': password,
    'confirmPassword': confirmpassword,
    'username': username,
    'birthdate': birthdate,
    'rr_number': rr_number,
  };
}
