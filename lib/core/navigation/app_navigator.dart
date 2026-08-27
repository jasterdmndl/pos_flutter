import 'package:flutter/material.dart';

/// Global navigator key used for app-level forced navigation
/// (e.g. cross-device single-session logout).
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
