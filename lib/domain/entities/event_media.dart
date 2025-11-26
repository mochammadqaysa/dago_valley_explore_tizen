class EventMedia {
  final int id;
  final String filePath;
  final String fileName;
  final String mimeType;
  final String fileSize;

  EventMedia({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  });

  factory EventMedia.fromJson(Map<String, dynamic> json) => EventMedia(
    id: json['id'],
    filePath: json['file_path'],
    fileName: json['file_name'],
    mimeType: json['mime_type'],
    fileSize: json['file_size'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'file_path': filePath,
    'file_name': fileName,
    'mime_type': mimeType,
    'file_size': fileSize,
  };
}
