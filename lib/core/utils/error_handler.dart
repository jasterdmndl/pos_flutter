import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorHandler {
  static String map(dynamic error) {
    if (error is AuthException) {
      final msg = error.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return 'Incorrect email or password. Please try again.';
      }
      if (msg.contains('email not confirmed')) {
        return 'Please confirm your email address before logging in.';
      }
      if (msg.contains('network error') || msg.contains('connection')) {
        return 'Connection lost. Switching to offline mode...';
      }
      return error.message;
    }

    if (error is SocketException || error is HttpException) {
      return 'No internet connection. Please check your network.';
    }

    if (error.toString().contains('IsarError')) {
      return 'Local database error. Please restart the app.';
    }

    return 'Something went wrong. Please try again later.';
  }
}
