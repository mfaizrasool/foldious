class WithdrawStatusModel {
  bool? status;
  List<WithdrawData>? withdrawData;

  WithdrawStatusModel({this.status, this.withdrawData});

  WithdrawStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['withdraw_data'] != null) {
      withdrawData = <WithdrawData>[];
      json['withdraw_data'].forEach((v) {
        withdrawData!.add(new WithdrawData.fromJson(v));
      });
    }
  }
}

class WithdrawData {
  String? withdrawId;
  String? userId;
  String? withdrawAmount;
  String? withdrawMethod;
  String? withdrawAccountName;
  String? withdrawAccountNumber;
  String? withdrawRequestDate;
  String? withdrawTransferDate;
  String? withdrawStatus;
  String? withdrawTransactionId;
  String? referalUsers;

  WithdrawData(
      {this.withdrawId,
      this.userId,
      this.withdrawAmount,
      this.withdrawMethod,
      this.withdrawAccountName,
      this.withdrawAccountNumber,
      this.withdrawRequestDate,
      this.withdrawTransferDate,
      this.withdrawStatus,
      this.withdrawTransactionId,
      this.referalUsers});

  WithdrawData.fromJson(Map<String, dynamic> json) {
    withdrawId = json['withdraw_id'];
    userId = json['user_id'];
    withdrawAmount = json['withdraw_amount'];
    withdrawMethod = json['withdraw_method'];
    withdrawAccountName = json['withdraw_account_name'];
    withdrawAccountNumber = json['withdraw_account_number'];
    withdrawRequestDate = json['withdraw_request_date'];
    withdrawTransferDate = json['withdraw_transfer_date'];
    withdrawStatus = json['withdraw_status'];
    withdrawTransactionId = json['withdraw_transaction_id'];
    referalUsers = json['referal_users'];
  }
}
