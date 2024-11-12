import 'dart:convert';

class MediaFile {
  
  static const List<String> imageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'svg'
  ];

  // Video Formats
  static const List<String> videoFormats = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
    'mkv',
    'webm'
  ];

  // Audio Formats
  static const List<String> audioFormats = [
    'mp3',
    'wav',
    'aac',
    'flac',
    'ogg',
    'm4a'
  ];

  // Document Formats
  static const List<String> documentFormats = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'csv'
  ];

  // Compressed Formats
  static const List<String> compressedFormats = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gz'
  ];

  // Other Formats
  static const List<String> otherFormats = [
    'json',
    'xml',
    'html',
    'css',
    'js'
  ];

  /// Returns the category of a file based on its extension.
  static String getCategory(String extension) {
    extension = extension.toLowerCase();

    if (imageFormats.contains(extension)) {
      return 'Image';
    } else if (videoFormats.contains(extension)) {
      return 'Video';
    } else if (audioFormats.contains(extension)) {
      return 'Audio';
    } else if (documentFormats.contains(extension)) {
      return 'Document';
    } else if (compressedFormats.contains(extension)) {
      return 'Compressed';
    } else if (otherFormats.contains(extension)) {
      return 'Other';
    } else {
      return 'Unknown';
    }
  }

  int? id;      
  String? url;   
  String? file_name;   
  String? type;  
  String? extension; 

  MediaFile({
    this.id,
    this.file_name,
    this.url,
    this.type,
    this.extension,
  });

  MediaFile copyWith({
    int? id,
    String? file_name,
    String? url,
    String? type,
    String? extension,
  }) {
    return MediaFile(
      id: id ?? this.id,
      file_name: file_name ?? this.file_name,
      url: url ?? this.url,
      type: type ?? this.type,
      extension: extension ?? this.extension,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'file_name': file_name,
      'url': url,
      'type': type,
      'extension': extension,
    };
  }

  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      id: map['id'] != null ? map['id'] as int : null,
      file_name: map['file_name'] != null ? map['file_name'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      extension: map['extension'] != null ? map['extension'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaFile.fromJson(String source) => MediaFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MediaFile(id: $id, url: $url, file_name: $file_name, type: $type, extension: $extension)';

}
