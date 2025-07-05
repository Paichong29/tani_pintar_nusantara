class AnalysisResult {
  final String title;
  final String status;
  final String description;
  final String time;
  final String imagePath;
  final Map<String, dynamic> analysisData;

  AnalysisResult({
    required this.title,
    required this.status,
    required this.description,
    required this.time,
    required this.imagePath,
    required this.analysisData,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'description': description,
      'time': time,
      'imagePath': imagePath,
      'analysisData': analysisData,
    };
  }

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      title: json['title'],
      status: json['status'],
      description: json['description'],
      time: json['time'],
      imagePath: json['imagePath'],
      analysisData: json['analysisData'],
    );
  }
}
