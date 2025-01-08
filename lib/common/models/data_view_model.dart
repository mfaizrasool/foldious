class DataViewModel {
  bool? status;
  List<Data>? data;

  DataViewModel({this.status, this.data});

  DataViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? dataId;
  String? fileAccessCode;
  String? dataFileId;
  String? dataFileName;
  String? dataFileSize;
  String? dataFileDimension;
  String? userId;
  String? folderId;

  Data(
      {this.dataId,
      this.fileAccessCode,
      this.dataFileId,
      this.dataFileName,
      this.dataFileSize,
      this.dataFileDimension,
      this.userId,
      this.folderId});

  Data.fromJson(Map<String, dynamic> json) {
    dataId = json['data_id'];
    fileAccessCode = json['file_access_code'];
    dataFileId = json['data_file_id'];
    dataFileName = json['data_file_name'];
    dataFileSize = json['data_file_size'];
    dataFileDimension = json['data_file_dimension'];
    userId = json['user_id'];
    folderId = json['folder_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_id'] = this.dataId;
    data['file_access_code'] = this.fileAccessCode;
    data['data_file_id'] = this.dataFileId;
    data['data_file_name'] = this.dataFileName;
    data['data_file_size'] = this.dataFileSize;
    data['data_file_dimension'] = this.dataFileDimension;
    data['user_id'] = this.userId;
    data['folder_id'] = this.folderId;
    return data;
  }
}
