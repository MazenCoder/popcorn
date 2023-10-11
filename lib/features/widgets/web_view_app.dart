import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:popcorn/core/controllers/utils/utils_logic.dart';
import '../../core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class WebVewApp extends StatefulWidget {
  final String? title;
  final String url;
  const WebVewApp({
    Key? key, this.title, required this.url
  }) : super(key: key);

  @override
  _WebVewAppState createState() => _WebVewAppState();
}

class _WebVewAppState extends State<WebVewApp> {

  late WebViewController _controller;
  final _key = UniqueKey();


  @override
  void initState() {
    super.initState();
    utilsLogic.setStateLoading(true);
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            utilsLogic.setStateLoading(false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
            utilsLogic.setStateLoading(false);
            utilsLogic.showSnack(
              type: SnackBarType.error,
              message: error.description,
            );
          },
        ),
      )..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title??''),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
        ),
        body: Stack(
          children: [

            WebViewWidget(
              key: _key,
              controller: _controller,
            ),

            GetBuilder<UtilsLogic>(
              builder: (logic) {
                if (logic.state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Stack();
                }
              },
            ),
          ],
        )
      ),
    );
  }
}

