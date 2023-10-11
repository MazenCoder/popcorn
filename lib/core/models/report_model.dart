
class ReportModel {

  final String id;
  final String report;
  final String reportedUid;
  final String uid;
  final dynamic timestamp;

  ReportModel({
    required this.id,
    required this.report,
    required this.reportedUid,
    required this.uid,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "report": report,
    "reportedUid": reportedUid,
    "uid": uid,
    "timestamp": timestamp,
  };

}