import 'package:equatable/equatable.dart';
import '../../../models/water_tank.dart';
import '../../../models/irrigation.dart';

/// Water state
abstract class WaterState extends Equatable {
  const WaterState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WaterInitial extends WaterState {
  const WaterInitial();
}

/// Loading state
class WaterLoading extends WaterState {
  const WaterLoading();
}

/// Tank loaded state
class WaterTankLoaded extends WaterState {
  final WaterTank tank;
  final bool autoIrrigationEnabled;

  const WaterTankLoaded({
    required this.tank,
    this.autoIrrigationEnabled = false,
  });

  @override
  List<Object?> get props => [tank, autoIrrigationEnabled];

  WaterTankLoaded copyWith({
    WaterTank? tank,
    bool? autoIrrigationEnabled,
  }) {
    return WaterTankLoaded(
      tank: tank ?? this.tank,
      autoIrrigationEnabled: autoIrrigationEnabled ?? this.autoIrrigationEnabled,
    );
  }
}

/// Schedules loaded state
class WaterSchedulesLoaded extends WaterState {
  final List<IrrigationSchedule> schedules;

  const WaterSchedulesLoaded(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

/// History loaded state
class WaterHistoryLoaded extends WaterState {
  final List<IrrigationEvent> events;
  final Map<String, dynamic> stats;

  const WaterHistoryLoaded({
    required this.events,
    required this.stats,
  });

  @override
  List<Object?> get props => [events, stats];
}

/// Irrigation started state
class WaterIrrigationStarted extends WaterState {
  final IrrigationEvent event;

  const WaterIrrigationStarted(this.event);

  @override
  List<Object?> get props => [event];
}

/// Error state
class WaterError extends WaterState {
  final String message;

  const WaterError(this.message);

  @override
  List<Object?> get props => [message];
}
