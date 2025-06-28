import 'package:flutter/material.dart';

class YogaMeditationProvider extends ChangeNotifier {
  // List of favorite yoga poses and meditation sessions
  final List<String> _favoriteYogaPoses = [];
  final List<String> _favoriteMeditations = [];
  
  // Completed yoga sessions
  final List<String> _completedYogaSessions = [];
  
  // Completed meditation sessions
  final List<String> _completedMeditationSessions = [];
  
  // Current streak (days with yoga or meditation practice)
  int _streak = 0;
  
  // Getters
  List<String> get favoriteYogaPoses => _favoriteYogaPoses;
  List<String> get favoriteMeditations => _favoriteMeditations;
  List<String> get completedYogaSessions => _completedYogaSessions;
  List<String> get completedMeditationSessions => _completedMeditationSessions;
  int get streak => _streak;
  
  // Add a yoga pose to favorites
  void addYogaPoseToFavorites(String poseId) {
    if (!_favoriteYogaPoses.contains(poseId)) {
      _favoriteYogaPoses.add(poseId);
      notifyListeners();
    }
  }
  
  // Remove a yoga pose from favorites
  void removeYogaPoseFromFavorites(String poseId) {
    if (_favoriteYogaPoses.contains(poseId)) {
      _favoriteYogaPoses.remove(poseId);
      notifyListeners();
    }
  }
  
  // Add a meditation to favorites
  void addMeditationToFavorites(String meditationId) {
    if (!_favoriteMeditations.contains(meditationId)) {
      _favoriteMeditations.add(meditationId);
      notifyListeners();
    }
  }
  
  // Remove a meditation from favorites
  void removeMeditationFromFavorites(String meditationId) {
    if (_favoriteMeditations.contains(meditationId)) {
      _favoriteMeditations.remove(meditationId);
      notifyListeners();
    }
  }
  
  // Complete a yoga session
  void completeYogaSession(String sessionId) {
    if (!_completedYogaSessions.contains(sessionId)) {
      _completedYogaSessions.add(sessionId);
      _updateStreak();
      notifyListeners();
    }
  }
  
  // Complete a meditation session
  void completeMeditationSession(String sessionId) {
    if (!_completedMeditationSessions.contains(sessionId)) {
      _completedMeditationSessions.add(sessionId);
      _updateStreak();
      notifyListeners();
    }
  }
  
  // Update streak
  void _updateStreak() {
    // In a real app, this would check if the last session was yesterday
    // For now, just increment the streak
    _streak++;
  }
  
  // Get yoga poses for a specific dosha
  List<Map<String, dynamic>> getYogaPosesForDosha(String dosha) {
    switch (dosha) {
      case 'Vata':
        return _vataYogaPoses;
      case 'Pitta':
        return _pittaYogaPoses;
      case 'Kapha':
        return _kaphaYogaPoses;
      default:
        return [];
    }
  }
  
  // Get meditations for a specific dosha
  List<Map<String, dynamic>> getMeditationsForDosha(String dosha) {
    switch (dosha) {
      case 'Vata':
        return _vataMeditations;
      case 'Pitta':
        return _pittaMeditations;
      case 'Kapha':
        return _kaphaMeditations;
      default:
        return [];
    }
  }
  
  // Vata yoga poses
  final List<Map<String, dynamic>> _vataYogaPoses = [
    {
      'id': 'v_pose1',
      'name': 'Mountain Pose (Tadasana)',
      'description': 'A grounding pose that helps improve posture and balance.',
      'benefits': [
        'Improves posture',
        'Creates stability and grounding',
        'Calms the mind',
        'Reduces anxiety',
      ],
      'duration': '1-3 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Standing_forward_pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Distribute weight evenly across both feet',
        'Engage your thighs and lengthen your spine',
        'Relax your shoulders down and back',
        'Extend arms alongside your body with palms facing forward',
        'Breathe deeply and hold the pose',
      ],
    },
    {
      'id': 'v_pose2',
      'name': 'Child\'s Pose (Balasana)',
      'description': 'A restful pose that gently stretches the back and promotes relaxation.',
      'benefits': [
        'Releases tension in back, shoulders, and chest',
        'Calms the mind and reduces stress',
        'Helps relieve fatigue',
        'Gently stretches hips, thighs, and ankles',
      ],
      'duration': '3-5 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Childs_Pose.svg',
      'instructions': [
        'Kneel on the floor with toes together and knees apart',
        'Sit back on your heels',
        'Exhale and lay your torso between your thighs',
        'Extend arms forward with palms on the floor',
        'Rest forehead on the ground',
        'Breathe deeply and relax into the pose',
      ],
    },
    {
      'id': 'v_pose3',
      'name': 'Standing Forward Bend (Uttanasana)',
      'description': 'A calming forward bend that stretches the back and hamstrings.',
      'benefits': [
        'Stretches hamstrings, calves, and hips',
        'Strengthens thighs and knees',
        'Reduces stress and anxiety',
        'Relieves tension in the spine and neck',
      ],
      'duration': '1-3 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Standing_forward_pose.svg',
      'instructions': [
        'Stand with feet hip-width apart',
        'Exhale and bend forward from the hips',
        'Lengthen the front of your torso',
        'Place hands on the floor or hold elbows',
        'Relax your head and neck',
        'Breathe deeply and hold the pose',
      ],
    },
    {
      'id': 'v_pose4',
      'name': 'Cat-Cow Pose (Marjaryasana-Bitilasana)',
      'description': 'A gentle flow between two poses that warms the body and brings flexibility to the spine.',
      'benefits': [
        'Improves posture and balance',
        'Strengthens and stretches the spine and neck',
        'Stretches the hips, abdomen and back',
        'Increases coordination',
      ],
      'duration': '1-3 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Cat_pose.svg',
      'instructions': [
        'Start on your hands and knees in a tabletop position',
        'For Cat: Exhale as you round your spine toward the ceiling',
        'Tuck your chin toward your chest',
        'For Cow: Inhale as you drop your belly towards the mat',
        'Lift your chin and chest, and gaze up toward the ceiling',
        'Flow between the two poses, matching your breath to the movement',
      ],
    },
    {
      'id': 'v_pose5',
      'name': 'Cobra Pose (Bhujangasana)',
      'description': 'A gentle backbend that opens the chest and strengthens the spine.',
      'benefits': [
        'Strengthens the spine',
        'Opens the chest and lungs',
        'Stimulates abdominal organs',
        'Helps relieve stress and fatigue',
      ],
      'duration': '15-30 seconds',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Cobra_Pose.svg',
      'instructions': [
        'Lie on your stomach with hands under shoulders',
        'Press the tops of your feet, thighs, and pelvis into the floor',
        'On an inhale, straighten your arms to lift your chest off the floor',
        'Keep your elbows slightly bent and close to your body',
        'Distribute the backbend evenly through the entire spine',
        'Hold the pose and breathe deeply',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
  
  // Pitta yoga poses
  final List<Map<String, dynamic>> _pittaYogaPoses = [
    {
      'id': 'p_pose1',
      'name': 'Moon Salutation (Chandra Namaskar)',
      'description': 'A cooling sequence that calms the mind and body.',
      'benefits': [
        'Cools the body and mind',
        'Reduces irritability and anger',
        'Balances hormones',
        'Promotes relaxation',
      ],
      'duration': '5-10 minutes',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Warrior_II.svg',
      'instructions': [
        'Begin in Mountain Pose with hands in prayer position',
        'Inhale and reach arms up, then side bend to the right',
        'Return to center, then side bend to the left',
        'Forward fold and step back to a lunge',
        'Move through the sequence on both sides',
        'End in Mountain Pose with hands in prayer position',
      ],
    },
    {
      'id': 'p_pose2',
      'name': 'Reclining Bound Angle Pose (Supta Baddha Konasana)',
      'description': 'A restorative pose that opens the hips and promotes relaxation.',
      'benefits': [
        'Opens the hips and groin',
        'Stimulates abdominal organs and improves digestion',
        'Reduces stress and anxiety',
        'Helps with fatigue and insomnia',
      ],
      'duration': '5-10 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Low_Lunge.svg',
      'instructions': [
        'Lie on your back',
        'Bring the soles of your feet together, allowing knees to fall out to the sides',
        'Place arms at your sides with palms facing up',
        'Close your eyes and breathe deeply',
        'Relax your inner thighs',
        'Hold the pose and focus on your breath',
      ],
    },
    {
      'id': 'p_pose3',
      'name': 'Seated Forward Bend (Paschimottanasana)',
      'description': 'A cooling forward bend that calms the mind and stretches the back body.',
      'benefits': [
        'Stretches the spine, shoulders, and hamstrings',
        'Calms the mind and reduces stress',
        'Stimulates the liver, kidneys, and digestive organs',
        'Reduces headache and anxiety',
      ],
      'duration': '1-3 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Halfway_Lift_pose.svg',
      'instructions': [
        'Sit with legs extended forward',
        'Inhale and lengthen your spine',
        'Exhale and hinge at the hips to fold forward',
        'Hold your feet, ankles, or shins',
        'Relax your head and neck',
        'Breathe deeply and hold the pose',
      ],
    },
    {
      'id': 'p_pose4',
      'name': 'Downward Facing Dog (Adho Mukha Svanasana)',
      'description': 'An invigorating pose that stretches the entire back body and builds strength.',
      'benefits': [
        'Stretches shoulders, hamstrings, calves, and hands',
        'Strengthens arms, legs, and core',
        'Energizes the body',
        'Calms the mind and relieves stress',
      ],
      'duration': '1-3 minutes',
      'difficulty': 'Beginner',
      'image': 'assets/Images_illustrations/Downward_Facing_Dog.svg',
      'instructions': [
        'Start on hands and knees',
        'Tuck your toes and lift your hips up and back',
        'Straighten your legs as much as comfortable',
        'Press your chest toward your thighs',
        'Keep your head between your arms',
        'Breathe deeply and hold the pose',
      ],
    },
    {
      'id': 'p_pose5',
      'name': 'Revolved Chair Pose (Parivrtta Utkatasana)',
      'description': 'A twisting pose that builds heat and detoxifies the body.',
      'benefits': [
        'Improves digestion and detoxification',
        'Strengthens legs and core',
        'Improves balance and focus',
        'Opens shoulders and chest',
      ],
      'duration': '30-60 seconds per side',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Revolved_Chair_pose.svg',
      'instructions': [
        'Begin in Chair Pose with knees bent and thighs parallel to the floor',
        'Bring palms together at heart center',
        'Twist to the right, placing left elbow outside right thigh',
        'Keep knees aligned and chest lifted',
        'Gaze over right shoulder',
        'Hold, then repeat on the other side',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
  
  // Kapha yoga poses
  final List<Map<String, dynamic>> _kaphaYogaPoses = [
    {
      'id': 'k_pose1',
      'name': 'Sun Salutation (Surya Namaskar)',
      'description': 'An energizing sequence that builds heat and stimulates the body.',
      'benefits': [
        'Increases energy and reduces lethargy',
        'Improves circulation and digestion',
        'Strengthens and tones muscles',
        'Stimulates metabolism',
      ],
      'duration': '5-10 minutes',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Upward _Facing_dog.svg',
      'instructions': [
        'Begin in Mountain Pose with hands in prayer position',
        'Inhale and reach arms up',
        'Exhale and forward fold',
        'Inhale to half-lift, exhale to step back to plank',
        'Lower to chaturanga, upward dog, downward dog',
        'Step forward, half-lift, forward fold, and return to standing',
      ],
    },
    {
      'id': 'k_pose2',
      'name': 'Warrior I (Virabhadrasana I)',
      'description': 'A strengthening pose that builds heat and energy.',
      'benefits': [
        'Strengthens legs, arms, and back',
        'Opens chest and shoulders',
        'Improves focus and balance',
        'Stimulates metabolism',
      ],
      'duration': '30-60 seconds per side',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Warrior_I.svg',
      'instructions': [
        'Step one foot back and turn it out at a 45-degree angle',
        'Bend your front knee to 90 degrees',
        'Square your hips and torso to the front',
        'Raise arms overhead with palms facing each other',
        'Gaze forward or up at your hands',
        'Breathe deeply and hold the pose',
      ],
    },
    {
      'id': 'k_pose3',
      'name': 'Chair Pose (Utkatasana)',
      'description': 'A heating pose that builds strength and energy.',
      'benefits': [
        'Strengthens thighs, ankles, and spine',
        'Stimulates abdominal organs and heart',
        'Increases energy and reduces lethargy',
        'Improves balance and posture',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Beginner',
      'image': 'assets/images/yoga/chair_pose.jpg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Inhale and raise arms overhead',
        'Exhale and bend knees as if sitting in a chair',
        'Keep weight in heels and chest lifted',
        'Draw tailbone down and engage core',
        'Breathe deeply and hold the pose',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
  
  // Vata meditations
  final List<Map<String, dynamic>> _vataMeditations = [
    {
      'id': 'v_med1',
      'name': 'Grounding Earth Meditation',
      'description': 'A calming meditation that helps ground Vata energy and reduce anxiety.',
      'benefits': [
        'Reduces anxiety and worry',
        'Creates stability and grounding',
        'Improves focus and concentration',
        'Promotes better sleep',
      ],
      'duration': '10 minutes',
      'audio': 'assets/audio/earth_meditation.mp3',
      'instructions': [
        'Sit comfortably with your back straight',
        'Close your eyes and take deep breaths',
        'Visualize roots growing from your body into the earth',
        'Feel a connection with the stable, solid earth beneath you',
        'Continue breathing deeply, feeling more grounded with each breath',
        'When ready, slowly open your eyes',
      ],
    },
    {
      'id': 'v_med2',
      'name': 'So Hum Mantra Meditation',
      'description': 'A traditional meditation using the natural sound of breath to calm the mind.',
      'benefits': [
        'Calms an overactive mind',
        'Reduces anxiety and stress',
        'Improves concentration',
        'Creates inner peace',
      ],
      'duration': '15 minutes',
      'audio': 'assets/audio/so_hum_meditation.mp3',
      'instructions': [
        'Sit in a comfortable position with eyes closed',
        'Become aware of your natural breath',
        'Mentally repeat "So" on the inhale',
        'Mentally repeat "Hum" on the exhale',
        'Continue for 10-15 minutes',
        'Slowly return to normal awareness',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
  
  // Pitta meditations
  final List<Map<String, dynamic>> _pittaMeditations = [
    {
      'id': 'p_med1',
      'name': 'Cooling Moonlight Meditation',
      'description': 'A cooling meditation that reduces heat and intensity in the mind and body.',
      'benefits': [
        'Reduces anger and irritability',
        'Cools the mind and body',
        'Promotes forgiveness and compassion',
        'Enhances emotional balance',
      ],
      'duration': '10 minutes',
      'audio': 'assets/audio/moonlight_meditation.mp3',
      'instructions': [
        'Sit comfortably with your back straight',
        'Close your eyes and take deep breaths',
        'Visualize cool, silver moonlight washing over you',
        'Feel the cooling energy spreading through your body',
        'Release any heat, tension, or irritation with each exhale',
        'When ready, slowly open your eyes',
      ],
    },
    {
      'id': 'p_med2',
      'name': 'Loving-Kindness Meditation',
      'description': 'A heart-centered meditation that cultivates compassion and forgiveness.',
      'benefits': [
        'Reduces anger and criticism',
        'Cultivates compassion and understanding',
        'Improves relationships',
        'Creates emotional balance',
      ],
      'duration': '15 minutes',
      'audio': 'assets/audio/loving_kindness.mp3',
      'instructions': [
        'Sit comfortably with eyes closed',
        'Begin by directing loving-kindness to yourself: "May I be happy, may I be healthy..."',
        'Extend to loved ones, then neutral people, then difficult people',
        'Finally extend to all beings everywhere',
        'Feel the warmth of compassion in your heart',
        'Slowly return to normal awareness',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
  
  // Kapha meditations
  final List<Map<String, dynamic>> _kaphaMeditations = [
    {
      'id': 'k_med1',
      'name': 'Dynamic Breath of Fire Meditation',
      'description': 'An energizing breathing meditation that stimulates and invigorates.',
      'benefits': [
        'Increases energy and reduces lethargy',
        'Stimulates metabolism',
        'Clears congestion',
        'Improves mental clarity',
      ],
      'duration': '5 minutes',
      'audio': 'assets/audio/breath_of_fire.mp3',
      'instructions': [
        'Sit with spine straight and eyes closed',
        'Begin rapid, rhythmic breathing through the nose',
        'Inhale and exhale should be equal in duration',
        'Use your diaphragm to forcefully expel air',
        'Continue for 1-3 minutes, then return to normal breathing',
        'Observe the sensations in your body',
      ],
    },
    {
      'id': 'k_med2',
      'name': 'Mountain Visualization Meditation',
      'description': 'An uplifting meditation that cultivates strength and determination.',
      'benefits': [
        'Increases motivation and willpower',
        'Reduces stagnation and attachment',
        'Builds confidence and determination',
        'Promotes mental clarity',
      ],
      'duration': '10 minutes',
      'audio': 'assets/audio/mountain_meditation.mp3',
      'instructions': [
        'Sit comfortably with your back straight',
        'Close your eyes and take deep breaths',
        'Visualize yourself as a strong, immovable mountain',
        'Feel the qualities of strength, stability, and majesty',
        'Embody these qualities with each breath',
        'When ready, slowly open your eyes',
      ],
      'duration': '30-60 seconds',
      'difficulty': 'Intermediate',
      'image': 'assets/Images_illustrations/Chair_Pose.svg',
      'instructions': [
        'Stand with feet together or hip-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Raise your arms overhead with palms facing each other',
        'Keep your chest lifted and weight in your heels',
        'Gaze forward or slightly upward',
        'Breathe deeply and hold the pose',
      ],
    },
  ];
}