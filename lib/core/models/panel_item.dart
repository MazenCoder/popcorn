

class PanelItem {

  PanelItem({
    required this.expandedValue,
    required this.headerValue,
    required this.reportItems,
    this.isExpanded = false,
  });

  int expandedValue;
  String headerValue;
  List<ReportItem> reportItems;
  bool isExpanded;
}

class ReportItem {

  String title;
  int valueItem;
  bool isButton;

  ReportItem({
    required this.title,
    required this.valueItem,
    required this.isButton,
  });

}