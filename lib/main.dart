import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map/generated/l10n.dart';
import 'package:google_map/localization/provider/local_provider.dart';
import 'package:google_map/map/map_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/notification', [
    NotificationChannel(
        channelKey: 'Basic Key',
        channelName: 'Test Channel',
        channelDescription: 'Notifications For Test',
        playSound: true,
        channelShowBadge: true),
    NotificationChannel(
        channelKey: 'schedule Key',
        channelName: 'schedule Channel',
        channelDescription: 'Notifications For schedule',
        playSound: true,
        channelShowBadge: true,
        //soundSource: 'assets://raw/sound'
        importance: NotificationImportance.High)
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocalProvider>(
      create: (context) => LocalProvider(),
      child: Consumer<LocalProvider>(
        builder: (context, localProvider, _) => MaterialApp(
          locale: localProvider.locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MapScreen(),
        ),
      ),
    );
  }
}
