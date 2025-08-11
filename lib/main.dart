import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niblin/firebase_options.dart';

import 'src/app_bootstrap/app.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Handle App Tracking Transparency for iOS
      if (Platform.isIOS) {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;

        if (status == TrackingStatus.notDetermined) {
          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          await AppTrackingTransparency.requestTrackingAuthorization();
        }

        // Always set advertiser tracking and auto log events regardless of permission
        await FacebookAppEvents().setAdvertiserTracking(enabled: true);
        await FacebookAppEvents().setAutoLogAppEventsEnabled(true);
      } else {
        // For Android, just enable the settings
        await FacebookAppEvents().setAdvertiserTracking(enabled: true);
        await FacebookAppEvents().setAutoLogAppEventsEnabled(true);
      }

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Initialize Firebase
      await Firebase.initializeApp(
        name: "niblin-app",
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initializing analytics
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

      // Caching firebase results
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );

      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Handle errors from the underlying platform, e.g. via MethodChannel
      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final List<dynamic> errorAndStacktrace = pair;
          await FirebaseCrashlytics.instance.recordError(
            errorAndStacktrace.first,
            errorAndStacktrace.last,
            fatal: true,
          );
        }).sendPort,
      );

      // Run the app
      runApp(const ProviderScope(child: App()));
    },
    (error, stack) {
      // This handles errors caught by runZonedGuarded
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}