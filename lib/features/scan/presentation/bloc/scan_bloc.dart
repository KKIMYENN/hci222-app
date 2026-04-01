import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/location_service.dart';
import '../../data/models/detection_result.dart';
import '../../data/repositories/scan_repository.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanRepository _repo;
  final LocationService _location;

  ScanBloc({ScanRepository? repo, LocationService? location})
      : _repo = repo ?? ScanRepositoryImpl(),
        _location = location ?? LocationService(),
        super(const ScanInitial()) {
    on<ScanImageCaptured>(_onImageCaptured);
    on<ScanWebMockRequested>(_onWebMock);
    on<ScanReset>(_onReset);
  }

  Future<void> _onImageCaptured(
    ScanImageCaptured event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanProcessing());
    try {
      final pos = await _location.getCurrentLocation();
      final result = await _repo.detectObject(
        image: event.image,
        lat: pos.lat,
        lon: pos.lon,
      );
      emit(ScanDetected(result));
    } catch (e) {
      emit(ScanError('상품 인식에 실패했어요. 다시 시도해주세요.\n($e)'));
    }
  }

  /// 웹에서 File 접근 불가 시 Mock 결과 직행
  Future<void> _onWebMock(
    ScanWebMockRequested event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanProcessing());
    await Future.delayed(const Duration(seconds: 1));
    emit(ScanDetected(DetectionResult.mock()));
  }

  void _onReset(ScanReset event, Emitter<ScanState> emit) {
    emit(const ScanInitial());
  }
}
