import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';

class YogaDetailScreen extends StatefulWidget {
  final String yogaId;
  
  const YogaDetailScreen({super.key, required this.yogaId});

  @override
  State<YogaDetailScreen> createState() => _YogaDetailScreenState();
}

class _YogaDetailScreenState extends State<YogaDetailScreen> {
  // Workout progress variables
  bool _isCountdownVisible = false;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;
  
  bool _isWorkoutInProgress = false;
  int _poseTimeRemaining = 0;
  int _totalWorkoutTime = 0;
  Timer? _workoutTimer;
  Map<String, dynamic>? _currentPose;
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _workoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YogaMeditationProvider>(builder: (context, provider, child) {
      // Find the pose with the matching ID
      Map<String, dynamic> pose;
      
      // Check in Vata poses
      pose = provider.getYogaPosesForDosha('Vata')
          .firstWhere((p) => p['id'] == widget.yogaId, orElse: () => {});
      
      // If not found, check in Pitta poses
      if (pose.isEmpty) {
        pose = provider.getYogaPosesForDosha('Pitta')
            .firstWhere((p) => p['id'] == widget.yogaId, orElse: () => {});
      }
      
      // If still not found, check in Kapha poses
      if (pose.isEmpty) {
        pose = provider.getYogaPosesForDosha('Kapha')
            .firstWhere((p) => p['id'] == widget.yogaId, orElse: () => {});
      }
      
      // If pose is not found, show error
      if (pose.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Yoga Pose')),
          body: const Center(child: Text('Yoga pose not found')),
        );
      }
      
      final isFavorite = provider.favoriteYogaPoses.contains(pose['id']);
      
      return Scaffold(
        body: Stack(
          children: [
            // Main content
            CustomScrollView(
              slivers: [
                // App bar with pose image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: Center(
                        child: _getSvgForPose(pose['name']).isNotEmpty
                            ? SvgPicture.asset(
                                'assets/illustrations/yoga/${_getSvgForPose(pose['name'])}',
                                height: 250,
                                placeholderBuilder: (BuildContext context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : const Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          provider.removeYogaPoseFromFavorites(pose['id']);
                        } else {
                          provider.addYogaPoseToFavorites(pose['id']);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // TODO: Implement share functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share functionality coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
                
                // Pose details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pose name and difficulty
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                pose['name'],
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(pose['difficulty']).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                pose['difficulty'],
                                style: TextStyle(
                                  color: _getDifficultyColor(pose['difficulty']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Sanskrit name if available
                        if (pose['sanskritName'] != null)
                          Text(
                            pose['sanskritName'],
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        const SizedBox(height: 16),
                        
                        // Duration
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 20, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              pose['duration'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(pose['description']),
                        const SizedBox(height: 24),
                        
                        // Benefits
                        _buildDetailSection('Benefits', pose['benefits']),
                        
                        // Instructions
                        _buildDetailSection('Instructions', pose['instructions']),
                        
                        // Modifications if available
                        if (pose['modifications'] != null)
                          _buildDetailSection('Modifications', pose['modifications']),
                        
                        const SizedBox(height: 32),
                        
                        // Start practice button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _startYogaSession(pose),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Start Practice'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
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
    });
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
                  const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  // Start a yoga session with the selected pose
  void _startYogaSession(Map<String, dynamic> pose) {
    _currentPose = pose;
    
    // Parse duration string to get seconds
    final durationString = pose['duration'];
    final durationRegex = RegExp(r'(\d+)\s*(min|sec)');
    final match = durationRegex.firstMatch(durationString);
    
    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2);
      
      if (unit == 'min') {
        _totalWorkoutTime = value * 60;
      } else {
        _totalWorkoutTime = value;
      }
      
      _poseTimeRemaining = _totalWorkoutTime;
      
      // Start countdown
      setState(() {
        _isCountdownVisible = true;
        _countdownSeconds = 5;
      });
      
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownSeconds > 1) {
            _countdownSeconds--;
          } else {
            _countdownTimer?.cancel();
            _isCountdownVisible = false;
            _startWorkoutTimer();
          }
        });
      });
    }
  }

  // Start the workout timer
  void _startWorkoutTimer() {
    setState(() {
      _isWorkoutInProgress = true;
    });
    
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_poseTimeRemaining > 1) {
          _poseTimeRemaining--;
        } else {
          _workoutTimer?.cancel();
          _completeWorkout();
        }
      });
    });
  }

  // Complete the workout
  void _completeWorkout() {
    setState(() {
      _isWorkoutInProgress = false;
    });
    
    // Record completion
    final provider = Provider.of<YogaMeditationProvider>(context, listen: false);
    provider.completeYogaSession(_currentPose!['id']);
    
    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 16),
            const Text('You completed your yoga practice!'),
            const SizedBox(height: 8),
            Text(
              'Keep up the good work to maintain your streak of ${provider.streak} days!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
              'Get Ready',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
              child: Center(
                child: Text(
                  '$_countdownSeconds',
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the workout overlay
  Widget _buildWorkoutOverlay() {
    final minutes = _poseTimeRemaining ~/ 60;
    final seconds = _poseTimeRemaining % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final progress = 1 - (_poseTimeRemaining / _totalWorkoutTime);
    
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Column(
        children: [
          // Top bar with close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _workoutTimer?.cancel();
                      setState(() {
                        _isWorkoutInProgress = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Pose display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pose name
                  Text(
                    _currentPose?['name'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Pose image
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _getSvgForPose(_currentPose?['name'] ?? '').isNotEmpty
                          ? SvgPicture.asset(
                              'assets/illustrations/yoga/${_getSvgForPose(_currentPose?['name'] ?? '')}',
                              height: 200,
                              placeholderBuilder: (BuildContext context) => Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : const Icon(Icons.image, size: 100, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Timer
                  Text(
                    timeString,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade700,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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