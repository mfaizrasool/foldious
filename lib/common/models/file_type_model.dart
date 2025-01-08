class FileTypeModel {
  bool? status;
  int? totalFiles;
  int? currentPage;
  int? filesOnCurrentPage;
  int? remainingFiles;
  bool? haveMoreData;
  List<Files>? files;

  FileTypeModel(
      {this.status,
      this.totalFiles,
      this.currentPage,
      this.filesOnCurrentPage,
      this.remainingFiles,
      this.haveMoreData,
      this.files});

  FileTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalFiles = json['total_files'];
    currentPage = json['current_page'];
    filesOnCurrentPage = json['files_on_current_page'];
    remainingFiles = json['remaining_files'];
    haveMoreData = json['have_more_data'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_files'] = this.totalFiles;
    data['current_page'] = this.currentPage;
    data['files_on_current_page'] = this.filesOnCurrentPage;
    data['remaining_files'] = this.remainingFiles;
    data['have_more_data'] = this.haveMoreData;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
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

  Files(
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
      this.fileState});

  Files.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
