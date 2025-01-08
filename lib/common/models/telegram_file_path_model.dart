class TelegramFilePathModel {
  bool? ok;
  Result? result;

  TelegramFilePathModel({this.ok, this.result});

  TelegramFilePathModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? fileId;
  String? fileUniqueId;
  int? fileSize;
  String? filePath;

  Result({this.fileId, this.fileUniqueId, this.fileSize, this.filePath});

  Result.fromJson(Map<String, dynamic> json) {
    fileId = json['file_id'];
    fileUniqueId = json['file_unique_id'];
    fileSize = json['file_size'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_id'] = this.fileId;
    data['file_unique_id'] = this.fileUniqueId;
    data['file_size'] = this.fileSize;
    data['file_path'] = this.filePath;
    return data;
  }
}
