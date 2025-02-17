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
  String? fileDownloadPath;

  Files({
    this.fileId,
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
    this.fileDownloadPath,
  });

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
    fileDownloadPath = json['file_download_path'];
  }
}
