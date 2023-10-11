import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/core/util/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../../../core/theme/generateMaterialColor.dart';


class SignUpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('sign_up'.tr,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // backgroundColor: backgroundColor,
        ),
        // body: WebView(
        //   initialUrl: _url,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (WebViewController webViewController) {
        //     _controller.complete(webViewController);
        //   },
        // ),
      ),
    );
  }
}



