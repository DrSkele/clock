library timerclock;

import 'package:flutter/material.dart';
import 'package:timer_clock/timer_clock/restartable_periodic_timer.dart';

part 'timer_clock_controller.dart';

///A Builder with internal timer.
///
///Setting [duration] to [Duration.zero] will immediately trigger [onTimerEnd].
///But avoid setting it to [Duration.zero] to prevent building [itemBuilder],
///since [itemBuilder] will build serveral times even if [duration] is set to [Duration.zero].
///
///[itemBuilder] will build once after [onTimerEnd] is called.
///if [duration] is not multiple of [interval],
///this last build will correctly set the time value to match [duration].
///
///Avoid setting [interval] value to [Duration.zero],
///as it will constantly call [itemBuilder] even if the value doesn't change.
///
///Timer will countdown as soon as it's built.
///Set [onTimerEnd] to false and provide [controller] to control starting time of the Widget.
class TimerClock extends StatefulWidget {
  TimerClock({
    super.key,
    TimerClockController? controller,
    required this.duration,
    required this.interval,
    required this.itemBuilder,
    this.onTimerEnd,
    this.startOnBuild = true,
    this.isCountDown = true,
  }) : controller = controller ?? _defaultController;

  ///Manual control of the [TimerClock] can be obtained with this.
  ///
  ///If [startOnBuild] is set to false, use [controller] to manually start the [TimerClock].
  final TimerClockController controller;

  ///Wheather to start the timer as soon as the widget builds.
  ///If set to false, [controller] is reqired to start the [TimerClock] manually.
  ///
  ///Defaults to true.
  final bool startOnBuild;

  ///Determines wheather the [TimerClock] counts down or up.
  ///If true, value given in [TimerClock.itemBuilder] will start at [duration] and count down to zero.
  ///
  ///If true, value given in [TimerClock.itemBuilder] will start at zero and count up to [duration].
  ///
  ///Defaults to true.
  final bool isCountDown;

  ///Duration of the timer until [onTimerEnd] is called.
  ///
  ///Must be non-negative [Duration].
  final Duration duration;

  ///Interval between [itemBuilder] builds the widget again.
  ///
  ///Must be positive [Duration].
  final Duration interval;

  ///Callback on timer runs out of duration.
  ///
  ///Know that widget updates once after this function is called.
  ///After [onTimerEnd] is called,
  ///[itemBuilder] rebuilds the widget one last time with the finishing duration value.
  final Function()? onTimerEnd;

  ///Builds widget every given [interval].
  ///
  ///time value varies as [isCountDown].
  ///if [isCountDown] is true, time value will start at [duration] and count down to zero.
  ///if [isCountDown] is false, time value is elapsed time since start.
  final Widget Function(BuildContext context, Duration time) itemBuilder;

  @override
  State<TimerClock> createState() => _TimerClockState();
}

class _TimerClockState extends State<TimerClock> {
  RestartablePeriodicTimer? _timer;

  Duration _elapsedTime = Duration.zero;

  void _startTimerClock() {
    _timer ??= RestartablePeriodicTimer(
      duration: widget.duration,
      interval: widget.interval,
      onTimerEnd: _onTimerEnd,
      onTimerInterval: _onInterval,
    );

    _timer!.reset();
  }

  void _resetTimerClock() {
    _timer!.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
    });
  }

  void _stopTimerClock() {
    _timer!.cancel();
  }

  void _setupStartOnBuild() {
    if (widget.startOnBuild) {
      _startTimerClock();
    }
  }

  void _setupController() {
    if (widget.isCountDown) widget.controller._time = widget.duration;

    widget.controller._onStart = _startTimerClock;
    widget.controller._onReset = _resetTimerClock;
    widget.controller._onStop = _stopTimerClock;
  }

  void _onTimerEnd() {
    if (widget.onTimerEnd != null) widget.onTimerEnd!();
    _stopTimerClock();
    setState(() {
      _elapsedTime = widget.duration;
      widget.controller._time =
          (widget.isCountDown) ? Duration.zero : widget.duration;
    });
  }

  void _onInterval(Duration elapsedTime) {
    setState(() {
      _elapsedTime = elapsedTime;
      widget.controller._time =
          (widget.isCountDown) ? widget.duration - elapsedTime : elapsedTime;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setupStartOnBuild();
    _setupController();
  }

  @override
  Widget build(BuildContext context) {
    return widget.itemBuilder(context,
        (widget.isCountDown) ? widget.duration - _elapsedTime : _elapsedTime);
  }
}
