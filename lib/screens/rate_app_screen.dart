import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({Key? key}) : super(key: key);

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int _selectedRating = 0;
  Set<String> _selectedCategories = {};
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = _selectedRating > 0 && _selectedCategories.isNotEmpty;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Beri Rating',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            const Column(
              children: [
                Text(
                  'Seberapa puas Anda dengan aplikasi kami?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Berikan penilaian Anda untuk membantu kami meningkatkan layanan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 40,
                    color: const Color(0xFFFFB800),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pilih rating (1-5 bintang)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                const Text(
                  'Kategori Ulasan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pilih kategori yang ingin Anda nilai (bisa lebih dari satu)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    _buildCategoryChip(
                      'Kemudahan\nPenggunaan',
                      Icons.touch_app_outlined,
                      const Color(0xFFE8F5E9),
                      const Color(0xFF4CAF50),
                    ),
                    _buildCategoryChip(
                      'Akurasi\nDeteksi',
                      Icons.check_circle_outline,
                      const Color(0xFFE3F2FD),
                      const Color(0xFF2196F3),
                    ),
                    _buildCategoryChip(
                      'Tampilan\nAplikasi',
                      Icons.palette_outlined,
                      const Color(0xFFF3E5F5),
                      const Color(0xFF9C27B0),
                    ),
                    _buildCategoryChip(
                      'Fitur\nAplikasi',
                      Icons.widgets_outlined,
                      const Color(0xFFFFF3E0),
                      const Color(0xFFFF9800),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                const Text(
                  'Ulasan Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bagikan pengalaman Anda untuk membantu kami meningkatkan layanan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Bagikan pengalaman Anda menggunakan aplikasi ini...',
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit 
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade300,
                  foregroundColor: canSubmit 
                      ? Colors.white
                      : Colors.grey.shade700,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: canSubmit ? _submitReview : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      size: 20,
                      color: canSubmit 
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kirim Ulasan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canSubmit 
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color bgColor, Color iconColor) {
    final bool isSelected = _selectedCategories.contains(label.replaceAll('\n', ' '));
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            final String normalizedLabel = label.replaceAll('\n', ' ');
            if (isSelected) {
              _selectedCategories.remove(normalizedLabel);
            } else {
              _selectedCategories.add(normalizedLabel);
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : bgColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: isSelected 
                ? Border.all(color: iconColor, width: 2)
                : null,
            boxShadow: isSelected ? [
              BoxShadow(
                color: iconColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: iconColor,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: iconColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_rating', _selectedRating);
    await prefs.setStringList('rating_categories', _selectedCategories.toList());
    if (_reviewController.text.isNotEmpty) {
      await prefs.setString('app_review', _reviewController.text);
    }
    
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
