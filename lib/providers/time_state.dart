import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_provider/database/entities/cleaning_time.dart';

part 'time_state.freezed.dart';

@freezed
class CleaningTimeState with _$CleaningTimeState {
  const factory CleaningTimeState.any() = CleaningTimeStateAny;

  const factory CleaningTimeState.inProgress({
    required CleaningTime cleaningTime,
  }) = CleaningTimeStateInProgress;

  const factory CleaningTimeState.stopped({
    required CleaningTime cleaningTime,
  }) = CleaningTimeStateStopped;
}
