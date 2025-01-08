class ForgotModel {
  bool? status;
  String? messaage;

  ForgotModel({this.status, this.messaage});

  ForgotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messaage = json['messaage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messaage'] = this.messaage;
    return data;
  }
}
