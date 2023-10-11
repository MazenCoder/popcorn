import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/report_model.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/panel_item.dart';
import '../../../core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';




class ReportBlockFit extends StatefulWidget {
  final UserModel user;
  const ReportBlockFit({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ReportBlockFit> createState() => _ReportBlockFitState();
}

class _ReportBlockFitState extends State<ReportBlockFit> {

  int _indexData = -1;
  int? _expandedValue;
  int? _valueItem;

  final List<PanelItem> _data = [
    PanelItem(
      headerValue: 'report_post_msg_comment'.tr,
      isExpanded: false,
      expandedValue: 0,
      reportItems: [
        ReportItem(
          title: reportAndBlock[0]!,
          valueItem: 0,
          isButton: false,
        ),
        ReportItem(
          title: reportAndBlock[1]!,
          valueItem: 1,
          isButton: false,
        ),
        ReportItem(
          title: 'submit'.tr,
          valueItem: 2,
          isButton: true,
        ),
      ]
    ),
    PanelItem(
      headerValue: 'report_content_profile'.tr,
      isExpanded: false,
      expandedValue: 1,
        reportItems: [
          ReportItem(
            title: reportAndBlock[3]!,
            valueItem: 3,
            isButton: false,
          ),
          ReportItem(
            title: reportAndBlock[4]!,
            valueItem: 4,
            isButton: false,
          ),
          ReportItem(
            title: 'submit'.tr,
            valueItem: 5,
            isButton: true,
          ),
        ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text('report_block'.tr,
            style: Get.textTheme.bodyText2?.copyWith(
              color: headlineColor,
              fontSize: 15,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.clear,
              color: headlineColor,
            ),
            onPressed: () => Get.back(),
          ),
          // backgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        // backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<ExpansionPanel>((PanelItem model) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(model.headerValue,
                          style: Get.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        ),
                      );
                    },
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: model.reportItems.map((item) {
                        if (item.isButton) {
                          return TextButton(
                            onPressed: (_expandedValue == model.expandedValue) ? () async {
                              final model = ReportModel(
                                id: const Uuid().v4(),
                                report: reportAndBlock[_valueItem]!,
                                reportedUid: widget.user.uid,
                                uid: userState.user!.uid,
                                timestamp: FieldValue.serverTimestamp(),
                              );
                              await userLogic.reportAccount(context, model).then((value) async {
                                  if (value) {
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    Get.back(result: false);
                                  }
                              });
                            } : null,
                            child: Text(item.title,
                              style: Get.textTheme.bodyText2?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text(item.title,
                              style: Get.textTheme.bodyText2?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),
                            trailing: _indexData == model.expandedValue + item.valueItem ?
                            Icon(Icons.check, color: primaryColor) :
                            const Icon(MdiIcons.checkboxBlankCircleOutline),
                            onTap: () {
                              setState(() {
                                _indexData = -1;
                                _expandedValue = null;
                                _valueItem = null;

                                _indexData = model.expandedValue + item.valueItem;
                                _expandedValue = model.expandedValue;
                                _valueItem =  item.valueItem;
                              });
                            });
                        }
                      }).toList(),
                    ),
                    isExpanded: model.isExpanded,
                  );
                }).toList(),
              ),

              Card(
                child: ListTile(
                  onTap: () async {
                    await userLogic.blockAccount(context, widget.user).then((value) async {
                      if (value) {
                        await Future.delayed(const Duration(milliseconds: 500));
                        Get.back(result: true);
                      }
                    });
                  },
                  title: Text('block_account'.trArgs(
                    [widget.user.displayName],
                  ), style: Get.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 14,
                  )),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
