import 'package:flutter/material.dart';

/// Custom route observer to track navigation events
class AyurvedaRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  /// Singleton instance
  static final AyurvedaRouteObserver _instance = AyurvedaRouteObserver._internal();
  
  /// Factory constructor
  factory AyurvedaRouteObserver() => _instance;
  
  /// Private constructor
  AyurvedaRouteObserver._internal();
  
  /// List of navigation listeners
  final List<NavigationListener> _listeners = [];
  
  /// Add a navigation listener
  void addListener(NavigationListener listener) {
    _listeners.add(listener);
  }
  
  /// Remove a navigation listener
  void removeListener(NavigationListener listener) {
    _listeners.remove(listener);
  }
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _notifyListeners(
        NavigationEvent.push,
        route.settings.name,
        previousRoute?.settings.name,
      );
    }
  }
  
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute) {
      _notifyListeners(
        NavigationEvent.pop,
        previousRoute?.settings.name,
        route.settings.name,
      );
    }
  }
  
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _notifyListeners(
        NavigationEvent.replace,
        newRoute.settings.name,
        oldRoute?.settings.name,
      );
    }
  }
  
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      _notifyListeners(
        NavigationEvent.remove,
        previousRoute?.settings.name,
        route.settings.name,
      );
    }
  }
  
  /// Notify all listeners of a navigation event
  void _notifyListeners(
    NavigationEvent event,
    String? currentRoute,
    String? previousRoute,
  ) {
    for (final listener in _listeners) {
      listener.onNavigationEvent(event, currentRoute, previousRoute);
    }
  }
}

/// Navigation event types
enum NavigationEvent {
  push,
  pop,
  replace,
  remove,
}

/// Navigation listener interface
abstract class NavigationListener {
  void onNavigationEvent(
    NavigationEvent event,
    String? currentRoute,
    String? previousRoute,
  );
}