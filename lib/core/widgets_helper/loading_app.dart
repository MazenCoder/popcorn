import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:popcorn/generated/assets.dart';
import '../theme/generateMaterialColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LoadingApp extends StatefulWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  _LoadingAppState createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp> {

  late Image image;

  @override
  void initState() {
    super.initState();
    image = Image(
      image: const AssetImage(Assets.imagesLogo2),
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
      fit: BoxFit.contain,
      height: Get.width / 3,
      width: Get.width / 3,
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(image.image, context);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesSplash),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RippleAnimation(
                  repeat: true,
                  color: primaryColor.shade300,
                  minRadius: 36,
                  ripplesCount: 25,
                  child: ClipOval(
                    child: Container(
                      color: primaryColor,
                      padding: const EdgeInsets.all(15),
                      child: image,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
