import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:async';


Timer? timer;
Stopwatch? watch;
class TimerService extends ChangeNotifier {

  Duration get currentDuration => getCurrentDuration;
  Duration getCurrentDuration = Duration.zero;

  bool get isRunning => timer != null;

  TimerService() {
    watch = Stopwatch();
  }

  void onTick(Timer timer) {
    getCurrentDuration = watch?.elapsed ?? const Duration(seconds: 0);
    notifyListeners();
  }

  void start() async {
    try {
      if (timer != null) return;

      timer = Timer.periodic(const Duration(seconds: 1), onTick);
      watch?.start();

      notifyListeners();
      logger.i('.. start ..');
    } catch(e) {
      logger.e(e);
    }
  }

  void stop() async {
    try {
      timer?.cancel();
      timer = null;
      watch?.stop();
      getCurrentDuration = watch?.elapsed ?? const Duration(seconds: 0);

      // notifyListeners();

    } catch(e) {
      logger.e(e);
    }
  }

  void reset() {
    stop();
    watch?.reset();
    getCurrentDuration = Duration.zero;
    notifyListeners();
  }

  static TimerService of(BuildContext context) {
    var provider = context.dependOnInheritedWidgetOfExactType<TimerServiceProvider>();
    return provider!.service;
  }
}

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider({Key? key, required this.service, required Widget child}) : super(key: key, child: child);

  final TimerService service;

  @override
  bool updateShouldNotify(TimerServiceProvider old) => service != old.service;
}