import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider/database/entities/cleaning_time.dart';
import 'package:test_provider/database/entities/user_time.dart';

import 'providers.dart';


extension TimeActionExtensions on WidgetRef {
  TimeActions get timeActions => TimeActions(this);
}

class TimeActions {
  const TimeActions(this._ref);

  final WidgetRef _ref;

  Future<void> startTime() async {
    final timeRepository = await _ref.read(timeRepoProvider.future);

    final cleaningTimeState =
        await _ref.watch(cleaningTimeStateProvider.future);
    cleaningTimeState.map(
      any: (_) async {
        // Create cleaning + user time
        CleaningTime ct = CleaningTime(
            description: 'Description',
            inProgress: true,
            finished: false);
        final newId = await timeRepository.insertCleaningTime(ct);

        UserTime ut = UserTime(
            cleaningTimeId: newId,
            userId: 1,
            startTime: DateTime.now().millisecondsSinceEpoch,
        );
        timeRepository.insertUserTime(ut);

      },
      inProgress: (cleaningTime) {
        debugPrint("startTime{inProgress}");
      },
      stopped: (cleaningTime) {
        debugPrint("startTime{stopped}");
        final cleaningTime = _ref.read(cleaningTimeProvider);
        if (cleaningTime == null) {
          return;
        }

        UserTime ut = UserTime(
          cleaningTimeId: cleaningTime.id!,
          userId: 1,
          startTime: DateTime.now().millisecondsSinceEpoch,
        );
        timeRepository.insertUserTime(ut);

        cleaningTime.inProgress = true;
        timeRepository.updateCleaningTime(cleaningTime);
      },
    );

    _ref.refresh(lastCleaningTimeProvider);

    // ?!
    _ref.refresh(fetchUserTimeStreamProvider);
  }

  Future<void> stopTime() async {
    final currentUserTime = await _ref.read(lastUserTimeProvider.future);
    if (currentUserTime == null) {
      return;
    }

    currentUserTime.endTime = DateTime.now().millisecondsSinceEpoch;

    final timeRepository = await _ref.read(timeRepoProvider.future);
    timeRepository.updateUserTime(currentUserTime);

    final cleaningTime = _ref.read(cleaningTimeProvider);
    if (cleaningTime == null) {
      return;
    }
    cleaningTime.inProgress = false;
    timeRepository.updateCleaningTime(cleaningTime);

    _ref.refresh(lastCleaningTimeProvider);
  }
}
