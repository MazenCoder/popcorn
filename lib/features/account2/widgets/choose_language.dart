import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {

  int _selectedIndex = -1;
  String languageCode = 'en';
  String countryCode = 'US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: greyColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Text('language'.tr),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text('save'.tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              var locale = Locale(languageCode, countryCode);
              Get.updateLocale(locale);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
          itemCount: Languages.list().length,
          itemBuilder: (context, index) {
            final lang = Languages.list()[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 50,
              child: ListTile(
                title: Text(lang.title,
                  style: TextStyle(
                    color: _selectedIndex == index ?
                    Colors.black87 : Colors.grey.shade200,
                  ),
                ),
                onTap: () => setState(() {
                  _selectedIndex = index;
                  countryCode = lang.countryCode;
                  languageCode = lang.languageCode;
                }),
              ),
            );
          }
      ),
    );
  }
}


class Languages {

  final String title;
  final String languageCode;
  final String countryCode;
  Languages({required this.title, required this.languageCode, required this.countryCode});

  static List<Languages> list() {
    return [
      Languages(title: 'English', languageCode: 'en', countryCode: 'US'),
      Languages(title: 'العربية', languageCode: 'ar', countryCode: 'AR'),
    ];
  }
}
