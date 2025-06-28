import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class YogaMeditationScreen extends StatefulWidget {
  const YogaMeditationScreen({super.key});

  @override
  State<YogaMeditationScreen> createState() => _YogaMeditationScreenState();
}

class _YogaMeditationScreenState extends State<YogaMeditationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Countdown timer variables
  bool _isCountdownVisible = false;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;
  
  // Workout progress variables
  bool _isWorkoutInProgress = false;
  int _currentPoseIndex = 0;
  int _totalPoses = 0;
  String _currentPoseName = '';
  int _poseTimeRemaining = 0;
  int _totalWorkoutTime = 0;
  Timer? _workoutTimer;
  Map<String, dynamic>? _currentWorkout;
  List<Map<String, dynamic>> _workoutPoses = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _workoutTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga & Meditation'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Yoga Poses'),
            Tab(text: 'Meditation'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Consumer2<YogaMeditationProvider, PrakritiProvider>(
            builder: (context, yogaProvider, prakritiProvider, child) {
              final dominantDosha = prakritiProvider.hasCompletedAssessment
                  ? prakritiProvider.dominantDosha
                  : '';
              
              return TabBarView(
                controller: _tabController,
                children: [
                  // Yoga Poses Tab
                  _buildYogaTab(yogaProvider, dominantDosha),
                  
                  // Meditation Tab
                  _buildMeditationTab(yogaProvider, dominantDosha),
                ],
              );
            },
          ),
          
          // Countdown overlay
          if (_isCountdownVisible)
            _buildCountdownOverlay(),
          
          // Workout in progress overlay
          if (_isWorkoutInProgress)
            _buildWorkoutOverlay(),
        ],
      ),
    );
  }

  Widget _buildYogaTab(YogaMeditationProvider provider, String dominantDosha) {
    List<Map<String, dynamic>> yogaPoses = [];
    
    if (dominantDosha.isNotEmpty) {
      yogaPoses = provider.getYogaPosesForDosha(dominantDosha);
    } else {
      // If no dosha assessment, show all poses
      yogaPoses = [
        ...provider.getYogaPosesForDosha('Vata'),
        ...provider.getYogaPosesForDosha('Pitta'),
        ...provider.getYogaPosesForDosha('Kapha'),
      ];
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dominantDosha.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Recommended Yoga Poses for $dominantDosha',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: yogaPoses.length,
            itemBuilder: (context, index) {
              final pose = yogaPoses[index];
              return _buildYogaPoseCard(pose, provider);
            },
          ),
        ],
      ),
    );
  }

  // Helper method to get SVG asset path for a pose name
  String _getSvgForPose(String poseName) {
    if (poseName.contains('Mountain')) return 'Images_illustrations/Standing_forward_pose.svg';
    else if (poseName.contains('Child')) return 'Images_illustrations/Childs_Pose.svg';
    else if (poseName.contains('Forward Bend')) return 'Images_illustrations/Standing_forward_pose.svg';
    else if (poseName.contains('Warrior I')) return 'Images_illustrations/Warrior_I.svg';
    else if (poseName.contains('Warrior II')) return 'Images_illustrations/Warrior_II.svg';
    else if (poseName.contains('Warrior III')) return 'Images_illustrations/Warrior_III.svg';
    else if (poseName.contains('Downward')) return 'Images_illustrations/Downward_Facing_Dog.svg';
    else if (poseName.contains('Cobra')) return 'Images_illustrations/Cobra_Pose.svg';
    else if (poseName.contains('Chair')) return 'Images_illustrations/Chair_Pose.svg';
    else if (poseName.contains('Plank')) return 'Images_illustrations/Plank_Pose.svg';
    return '';
  }
  
  // Helper method to get SVG asset path for a meditation ID
  String _getSvgForMeditation(String meditationId) {
    if (meditationId.startsWith('v_')) return 'Images_illustrations/i1.svg';
    else if (meditationId.startsWith('p_')) return 'Images_illustrations/i2.svg';
    else if (meditationId.startsWith('k_')) return 'Images_illustrations/i3.svg';
    return 'Images_illustrations/i${(meditationId.hashCode % 5) + 1}.svg';
  }
  
  Widget _buildYogaPoseCard(Map<String, dynamic> pose, YogaMeditationProvider provider) {
    final isFavorite = provider.favoriteYogaPoses.contains(pose['id']);
    
    // Get SVG asset path
    String svgAsset = _getSvgForPose(pose['name']);
    if (svgAsset.isEmpty) {
      svgAsset = 'Images_illustrations/i${(pose['id'].hashCode % 5) + 1}.svg'; // Fallback to generic illustrations
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showYogaPoseDetails(pose, provider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SVG image for pose
            Container(
              height: 120,
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
                        svgAsset,
                        height: 80,
                        width: 80,
                      )
                    : const Icon(Icons.self_improvement, size: 50, color: Colors.grey),
              ),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationTab(YogaMeditationProvider provider, String dominantDosha) {
    List<Map<String, dynamic>> meditations = [];
    
    if (dominantDosha.isNotEmpty) {
      meditations = provider.getMeditationsForDosha(dominantDosha);
    } else {
      // If no dosha assessment, show all meditations
      meditations = [
        ...provider.getMeditationsForDosha('Vata'),
        ...provider.getMeditationsForDosha('Pitta'),
        ...provider.getMeditationsForDosha('Kapha'),
      ];
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dominantDosha.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Recommended Meditations for $dominantDosha',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final meditation = meditations[index];
              return _buildMeditationCard(meditation, provider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(Map<String, dynamic> meditation, YogaMeditationProvider provider) {
    final isFavorite = provider.favoriteMeditations.contains(meditation['id']);
    
    // Determine which SVG to use based on meditation name or id
    String svgAsset = '';
    final meditationId = meditation['id'];
    
    // Use generic illustrations for meditations
    if (meditationId.startsWith('v_')) svgAsset = 'Images_illustrations/i1.svg';
    else if (meditationId.startsWith('p_')) svgAsset = 'Images_illustrations/i2.svg';
    else if (meditationId.startsWith('k_')) svgAsset = 'Images_illustrations/i3.svg';
    else svgAsset = 'Images_illustrations/i${(meditation['id'].hashCode % 5) + 1}.svg';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showMeditationDetails(meditation, provider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // SVG illustration for meditation
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: svgAsset.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        svgAsset,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : const Icon(
                      Icons.play_arrow,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            meditation['name'],
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
                              provider.removeMeditationFromFavorites(meditation['id']);
                            } else {
                              provider.addMeditationToFavorites(meditation['id']);
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
                      meditation['duration'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meditation['description'],
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYogaPoseDetails(Map<String, dynamic> pose, YogaMeditationProvider provider) {
    final isFavorite = provider.favoriteYogaPoses.contains(pose['id']);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                                size: 28,
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  provider.removeYogaPoseFromFavorites(pose['id']);
                                } else {
                                  provider.addYogaPoseToFavorites(pose['id']);
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // SVG image for pose
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _getSvgForPose(pose['name']).isNotEmpty
                              ? SvgPicture.asset(
                                  _getSvgForPose(pose['name']),
                                  height: 150,
                                  width: 150,
                                )
                              : const Icon(Icons.self_improvement, size: 80, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          pose['description'],
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailSection('Benefits', pose['benefits']),
                        const SizedBox(height: 16),
                        _buildDetailSection('Instructions', pose['instructions']),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                'Difficulty',
                                pose['difficulty'],
                                Icons.fitness_center,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoCard(
                                'Duration',
                                pose['duration'],
                                Icons.timer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _startYogaSession(pose);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Start Guided Practice'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showMeditationDetails(Map<String, dynamic> meditation, YogaMeditationProvider provider) {
    final isFavorite = provider.favoriteMeditations.contains(meditation['id']);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                meditation['name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                                size: 28,
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  provider.removeMeditationFromFavorites(meditation['id']);
                                } else {
                                  provider.addMeditationToFavorites(meditation['id']);
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: AppTheme.primaryColor,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Guided Meditation',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      meditation['duration'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          meditation['description'],
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailSection('Benefits', meditation['benefits']),
                        const SizedBox(height: 16),
                        _buildDetailSection('Instructions', meditation['instructions']),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _startMeditationSession(meditation);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Begin Meditation'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  // Start a yoga session with the selected pose
  void _startYogaSession(Map<String, dynamic> pose) {
    final yogaPoses = [pose]; // For now, just use the selected pose
    _workoutPoses = yogaPoses;
    _totalPoses = yogaPoses.length;
    _currentPoseIndex = 0;
    _currentPoseName = yogaPoses[0]['name'];
    
    // Calculate total workout time (in seconds)
    _totalWorkoutTime = 60; // Default 1 minute per pose
    _poseTimeRemaining = _totalWorkoutTime;
    
    // Start the countdown
    _isCountdownVisible = true;
    _countdownSeconds = 5;
    _startCountdown();
  }
  
  // Start a meditation session
  void _startMeditationSession(Map<String, dynamic> meditation) {
    _currentWorkout = meditation;
    
    // Parse duration string to get seconds (e.g., "10 minutes" -> 600 seconds)
    final durationString = meditation['duration'];
    int minutes = 10; // Default 10 minutes
    
    if (durationString.contains(RegExp(r'\d+'))) {
      minutes = int.parse(RegExp(r'(\d+)').firstMatch(durationString)?.group(1) ?? '10');
    }
    
    _totalWorkoutTime = minutes * 60;
    _poseTimeRemaining = _totalWorkoutTime;
    
    // Start the countdown
    _isCountdownVisible = true;
    _countdownSeconds = 5;
    _startCountdown();
  }
  
  // Start the countdown timer
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 1) {
          _countdownSeconds--;
        } else {
          // Countdown finished, start the workout
          _isCountdownVisible = false;
          _countdownTimer?.cancel();
          _startWorkout();
        }
      });
    });
  }
  
  // Start the workout timer
  void _startWorkout() {
    _isWorkoutInProgress = true;
    
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_poseTimeRemaining > 1) {
          _poseTimeRemaining--;
        } else {
          // Current pose finished
          if (_currentPoseIndex < _totalPoses - 1) {
            // Move to next pose
            _currentPoseIndex++;
            _currentPoseName = _workoutPoses[_currentPoseIndex]['name'];
            _poseTimeRemaining = _totalWorkoutTime;
          } else {
            // Workout completed
            _completeWorkout();
          }
        }
      });
    });
  }
  
  // Complete the workout
  void _completeWorkout() {
    _workoutTimer?.cancel();
    _isWorkoutInProgress = false;
    
    // Update provider with completed session
    final provider = Provider.of<YogaMeditationProvider>(context, listen: false);
    
    if (_workoutPoses.isNotEmpty) {
      // This was a yoga session
      provider.completeYogaSession(_workoutPoses[0]['id']);
    } else if (_currentWorkout != null) {
      // This was a meditation session
      provider.completeMeditationSession(_currentWorkout!['id']);
    }
    
    // Show completion dialog
    _showCompletionDialog();
  }
  
  // Show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great job!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'You completed your session!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep up the good work to maintain your streak of ${Provider.of<YogaMeditationProvider>(context, listen: false).streak} days!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  // Build the countdown overlay
  Widget _buildCountdownOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Get Ready!',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _countdownSeconds.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _countdownTimer?.cancel();
                setState(() {
                  _isCountdownVisible = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
  
  // Build the workout overlay
  Widget _buildWorkoutOverlay() {
    // Calculate progress percentage
    final progress = 1 - (_poseTimeRemaining / _totalWorkoutTime);
    
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('End Session?'),
                          content: const Text('Are you sure you want to end this session?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _workoutTimer?.cancel();
                                setState(() {
                                  _isWorkoutInProgress = false;
                                });
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (_workoutPoses.isNotEmpty)
                    Text(
                      'Pose ${_currentPoseIndex + 1} of $_totalPoses',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  IconButton(
                    icon: const Icon(Icons.pause, color: Colors.white),
                    onPressed: () {
                      // Pause functionality could be added here
                    },
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: _workoutPoses.isNotEmpty
                    ? _buildYogaPoseDisplay()
                    : _buildMeditationDisplay(),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(_poseTimeRemaining),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        _formatTime(_totalWorkoutTime),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade800,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Build the yoga pose display
  Widget _buildYogaPoseDisplay() {
    final pose = _workoutPoses[_currentPoseIndex];
    final poseName = pose['name'];
    final poseImagePath = pose['id'].toString().toLowerCase();
    
    // Try to find a matching SVG from the Images_illustrations folder
    String svgAsset = '';
    if (poseName.contains('Mountain')) svgAsset = 'Images_illustrations/Standing_forward_pose.svg';
    else if (poseName.contains('Child')) svgAsset = 'Images_illustrations/Childs_Pose.svg';
    else if (poseName.contains('Forward Bend')) svgAsset = 'Images_illustrations/Standing_forward_pose.svg';
    else if (poseName.contains('Warrior I')) svgAsset = 'Images_illustrations/Warrior_I.svg';
    else if (poseName.contains('Warrior II')) svgAsset = 'Images_illustrations/Warrior_II.svg';
    else if (poseName.contains('Warrior III')) svgAsset = 'Images_illustrations/Warrior_III.svg';
    else if (poseName.contains('Downward')) svgAsset = 'Images_illustrations/Downward_Facing_Dog.svg';
    else if (poseName.contains('Cobra')) svgAsset = 'Images_illustrations/Cobra_Pose.svg';
    else if (poseName.contains('Chair')) svgAsset = 'Images_illustrations/Chair_Pose.svg';
    else if (poseName.contains('Plank')) svgAsset = 'Images_illustrations/Plank_Pose.svg';
    else svgAsset = 'Images_illustrations/i${(_currentPoseIndex % 5) + 1}.svg'; // Fallback to generic illustrations
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: svgAsset.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SvgPicture.asset(
                    svgAsset,
                    height: 200,
                    width: 200,
                  ),
                )
              : const Icon(Icons.self_improvement, size: 120, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          poseName,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Hold this pose',
          style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
        ),
      ],
    );
  }
  
  // Build the meditation display
  Widget _buildMeditationDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'Images_illustrations/i3.svg', // Using a generic illustration
              height: 150,
              width: 150,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _currentWorkout?['name'] ?? 'Meditation',
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Focus on your breath',
          style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
        ),
      ],
    );
  }
  
  // Format seconds to MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}