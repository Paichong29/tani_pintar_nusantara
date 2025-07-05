import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_result.dart';
import 'analysis_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  bool _isSelectionMode = false;
  Set<String> _selectedItems = {};
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = const [
    'Semua',
    'Padi',
    'Jagung',
    'Singkong',
    'Cabai',
    'Tomat',
    'Terdeteksi Penyakit',
    'Sehat'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Refresh data when screen is initialized or becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = Provider.of<AnalysisProvider>(context, listen: false);
        provider.initializeData(); // Refresh data
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change (e.g., when returning to this screen)
    final provider = Provider.of<AnalysisProvider>(context, listen: false);
    provider.initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String itemKey) {
    setState(() {
      if (_selectedItems.contains(itemKey)) {
        _selectedItems.remove(itemKey);
      } else {
        _selectedItems.add(itemKey);
      }

      if (_selectedItems.isEmpty && _isSelectionMode) {
        _isSelectionMode = false;
      }
    });
  }

  Future<void> _deleteSelectedItems(
      BuildContext context, AnalysisProvider provider) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
        title: Text(
          'Hapus Riwayat',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.text,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus ${_selectedItems.length} riwayat yang dipilih?',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDark ? Colors.black12 : Colors.grey[100],
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: isDark ? AppColors.darkError : AppColors.error,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Text(
                      'Tindakan ini tidak dapat dibatalkan',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkError : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final itemsToDelete = provider.filteredHistory
          .where((item) => _selectedItems.contains(item.title + item.time))
          .toList();

      await provider.deleteMultiple(itemsToDelete);

      setState(() {
        _isSelectionMode = false;
        _selectedItems.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${itemsToDelete.length} riwayat telah dihapus'),
            action: SnackBarAction(
              label: 'Urungkan',
              onPressed: () async {
                for (var item in itemsToDelete) {
                  await provider.undoDelete(item);
                }
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AnalysisProvider>(
      builder: (context, analysisProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await analysisProvider.initializeData();
          },
          child: Scaffold(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, isDark, analysisProvider),
                  if (!_isSelectionMode)
                    _buildSearchBar(context, isDark, analysisProvider),
                  _buildFilterSection(context, isDark, analysisProvider),
                  if (!_isSelectionMode)
                    _buildSortButton(context, isDark, analysisProvider),
                  Expanded(
                    child: analysisProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                              ),
                            ),
                          )
                        : analysisProvider.filteredHistory.isEmpty
                            ? _buildEmptyState(isDark)
                            : _buildHistoryList(
                                context, isDark, analysisProvider),
                  ),
                ],
              ),
            ),
            floatingActionButton:
                _buildFloatingActionButton(context, analysisProvider, isDark),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, AnalysisProvider provider) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          if (!_isSelectionMode) ...[
            Container(
              padding: EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.history,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Riwayat Analisis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: Icon(
                Icons.close,
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
            Text(
              '${_selectedItems.length} item dipilih',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.text,
              ),
            ),
          ],
          const Spacer(),
          if (!_isSelectionMode && provider.allHistory.isNotEmpty)
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: Icon(
                Icons.checklist,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              tooltip: 'Pilih Item',
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, bool isDark, AnalysisProvider provider) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: provider.setSearchQuery,
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.text,
        ),
        decoration: InputDecoration(
          hintText: 'Cari riwayat...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white60 : Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, bool isDark, AnalysisProvider provider) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = provider.selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child:
                _buildFilterChip(context, filter, isSelected, isDark, provider),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected,
      bool isDark, AnalysisProvider provider) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => provider.setFilter(label),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : isDark
                    ? AppColors.darkCardBackground
                    : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.small,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(
      BuildContext context, bool isDark, AnalysisProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: provider.toggleSort,
            icon: Icon(
              provider.sortBy == 'Terbaru'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
            ),
            label: Text(
              provider.sortBy,
              style: TextStyle(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: isDark ? Colors.white24 : Colors.grey[300],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            _searchController.text.isNotEmpty
                ? 'Tidak ada hasil yang cocok'
                : 'Belum ada riwayat analisis',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              'Coba kata kunci lain',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryList(
      BuildContext context, bool isDark, AnalysisProvider provider) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: provider.filteredHistory.length,
      itemBuilder: (context, index) {
        final item = provider.filteredHistory[index];
        return Dismissible(
          key: Key(item.title + item.time),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            await provider.deleteItem(item);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Riwayat telah dihapus'),
                  action: SnackBarAction(
                    label: 'Urungkan',
                    onPressed: () => provider.undoDelete(item),
                  ),
                ),
              );
            }
            return false;
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkError : AppColors.error,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          child: _buildHistoryItem(context, item, isDark),
        );
      },
    );
  }

  Widget _buildHistoryItem(
      BuildContext context, AnalysisResult item, bool isDark) {
    final bool isHealthy = item.status.toLowerCase().contains('sehat');
    final Color statusColor = isHealthy
        ? (isDark ? AppColors.darkSuccess : AppColors.success)
        : (isDark ? AppColors.darkError : AppColors.error);

    final String itemKey = item.title + item.time;
    final bool isSelected = _selectedItems.contains(itemKey);

    final String diseaseName =
        item.analysisData['nama_penyakit'] ?? 'Tidak dapat mendeteksi penyakit';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(context, item),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
              _toggleItemSelection(itemKey);
              _animationController.forward(from: 0.0);
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.small,
              border: isSelected
                  ? Border.all(
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (_isSelectionMode)
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md),
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    isHealthy ? Icons.check_circle : Icons.warning,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.text,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        item.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isHealthy)
                        Text(
                          diseaseName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(item.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (!_isSelectionMode)
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        onPressed: () =>
                            _showItemActions(context, item, isDark),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showItemActions(
      BuildContext context, AnalysisResult item, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.visibility,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                title: Text(
                  'Lihat Detail',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.text,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToDetail(context, item);
                },
              ),
              Consumer<AnalysisProvider>(
                builder: (context, provider, child) => ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: isDark ? AppColors.darkError : AppColors.error,
                  ),
                  title: Text(
                    'Hapus',
                    style: TextStyle(
                      color: isDark ? AppColors.darkError : AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    provider.deleteItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Riwayat telah dihapus'),
                        action: SnackBarAction(
                          label: 'Urungkan',
                          onPressed: () => provider.undoDelete(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, AnalysisResult item) {
    if (_isSelectionMode) {
      _toggleItemSelection(item.title + item.time);
    } else {
      final plantType = item.title.split(' ')[1];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisDetailScreen(
            title: item.title,
            status: item.status,
            description: item.description,
            time: item.time,
            imagePath: item.imagePath,
            selectedPlantType: plantType,
          ),
        ),
      );
    }
  }

  String _formatTime(String time) {
    final date = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 2) {
      return 'Kemarin';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  Widget? _buildFloatingActionButton(
      BuildContext context, AnalysisProvider provider, bool isDark) {
    if (_isSelectionMode && _selectedItems.isNotEmpty) {
      return FloatingActionButton.extended(
        onPressed: () => _deleteSelectedItems(context, provider),
        backgroundColor: isDark ? AppColors.darkError : AppColors.error,
        icon: const Icon(Icons.delete, color: Colors.white),
        label: Text(
          'Hapus (${_selectedItems.length})',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    return null;
  }
}
