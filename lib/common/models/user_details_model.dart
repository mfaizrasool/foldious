class UserDetailsModel {
  User? user;

  UserDetailsModel({this.user});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }
}

class User {
  UserDetails? userDetails;
  PackageDetails? packageDetails;
  FolderDetails? folderDetails;
  StorageDetails? storageDetails;
  TransactionDetails? transactionDetails;

  User(
      {this.userDetails,
      this.packageDetails,
      this.folderDetails,
      this.storageDetails,
      this.transactionDetails});

  User.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    packageDetails = json['package_details'] != null
        ? new PackageDetails.fromJson(json['package_details'])
        : null;
    folderDetails = json['folder_details'] != null
        ? new FolderDetails.fromJson(json['folder_details'])
        : null;
    storageDetails = json['storage_details'] != null
        ? new StorageDetails.fromJson(json['storage_details'])
        : null;
    transactionDetails = json['transaction_details'] != null
        ? new TransactionDetails.fromJson(json['transaction_details'])
        : null;
  }
}

class UserDetails {
  String? userId;
  String? packageId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userChannelId;
  String? userImage;
  String? userContact;
  String? userAge;
  String? userGender;
  String? userAddress;
  String? userVerify;
  String? userBalance;
  String? userReferalId;
  String? createdAt;

  UserDetails(
      {this.userId,
      this.packageId,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.userChannelId,
      this.userImage,
      this.userContact,
      this.userAge,
      this.userGender,
      this.userAddress,
      this.userVerify,
      this.userBalance,
      this.userReferalId,
      this.createdAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    packageId = json['package_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userChannelId = json['user_channel_id'];
    userImage = json['user_image'];
    userContact = json['user_contact'];
    userAge = json['user_age'];
    userGender = json['user_gender'];
    userAddress = json['user_address'];
    userVerify = json['user_verify'];
    userBalance = json['user_balance'];
    userReferalId = json['user_referal_id'];
    createdAt = json['created_at'];
  }
}

class PackageDetails {
  String? packageId;
  String? packageName;
  String? packageDuration;
  String? packageAmount;
  String? packageStorage;

  PackageDetails(
      {this.packageId,
      this.packageName,
      this.packageDuration,
      this.packageAmount,
      this.packageStorage});

  PackageDetails.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    packageName = json['package_name'];
    packageDuration = json['package_duration'];
    packageAmount = json['package_amount'];
    packageStorage = json['package_storage'];
  }
}

class FolderDetails {
  String? folderId;
  String? folderKey;
  String? userId;
  String? parentId;
  String? folderName;
  String? folderPassword;
  String? createdAt;

  FolderDetails(
      {this.folderId,
      this.folderKey,
      this.userId,
      this.parentId,
      this.folderName,
      this.folderPassword,
      this.createdAt});

  FolderDetails.fromJson(Map<String, dynamic> json) {
    folderId = json['folder_id'];
    folderKey = json['folder_key'];
    userId = json['user_id'];
    parentId = json['parent_id'];
    folderName = json['folder_name'];
    folderPassword = json['folder_password'];
    createdAt = json['created_at'];
  }
}

class StorageDetails {
  String? totalStorage;
  String? storageUsed;
  String? remainingStorage;
  String? usagePercentage;
  String? totalImageFiles;
  String? totalImagesSize;
  String? totalVideoFiles;
  String? totalVideoSize;
  String? totalTextFiles;
  String? totalTextSize;
  String? totalApplicationFiles;
  String? totalApplicationSize;

  StorageDetails(
      {this.totalStorage,
      this.storageUsed,
      this.remainingStorage,
      this.usagePercentage,
      this.totalImageFiles,
      this.totalImagesSize,
      this.totalVideoFiles,
      this.totalVideoSize,
      this.totalTextFiles,
      this.totalTextSize,
      this.totalApplicationFiles,
      this.totalApplicationSize});

  StorageDetails.fromJson(Map<String, dynamic> json) {
    totalStorage = json['total_storage'];
    storageUsed = json['storage_used'];
    remainingStorage = json['remaining_storage'];
    usagePercentage = json['usage_percentage'];
    totalImageFiles = json['total_image_files'];
    totalImagesSize = json['total_images_size'];
    totalVideoFiles = json['total_video_files'];
    totalVideoSize = json['total_video_size'];
    totalTextFiles = json['total_text_files'];
    totalTextSize = json['total_text_size'];
    totalApplicationFiles = json['total_application_files'];
    totalApplicationSize = json['total_application_size'];
  }
}

class TransactionDetails {
  String? transactionId;
  String? userId;
  String? packageId;
  String? transactionAmount;
  String? transactionSource;
  String? transactionDate;
  String? transactionExpiryDate;

  TransactionDetails(
      {this.transactionId,
      this.userId,
      this.packageId,
      this.transactionAmount,
      this.transactionSource,
      this.transactionDate,
      this.transactionExpiryDate});

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    transactionAmount = json['transaction_amount'];
    transactionSource = json['transaction_source'];
    transactionDate = json['transaction_date'];
    transactionExpiryDate = json['transaction_expiry_date'];
  }
}
