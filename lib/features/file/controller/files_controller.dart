import 'package:geolocation/features/file/model/file_item.dart';
import 'package:get/get.dart';

class FilesController extends GetxController {
  static FilesController controller = Get.find();

  var files = <FileItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles(); // Fetch files when the controller initializes
  }

  void fetchFiles() {
    // Example of adding some files to the list
    files.addAll([
      FileItem(name: 'Report_2024.pdf', extension: 'pdf'),
      FileItem(name: 'Meeting_Notes.docx', extension: 'docx'),
      FileItem(name: 'Budget_Proposal_2024.pdf', extension: 'pdf'),
      FileItem(name: 'Project_Plan.docx', extension: 'docx'),
      FileItem(name: 'Presentation_Slides.pptx', extension: 'pptx'),
    ]);
  }

  void addFile(FileItem file) {
    files.add(file);
  }

  void removeFile(FileItem file) {
    files.remove(file);
  }
}