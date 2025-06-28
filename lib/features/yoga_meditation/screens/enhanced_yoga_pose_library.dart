import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/enhanced_yoga_session_player.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class EnhancedYogaPoseLibrary extends StatefulWidget {
  const EnhancedYogaPoseLibrary({super.key});

  @override
  State<EnhancedYogaPoseLibrary> createState() => _EnhancedYogaPoseLibraryState();
}

class _EnhancedYogaPoseLibraryState extends State<EnhancedYogaPoseLibrary> {
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _categories = [
    'All',
    'Standing',
    'Seated',
    'Balancing',
    'Twists',
    'Backbends',
    'Inversions',
    'Restorative'
  ];
  
  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Pose Library'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search poses...',
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
          ),
          
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : 'All';
                            });
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 8),
                const Text(
                  'Difficulty:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _difficulties.length,
                    itemBuilder: (context, index) {
                      final difficulty = _difficulties[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(difficulty),
                          selected: _selectedDifficulty == difficulty,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDifficulty = selected ? difficulty : 'All';
                            });
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Pose grid
          Expanded(
            child: Consumer2<YogaMeditationProvider, PrakritiProvider>(
              builder: (context, yogaProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                // Get all yoga poses
                List<Map<String, dynamic>> allPoses = [];
                allPoses.addAll(yogaProvider.getYogaPosesForDosha('Vata'));
                allPoses.addAll(yogaProvider.getYogaPosesForDosha('Pitta'));
                allPoses.addAll(yogaProvider.getYogaPosesForDosha('Kapha'));
                
                // Filter poses based on search query, category, and difficulty
                final filteredPoses = allPoses.where((pose) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      pose['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  final matchesCategory = _selectedCategory == 'All' ||
                      pose['category'] == _selectedCategory;
                  
                  final matchesDifficulty = _selectedDifficulty == 'All' ||
                      pose['difficulty'] == _selectedDifficulty;
                  
                  return matchesSearch && matchesCategory && matchesDifficulty;
                }).toList();
                
                // Sort poses - recommended for user's dosha first
                if (dominantDosha.isNotEmpty) {
                  filteredPoses.sort((a, b) {
                    final aRecommended = a['recommendedFor']?.contains(dominantDosha) ?? false;
                    final bRecommended = b['recommendedFor']?.contains(dominantDosha) ?? false;
                    
                    if (aRecommended && !bRecommended) return -1;
                    if (!aRecommended && bRecommended) return 1;
                    return 0;
                  });
                }
                
                if (filteredPoses.isEmpty) {
                  return const Center(
                    child: Text('No poses found matching your criteria'),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredPoses.length,
                  itemBuilder: (context, index) {
                    final pose = filteredPoses[index];
                    return _buildPoseCard(context, pose, dominantDosha);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseCard(BuildContext context, Map<String, dynamic> pose, String userDosha) {
    final poseName = pose['name'] as String;
    final poseImage = pose['imageUrl'] as String;
    final poseDifficulty = pose['difficulty'] as String? ?? 'Beginner';
    final poseCategory = pose['category'] as String? ?? 'General';
    final recommendedFor = List<String>.from(pose['recommendedFor'] ?? []);
    final isRecommended = recommendedFor.contains(userDosha);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YogaPoseDetailScreen(pose: pose),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with difficulty badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    poseImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(poseDifficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      poseDifficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isRecommended)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    poseCategory,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.fitness_center, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return Colors.green;
      case 'intermediate': return Colors.orange;
      case 'advanced': return Colors.red;
      default: return Colors.blue;
    }
  }
  
  Color _getChakraColor(String chakraName) {
    switch (chakraName.toLowerCase()) {
      case 'root chakra': return Colors.red;
      case 'sacral chakra': return Colors.orange;
      case 'solar plexus chakra': return Colors.yellow;
      case 'heart chakra': return Colors.green;
      case 'throat chakra': return Colors.blue;
      case 'third eye chakra': return Colors.indigo;
      case 'crown chakra': return Colors.purple;
      default: return Colors.teal;
    }
  }
}

class YogaPoseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pose;

  const YogaPoseDetailScreen({super.key, required this.pose});

  @override
  State<YogaPoseDetailScreen> createState() => _YogaPoseDetailScreenState();
}

class _YogaPoseDetailScreenState extends State<YogaPoseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAnimating = false;
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poseName = widget.pose['name'] as String;
    final sanskritName = widget.pose['sanskritName'] as String? ?? '';
    final poseImage = widget.pose['imageUrl'] as String;
    final poseDifficulty = widget.pose['difficulty'] as String? ?? 'Beginner';
    final poseCategory = widget.pose['category'] as String? ?? 'General';
    final poseDescription = widget.pose['description'] as String? ?? 'No description available';
    final instructions = List<String>.from(widget.pose['instructions'] ?? []);
    final benefits = List<String>.from(widget.pose['benefits'] ?? []);
    final breathingGuide = List<String>.from(widget.pose['breathingGuide'] ?? []);
    final contraindications = List<String>.from(widget.pose['contraindications'] ?? []);
    final modifications = List<String>.from(widget.pose['modifications'] ?? []);
    final chakraAlignment = widget.pose['chakraAlignment'] as Map<String, dynamic>?;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Pose image
                  Image.asset(
                    poseImage,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Pose name at the bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          poseName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (sanskritName.isNotEmpty)
                          Text(
                            sanskritName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  // TODO: Implement favorite functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficulty and category badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(poseDifficulty),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          poseDifficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          poseCategory,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    poseDescription,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  
                  // Animation control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isAnimating = !_isAnimating;
                          });
                        },
                        icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
                        label: Text(_isAnimating ? 'Pause Animation' : 'Play Animation'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Animated pose demonstration
                  if (_isAnimating)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: AnimationController(
                            vsync: this,
                            duration: const Duration(seconds: 3),
                          )..repeat(reverse: true),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + math.sin(DateTime.now().millisecondsSinceEpoch / 500) * 0.05,
                              child: Image.asset(
                                poseImage,
                                height: 180,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Instructions'),
                      Tab(text: 'Benefits'),
                      Tab(text: 'Modifications'),
                      Tab(text: 'Cautions'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Instructions Tab
                _buildInstructionsTab(instructions, breathingGuide),
                
                // Benefits Tab
                _buildBenefitsTab(benefits, chakraAlignment),
                
                // Modifications Tab
                _buildModificationsTab(modifications),
                
                // Contraindications Tab
                _buildContraindicationsTab(contraindications),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Practice $poseName')),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: EnhancedYogaSessionPlayer(
                    title: poseName,
                    duration: '5 min',
                    description: poseDescription,
                    imageAsset: poseImage,
                    instructions: instructions,
                    difficulty: poseDifficulty,
                    benefits: benefits,
                    breathingGuide: breathingGuide,
                    chakraAlignment: chakraAlignment,
                  ),
                ),
              ),
            ),
          );
        },
        label: const Text('Practice This Pose'),
        icon: const Icon(Icons.fitness_center),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildInstructionsTab(List<String> instructions, List<String> breathingGuide) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Step-by-Step Instructions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...instructions.asMap().entries.map((entry) {
          final index = entry.key;
          final instruction = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    instruction,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        
        if (breathingGuide.isNotEmpty) ...[  
          const SizedBox(height: 24),
          const Text(
            'Breathing Guide',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...breathingGuide.map((guide) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.air, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    guide,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ],
    );
  }

  Widget _buildBenefitsTab(List<String> benefits, Map<String, dynamic>? chakraAlignment) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Benefits',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  benefit,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        )).toList(),
        
        if (chakraAlignment != null) ...[  
          const SizedBox(height: 24),
          const Text(
            'Chakra Alignment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildChakraInfo(chakraAlignment),
        ],
      ],
    );
  }

  Widget _buildChakraInfo(Map<String, dynamic> chakraAlignment) {
    final chakraName = chakraAlignment['name'] as String;
    final chakraDescription = chakraAlignment['description'] as String;
    final chakraColor = _getChakraColor(chakraName);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: chakraColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chakraColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: chakraColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                chakraName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: chakraColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            chakraDescription,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildModificationsTab(List<String> modifications) {
    if (modifications.isEmpty) {
      return const Center(
        child: Text('No modifications available for this pose'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Modifications & Variations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...modifications.asMap().entries.map((entry) {
          final index = entry.key;
          final modification = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    modification,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContraindicationsTab(List<String> contraindications) {
    if (contraindications.isEmpty) {
      return const Center(
        child: Text('No contraindications listed for this pose'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Cautions & Contraindications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...contraindications.map((contraindication) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  contraindication,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}