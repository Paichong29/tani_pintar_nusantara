import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';
import '../services/storage_service.dart';

class AnalysisProvider with ChangeNotifier {
  final StorageService _storageService;
  List<AnalysisResult> _allHistory = [];
  List<AnalysisResult> _filteredHistory = [];
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  String _sortBy = 'Terbaru';
  bool _isLoading = true;

  AnalysisProvider(this._storageService) {
    initializeData();
  }

  List<AnalysisResult> get allHistory => _allHistory;
  List<AnalysisResult> get filteredHistory => _filteredHistory;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;
  String get sortBy => _sortBy;

  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    _allHistory = await _storageService.getAnalysisResults();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void toggleSort() {
    _sortBy = _sortBy == 'Terbaru' ? 'Terlama' : 'Terbaru';
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<AnalysisResult>.from(_allHistory);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.status.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (item.analysisData['nama_penyakit'] ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'Semua') {
      if (_selectedFilter == 'Sehat') {
        filtered = filtered
            .where((item) => item.status.toLowerCase().contains('sehat'))
            .toList();
      } else if (_selectedFilter == 'Terdeteksi Penyakit') {
        filtered = filtered
            .where((item) => !item.status.toLowerCase().contains('sehat'))
            .toList();
      } else {
        filtered = filtered
            .where((item) => item.title
                .toLowerCase()
                .contains(_selectedFilter.toLowerCase()))
            .toList();
      }
    }

    // Apply sorting
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a.time);
      final dateB = DateTime.parse(b.time);
      return _sortBy == 'Terbaru'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    _filteredHistory = filtered;
    notifyListeners();
  }

  Future<void> deleteItem(AnalysisResult item) async {
    final index = _allHistory.indexOf(item);
    if (index != -1) {
      _allHistory.removeAt(index);
      _applyFilters();
      notifyListeners();

      // Update storage
      await _storageService.clearAnalysisResults();
      for (var result in _allHistory) {
        await _storageService.saveAnalysisResult(result);
      }
    }
  }

  Future<void> undoDelete(AnalysisResult item) async {
    _allHistory.add(item);
    _applyFilters();
    notifyListeners();
    await _storageService.saveAnalysisResult(item);
  }

  Future<void> deleteMultiple(List<AnalysisResult> items) async {
    _allHistory.removeWhere((item) => items.contains(item));
    _applyFilters();
    notifyListeners();

    // Update storage
    await _storageService.clearAnalysisResults();
    for (var result in _allHistory) {
      await _storageService.saveAnalysisResult(result);
    }
  }

  Future<void> addAnalysis(AnalysisResult analysis) async {
    _allHistory.insert(0, analysis);
    _applyFilters();
    notifyListeners();
    await _storageService.saveAnalysisResult(analysis);
  }

  List<AnalysisResult> getRecentAnalyses(int count) {
    return _allHistory.take(count).toList();
  }
}
