import 'package:popcorn/core/theme/generateMaterialColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MicOptionFit extends StatelessWidget {
  const MicOptionFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: ()=> Navigator.pop(context, 1),
            title: Text('take_mic'.tr),
            trailing: Icon(Icons.mic,
              color: primaryColor,
            ),
          ),

          ListTile(
            onTap: ()=> Navigator.pop(context, 2),
            title: Text('lock_mic'.tr),
            trailing: Icon(Icons.mic_off,
              color: errorColor,
            ),
          ),
          const Divider(),
          ListTile(
            onTap: ()=> Navigator.pop(context, 3),
            title: Text('cancel'.tr),
            trailing: Icon(Icons.cancel,
              color: errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
