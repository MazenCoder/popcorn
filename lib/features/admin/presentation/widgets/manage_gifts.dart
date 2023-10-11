import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/controllers/utils/utils_logic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcorn/core/usecases/constants.dart';
import '../../../../core/models/gift_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/usecases/boxes.dart';
import '../../../../core/usecases/keys.dart';
import '../../../../core/mobx/mobx_app.dart';
import '../../../../core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

import '../../../rooms/widgets/full_screen_image.dart';



class ManageGifts extends StatefulWidget {
  const ManageGifts({Key? key}) : super(key: key);

  @override
  State<ManageGifts> createState() => _ManageGiftsState();
}

class _ManageGiftsState extends State<ManageGifts> {

  final ImagePicker _picker = ImagePicker();
  final MobxApp _mobxApp = MobxApp();
  final box = Boxes.settings();

  @override
  void initState() {
    final display = box.get(
      Keys.displayGalleryGift,
      defaultValue: false,
    );
    _mobxApp.setDisplayLayout(display);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_gifts'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          Observer(
            builder: (_) {
              return IconButton(
                onPressed: () async {
                  _mobxApp.setDisplayLayout(!_mobxApp.gridLarge);
                  await box.put(Keys.displayGalleryGift, _mobxApp.gridLarge);
                },
                icon: Icon(
                  _mobxApp.gridLarge ? MdiIcons.viewList : MdiIcons.gridLarge,
                  color: Colors.white,
                ),
              );
            },
          )
        ],
      ),
      body: GetBuilder<UtilsLogic>(
        builder: (logic) {
          if (logic.state.gifts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      IMG.jsonEmpty,
                      width: Get.width / 1.5,
                    ),
                    Text(
                      'no_results_found'.tr,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Observer(
              builder: (_) => GridView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: logic.state.gifts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _mobxApp.gridLarge ? 2 : 1,
                  childAspectRatio: _mobxApp.gridLarge ? 12 / 16.5 : 38 / 16.5,
                ),
                itemBuilder: (context, index) {
                  GiftModel gift = logic.state.gifts[index];
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => FullScreenImage(gift.image)),
                            child: Hero(
                              tag: gift.image,
                              child: CachedNetworkImage(
                                  width: Get.width,
                                  fit: BoxFit.contain,
                                  imageUrl: gift.image,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Image.asset(IMG.defaultImg),
                                  ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            bool delete = await logic.deleteGiftDialog(context);
                            if (delete) {
                              logic.deleteGift(
                                context: context,
                                model: gift,
                              );
                            }  
                            // await deleteImageDialog(context, gallery!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('delete'.tr),
                                const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: const Uuid().v4(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            var photosStatus = await Permission.photos.status;

            // if (photosStatus.isDenied) {
            //   openAppSettings();
            //   return;
            // }

            List<XFile> files = await _picker.pickMultiImage();
            if (files.isNotEmpty) {
              List<GiftModel> gifts = files.map((e) =>
                  GiftModel(id: const Uuid().v4(), image: e.path)).toList();
              if (!mounted) return;
              await utilsLogic.uploadGifts(context, gifts);
            }
          },
      ),
    );
  }
}
