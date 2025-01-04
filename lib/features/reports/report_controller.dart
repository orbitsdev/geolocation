import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class ReportController extends GetxController {
  static ReportController get controller => Get.find<ReportController>();
  bool isLoadingEvents = false;
  bool isLoadingCollections = false;
  bool isLoadingTasks = false;

  // Helper to get councilId
  int? get councilId => AuthController.controller.user.value.defaultPosition?.councilId;

  // Export Events Report
  Future<void> exportEventsByCouncil() async {
    if (councilId == null) {
      Get.snackbar('Error', 'Council ID not found.');
      return;
    }

    isLoadingEvents = true;
    update();

    final url = 'https://geolocation.me/api/report/council/$councilId/events/export';
    await _openInBrowser(url);

    isLoadingEvents = false;
    update();
  }

  // Export Collections Report
  Future<void> exportCollectionsByCouncil() async {
    if (councilId == null) {
      Get.snackbar('Error', 'Council ID not found.');
      return;
    }

    isLoadingCollections = true;
    update();

    final url = 'https://geolocation.me/api/report/council/$councilId/collections/export';
    await _openInBrowser(url);

    isLoadingCollections = false;
    update();
  }

  // Export Tasks Report
  Future<void> exportTasksByCouncil() async {
    if (councilId == null) {
      Get.snackbar('Error', 'Council ID not found.');
      return;
    }

    isLoadingTasks = true;
    update();

    final url = 'https://geolocation.me/api/report/council/$councilId/tasks/export';
    await _openInBrowser(url);

    isLoadingTasks = false;
    update();
  }

   bool isLoadingAttendance = false;

  Future<void> exportEventAttendance(int eventId) async {
    isLoadingAttendance = true;
    update();

    final url = 'https://geolocation.me/api/report/event/attendance/export/$eventId';
    await _openInBrowser(url);

    isLoadingAttendance = false;
    update();
  }

  Future<void> exportAttendanceByCouncilPosition({
  required int councilId,
  required int councilPositionId,
}) async {
  final url = 'https://geolocation.me/api/report/council/$councilId/position/$councilPositionId/attendance/export';
  await _openInBrowser(url);
}


Future<void> exportTasksByCouncilPosition({required int councilPositionId}) async {
  final url = 'https://geolocation.me/api/report/council-position/$councilPositionId/tasks/export';
  await _openInBrowser(url);
}


  // Open URL in Browser
  Future<void> _openInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open the browser for downloading.');
    }
  }
}
