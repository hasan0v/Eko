import 'package:equatable/equatable.dart';

/// Water events
abstract class WaterEvent extends Equatable {
  const WaterEvent();

  @override
  List<Object?> get props => [];
}

/// Load tank status
class WaterLoadTank extends WaterEvent {
  const WaterLoadTank();
}

/// Toggle auto-irrigation
class WaterToggleAuto extends WaterEvent {
  final bool enabled;

  const WaterToggleAuto(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Start manual irrigation
class WaterStartManualIrrigation extends WaterEvent {
  final int duration;
  final String? zone;

  const WaterStartManualIrrigation({
    required this.duration,
    this.zone,
  });

  @override
  List<Object?> get props => [duration, zone];
}

/// Load irrigation schedules
class WaterLoadSchedules extends WaterEvent {
  const WaterLoadSchedules();
}

/// Add irrigation schedule
class WaterAddSchedule extends WaterEvent {
  final DateTime scheduledTime;
  final int duration;
  final String? zone;

  const WaterAddSchedule({
    required this.scheduledTime,
    required this.duration,
    this.zone,
  });

  @override
  List<Object?> get props => [scheduledTime, duration, zone];
}

/// Delete irrigation schedule
class WaterDeleteSchedule extends WaterEvent {
  final String scheduleId;

  const WaterDeleteSchedule(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

/// Load irrigation history
class WaterLoadHistory extends WaterEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const WaterLoadHistory({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Refresh water data
class WaterRefresh extends WaterEvent {
  const WaterRefresh();
}
