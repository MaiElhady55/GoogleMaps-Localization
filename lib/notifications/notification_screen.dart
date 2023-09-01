import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().requestPermissionToSendNotifications();
                },
                child: const Text('request Permission')),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 1,
                          channelKey: 'Basic Key',
                          title: 'Title Test',
                          body: 'Body Test Notifications',
                          bigPicture: 'assets://assets/images/notification',
                          notificationLayout: NotificationLayout.BigPicture));
                },
                child: const Text('Create')),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 1,
                        channelKey: 'schedule Key',
                        title: 'Title Test schedule',
                        body: 'Body Test Notifications',
                        //bigPicture: 'assets://assets/images/notification',
                        //notificationLayout: NotificationLayout.BigPicture
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date:
                              DateTime.now().add(const Duration(seconds: 2))));
                },
                child: const Text('Schedule')),
          ],
        ),
      ),
    );
  }
}
