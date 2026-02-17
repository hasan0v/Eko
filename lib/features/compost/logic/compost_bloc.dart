import 'package:flutter_bloc/flutter_bloc.dart';
import 'compost_event.dart';
import 'compost_state.dart';
import '../data/compost_repository.dart';

/// Compost BLoC
class CompostBloc extends Bloc<CompostEvent, CompostState> {
  final CompostRepository _compostRepository;

  CompostBloc({required CompostRepository compostRepository})
      : _compostRepository = compostRepository,
        super(const CompostInitial()) {
    on<CompostLoadBatches>(_onLoadBatches);
    on<CompostLoadBatchDetails>(_onLoadBatchDetails);
    on<CompostCreateBatch>(_onCreateBatch);
    on<CompostUpdateBatchStatus>(_onUpdateBatchStatus);
    on<CompostLoadSensorData>(_onLoadSensorData);
    on<CompostRefresh>(_onRefresh);
    on<CompostDeleteBatch>(_onDeleteBatch);
    on<CompostSelectBatch>(_onSelectBatch);
  }

  /// Load all compost batches
  Future<void> _onLoadBatches(
    CompostLoadBatches event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      final batches = await _compostRepository.getAllBatches();
      emit(CompostLoaded(batches: batches));
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Load specific batch details
  Future<void> _onLoadBatchDetails(
    CompostLoadBatchDetails event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      final batch = await _compostRepository.getBatchById(event.batchId);
      if (batch != null) {
        final batches = await _compostRepository.getAllBatches();
        emit(CompostLoaded(
          batches: batches,
          selectedBatch: batch,
        ));
      } else {
        emit(const CompostError('Batch not found'));
      }
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Create new batch
  Future<void> _onCreateBatch(
    CompostCreateBatch event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      final batch = await _compostRepository.createBatch(
        name: event.name,
        initialWeight: event.initialWeight,
        location: event.location,
      );
      emit(CompostBatchCreated(batch));
      
      // Reload batches
      final batches = await _compostRepository.getAllBatches();
      emit(CompostLoaded(batches: batches, selectedBatch: batch));
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Update batch status
  Future<void> _onUpdateBatchStatus(
    CompostUpdateBatchStatus event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      // Get the batch first
      final batch = await _compostRepository.getBatchById(event.batchId);
      if (batch != null) {
        // Update it with new status
        final updatedBatch = await _compostRepository.updateBatch(
          batch.copyWith(status: event.status),
        );
        emit(CompostBatchUpdated(updatedBatch));
        
        // Reload batches
        final batches = await _compostRepository.getAllBatches();
        emit(CompostLoaded(batches: batches, selectedBatch: updatedBatch));
      } else {
        emit(const CompostError('Failed to update batch'));
      }
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Load sensor data
  Future<void> _onLoadSensorData(
    CompostLoadSensorData event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      final sensorData = await _compostRepository.getSensorReadings(
        event.batchId,
      );
      emit(CompostSensorDataLoaded(
        sensorData: sensorData,
        batchId: event.batchId,
      ));
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Refresh data
  Future<void> _onRefresh(
    CompostRefresh event,
    Emitter<CompostState> emit,
  ) async {
    try {
      final batches = await _compostRepository.getAllBatches();
      
      if (state is CompostLoaded) {
        final currentState = state as CompostLoaded;
        emit(CompostLoaded(
          batches: batches,
          selectedBatch: currentState.selectedBatch,
        ));
      } else {
        emit(CompostLoaded(batches: batches));
      }
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Delete batch
  Future<void> _onDeleteBatch(
    CompostDeleteBatch event,
    Emitter<CompostState> emit,
  ) async {
    emit(const CompostLoading());
    
    try {
      await _compostRepository.deleteBatch(event.batchId);
      
      // Reload batches
      final batches = await _compostRepository.getAllBatches();
      emit(CompostLoaded(batches: batches));
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }

  /// Select batch
  Future<void> _onSelectBatch(
    CompostSelectBatch event,
    Emitter<CompostState> emit,
  ) async {
    if (state is! CompostLoaded) return;
    
    final currentState = state as CompostLoaded;
    
    if (event.batchId == null) {
      emit(CompostLoaded(
        batches: currentState.batches,
        selectedBatch: null,
      ));
      return;
    }
    
    try {
      final batch = await _compostRepository.getBatchById(event.batchId!);
      emit(CompostLoaded(
        batches: currentState.batches,
        selectedBatch: batch,
      ));
    } catch (e) {
      emit(CompostError(e.toString()));
    }
  }
}
