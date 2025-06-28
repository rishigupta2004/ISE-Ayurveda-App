import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userId = '';
  String _userName = '';
  String _userEmail = '';

  bool get isAuthenticated => _isAuthenticated;
  String get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;

  // Initialize auth state from local storage
  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userId = prefs.getString('userId') ?? '';
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      // In a real app, this would make an API call to authenticate
      // For demo purposes, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 1));
      
      // Set user data
      _isAuthenticated = true;
      _userId = 'user_123'; // This would come from the backend
      _userName = 'Demo User'; // This would come from the backend
      _userEmail = email;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuthenticated', true);
      prefs.setString('userId', _userId);
      prefs.setString('userName', _userName);
      prefs.setString('userEmail', _userEmail);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Register user
  Future<bool> register(String name, String email, String password) async {
    try {
      // In a real app, this would make an API call to register
      // For demo purposes, we'll simulate a successful registration
      await Future.delayed(const Duration(seconds: 1));
      
      // Set user data
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}'; // Generate a unique ID
      _userName = name;
      _userEmail = email;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuthenticated', true);
      prefs.setString('userId', _userId);
      prefs.setString('userName', _userName);
      prefs.setString('userEmail', _userEmail);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = '';
    _userName = '';
    _userEmail = '';
    
    // Clear from local storage
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isAuthenticated');
    prefs.remove('userId');
    prefs.remove('userName');
    prefs.remove('userEmail');
    
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile(String name, String email) async {
    try {
      // In a real app, this would make an API call to update profile
      await Future.delayed(const Duration(seconds: 1));
      
      _userName = name;
      _userEmail = email;
      
      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', _userName);
      prefs.setString('userEmail', _userEmail);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}