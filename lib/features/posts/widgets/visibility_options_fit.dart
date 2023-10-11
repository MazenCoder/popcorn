import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class VisibilityOptionsFit extends StatelessWidget {
  const VisibilityOptionsFit({Key? key}) : super(key: key);

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
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: visibilityOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.pop(context, index),
                  leading: visibilityIcon[index],
                  title: Text(visibilityOptions[index]!,
                    style: GoogleFonts.notoSans(),
                  ),
                  subtitle: Text(visibilitySubTitle[index]!,
                    style: GoogleFonts.notoSans(
                      fontSize: 13
                    ),
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
