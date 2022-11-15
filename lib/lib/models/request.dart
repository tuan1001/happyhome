// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Request {
  int id;
  String title;
  String status;
  String content;
  String updateTime;
  Request({
    required this.id,
    required this.title,
    required this.status,
    required this.content,
    required this.updateTime,
  });

  Request copyWith({
    int? id,
    String? title,
    String? status,
    String? content,
    String? updateTime,
  }) {
    return Request(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      content: content ?? this.content,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'trang_thai': status,
      'noi_dung': content,
      'created': updateTime,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'] as int,
      title: map['title'] as String,
      status: map['trang_thai'] as String,
      content: map['noi_dung'] as String,
      updateTime: map['created'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) => Request.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Request(id: $id, title: $title, status: $status, content: $content, updateTime: $updateTime)';
  }

  @override
  bool operator ==(covariant Request other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.status == status && other.content == content && other.updateTime == updateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ status.hashCode ^ content.hashCode ^ updateTime.hashCode;
  }
}
