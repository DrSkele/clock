import 'dart:async';
import 'package:async/async.dart';

///A restartable periodic timer.
///
///[duration] and [interval] must be non-negative [Duration].
class RestartablePeriodicTimer {
  RestartablePeriodicTimer({
    required this.duration,
    required this.interval,
    required this.onTimerEnd,
    required this.onTimerInterval,
  })  : _timer = RestartableTimer(duration, onTimerEnd),
        _intervalCounter = Timer.periodic(interval, (timer) {
          onTimerInterval(interval * timer.tick);
        });

  ///Span of time until the timer stops.
  ///If duration is expired, [onTimerEnd] is called.
  ///
  ///must be non-negative.
  final Duration duration;

  ///Time between events.
  ///[onTimerInterval] will be called every given [interval]
  ///until [duration] expires.
  ///
  ///must be non-negative.
  final Duration interval;

  ///Called when [duration] expires.
  final Function() onTimerEnd;

  ///Called every given [interval] until [duration] expires.
  final Function(Duration elapsedTime) onTimerInterval;

  ///internal timer for duration check.
  final RestartableTimer _timer;

  ///internal timer for periodic interval check.
  Timer _intervalCounter;

  void reset() {
    _timer.reset();
    _intervalCounter.cancel();
    _intervalCounter = Timer.periodic(interval, (timer) {
      onTimerInterval(interval * timer.tick);
    });
  }

  void cancel() {
    _timer.cancel();
    _intervalCounter.cancel();
  }
}
