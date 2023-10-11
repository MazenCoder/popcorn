import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class TypesPostFit extends StatefulWidget {
  final int index;
  const TypesPostFit({Key? key, required this.index}) : super(key: key);

  @override
  State<TypesPostFit> createState() => _TypesPostFitState();
}

class _TypesPostFitState extends State<TypesPostFit> {

  final MobxApp _mobxApp = MobxApp();

  @override
  void initState() {
    _mobxApp.setIndexAction(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8)
            ),
            width: Get.width/4,
            height: 6,
          ),
          Text('post_types'.tr,
            style: GoogleFonts.notoSans(
              color: Colors.grey
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: typesPost.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _mobxApp.setIndexAction(index);
                    Future.delayed(const Duration(milliseconds: 300)).then((value) {
                      Navigator.pop(context, index);
                    });
                  },
                  leading: Observer(
                    builder: (_) {
                      if (_mobxApp.indexAction == index) {
                        return Icon(Icons.check_circle,
                          color: primaryColor,
                        );
                      } else {
                        return Icon(MdiIcons.circleOutline,
                          color: primaryColor,
                        );
                      }
                    },
                  ),
                  title: Text(typesPost[index]!,
                    style: GoogleFonts.notoSans(),
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
