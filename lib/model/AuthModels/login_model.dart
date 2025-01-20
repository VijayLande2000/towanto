class LoginModel {
  final String status;
  final String message;
  final int userId;
  final int partnerId;
  final String sessionId;
  final String username;


  LoginModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.partnerId,
    required this.sessionId,
    required this.username,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userId: json['user_id'] ?? 0,
      partnerId: json['partner_id'] ?? 0,
      sessionId: json['session_id'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user_id': userId,
      'partner_id': partnerId,
      'session_id': sessionId,
      'username': username,
    };
  }
}
