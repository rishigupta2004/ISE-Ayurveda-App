import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import 'yoga_detail_screen.dart';

class YogaListScreen extends StatefulWidget {
  const YogaListScreen({super.key});

  @override
  State<YogaListScreen> createState() => _YogaListScreenState();
}

class _YogaListScreenState extends State<YogaListScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Poses'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search yoga poses...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Beginner'),
                      _buildFilterChip('Intermediate'),
                      _buildFilterChip('Advanced'),
                      _buildFilterChip('Vata'),
                      _buildFilterChip('Pitta'),
                      _buildFilterChip('Kapha'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer2<YogaMeditationProvider, PrakritiProvider>(
              builder: (context, yogaProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                List<Map<String, dynamic>> yogaPoses = [];
                
                // Get poses based on filter
                if (_selectedFilter == 'All') {
                  yogaPoses = [
                    ...yogaProvider.getYogaPosesForDosha('Vata'),
                    ...yogaProvider.getYogaPosesForDosha('Pitta'),
                    ...yogaProvider.getYogaPosesForDosha('Kapha'),
                  ];
                } else if (_selectedFilter == 'Vata' || 
                           _selectedFilter == 'Pitta' || 
                           _selectedFilter == 'Kapha') {
                  yogaPoses = yogaProvider.getYogaPosesForDosha(_selectedFilter);
                } else {
                  // Filter by difficulty level
                  yogaPoses = [
                    ...yogaProvider.getYogaPosesForDosha('Vata'),
                    ...yogaProvider.getYogaPosesForDosha('Pitta'),
                    ...yogaProvider.getYogaPosesForDosha('Kapha'),
                  ].where((pose) => 
                    pose['difficulty'].toLowerCase() == _selectedFilter.toLowerCase()
                  ).toList();
                }
                
                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  yogaPoses = yogaPoses.where((pose) {
                    return pose['name'].toLowerCase().contains(query) ||
                        pose['description'].toLowerCase().contains(query) ||
                        pose['benefits'].any((benefit) =>
                            benefit.toLowerCase().contains(query));
                  }).toList();
                }
                
                if (yogaPoses.isEmpty) {
                  return const Center(
                    child: Text('No yoga poses found matching your search.'),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: yogaPoses.length,
                  itemBuilder: (context, index) {
                    final pose = yogaPoses[index];
                    return _buildYogaPoseCard(pose, yogaProvider, dominantDosha);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'All';
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildYogaPoseCard(Map<String, dynamic> pose, YogaMeditationProvider provider, String userDosha) {
    final isFavorite = provider.favoriteYogaPoses.contains(pose['id']);
    final isRecommended = userDosha.isNotEmpty &&
        pose['id'].toString().startsWith(userDosha.substring(0, 1).toLowerCase());
    
    // Get SVG asset path
    String svgAsset = _getSvgForPose(pose['name']);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Use GoRouter for consistent navigation
          context.go('/yoga/${pose['id']}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SVG image for pose
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: svgAsset.isNotEmpty
                        ? SvgPicture.asset(
                            'assets/illustrations/yoga/${svgAsset}',
                            height: 100,
                            placeholderBuilder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                if (isRecommended)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pose['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isFavorite) {
                            provider.removeYogaPoseFromFavorites(pose['id']);
                          } else {
                            provider.addYogaPoseToFavorites(pose['id']);
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pose['difficulty'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _getDifficultyColor(pose['difficulty']),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pose['duration'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to get SVG asset path for a pose name
  String _getSvgForPose(String poseName) {
    if (poseName.contains('Mountain')) return 'Standing_forward_pose.svg';
    else if (poseName.contains('Child')) return 'Childs_Pose.svg';
    else if (poseName.contains('Forward Bend')) return 'Standing_forward_pose.svg';
    else if (poseName.contains('Warrior I')) return 'Warrior_I.svg';
    else if (poseName.contains('Warrior II')) return 'Warrior_II.svg';
    else if (poseName.contains('Warrior III')) return 'Warrior_III.svg';
    else if (poseName.contains('Downward')) return 'Downward_Facing_Dog.svg';
    else if (poseName.contains('Cobra')) return 'Cobra_Pose.svg';
    else if (poseName.contains('Chair')) return 'Chair_Pose.svg';
    else if (poseName.contains('Plank')) return 'Plank_Pose.svg';
    else if (poseName.contains('Cat')) return 'Cat_pose.svg';
    else if (poseName.contains('Low Lunge')) return 'Low_Lunge.svg';
    else if (poseName.contains('Revolved Chair')) return 'Revolved_Chair_pose.svg';
    else if (poseName.contains('Shoulder Stand')) return 'Shoulder_Stand.svg';
    else if (poseName.contains('Table Top')) return 'Table_Top.svg';
    else if (poseName.contains('Upward Facing Dog')) return 'Upward _Facing_dog.svg';
    else if (poseName.contains('Halfway Lift')) return 'Halfway_Lift_pose.svg';
    return '';
  }
  
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}