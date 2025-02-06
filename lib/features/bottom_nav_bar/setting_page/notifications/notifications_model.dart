class NotificationsModel {
  String? message;
  List<Notifications>? notifications;
  int? unreadCount;

  NotificationsModel({this.message, this.notifications, this.unreadCount});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['unread_count'] = this.unreadCount;
    return data;
  }
}

class Notifications {
  String? id;
  String? title;
  String? body;
  String? route;
  String? bookId;
  String? userId;
  String? isRead;
  String? createdAt;

  Notifications(
      {this.id,
      this.title,
      this.body,
      this.route,
      this.bookId,
      this.userId,
      this.isRead,
      this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    route = json['route'];
    bookId = json['book_id'];
    userId = json['user_id'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['route'] = this.route;
    data['book_id'] = this.bookId;
    data['user_id'] = this.userId;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}
