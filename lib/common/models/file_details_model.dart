class FileDetailsModel {
  bool? status;
  Data? data;

  FileDetailsModel({this.status, this.data});

  FileDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? fileId;
  String? userId;
  String? folderKey;
  String? fileExternalUrl;
  String? fileName;
  String? fileAccessKey;
  String? fileUniqueId;
  String? fileSize;
  String? fileType;
  String? fileExtension;
  String? fileDate;
  String? fileStatus;
  String? fileState;
  String? fileDownloadPath;

  Data(
      {this.fileId,
      this.userId,
      this.folderKey,
      this.fileExternalUrl,
      this.fileName,
      this.fileAccessKey,
      this.fileUniqueId,
      this.fileSize,
      this.fileType,
      this.fileExtension,
      this.fileDate,
      this.fileStatus,
      this.fileState,
      this.fileDownloadPath});

  Data.fromJson(Map<String, dynamic> json) {
    fileId = json['file_id'];
    userId = json['user_id'];
    folderKey = json['folder_key'];
    fileExternalUrl = json['file_external_url'];
    fileName = json['file_name'];
    fileAccessKey = json['file_access_key'];
    fileUniqueId = json['file_unique_id'];
    fileSize = json['file_size'];
    fileType = json['file_type'];
    fileExtension = json['file_extension'];
    fileDate = json['file_date'];
    fileStatus = json['file_status'];
    fileState = json['file_state'];
    fileDownloadPath = json['file_download_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_id'] = this.fileId;
    data['user_id'] = this.userId;
    data['folder_key'] = this.folderKey;
    data['file_external_url'] = this.fileExternalUrl;
    data['file_name'] = this.fileName;
    data['file_access_key'] = this.fileAccessKey;
    data['file_unique_id'] = this.fileUniqueId;
    data['file_size'] = this.fileSize;
    data['file_type'] = this.fileType;
    data['file_extension'] = this.fileExtension;
    data['file_date'] = this.fileDate;
    data['file_status'] = this.fileStatus;
    data['file_state'] = this.fileState;
    data['file_download_path'] = this.fileDownloadPath;
    return data;
  }
}
