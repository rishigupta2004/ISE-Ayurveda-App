import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.userName;
    _emailController.text = authProvider.userEmail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Profile Avatar with improved design
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryColor, width: 2),
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  if (!_isEditing)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // User Name
              if (!_isEditing) ...[  
                Text(
                  _nameController.text,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _emailController.text,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                
                // User Stats with improved design
                _buildStatsCard(),
                const SizedBox(height: 24),
                
                // Settings Options with improved design
                _buildSettingsSection(),
              ] else ...[  
                // Edit Profile Form with improved design
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel'),
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                // Reset controllers to original values
                                _nameController.text = authProvider.userName;
                                _emailController.text = authProvider.userEmail;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Save profile changes
                                final success = await authProvider.updateProfile(
                                  _nameController.text,
                                  _emailController.text,
                                );
                                
                                if (success && mounted) {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profile updated successfully')),
                                  );
                                } else if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to update profile')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.insights, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Meditations', '12', Icons.self_improvement),
                _buildStatItem('Yoga Sessions', '8', Icons.fitness_center),
                _buildStatItem('Wellness Score', '85%', Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.settings, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingItem('Notifications', Icons.notifications_outlined, () {
              // TODO: Implement notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings coming soon!')),
              );
            }),
            const Divider(),
            _buildSettingItem('App Theme', Icons.color_lens_outlined, () {
              // TODO: Implement theme settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon!')),
              );
            }),
            const Divider(),
            _buildSettingItem('Privacy Policy', Icons.privacy_tip_outlined, () {
              // TODO: Implement privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy coming soon!')),
              );
            }),
            const Divider(),
            _buildSettingItem('Log Out', Icons.logout, () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text('Are you sure you want to log out?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Log out user
                        Provider.of<AuthProvider>(context, listen: false).logout();
                        // Navigate to login screen
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}