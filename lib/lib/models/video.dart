// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TranningVideo {
  final String title;
  final String url;
  final String description;
  final String tags;
  final String imageUrl;
  TranningVideo({
    required this.title,
    required this.url,
    required this.description,
    required this.tags,
    required this.imageUrl,
  });

  TranningVideo copyWith({
    String? title,
    String? url,
    String? description,
    String? tags,
    String? imageUrl,
  }) {
    return TranningVideo(
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'file_name': url,
      'description': description,
      'tags': tags,
      'image': imageUrl,
    };
  }

  factory TranningVideo.fromMap(Map<String, dynamic> map) {
    return TranningVideo(
      title: map['title'] as String,
      url: map['file_name'] as String,
      description: map['description'] as String,
      tags: map['tags'] as String,
      imageUrl: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TranningVideo.fromJson(String source) => TranningVideo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TranningVideo(title: $title, url: $url, description: $description, tags: $tags, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant TranningVideo other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url && other.description == description && other.tags == tags && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^ url.hashCode ^ description.hashCode ^ tags.hashCode ^ imageUrl.hashCode;
  }
}
