import 'package:flutter_bloc/flutter_bloc.dart';
import 'water_event.dart';
import 'water_state.dart';
import '../data/water_repository.dart';

/// Water BLoC
class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final WaterRepository _waterRepository;

  WaterBloc({required WaterRepository waterRepository})
      : _waterRepository = waterRepository,
        super(const WaterInitial()) {
    on<WaterLoadTank>(_onLoadTank);
    on<WaterToggleAuto>(_onToggleAuto);
    on<WaterStartManualIrrigation>(_onStartManualIrrigation);
    on<WaterLoadSchedules>(_onLoadSchedules);
    on<WaterAddSchedule>(_onAddSchedule);
    on<WaterDeleteSchedule>(_onDeleteSchedule);
    on<WaterLoadHistory>(_onLoadHistory);
    on<WaterRefresh>(_onRefresh);
  }

  /// Load tank status
  Future<void> _onLoadTank(
    WaterLoadTank event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      final tank = await _waterRepository.getTankStatus();
      emit(WaterTankLoaded(tank: tank));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Toggle auto-irrigation
  Future<void> _onToggleAuto(
    WaterToggleAuto event,
    Emitter<WaterState> emit,
  ) async {
    if (state is! WaterTankLoaded) return;
    
    try {
      final enabled = await _waterRepository.toggleAutoIrrigation(event.enabled);
      final currentState = state as WaterTankLoaded;
      emit(currentState.copyWith(autoIrrigationEnabled: enabled));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Start manual irrigation
  Future<void> _onStartManualIrrigation(
    WaterStartManualIrrigation event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      final irrigationEvent = await _waterRepository.startManualIrrigation(
        duration: event.duration,
        zone: event.zone,
      );
      emit(WaterIrrigationStarted(irrigationEvent));
      
      // Reload tank status
      final tank = await _waterRepository.getTankStatus();
      emit(WaterTankLoaded(tank: tank));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Load irrigation schedules
  Future<void> _onLoadSchedules(
    WaterLoadSchedules event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      final schedules = await _waterRepository.getSchedules();
      emit(WaterSchedulesLoaded(schedules));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Add irrigation schedule
  Future<void> _onAddSchedule(
    WaterAddSchedule event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      await _waterRepository.addSchedule(
        scheduledTime: event.scheduledTime,
        duration: event.duration,
        zone: event.zone,
      );
      
      // Reload schedules
      final schedules = await _waterRepository.getSchedules();
      emit(WaterSchedulesLoaded(schedules));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Delete irrigation schedule
  Future<void> _onDeleteSchedule(
    WaterDeleteSchedule event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      await _waterRepository.deleteSchedule(event.scheduleId);
      
      // Reload schedules
      final schedules = await _waterRepository.getSchedules();
      emit(WaterSchedulesLoaded(schedules));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Load irrigation history
  Future<void> _onLoadHistory(
    WaterLoadHistory event,
    Emitter<WaterState> emit,
  ) async {
    emit(const WaterLoading());
    
    try {
      final events = await _waterRepository.getHistory(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      
      final stats = await _waterRepository.getUsageStats(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      
      emit(WaterHistoryLoaded(events: events, stats: stats));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  /// Refresh water data
  Future<void> _onRefresh(
    WaterRefresh event,
    Emitter<WaterState> emit,
  ) async {
    try {
      final tank = await _waterRepository.getTankStatus();
      
      if (state is WaterTankLoaded) {
        final currentState = state as WaterTankLoaded;
        emit(currentState.copyWith(tank: tank));
      } else {
        emit(WaterTankLoaded(tank: tank));
      }
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }
}
