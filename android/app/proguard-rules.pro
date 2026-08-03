# Keep Isar classes from being minified/stripped
-keep class io.isar.** { *; }
-dontwarn io.isar.**

# Keep Supabase/Postgrest classes
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# General Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }

# Fix R8 missing classes for Play Store Core (needed for release builds)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager
