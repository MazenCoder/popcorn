import 'package:svgaplayer_flutter/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class GiftWidget extends StatelessWidget {

  static void show({Key? key,
    required BuildContext context,
    required String url,
    Color? color,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: color,
      builder: (_) => GiftWidget(key: key, url: url),
    );
  }

  static void hide({required BuildContext context}) {
    Navigator.pop(context);
  }

  final String url;
  const GiftWidget({Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Center(
        child: Card(
          color: Colors.transparent,
          child: Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.all(12.0),
            child: SVGASimpleImage(
              resUrl: url,
            )
          ),
        ),
      ),
    );
  }
}
