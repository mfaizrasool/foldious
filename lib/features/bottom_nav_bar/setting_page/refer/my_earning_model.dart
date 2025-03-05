class MyEarningModel {
  bool? status;
  int? earnings;
  Null totalWithdraw;
  List<UserData>? userData;

  MyEarningModel(
      {this.status, this.earnings, this.totalWithdraw, this.userData});

  MyEarningModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    earnings = json['earnings'];
    totalWithdraw = json['total_withdraw'];
    if (json['user_data'] != null) {
      userData = <UserData>[];
      json['user_data'].forEach((v) {
        userData!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['earnings'] = this.earnings;
    data['total_withdraw'] = this.totalWithdraw;
    if (this.userData != null) {
      data['user_data'] = this.userData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? userId;
  String? userName;
  String? userEmail;
  String? createdAt;
  String? userReferalAmount;

  UserData(
      {this.userId,
      this.userName,
      this.userEmail,
      this.createdAt,
      this.userReferalAmount});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    createdAt = json['created_at'];
    userReferalAmount = json['user_referal_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['created_at'] = this.createdAt;
    data['user_referal_amount'] = this.userReferalAmount;
    return data;
  }
}
