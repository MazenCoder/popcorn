import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class UserModalFit extends StatelessWidget {
  const UserModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 5, left: 16, right: 16),
            child: Text('upload_profile_pic'.tr),
          ),
          ListTile(
            title: Text('photo_library'.tr),
            leading: Icon(Icons.photo,
              color: primaryColor,
            ),
            onTap: () => Navigator.of(context).pop(ActionSelect.gallery),
          ),
          ListTile(
            title: Text('take_photo'.tr),
            leading: Icon(Icons.camera_alt,
              color: primaryColor,
            ),
            onTap: () => Navigator.of(context).pop(ActionSelect.camera),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45.0,
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                shadowColor: primaryColor,
                color: primaryColor,
                elevation: 0,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Text('cancel'.tr,
                      style: context.textTheme.bodyText2?.copyWith(
                        color: headlineColor
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
