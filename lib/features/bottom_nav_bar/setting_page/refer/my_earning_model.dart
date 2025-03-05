class MyEarningModel {
  bool? status;
  int? earnings;
  List<UserData>? userData;

  MyEarningModel({this.status, this.earnings, this.userData});

  MyEarningModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    earnings = json['earnings'];
    if (json['user_data'] != null) {
      userData = <UserData>[];
      json['user_data'].forEach((v) {
        userData!.add(new UserData.fromJson(v));
      });
    }
  }
}

class UserData {
  String? userId;
  String? packageId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userChannelId;
  String? userReferalId;
  String? userImage;
  String? userContact;
  String? userAddress;
  String? userGender;
  String? userAge;
  String? userVerify;
  String? userBalance;
  String? createdAt;
  String? deletedAt;
  String? deviceToken;

  UserData(
      {this.userId,
      this.packageId,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.userChannelId,
      this.userReferalId,
      this.userImage,
      this.userContact,
      this.userAddress,
      this.userGender,
      this.userAge,
      this.userVerify,
      this.userBalance,
      this.createdAt,
      this.deletedAt,
      this.deviceToken});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    packageId = json['package_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userChannelId = json['user_channel_id'];
    userReferalId = json['user_referal_id'];
    userImage = json['user_image'];
    userContact = json['user_contact'];
    userAddress = json['user_address'];
    userGender = json['user_gender'];
    userAge = json['user_age'];
    userVerify = json['user_verify'];
    userBalance = json['user_balance'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    deviceToken = json['device_token'];
  }
}
