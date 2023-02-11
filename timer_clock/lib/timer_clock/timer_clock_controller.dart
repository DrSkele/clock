part of timerclock;

final TimerClockController _defaultController = TimerClockController();

///A controller for [TimerClock].
class TimerClockController {
  TimerClockController();

  ///internal time value.
  Duration _time = Duration.zero;

  ///Current time of the [TimerClock].
  ///Is same as the [Duration] parameter passed from [TimerClock.itemBuilder].
  ///
  ///Widget using this value won't rebuild automatically as the value changes.
  ///Use [TimerClock.itemBuilder] for building widget that updates every time interval.
  Duration get time => _time;

  late Function _onStart;
  late Function _onReset;
  late Function _onStop;

  void start() {
    _onStart();
  }

  void reset() {
    _onReset();
  }

  void stop() {
    _onStop();
  }
}
