import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';

class StorageService {
  static const String _analysisKey = 'analysis_results';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveAnalysisResult(AnalysisResult result) async {
    final results = await getAnalysisResults();
    results.insert(0, result); // Add new result at the beginning
    
    // Convert to JSON and save
    final jsonList = results.map((r) => r.toJson()).toList();
    await _prefs.setString(_analysisKey, jsonEncode(jsonList));
  }

  Future<List<AnalysisResult>> getAnalysisResults() async {
    final jsonString = _prefs.getString(_analysisKey);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => AnalysisResult.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading analysis results: $e');
      return [];
    }
  }

  Future<AnalysisResult?> getLatestAnalysis() async {
    final results = await getAnalysisResults();
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> clearAnalysisResults() async {
    await _prefs.remove(_analysisKey);
  }
}
