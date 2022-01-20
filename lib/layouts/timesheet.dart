import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider/providers/actions.dart';
import 'package:test_provider/providers/providers.dart';

class TimesheetLayout extends ConsumerWidget {
  const TimesheetLayout({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: const [
        TimeSheetListLayout(),
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TimeActionBar(),
            ),
          ),
        ),
      ],
    );
  }
}

class TimeSheetListLayout extends ConsumerWidget {
  const TimeSheetListLayout({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTimes = ref.read(fetchUserTimeStreamProvider);

    return userTimes.when(
        data: (data) {
          debugPrint("User times size ${data.length}");
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text("Id: ${data[index].id}"),
                  Text("Start: ${data[index].startTime}"),
                  Text("Stop: ${data[index].endTime}"),
                ],
              );
            },
          );
        },
        error: (message, e) => Text("User times error : ${message.toString()}"),
        loading: () => const CircularProgressIndicator());
  }
}

class TimeActionBar extends ConsumerWidget {
  const TimeActionBar({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelableTime = ref.watch(timeCancellableProvider);
    final timeInProgress = ref.watch(timeIsProgressProvider);
    final timeFinished = ref.watch(timeFinishEnableProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Visibility(
          visible: cancelableTime,
          child: const FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.close),
          ),
        ),
        Visibility(
          child: FloatingActionButton(
            onPressed: () => timeInProgress
                ? ref.timeActions.stopTime()
                : ref.timeActions.startTime(),
            child: Icon(timeInProgress ? Icons.stop : Icons.play_arrow),
          ),
        ),
        Visibility(
          visible: timeFinished,
          child: const FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.sports_score_outlined),
          ),
        )
      ],
    );
  }
}
