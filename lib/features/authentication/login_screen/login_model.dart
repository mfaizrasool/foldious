class LoginModel {
  bool? status;
  String? userId;

  LoginModel({this.status, this.userId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    return data;
  }
}
