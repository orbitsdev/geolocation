import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/globalcontroller/browserviewer_controller.dart';
import 'package:geolocation/features/files/model/media_resource.dart';

class MediaResourceBrowserViewerPage extends StatefulWidget {
  final MediaResource file;

  const MediaResourceBrowserViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<MediaResourceBrowserViewerPage> createState() =>
      _MediaResourceBrowserViewerPageState();
}

class _MediaResourceBrowserViewerPageState
    extends State<MediaResourceBrowserViewerPage> {
  final BrowserviewerController browserController =
      Get.put(BrowserviewerController());

  late String displayUrl;

  @override
  void initState() {
    super.initState();
    displayUrl = _getViewerUrl(widget.file.url ?? '');
  }

  @override
  void dispose() {
    // Check if the webViewController is already disposed
    if (browserController.webViewController != null) {
      browserController.webViewController = null; // Nullify the reference
    }
    super.dispose();
  }

  Future<void> handleBackButton() async {
    if (browserController.isDisposed) return;

    bool shouldExit = await browserController.confirmExit();
    if (shouldExit) {
      browserController.closeThenResetUrl();
    }
  }

  String _getViewerUrl(String fileUrl) {
    if (fileUrl.endsWith('.pdf')) {
      return 'https://docs.google.com/viewer?url=$fileUrl';
    } else if (fileUrl.endsWith('.docx') ||
        fileUrl.endsWith('.xlsx') ||
        fileUrl.endsWith('.pptx')) {
      return 'https://view.officeapps.live.com/op/view.aspx?src=$fileUrl';
    }
    return fileUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(widget.file.fileName ?? 'Document'),
        leading: IconButton(
          onPressed: () async {
            await handleBackButton();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<BrowserviewerController>(
              builder: (controller) {
                return InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri.uri(Uri.parse(displayUrl)),
                  ),
                  onWebViewCreated: (InAppWebViewController webViewController) {
                    controller.webViewController = webViewController;
                  },
                  onLoadStart: (webViewController, url) {
                    // Handle load start
                  },
                  onLoadStop: (webViewController, url) async {
                    // Handle load stop
                  },
                  onLoadError: (webViewController, url, code, message) {
                    controller.handleLoadError(
                      Failure(
                        message: "Error loading: $url, Error: $message",
                      ),
                    );
                  },
                  onLoadHttpError: (webViewController, url, statusCode, description) {
                    controller.handleLoadError(
                      Failure(
                        message:
                            "HTTP Error: $statusCode, Description: $description",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
