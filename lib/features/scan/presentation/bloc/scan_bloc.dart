import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/scan_repository.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanRepository _repo;

  ScanBloc({ScanRepository? repo})
      : _repo = repo ?? ScanRepositoryImpl(),
        super(const ScanInitial()) {
    on<ScanImageCaptured>(_onImageCaptured);
    on<ScanReset>(_onReset);
  }

  Future<void> _onImageCaptured(
    ScanImageCaptured event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanProcessing());
    try {
      final result = await _repo.detectObject(
        image: event.image,
        lat: 41.0108, // TODO: 실제 GPS 좌표로 교체
        lon: 28.9683,
      );
      emit(ScanDetected(result));
    } catch (e) {
      emit(ScanError('상품 인식에 실패했어요. 다시 시도해주세요.\n($e)'));
    }
  }

  void _onReset(ScanReset event, Emitter<ScanState> emit) {
    emit(const ScanInitial());
  }
}
