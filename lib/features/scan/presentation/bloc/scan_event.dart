import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();
  @override
  List<Object?> get props => [];
}

class ScanImageCaptured extends ScanEvent {
  final File image;
  const ScanImageCaptured(this.image);

  // File 자체는 equatable 비교 불가 → path + lastModified로 식별
  @override
  List<Object?> get props => [image.path, image.lastModifiedSync()];
}

class ScanReset extends ScanEvent {
  const ScanReset();
}

/// 웹 환경에서 이미지 파일 접근이 불가능할 때 Mock 결과로 직행
class ScanWebMockRequested extends ScanEvent {
  const ScanWebMockRequested();
}
