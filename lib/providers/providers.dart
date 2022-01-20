import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider/database/database.dart';
import 'package:test_provider/database/entities/cleaning_time.dart';
import 'package:test_provider/database/entities/user_time.dart';
import 'package:test_provider/providers/time_state.dart';
import 'package:test_provider/repository/time_repository.dart';

// Database
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase.databaseBuilder('app_database').build();
});

// Repository
final timeRepoProvider = FutureProvider<TimeRepositoryImpl>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return TimeRepositoryImpl(database);
});

// Cleaning
final lastCleaningTimeProvider = FutureProvider<CleaningTime?>((ref) async {
  final timeRepository = await ref.watch(timeRepoProvider.future);
  return timeRepository.getLastCleaningTime();
});

final cleaningTimeStateProvider =
FutureProvider<CleaningTimeState>((ref) async {
  final lastTime = ref.watch(lastCleaningTimeProvider);

  return lastTime.maybeMap(
    data: (data) {
      if (data.value == null) {
        return const CleaningTimeState.any();
      } else {
        if (data.value?.inProgress == true) {
          return CleaningTimeState.inProgress(cleaningTime: data.value!);
        } else {
          return CleaningTimeState.stopped(cleaningTime: data.value!);
        }
      }
    },
    orElse: () => const CleaningTimeState.any(),
  );
});

final cleaningTimeProvider = Provider<CleaningTime?>((ref) {
  final timeState = ref.watch(cleaningTimeStateProvider);

  return timeState.map(
    data: (data) => data.value.map(
      any: (_) => null,
      inProgress: (inProgress) => inProgress.cleaningTime,
      stopped: (stopped) => stopped.cleaningTime,
    ),
    loading: (loading) => null,
    error: (error) => null,
  );
});

final timeCancellableProvider = Provider<bool>((ref) {
  final timeState = ref.watch(cleaningTimeProvider);
  return timeState?.inProgress ?? false;
});

final timeIsProgressProvider = Provider<bool>((ref) {
  final timeState = ref.watch(cleaningTimeProvider);
  return timeState?.inProgress ?? false;
});

final timeFinishEnableProvider = Provider<bool>((ref) {
  final timeState = ref.watch(cleaningTimeProvider);
  return timeState?.finished ?? false;
});

// UserTime
final fetchUserTimeStreamProvider = StreamProvider<List<UserTime>>((ref) async* {

  final lastTime = await ref.watch(lastCleaningTimeProvider.future);
  if (lastTime == null) {
    yield List.empty();
  }

  final timeRepository = await ref.watch(timeRepoProvider.future);
  yield* timeRepository.fetchUserTime(lastTime!.id!);
});

final lastUserTimeProvider = FutureProvider<UserTime?>((ref) async {
  final userTimes = await ref.watch(fetchUserTimeStreamProvider.future);

  try {
    return userTimes.last;

  } catch (error) {
    return null;
  }
});



