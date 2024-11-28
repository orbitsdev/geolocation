// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/post/model/related_model.dart';

class Post {
  int? id;
  String? title;
  String? content;
  String? description;
  String? createdAt;
  String? updatedAt;
  bool? isPublish;
  List<MediaFile>? media; // List of associated media files
  Council? council;
  CouncilPosition? councilPosition;
  RelatedModel? relatedModel; // Dynamically handles related models

  Post({
    this.id,
    this.title,
    this.content,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isPublish,
    this.media,
    this.council,
    this.councilPosition,
    this.relatedModel,
  });

  /// Creates a copy of the current instance with updated fields.
  Post copyWith({
    int? id,
    String? title,
    String? content,
    String? description,
    String? createdAt,
    String? updatedAt,
    bool? isPublish,
    List<MediaFile>? media,
    Council? council,
    CouncilPosition? councilPosition,
    RelatedModel? relatedModel,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublish: isPublish ?? this.isPublish,
      media: media ?? this.media,
      council: council ?? this.council,
      councilPosition: councilPosition ?? this.councilPosition,
      relatedModel: relatedModel ?? this.relatedModel,
    );
  }

  /// Converts a map to a `Post` instance.
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      isPublish: map['is_publish'] != null ? map['is_publish'] as bool : null,
      media: map['media'] != null
          ? List<MediaFile>.from(
              (map['media'] as List<dynamic>).map((x) => MediaFile.fromMap(x as Map<String, dynamic>)))
          : null,
      council: map['council'] != null ? Council.fromMap(map['council'] as Map<String, dynamic>) : null,
      councilPosition: map['council_position'] != null
          ? CouncilPosition.fromMap(map['council_position'] as Map<String, dynamic>)
          : null,
      relatedModel: map['related_model'] != null
          ? RelatedModel.fromMap(map['related_model'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts the `Post` instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_publish': isPublish,
      'media': media?.map((x) => x.toMap()).toList(),
      'council': council?.toMap(),
      'council_position': councilPosition?.toMap(),
      'related_model': relatedModel?.toMap(),
    };
  }

  /// Converts the `Post` instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a `Post` instance from a JSON string.
  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  /// String representation of the `Post` instance.
  @override
  String toString() {
    return 'Post(id: $id, title: $title, content: $content, description: $description, createdAt: $createdAt, updatedAt: $updatedAt,isPublish: $isPublish, media: $media, council: $council, councilPosition: $councilPosition, relatedModel: $relatedModel)';
  }
}
