import 'package:equatable/equatable.dart';
import '../../../models/compost_batch.dart';

/// Compost events
abstract class CompostEvent extends Equatable {
  const CompostEvent();

  @override
  List<Object?> get props => [];
}

/// Load all batches
class CompostLoadBatches extends CompostEvent {
  const CompostLoadBatches();
}

/// Load specific batch details
class CompostLoadBatchDetails extends CompostEvent {
  final String batchId;

  const CompostLoadBatchDetails(this.batchId);

  @override
  List<Object?> get props => [batchId];
}

/// Create new batch
class CompostCreateBatch extends CompostEvent {
  final String name;
  final double initialWeight;
  final String location;

  const CompostCreateBatch({
    required this.name,
    required this.initialWeight,
    required this.location,
  });

  @override
  List<Object?> get props => [name, initialWeight, location];
}

/// Update batch status
class CompostUpdateBatchStatus extends CompostEvent {
  final String batchId;
  final CompostStatus status;

  const CompostUpdateBatchStatus({
    required this.batchId,
    required this.status,
  });

  @override
  List<Object?> get props => [batchId, status];
}

/// Load sensor data for batch
class CompostLoadSensorData extends CompostEvent {
  final String batchId;
  final DateTime? startDate;
  final DateTime? endDate;

  const CompostLoadSensorData({
    required this.batchId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [batchId, startDate, endDate];
}

/// Refresh data
class CompostRefresh extends CompostEvent {
  const CompostRefresh();
}

/// Delete batch
class CompostDeleteBatch extends CompostEvent {
  final String batchId;

  const CompostDeleteBatch(this.batchId);

  @override
  List<Object?> get props => [batchId];
}

/// Select batch
class CompostSelectBatch extends CompostEvent {
  final String? batchId;

  const CompostSelectBatch(this.batchId);

  @override
  List<Object?> get props => [batchId];
}
