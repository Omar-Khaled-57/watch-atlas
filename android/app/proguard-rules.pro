# Flutter-specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Supabase
-keep class io.github.jan-tennert.supabase.** { *; }

# Freezed / JSON Serializable
-keep class **.freezed.** { *; }
-keep class **.g.dart { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Dart annotations
-keepattributes *Annotation*

# Firebase
-keep class com.google.firebase.** { *; }

# Don't strip annotations
-keepattributes Signature,InnerClasses,EnclosingMethod
