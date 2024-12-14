import 'dart:convert';

import 'package:geolocation/features/auth/model/council_position.dart';

class MediaResource {
  int? id;              // Media ID
  String? fileName;      // File name
  String? url;           // File URL
  String? type;          // MIME type
  String? extension;     // File extension
  int? size;             // File size in bytes
  String? collectionName; // Media collection name
  CouncilPosition? councilPosition; // Related council position if applicable

  MediaResource({
    this.id,
    this.fileName,
    this.url,
    this.type,
    this.extension,
    this.size,
    this.collectionName,
    this.councilPosition,
  });

  // Copy constructor for immutability and easy modification
  MediaResource copyWith({
    int? id,
    String? fileName,
    String? url,
    String? type,
    String? extension,
    int? size,
    String? collectionName,
    CouncilPosition? councilPosition,
  }) {
    return MediaResource(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      type: type ?? this.type,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      collectionName: collectionName ?? this.collectionName,
      councilPosition: councilPosition ?? this.councilPosition,
    );
  }

  // Convert the object to a Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'file_name': fileName,
      'url': url,
      'type': type,
      'extension': extension,
      'size': size,
      'collection_name': collectionName,
      'council_position': councilPosition?.toMap(),
    };
  }

  // Create the object from a Map
  factory MediaResource.fromMap(Map<String, dynamic> map) {
    return MediaResource(
      id: map['id'] != null ? map['id'] as int : null,
      fileName: map['file_name'] != null ? map['file_name'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      extension: map['extension'] != null ? map['extension'] as String : null,
      size: map['size'] != null ? map['size'] as int : null,
      collectionName: map['collection_name'] != null ? map['collection_name'] as String : null,
      councilPosition: map['council_position'] != null
          ? CouncilPosition.fromMap(map['council_position'] as Map<String, dynamic>)
          : null,
    );
  }

  // Convert the object to a JSON string
  String toJson() => json.encode(toMap());

  // Create the object from a JSON string
  factory MediaResource.fromJson(String source) =>
      MediaResource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MediaResource(id: $id, fileName: $fileName, url: $url, type: $type, extension: $extension, size: $size, collectionName: $collectionName, councilPosition: $councilPosition)';
  }
}
