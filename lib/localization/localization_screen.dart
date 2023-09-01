import 'package:flutter/material.dart';
import 'package:google_map/generated/l10n.dart';
import 'package:google_map/localization/provider/local_provider.dart';
import 'package:google_map/notifications/notification_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocalizationScreen extends StatelessWidget {
  const LocalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localProvider = Provider.of<LocalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const NotificationScreen();
                  },
                ));
              },
              icon: const Icon(Icons.arrow_forward_ios))
        ],
      ),
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: isArabic() ? 16 : 0, left: isArabic() ? 0 : 16),
            child: Text(
              S.of(context).hello,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: isArabic() ? 16 : 0, left: isArabic() ? 0 : 16),
            child: Text(
              S.of(context).name,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Switch language on the click of the FAB
        onPressed: () {
          String newLanguageCode =
              localProvider.locale.languageCode == 'ar' ? 'en' : 'ar';
          localProvider.switchLanguage(newLanguageCode);
        },
        child: const Icon(Icons.language),
      ),
    );
  }

  bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }
}
