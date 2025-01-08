class FileResource {
  String? message;
  int? fileId;
  String? fileName;
  String? fileType;
  int? fileSize;

  FileResource(
      {this.message, this.fileId, this.fileName, this.fileType, this.fileSize});

  FileResource.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    fileId = json['file_id'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['file_id'] = fileId;
    data['file_name'] = fileName;
    data['file_type'] = fileType;
    data['file_size'] = fileSize;
    return data;
  }
}
