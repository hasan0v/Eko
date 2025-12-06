import 'package:equatable/equatable.dart';
import '../../../models/compost_batch.dart';
import '../../../models/sensor_data.dart';

/// Compost state
abstract class CompostState extends Equatable {
  const CompostState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CompostInitial extends CompostState {
  const CompostInitial();
}

/// Loading state
class CompostLoading extends CompostState {
  const CompostLoading();
}

/// Loaded state with batches
class CompostLoaded extends CompostState {
  final List<CompostBatch> batches;
  final CompostBatch? selectedBatch;

  const CompostLoaded({
    required this.batches,
    this.selectedBatch,
  });

  @override
  List<Object?> get props => [batches, selectedBatch];

  CompostLoaded copyWith({
    List<CompostBatch>? batches,
    CompostBatch? selectedBatch,
  }) {
    return CompostLoaded(
      batches: batches ?? this.batches,
      selectedBatch: selectedBatch ?? this.selectedBatch,
    );
  }
}

/// Sensor data loaded state
class CompostSensorDataLoaded extends CompostState {
  final List<SensorData> sensorData;
  final String batchId;

  const CompostSensorDataLoaded({
    required this.sensorData,
    required this.batchId,
  });

  @override
  List<Object?> get props => [sensorData, batchId];
}

/// Error state
class CompostError extends CompostState {
  final String message;

  const CompostError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Batch created state
class CompostBatchCreated extends CompostState {
  final CompostBatch batch;

  const CompostBatchCreated(this.batch);

  @override
  List<Object?> get props => [batch];
}

/// Batch updated state
class CompostBatchUpdated extends CompostState {
  final CompostBatch batch;

  const CompostBatchUpdated(this.batch);

  @override
  List<Object?> get props => [batch];
}
