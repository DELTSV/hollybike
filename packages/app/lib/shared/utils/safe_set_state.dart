import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

extension SafeUpdateState on State {
  void safeSetState(void Function() updaterFunction) {
    void callSetState() {
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(updaterFunction);
      }
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
