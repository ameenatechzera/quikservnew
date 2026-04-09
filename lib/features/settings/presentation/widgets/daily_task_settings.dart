import 'package:shared_preferences/shared_preferences.dart';

class DailyTaskHelper {

  static Future<void> runOncePerDay({
    required String taskKey,
    required Future<void> Function() task,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final lastRun = prefs.getString(taskKey);

    final now = DateTime.now();

    bool shouldRun = false;


    if (lastRun == null) {
      shouldRun = true;
    } else {
      final lastDate = DateTime.parse(lastRun);

      if (lastDate.year != now.year ||
          lastDate.month != now.month ||
          lastDate.day != now.day) {
        shouldRun = true;
      }
    }

    if (shouldRun) {
      await task();

      await prefs.setString(
        taskKey,
        now.toIso8601String(),
      );
    }
  }
}
