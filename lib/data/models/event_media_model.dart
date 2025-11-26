import 'package:dago_valley_explore/domain/entities/event_media.dart';

class EventMediaModel extends EventMedia {
  EventMediaModel({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  }) : super(
         id: id,
         filePath: filePath,
         fileName: fileName,
         mimeType: mimeType,
         fileSize: fileSize,
       );

  final int id;
  final String filePath;
  final String fileName;
  final String mimeType;
  final String fileSize;

  @override
  factory EventMediaModel.fromJson(Map<String, dynamic> json) =>
      EventMediaModel(
        id: json["id"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        fileSize: json["file_size"],
      );
}
