import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/enhanced_yoga_session_player.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class EnhancedMeditationLibrary extends StatefulWidget {
  const EnhancedMeditationLibrary({super.key});

  @override
  State<EnhancedMeditationLibrary> createState() => _EnhancedMeditationLibraryState();
}

class _EnhancedMeditationLibraryState extends State<EnhancedMeditationLibrary> {
  String _selectedCategory = 'All';
  String _selectedDuration = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _categories = [
    'All',
    'Guided',
    'Mindfulness',
    'Chakra',
    'Sleep',
    'Stress Relief',
    'Focus',
    'Healing'
  ];
  
  final List<String> _durations = [
    'All',
    '5 min',
    '10 min',
    '15 min',
    '30 min'
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
        title: const Text('Meditation Library'),
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
                hintText: 'Search meditations...',
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
                  'Duration:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _durations.length,
                    itemBuilder: (context, index) {
                      final duration = _durations[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(duration),
                          selected: _selectedDuration == duration,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDuration = selected ? duration : 'All';
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
          
          // Meditation grid
          Expanded(
            child: Consumer2<YogaMeditationProvider, PrakritiProvider>(
              builder: (context, yogaProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                // Get all meditations
                List<Map<String, dynamic>> allMeditations = [];
                allMeditations.addAll(yogaProvider.getMeditationsForDosha('Vata'));
                allMeditations.addAll(yogaProvider.getMeditationsForDosha('Pitta'));
                allMeditations.addAll(yogaProvider.getMeditationsForDosha('Kapha'));
                
                // Filter meditations based on search query, category, and duration
                final filteredMeditations = allMeditations.where((meditation) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      meditation['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  final matchesCategory = _selectedCategory == 'All' ||
                      meditation['category'] == _selectedCategory;
                  
                  final matchesDuration = _selectedDuration == 'All' ||
                      meditation['duration'] == _selectedDuration;
                  
                  return matchesSearch && matchesCategory && matchesDuration;
                }).toList();
                
                // Sort meditations - recommended for user's dosha first
                if (dominantDosha.isNotEmpty) {
                  filteredMeditations.sort((a, b) {
                    final aRecommended = a['recommendedFor']?.contains(dominantDosha) ?? false;
                    final bRecommended = b['recommendedFor']?.contains(dominantDosha) ?? false;
                    
                    if (aRecommended && !bRecommended) return -1;
                    if (!aRecommended && bRecommended) return 1;
                    return 0;
                  });
                }
                
                if (filteredMeditations.isEmpty) {
                  return const Center(
                    child: Text('No meditations found matching your criteria'),
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
                  itemCount: filteredMeditations.length,
                  itemBuilder: (context, index) {
                    final meditation = filteredMeditations[index];
                    return _buildMeditationCard(context, meditation, dominantDosha);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(BuildContext context, Map<String, dynamic> meditation, String userDosha) {
    final title = meditation['title'] as String;
    final imageUrl = meditation['imageUrl'] as String;
    final duration = meditation['duration'] as String? ?? '10 min';
    final category = meditation['category'] as String? ?? 'Mindfulness';
    final chakraType = meditation['chakraType'] as String?;
    final recommendedFor = List<String>.from(meditation['recommendedFor'] ?? []);
    final isRecommended = recommendedFor.contains(userDosha);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(meditation: meditation),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with chakra badge if applicable
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (chakraType != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getChakraColor(chakraType),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chakraType,
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
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.headphones, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Listen Now',
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'guided': return Icons.record_voice_over;
      case 'mindfulness': return Icons.psychology;
      case 'chakra': return Icons.spa;
      case 'sleep': return Icons.nightlight;
      case 'stress relief': return Icons.self_improvement;
      case 'focus': return Icons.center_focus_strong;
      case 'healing': return Icons.healing;
      default: return Icons.spa;
    }
  }

  Color _getChakraColor(String chakraType) {
    switch (chakraType.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }
}

class MeditationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> meditation;

  const MeditationDetailScreen({super.key, required this.meditation});

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.meditation['title'] as String;
    final imageUrl = widget.meditation['imageUrl'] as String;
    final audioUrl = widget.meditation['audioUrl'] as String;
    final duration = widget.meditation['duration'] as String? ?? '10 min';
    final category = widget.meditation['category'] as String? ?? 'Mindfulness';
    final chakraType = widget.meditation['chakraType'] as String?;
    final description = widget.meditation['description'] as String? ?? 'No description available';
    final benefits = List<String>.from(widget.meditation['benefits'] ?? []);
    final guidedMeditation = widget.meditation['guidedMeditation'] as Map<String, dynamic>?;
    
    // Convert duration from "10 min" format to "10:00" format for the player
    final playerDuration = duration.contains('min')
        ? '${duration.split(' ')[0]}:00'
        : duration;
    
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
                  // Meditation image
                  Image.asset(
                    imageUrl,
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
                  // Meditation title at the bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.timer,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              duration,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
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
                  // Chakra badge if applicable
                  if (chakraType != null) ...[  
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getChakraColor(chakraType).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getChakraColor(chakraType)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getChakraColor(chakraType),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$chakraType Chakra',
                            style: TextStyle(
                              color: _getChakraColor(chakraType),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Description
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  
                  // Meditation Player
                  EnhancedMeditationMusicPlayer(
                    title: title,
                    duration: playerDuration,
                    imageAsset: imageUrl,
                    audioAsset: audioUrl,
                    chakraType: chakraType,
                    description: description,
                    benefits: benefits,
                    guidedMeditation: guidedMeditation,
                  ),
                  const SizedBox(height: 24),
                  
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    labelColor: chakraType != null
                        ? _getChakraColor(chakraType)
                        : AppTheme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Benefits'),
                      Tab(text: 'How to Practice'),
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
                // Benefits Tab
                _buildBenefitsTab(benefits),
                
                // How to Practice Tab
                _buildHowToPracticeTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add to favorites or playlist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to your meditation playlist')),
          );
        },
        label: const Text('Add to Playlist'),
        icon: const Icon(Icons.playlist_add),
        backgroundColor: chakraType != null
            ? _getChakraColor(chakraType)
            : AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildBenefitsTab(List<String> benefits) {
    if (benefits.isEmpty) {
      return const Center(
        child: Text('Benefits information not available'),
      );
    }
    
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
              const Icon(Icons.spa, color: AppTheme.primaryColor),
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
      ],
    );
  }

  Widget _buildHowToPracticeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'How to Practice',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPracticeStep(
          '1',
          'Find a Quiet Space',
          'Choose a quiet, comfortable place where you won\'t be disturbed for the duration of your meditation.',
          Icons.room,
        ),
        _buildPracticeStep(
          '2',
          'Comfortable Position',
          'Sit in a comfortable position with your spine straight. You can sit on a chair, cushion, or mat.',
          Icons.airline_seat_recline_normal,
        ),
        _buildPracticeStep(
          '3',
          'Set Your Intention',
          'Take a moment to set an intention for your practice. What do you hope to gain from this session?',
          Icons.lightbulb_outline,
        ),
        _buildPracticeStep(
          '4',
          'Focus on Your Breath',
          'Begin by taking a few deep breaths. Inhale slowly through your nose, and exhale through your mouth.',
          Icons.air,
        ),
        _buildPracticeStep(
          '5',
          'Start the Meditation',
          'Press play and follow along with the guided instructions. If your mind wanders, gently bring it back to the practice.',
          Icons.headphones,
        ),
        _buildPracticeStep(
          '6',
          'Close Your Practice',
          'When the meditation ends, take a moment to notice how you feel before returning to your day.',
          Icons.spa,
        ),
      ],
    );
  }

  Widget _buildPracticeStep(String number, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'guided': return Icons.record_voice_over;
      case 'mindfulness': return Icons.psychology;
      case 'chakra': return Icons.spa;
      case 'sleep': return Icons.nightlight;
      case 'stress relief': return Icons.self_improvement;
      case 'focus': return Icons.center_focus_strong;
      case 'healing': return Icons.healing;
      default: return Icons.spa;
    }
  }

  Color _getChakraColor(String chakraType) {
    switch (chakraType.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }
}