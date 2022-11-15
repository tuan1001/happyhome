import 'dart:convert';

class TranningFile {
  final int id;
  final String title;
  final String url;
  TranningFile({
    required this.id,
    required this.title,
    required this.url,
  });

  TranningFile copyWith({
    int? id,
    String? title,
    String? url,
  }) {
    return TranningFile(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'filename': url,
    };
  }

  factory TranningFile.fromMap(Map<String, dynamic> map) {
    return TranningFile(
      id: map['id'] as int,
      title: map['title'] as String,
      url: map['filename'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TranningFile.fromJson(String source) => TranningFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TranningFile(title: $title, url: $url, id: $id)';

  @override
  bool operator ==(covariant TranningFile other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url && other.id == id;
  }

  @override
  int get hashCode => title.hashCode ^ url.hashCode ^ id.hashCode;
}
